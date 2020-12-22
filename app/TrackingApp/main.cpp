#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QAndroidJniObject>
#include  <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/view/MainMenu.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

//     QAndroidJniObject::callStaticMethod<jint>
//                                ("org/qtproject/trackingapp/OrientationChanger" // class name
//                                , "change" // method name
//                                , "(I)I" // signature
//                                , 1);
    //    qDebug()<<"retVal" + QString::number(retVal);
    return app.exec();
}
