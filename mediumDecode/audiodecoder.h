#ifndef AUDIODECODER_H
#define AUDIODECODER_H
#include <QtMultimedia/QAudioFormat>
#include <QObject>
#include <QThread>
#include "bufferqueue.h"
#include <QMutex>
#include <QQueue>
struct Packet
{
    QByteArray data;
    qreal time;
};
class AudioDecoder : public QThread
{
    Q_OBJECT

public:
    AudioDecoder(QObject *parent = nullptr);
    ~AudioDecoder();

    void stop();
    void open(const QString &filename);

    QAudioFormat format();
    int duration();
    QByteArray currentFrame();
signals:
    void resolved();
    void finish();

protected:
    void run();

private:
    void demuxing_decoding();
    qreal m_duration = 0.0;
    qreal m_currentTime = 0.0;
    bool m_runnable = true;
    QAudioFormat m_format;
    QMutex m_mutex;
    QString m_filename;
    BufferQueue<Packet> m_frameQueue;
};
#endif // AUDIODECODER_H
