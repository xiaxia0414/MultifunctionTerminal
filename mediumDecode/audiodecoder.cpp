#include "audiodecoder.h"

extern "C"
{
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswresample/swresample.h>
}
#include <QDropEvent>
#include <QMimeData>
#include <QPainter>
#include <QScreen>
#include <QTimer>
#include <QDebug>

AudioDecoder::AudioDecoder(QObject *parent)
    : QThread (parent)
{

}

AudioDecoder::~AudioDecoder()
{
    stop();
}

void AudioDecoder::stop()
{
    //必须先重置信号量
    m_frameQueue.init();
    QMutexLocker locker(&m_mutex);
    m_runnable = false;
    wait();
}

void AudioDecoder::open(const QString &filename)
{
    stop();
    m_mutex.lock();
    m_filename = filename;
    m_runnable = true;
    m_mutex.unlock();
    start();
}

QAudioFormat AudioDecoder::format()
{
    QMutexLocker locker(&m_mutex);
    return m_format;
}

QByteArray AudioDecoder::currentFrame()
{
    QByteArray data = QByteArray();
    Packet packet = m_frameQueue.tryDequeue();
    data += packet.data;
    if (packet.time >= m_duration) emit finish();
    return data;
}

void AudioDecoder::run()
{
    demuxing_decoding();
}

void AudioDecoder::demuxing_decoding()
{
    AVFormatContext *formatContext = nullptr;
    AVCodecContext *codecContext = nullptr;
    AVCodec *audioDecoder = nullptr;
    AVStream *audioStream = nullptr;
    int audioIndex = -1;

    //打开输入文件，并分配格式上下文
    avformat_open_input(&formatContext, m_filename.toStdString().c_str(), nullptr, nullptr);
    avformat_find_stream_info(formatContext, nullptr);

    //找到音频流的索引
    audioIndex = av_find_best_stream(formatContext, AVMEDIA_TYPE_AUDIO, -1, -1, nullptr, 0);

    if (audioIndex < 0) {
        qDebug() << "Has Error: line =" << __LINE__;
        return;
    }
    audioStream = formatContext->streams[audioIndex];

    if (!audioStream) {
        qDebug() << "Has Error: line =" << __LINE__;
        return;
    }
    audioDecoder = avcodec_find_decoder(audioStream->codecpar->codec_id);

    if (!audioDecoder) {
        qDebug() << "Has Error: line =" << __LINE__;
        return;
    }
    codecContext = avcodec_alloc_context3(audioDecoder);

    if (!codecContext) {
        qDebug() << "Has Error: line =" << __LINE__;
        return;
    }
    avcodec_parameters_to_context(codecContext, audioStream->codecpar);

    if (!codecContext) {
        qDebug() << "Has Error: line =" << __LINE__;
        return;
    }
    avcodec_open2(codecContext, audioDecoder, nullptr);

    //打印相关信息
    av_dump_format(formatContext, 0, "format", 0);
    fflush(stderr);

    QAudioFormat format;
    format.setCodec("audio/pcm");
    format.setSampleRate(codecContext->sample_rate);
    format.setSampleType(QAudioFormat::SignedInt);
    format.setSampleSize(8 * av_get_bytes_per_sample(AV_SAMPLE_FMT_S32));
    format.setChannelCount(codecContext->channels);
    m_format = format;
    m_duration = audioStream->duration * av_q2d(audioStream->time_base);
    emit resolved();

    SwrContext *swrContext = swr_alloc_set_opts(nullptr, int64_t(codecContext->channel_layout), AV_SAMPLE_FMT_S32, codecContext->sample_rate,
                                                int64_t(codecContext->channel_layout), codecContext->sample_fmt, codecContext->sample_rate,
                                                0, nullptr);
    swr_init(swrContext);

    //分配并初始化一个临时的帧和包
    AVPacket *packet = av_packet_alloc();
    AVFrame *frame = av_frame_alloc();
    packet->data = nullptr;
    packet->size = 0;

    //读取下一帧
    while (m_runnable && av_read_frame(formatContext, packet) >= 0) {
        if (packet->stream_index == audioIndex) {
            //发送给解码器
            int ret = avcodec_send_packet(codecContext, packet);
            QByteArray data;
            while (ret >= 0) {
                //从解码器接收解码后的帧
                ret = avcodec_receive_frame(codecContext, frame);
                if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) break;
                else if (ret < 0) return;

                int size = av_samples_get_buffer_size(nullptr, frame->channels, frame->nb_samples, AV_SAMPLE_FMT_S32, 0);
                uint8_t *buf = new uint8_t[size];
                swr_convert(swrContext, &buf, frame->nb_samples, const_cast<const uint8_t**>(frame->data), frame->nb_samples);
                data += QByteArray((const char *)buf, size);
                delete[] buf;
                qreal time = frame->pts * av_q2d(audioStream->time_base) + frame->pkt_duration * av_q2d(audioStream->time_base);
                m_currentTime = time;
                m_frameQueue.enqueue({ data, time });
                av_frame_unref(frame);
            }
        }
        av_packet_unref(packet);
    }

    if (frame) av_frame_free(&frame);
    if (packet) av_packet_free(&packet);
    if (swrContext) swr_free(&swrContext);
    if (codecContext) avcodec_free_context(&codecContext);
    if (formatContext) avformat_close_input(&formatContext);
}
