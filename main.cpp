#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include<QProcess>
#include <QDir>
#include "appcore.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    AppCore appCore;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("KaakdiLauncher", "Main");
    // NOTE: Ensure your retroarch path is correct for the final build,
    // you might want to bundle RetroArch inside your basePath eventually too!


   // QProcess::startDetached(retroarchPath, arguments);
    return QCoreApplication::exec();
}
