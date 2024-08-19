#include "videooutput.h"
#include "QPainter"
#include <QTimer>
VideoOutput::VideoOutput() {
    m_videoDecoder = new VideoDecoder();
    m_audioDecoder = new AudioDecoder();
    m_videotimer = new QTimer(this);
    m_audioTimer = new QTimer(this);
    connect(m_videotimer, &QTimer::timeout, this, [this](){
        m_videoFrame = m_videoDecoder->currentFrame();
        update();
    });
   //m_videoDecoder = new VideoDecoder(this);
    // connect(m_videoDecoder, &VideoDecoder::resolved, this, [=]() {
    //    // QTimer::singleShot(1000,[=](){
    //        m_videotimer->start((1000/m_videoDecoder->fps()));
    //    // });
    // });
    connect(m_audioTimer, &QTimer::timeout, this, [this](){
        if (m_audioFrame.size() < m_audioOutput->bytesFree()) {
            m_audioFrame += m_audioDecoder->currentFrame();
            int readSize = m_audioOutput->periodSize();
            int chunks = m_audioOutput->bytesFree() / readSize;
            while (chunks--) {
                QByteArray pcm = m_audioFrame.mid(0, readSize);
                int len = pcm.size();
                m_audioFrame.remove(0, len);
                if (len) m_device->write(pcm);
                if (len != readSize) break;
            }
        }
    });
    // connect(m_audioDecoder, &AudioDecoder::resolved, this, [this]() {
    //     if (m_audioOutput) m_audioOutput->deleteLater();
    //     m_audioOutput = new QAudioOutput(m_audioOutput->format());
    //     m_device = m_audioOutput->start();
    //     m_audioTimer->start(10);
    // });
     m_videoDecoder->open("C:\\Users\\intern04\\Documents\\Tencent Files\\2843897187\\FileRecv\\MobileFile\\VID20240728154701.mp4");
     m_audioDecoder->open("C:\\Users\\intern04\\Documents\\Tencent Files\\2843897187\\FileRecv\\MobileFile\\VID20240728154701.mp4");
}

void VideoOutput::paint(QPainter *painter)
{
    if (!m_videoFrame.isNull())
    {
        painter->drawImage(this->boundingRect(), m_videoFrame);
    }
}

void VideoOutput::playVideo()
{
    qDebug()<<m_videoDecoder->fps();
    m_videotimer->start(1000.0/m_videoDecoder->fps());
}

void VideoOutput::playAudio()
{
    // if (m_audioOutput) m_audioOutput->deleteLater();
    // m_audioOutput = new QAudioOutput(m_audioDecoder->format());
    // m_device = m_audioOutput->start();
    // m_audioTimer->start(10);
}

