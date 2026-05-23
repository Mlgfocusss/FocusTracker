#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "habitsmodel.h"
#include "SettingsManager.h"
#include "tasksmodel.h"
#include <QQuickWindow>
#include "notesmodel.h"
#include "authmanager.h"
#include "eventsmodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    HabitsModel habitsModel;
    SettingsManager settingsManager;
    TasksModel tasksModel;
    NotesModel notesModel;
    AuthManager authManager;
    EventsModel eventsModel;
    engine.rootContext()->setContextProperty("HabitsModel", &habitsModel);
    engine.rootContext()->setContextProperty("SettingsManager", &settingsManager);
    engine.rootContext()->setContextProperty("TasksModel", &tasksModel);
    engine.rootContext()->setContextProperty("notesModelInstance", &notesModel);
    engine.rootContext()->setContextProperty("AuthManager", &authManager);
    engine.rootContext()->setContextProperty("EventsModel", &eventsModel);
    authManager.initSavedUser();

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("FocusTracker", "Main");
    return app.exec();
}
