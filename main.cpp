#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSurfaceFormat>
#include <QFontDatabase>
#include <QQuickStyle>
#include "videooutput.h"
#include "weatherserver.h"
int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Material");
    const int font_id = QFontDatabase::addApplicationFont(":/iconFont/iconfont.ttf");
    qDebug() << QFontDatabase::applicationFontFamilies(font_id);

    QSurfaceFormat format;
    format.setSamples(8);
    QSurfaceFormat::setDefaultFormat(format);
    WeatherServer* wserver = new WeatherServer();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);
    qmlRegisterSingletonInstance("WeatherServer",1,0,"WeatherServer",wserver);
    qmlRegisterType<VideoOutput>("VideoOutput", 1, 0,"VideoOutput");

    wserver->getWeather();


    return app.exec();
}
