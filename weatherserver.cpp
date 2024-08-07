#include "weatherserver.h"

#include <QEventLoop>
#include <QJsonDocument>
#include <QNetworkAccessManager>
#include <QJsonObject>
#include <QNetworkReply>
#include <QFile>
WeatherServer::WeatherServer(QObject *parent)
    : QObject{parent}
{

}

QString WeatherServer::getLocation()
{
    QDateTime currentDateTime = QDateTime::currentDateTime();
    QString log = currentDateTime.toString("yyyy/MM/dd HH:mm:ss") + "\n";
    QUrl url;
    QString surl;
    QNetworkAccessManager manager;
    QNetworkReply *reply;
    QEventLoop loop;
    QByteArray BA;
    QJsonDocument JD;
    QJsonParseError JPE;

    QString city;
    surl = API_ipToAddr;
    url.setUrl(surl);
    reply = manager.get(QNetworkRequest(url));
        //请求结束并下载完成后，退出子事件循环
    QObject::connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
        //开启子事件循环
    loop.exec();
    BA = reply->readAll();
    log += surl + "\n";
    log += BA + "\n";
    JD = QJsonDocument::fromJson(BA, &JPE);
    if(JPE.error == QJsonParseError::NoError) {
        if(JD.isObject()) {
            QJsonObject obj = JD.object();
            if(obj.contains("city")) {
                QJsonValue JV_city = obj.take("city");
                if(JV_city.isString()) {
                    city = JV_city.toString();
                }
            }
        }
     }
    return city;
}

QString WeatherServer::getCityID(QString city)
{
    QString cityID;
    QFile file("./cityID.txt");
    bool ok = file.open(QIODevice::ReadOnly);
    if (ok) {
        QTextStream TS(&file);
        QString s = TS.readAll();
        file.close();
        QStringList SL = s.split("\n");
        for(int i=0; i<SL.length(); i++){
            QString line = SL.at(i);
            if (line.contains(city)) {
                cityID = line.left(line.indexOf("="));
                break;
            }
        }
    }
    //qDebug()<<cityID;
    return cityID;
}

void WeatherServer::getWeather()
{
    if(m_city == "")
    {
        m_city = getLocation();
    }
    if(m_cityID == "")
    {
        m_cityID = getCityID(m_city);
    }
    QDateTime currentDateTime = QDateTime::currentDateTime();
    QString log = currentDateTime.toString("yyyy/MM/dd HH:mm:ss") + "\n";
    QUrl url;
    QString surl;
    QNetworkAccessManager manager;
    QNetworkReply *reply;
    QEventLoop loop;
    QByteArray BA;
    QJsonDocument JD;
    QJsonParseError JPE;
    surl = "http://t.weather.sojson.com/api/weather/city/"+ m_cityID;
    url.setUrl(surl);
    reply = manager.get(QNetworkRequest(url));
    QObject::connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();
    BA = reply->readAll();
    //qDebug() << surl;
    //qDebug() << BA;
    log += surl + "\n";
    log += BA + "\n";
    JD = QJsonDocument::fromJson(BA, &JPE);
    QString weatherInfo(JD.toJson().data());
    m_weatherJson = weatherInfo;
    //qDebug()<<weatherInfo;
}

QString WeatherServer::getWeatherJson()
{
    return m_weatherJson;
}

