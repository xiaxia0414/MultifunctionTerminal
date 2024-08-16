#ifndef VIDEOOUTPUT_H
#define VIDEOOUTPUT_H

#include <QObject>
#include <QQuickPaintedItem>
#include <QImage>
#include <QAudioOutput>
#include "videodecoder.h"
#include "audiodecoder.h"
class VideoOutput : public QQuickPaintedItem
{
    Q_OBJECT
public:
    VideoOutput();
    void paint(QPainter *painter);
    Q_INVOKABLE void playVideo();
    Q_INVOKABLE void playAudio();
private:
    QImage m_videoFrame;
    VideoDecoder* m_videoDecoder;
    QTimer* m_videotimer;

    QTimer* m_audioTimer;
    QByteArray m_audioFrame = QByteArray();
    QAudioOutput *m_audioOutput = nullptr;
    QIODevice *m_device = nullptr;
    AudioDecoder *m_audioDecoder = nullptr;

};

#endif // VIDEOOUTPUT_H
