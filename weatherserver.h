#ifndef WEATHERSERVER_H
#define WEATHERSERVER_H

#include <QObject>


class WeatherServer : public QObject
{
    Q_OBJECT
public:
    explicit WeatherServer(QObject *parent = nullptr);
    QString getLocation();
    QString getCityID(QString city);
    void getWeather();
private:
    QString API_ipToAddr="http://ip-api.com/json/?lang=zh-CN";
    QString API_Weather;

    QString m_city="";
    QString m_cityID="";
signals:
    void notifyCityWeatherJson(QString josn);
};

#endif // WEATHERSERVER_H
