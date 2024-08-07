#ifndef WEATHERSERVER_H
#define WEATHERSERVER_H

#include <QObject>
#include <QtQml>

class WeatherServer : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit WeatherServer(QObject *parent = nullptr);
    QString getLocation();
    QString getCityID(QString city);
    void getWeather();
    Q_INVOKABLE QString getWeatherJson();
private:
    QString API_ipToAddr="http://ip-api.com/json/?lang=zh-CN";
    QString API_Weather;

    QString m_city="";
    QString m_cityID="";

    QString m_weatherJson;
signals:
    void notifyCityWeatherJson(QString josn);
};

#endif // WEATHERSERVER_H
