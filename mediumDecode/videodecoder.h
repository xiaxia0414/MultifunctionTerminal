#ifndef VIDEODECODER_H
#define VIDEODECODER_H

#include "bufferqueue.h"
#include <QObject>
#include <QThread>
#include <QMutex>
class VideoDecoder : public QThread
{
    Q_OBJECT
public:
    VideoDecoder(QObject *parent = nullptr);
    ~VideoDecoder();

    void stop();
    void open(const QString &filename);

    int fps() const { return m_fps; }
    int width() const { return m_width; }
    int height() const { return m_height; }
    QImage currentFrame();
signals:
    void resolved();
    void finish();

protected:
    void run();

private:
    void demuxing_decoding();

    bool m_runnable = true;
    QMutex m_mutex;
    QString m_filename;
    BufferQueue<QImage> m_frameQueue;
    int m_fps, m_width, m_height;
};

#endif // VIDEODECODER_H
