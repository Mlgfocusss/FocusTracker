#include "eventsmodel.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QDateTime>
#include <QDebug>

Event::Event(const QString &title, const QString &description,
             const QDate &date, const QTime &time, int duration)
    : m_title(title),
    m_description(description),
    m_date(date),
    m_time(time),
    m_duration(duration),
    m_category("General"),
    m_allDay(false)
{
}

QString Event::title() const { return m_title; }
QString Event::description() const { return m_description; }
QDate Event::date() const { return m_date; }
QTime Event::time() const { return m_time; }
int Event::duration() const { return m_duration; }
QString Event::category() const { return m_category; }
bool Event::isAllDay() const { return m_allDay; }

void Event::setTitle(const QString &title) { m_title = title; }
void Event::setDescription(const QString &description) { m_description = description; }
void Event::setDate(const QDate &date) { m_date = date; }
void Event::setTime(const QTime &time) { m_time = time; }
void Event::setDuration(int duration) { m_duration = duration; }
void Event::setCategory(const QString &category) { m_category = category; }
void Event::setAllDay(bool allDay) { m_allDay = allDay; }

EventsModel::EventsModel(QObject *parent)
    : QAbstractListModel(parent)
{
    loadData();
}

int EventsModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_events.size();
}

QVariant EventsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_events.size())
        return QVariant();

    const Event &event = m_events.at(index.row());

    switch (role) {
    case TitleRole:
        return event.title();
    case DescriptionRole:
        return event.description();
    case DateRole:
        return event.date().toString("yyyy-MM-dd");
    case TimeRole:
        return event.time().toString("hh:mm");
    case DurationRole:
        return event.duration();
    case CategoryRole:
        return event.category();
    case AllDayRole:
        return event.isAllDay();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> EventsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[DescriptionRole] = "description";
    roles[DateRole] = "date";
    roles[TimeRole] = "time";
    roles[DurationRole] = "duration";
    roles[CategoryRole] = "category";
    roles[AllDayRole] = "allDay";
    return roles;
}

int EventsModel::count() const
{
    return m_events.size();
}

void EventsModel::addEvent(const QString &title, const QString &description,
                           const QString &dateStr, const QString &timeStr,
                           int duration, const QString &category, bool allDay)
{
    QDate date = QDate::fromString(dateStr, "yyyy-MM-dd");
    QTime time = QTime::fromString(timeStr, "hh:mm");

    beginInsertRows(QModelIndex(), m_events.size(), m_events.size());
    Event event(title, description, date, time, duration);
    event.setCategory(category);
    event.setAllDay(allDay);
    m_events.append(event);
    endInsertRows();

    emit countChanged();
    saveData();
}

void EventsModel::removeEvent(int index)
{
    if (index < 0 || index >= m_events.size())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_events.remove(index);
    endRemoveRows();

    emit countChanged();
    saveData();
}

void EventsModel::editEvent(int index, const QString &title, const QString &description,
                            const QString &dateStr, const QString &timeStr,
                            int duration, const QString &category, bool allDay)
{
    if (index < 0 || index >= m_events.size())
        return;

    QDate date = QDate::fromString(dateStr, "yyyy-MM-dd");
    QTime time = QTime::fromString(timeStr, "hh:mm");

    m_events[index].setTitle(title);
    m_events[index].setDescription(description);
    m_events[index].setDate(date);
    m_events[index].setTime(time);
    m_events[index].setDuration(duration);
    m_events[index].setCategory(category);
    m_events[index].setAllDay(allDay);

    QModelIndex modelIndex = createIndex(index, 0);
    emit dataChanged(modelIndex, modelIndex, {TitleRole, DescriptionRole, DateRole, TimeRole, DurationRole, CategoryRole, AllDayRole});

    saveData();
}

void EventsModel::saveData()
{
    QJsonArray eventArray;

    for (int i = 0; i < m_events.size(); ++i) {
        const Event &event = m_events.at(i);
        QJsonObject eventObject;
        eventObject["title"] = event.title();
        eventObject["description"] = event.description();
        eventObject["date"] = event.date().toString("yyyy-MM-dd");
        eventObject["time"] = event.time().toString("hh:mm");
        eventObject["duration"] = event.duration();
        eventObject["category"] = event.category();
        eventObject["allDay"] = event.isAllDay();

        eventArray.append(eventObject);
    }

    QJsonDocument document(eventArray);

    QString dataLocation = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataLocation);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString filePath = dataLocation + "/events.json";
    QFile file(filePath);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Could not open file for writing:" << filePath << "Error:" << file.errorString();
        return;
    }

    file.write(document.toJson());
    file.close();

    qDebug() << "Events data saved successfully to" << filePath;
}

void EventsModel::loadData()
{
    QString dataLocation = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QString filePath = dataLocation + "/events.json";
    QFile file(filePath);

    if (!file.exists()) {
        qDebug() << "Events file does not exist:" << filePath;
        return;
    }

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Could not open file for reading:" << filePath << "Error:" << file.errorString();
        return;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonParseError parseError;
    QJsonDocument document = QJsonDocument::fromJson(data, &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qWarning() << "JSON parse error:" << parseError.errorString();
        return;
    }

    if (!document.isArray()) {
        qWarning() << "JSON document is not an array";
        return;
    }

    QJsonArray eventArray = document.array();

    beginResetModel();
    m_events.clear();

    for (int i = 0; i < eventArray.size(); ++i) {
        QJsonObject eventObject = eventArray.at(i).toObject();

        QString title = eventObject["title"].toString();
        QString description = eventObject["description"].toString();
        QDate date = QDate::fromString(eventObject["date"].toString(), "yyyy-MM-dd");
        QTime time = QTime::fromString(eventObject["time"].toString(), "hh:mm");
        int duration = eventObject["duration"].toInt();
        QString category = eventObject["category"].toString("General");
        bool allDay = eventObject["allDay"].toBool(false);

        Event event(title, description, date, time, duration);
        event.setCategory(category);
        event.setAllDay(allDay);

        m_events.append(event);
    }

    endResetModel();
    emit countChanged();

    qDebug() << "Loaded" << m_events.size() << "events from" << filePath;
}
