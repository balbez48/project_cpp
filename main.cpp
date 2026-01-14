#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "db.h"
#include "train.h"
#include "typewagon.h"
#include "route.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    if (!DbManager::connect())
        return -1;

    TrainModel trainModel;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("trainModel", &trainModel);

    TypeWagonModel typeWagonModel;
    engine.rootContext()->setContextProperty("typeWagonModel", &typeWagonModel);

    RouteModel routeModel;
    engine.rootContext()->setContextProperty("routeModel", &routeModel);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
