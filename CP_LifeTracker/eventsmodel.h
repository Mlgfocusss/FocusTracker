#ifndef EVENTSMODEL_H
#define EVENTSMODEL_H

#include <QAbstractListModel>
#include <QDate>
#include <QTime>

class Event
{
public:
    Event(const QString &title, const QString &description,
          const QDate &date, const QTime &time, int duration);

    QString title() const;
    QString description() const;
    QDate date() const;
    QTime time() const;
    int duration() const;
    QString category() const;
    bool isAllDay() const;

    void setTitle(const QString &title);
    void setDescription(const QString &description);
    void setDate(const QDate &date);
    void setTime(const QTime &time);
    void setDuration(int duration);
    void setCategory(const QString &category);
    void setAllDay(bool allDay);

private:
    QString m_title;
    QString m_description;
    QDate m_date;
    QTime m_time;
    int m_duration;
    QString m_category;
    bool m_allDay;
};

class EventsModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum EventRoles {
        TitleRole = Qt::UserRole + 1,
        DescriptionRole,
        DateRole,
        TimeRole,
        DurationRole,
        CategoryRole,
        AllDayRole
    };

    explicit EventsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    int count() const;

    Q_INVOKABLE void addEvent(const QString &title, const QString &description,
                              const QString &dateStr, const QString &timeStr,
                              int duration, const QString &category, bool allDay);
    Q_INVOKABLE void removeEvent(int index);
    Q_INVOKABLE void editEvent(int index, const QString &title, const QString &description,
                               const QString &dateStr, const QString &timeStr,
                               int duration, const QString &category, bool allDay);

signals:
    void countChanged();

private:
    void saveData();
    void loadData();

    QList<Event> m_events;
};

#endif // EVENTSMODEL_H
