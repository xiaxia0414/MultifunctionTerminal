#include "videodecoder.h"
extern "C"
{
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/imgutils.h>
#include <libswscale/swscale.h>
}
#include <QMimeData>
#include <QTimer>
#include <QDebug>
#include <QImage>
VideoDecoder::VideoDecoder(QObject *parent)
    : QThread (parent)
{

}

VideoDecoder::~VideoDecoder()
{
    stop();
}

void VideoDecoder::stop()
{
    //必须先重置信号量
    m_frameQueue.init();
    m_runnable = false;
    wait();
}

void VideoDecoder::open(const QString &filename)
{
    stop();

    m_mutex.lock();
    m_filename = filename;
    m_runnable = true;
    m_mutex.unlock();

    start();
}

QImage VideoDecoder::currentFrame()
{
    static QImage image = QImage();
    image = m_frameQueue.tryDequeue();
    return image;
}

void VideoDecoder::run()
{
    demuxing_decoding();
}

void VideoDecoder::demuxing_decoding()
{
    AVFormatContext *formatContext = nullptr;//封装格式上下文结构体，也是统领全局的结构体，保存了视频文件封装格式相关信息。
    AVCodecContext *codecContext = nullptr;//编码器上下文结构体，保存了视频（音频）编解码相关信息
    AVCodec *videoDecoder = nullptr;//每种视频（音频）编解码器(例如H.264解码器)对应一个该结构体。
    AVStream *videoStream = nullptr;//视频文件中每个视频（音频）流对应一个该结构体。
    int videoIndex = -1;

    //打开输入文件，并分配格式上下文
    avformat_open_input(&formatContext, m_filename.toStdString().c_str(), nullptr, nullptr);
    avformat_find_stream_info(formatContext, nullptr);

    //找到视频流的索引
    videoIndex = av_find_best_stream(formatContext, AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);

    if (videoIndex < 0) {
        qDebug() << "Has Error: line =" << __LINE__;
        return;
    }
    videoStream = formatContext->streams[videoIndex];

    if (!videoStream) {
        qDebug() << "Has Error: line =" << __LINE__;
        return;
    }

    videoDecoder = avcodec_find_decoder(videoStream->codecpar->codec_id);

    if (!videoDecoder) {
        qDebug() << "Has Error: line =" << __LINE__;
        return;
    }

    codecContext = avcodec_alloc_context3(videoDecoder);

    if (!codecContext) {
        qDebug() << "Has Error: line =" << __LINE__;
        return;
    }
    avcodec_parameters_to_context(codecContext, videoStream->codecpar);

    if (!codecContext) {
        qDebug() << "Has Error: line =" << __LINE__;
        return;
    }
    avcodec_open2(codecContext, videoDecoder, nullptr);

    //打印相关信息
    av_dump_format(formatContext, 0, "format", 0);
    fflush(stderr);

    m_fps = videoStream->avg_frame_rate.num / videoStream->avg_frame_rate.den;
    qDebug()<<videoStream->avg_frame_rate.num<< videoStream->avg_frame_rate.den;
    int64_t duration = formatContext->duration;
    int64_t totalFrames = videoStream->nb_frames;
    qDebug()<<duration<<totalFrames;
    m_width = codecContext->width;
    m_height = codecContext->height;

    emit resolved();

    SwsContext *swsContext = sws_getContext(m_width, m_height, codecContext->pix_fmt, m_width, m_height, AV_PIX_FMT_RGB24,
                                            SWS_BILINEAR, nullptr, nullptr, nullptr);
    //分配并初始化一个临时的帧和包
    AVPacket *packet = av_packet_alloc();
    AVFrame *frame = av_frame_alloc();
    packet->data = nullptr;
    packet->size = 0;

    //读取下一帧
    while (m_runnable && av_read_frame(formatContext, packet) >= 0) {

        if (packet->stream_index == videoIndex) {
            //发送给解码器
            int ret = avcodec_send_packet(codecContext, packet);

            while (ret >= 0) {
                //从解码器接收解码后的帧
                ret = avcodec_receive_frame(codecContext, frame);

                if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) break;
                else if (ret < 0) goto Run_End;

                int dst_linesize[4];
                uint8_t *dst_data[4];
                av_image_alloc(dst_data, dst_linesize, m_width, m_height, AV_PIX_FMT_RGB24, 1);
                sws_scale(swsContext, frame->data, frame->linesize, 0, frame->height, dst_data, dst_linesize);
                QImage image = QImage(dst_data[0], m_width, m_height, QImage::Format_RGB888).copy();
                av_freep(&dst_data[0]);
                m_frameQueue.enqueue(image);

                av_frame_unref(frame);
            }
        }

        av_packet_unref(packet);
    }
qDebug()<<"resoved";

Run_End:
    m_fps = m_width = m_height = 0;
    if (frame) av_frame_free(&frame);
    if (packet) av_packet_free(&packet);
    if (swsContext) sws_freeContext(swsContext);
    if (codecContext) avcodec_free_context(&codecContext);
    if (formatContext) avformat_close_input(&formatContext);
}

