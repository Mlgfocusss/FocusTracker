#include "habitsmodel.h"
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QSettings>
#include <algorithm>

HabitsModel::HabitsModel(QObject *parent)
    : QAbstractListModel(parent)
{
    loadHabits();
    checkAndResetDaily();
}

int HabitsModel::rowCount(const QModelIndex &parent) const
{
    return parent.isValid() ? 0 : m_habits.size();
}

QVariant HabitsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_habits.size())
        return QVariant();

    const Habit &habit = m_habits.at(index.row());

    switch (role) {
    case NameRole:        return habit.name;
    case DescriptionRole: return habit.description;
    case CompletedRole:   return habit.completed;
    case StreakRole:      return habit.streak;
    case IconRole:        return habit.icon;
    case ColorRole:       return habit.color;
    case DifficultyRole:  return habit.difficulty;
    case FrequencyRole:   return habit.frequency;
    case FrequencyDaysRole: return QVariant::fromValue(habit.frequencyDays);
    case ImportanceRole:  return habit.importance;
    default:              return QVariant();
    }
}

bool HabitsModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid() || index.row() >= m_habits.size())
        return false;

    Habit &habit = m_habits[index.row()];
    bool changed = false;

    switch (role) {
    case CompletedRole: {
        bool completed = value.toBool();
        if (habit.completed != completed) {
            habit.completed = completed;
            QDate today = QDate::currentDate();

            if (completed) {
                if (!habit.completedDates.contains(today)) {
                    habit.completedDates.append(today);
                    updateStreak(index.row());
                }
            } else {
                habit.completedDates.removeAll(today);
                updateStreak(index.row());
            }
            changed = true;
        }
        break;
    }
    case NameRole:
        if (habit.name != value.toString()) {
            habit.name = value.toString();
            changed = true;
        }
        break;
    case DescriptionRole:
        if (habit.description != value.toString()) {
            habit.description = value.toString();
            changed = true;
        }
        break;
    default:
        return false;
    }

    if (changed) {
        emit dataChanged(index, index, QVector<int>() << role);
        saveHabits();
        emit habitsChanged();
        return true;
    }

    return false;
}

QHash<int, QByteArray> HabitsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[DescriptionRole] = "description";
    roles[CompletedRole] = "completed";
    roles[StreakRole] = "streak";
    roles[IconRole] = "icon";
    roles[ColorRole] = "color";
    roles[DifficultyRole] = "difficulty";
    roles[FrequencyRole] = "frequency";
    roles[FrequencyDaysRole] = "frequencyDays";
    roles[ImportanceRole] = "importance";
    return roles;
}

void HabitsModel::addHabit(const QString &name, const QString &description, const QString &icon,
                           const QString &color, int difficulty, int frequency,
                           const QVariantList &frequencyDays, int importance)
{
    QString trimmedName = name.trimmed();
    if (trimmedName.isEmpty())
        return;

    beginInsertRows(QModelIndex(), m_habits.size(), m_habits.size());

    Habit habit;
    habit.name = trimmedName;
    habit.description = description.trimmed();
    habit.completed = false;
    habit.streak = 0;
    habit.icon = icon.isEmpty() ? "🎯" : icon;
    habit.color = color.isEmpty() ? "#3B82F6" : color;
    habit.difficulty = difficulty;
    habit.frequency = frequency;

    for (const QVariant &day : frequencyDays) {
        habit.frequencyDays.append(day.toBool());
    }

    habit.importance = importance;

    m_habits.append(habit);

    endInsertRows();
    saveHabits();
    emit habitsChanged();
}

void HabitsModel::editHabit(int index, const QString &name, const QString &description,
                            const QString &icon, const QString &color, int difficulty,
                            int frequency, const QVariantList &frequencyDays, int importance)
{
    if (index < 0 || index >= m_habits.size())
        return;

    Habit &habit = m_habits[index];
    habit.name = name.trimmed();
    habit.description = description.trimmed();
    habit.icon = icon;
    habit.color = color;
    habit.difficulty = difficulty;
    habit.frequency = frequency;

    habit.frequencyDays.clear();
    for (const QVariant &day : frequencyDays) {
        habit.frequencyDays.append(day.toBool());
    }

    habit.importance = importance;

    emit dataChanged(createIndex(index, 0), createIndex(index, 0));
    saveHabits();
    emit habitsChanged();
}

void HabitsModel::removeHabit(int index)
{
    if (index < 0 || index >= m_habits.size())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_habits.removeAt(index);
    endRemoveRows();

    saveHabits();
    emit habitsChanged();
}

void HabitsModel::setCompleted(int index, bool completed)
{
    if (index < 0 || index >= m_habits.size())
        return;

    setData(createIndex(index, 0), completed, CompletedRole);
}

QVariantMap HabitsModel::getHabitData(int index) const
{
    QVariantMap data;

    if (index < 0 || index >= m_habits.size())
        return data;

    const Habit &habit = m_habits.at(index);

    data["name"] = habit.name;
    data["description"] = habit.description;
    data["icon"] = habit.icon;
    data["color"] = habit.color;
    data["difficulty"] = habit.difficulty;
    data["frequency"] = habit.frequency;

    QVariantList days;
    for (bool day : habit.frequencyDays) {
        days.append(day);
    }
    data["frequencyDays"] = days;

    data["importance"] = habit.importance;

    return data;
}

void HabitsModel::updateStreak(int index)
{
    if (index < 0 || index >= m_habits.size())
        return;

    Habit &habit = m_habits[index];
    QDate today = QDate::currentDate();

    std::sort(habit.completedDates.begin(), habit.completedDates.end());

    if (habit.completedDates.isEmpty()) {
        habit.streak = 0;
    } else {
        bool todayCompleted = habit.completedDates.contains(today);
        int streak = 0;
        QDate currentDate = todayCompleted ? today : today.addDays(-1);

        while (habit.completedDates.contains(currentDate)) {
            streak++;
            currentDate = currentDate.addDays(-1);
        }

        habit.streak = streak;
    }

    emit dataChanged(createIndex(index, 0), createIndex(index, 0), QVector<int>() << StreakRole);
}

void HabitsModel::saveHabits()
{
    QJsonArray habitsArray;

    for (const Habit &habit : m_habits) {
        QJsonObject habitObject;
        habitObject["name"] = habit.name;
        habitObject["description"] = habit.description;
        habitObject["streak"] = habit.streak;
        habitObject["icon"] = habit.icon;
        habitObject["color"] = habit.color;
        habitObject["difficulty"] = habit.difficulty;
        habitObject["frequency"] = habit.frequency;
        habitObject["importance"] = habit.importance;

        QJsonArray datesArray;
        for (const QDate &date : habit.completedDates) {
            datesArray.append(date.toString(Qt::ISODate));
        }
        habitObject["completedDates"] = datesArray;

        QJsonArray daysArray;
        for (bool day : habit.frequencyDays) {
            daysArray.append(day);
        }
        habitObject["frequencyDays"] = daysArray;

        habitsArray.append(habitObject);
    }

    QJsonDocument doc(habitsArray);
    QFile file("habits.json");

    if (file.open(QIODevice::WriteOnly)) {
        file.write(doc.toJson());
        file.close();
    }

    QSettings settings;
    settings.setValue("LastCheckDate", QDate::currentDate().toString(Qt::ISODate));
}

void HabitsModel::loadHabits()
{
    QFile file("habits.json");
    if (!file.open(QIODevice::ReadOnly))
        return;

    QByteArray data = file.readAll();
    file.close();

    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonArray habitsArray = doc.array();

    beginResetModel();
    m_habits.clear();
    QDate today = QDate::currentDate();

    for (const QJsonValue &value : habitsArray) {
        QJsonObject habitObject = value.toObject();

        Habit habit;
        habit.name = habitObject["name"].toString();
        habit.description = habitObject["description"].toString();
        habit.streak = habitObject["streak"].toInt();
        habit.completed = false;
        habit.icon = habitObject["icon"].toString("🎯");
        habit.color = habitObject["color"].toString("#3B82F6");
        habit.difficulty = habitObject["difficulty"].toInt(1);
        habit.frequency = habitObject["frequency"].toInt(1);
        habit.importance = habitObject["importance"].toInt(1);

        QJsonArray datesArray = habitObject["completedDates"].toArray();
        for (const QJsonValue &dateValue : datesArray) {
            habit.completedDates.append(QDate::fromString(dateValue.toString(), Qt::ISODate));
        }

        QJsonArray daysArray = habitObject["frequencyDays"].toArray();
        if (daysArray.isEmpty()) {
            for (int i = 0; i < 7; i++) {
                habit.frequencyDays.append(true);
            }
        } else {
            for (const QJsonValue &dayValue : daysArray) {
                habit.frequencyDays.append(dayValue.toBool());
            }
        }

        habit.completed = habit.completedDates.contains(today);
        m_habits.append(habit);
    }

    endResetModel();
    emit habitsChanged();
}

bool HabitsModel::shouldResetStreak(const QDate &lastCompletedDate) const
{
    return lastCompletedDate < QDate::currentDate().addDays(-1);
}

void HabitsModel::checkAndResetDaily()
{
    QSettings settings;
    QDate lastCheckDate = QDate::fromString(settings.value("LastCheckDate").toString(), Qt::ISODate);
    QDate today = QDate::currentDate();

    if (!lastCheckDate.isValid() || lastCheckDate >= today)
        return;

    bool changed = false;
    for (int i = 0; i < m_habits.size(); i++) {
        Habit &habit = m_habits[i];

        if (habit.completed) {
            habit.completed = false;
            changed = true;
        }

        if (!habit.completedDates.isEmpty()) {
            QDate latestDate = *std::max_element(habit.completedDates.begin(), habit.completedDates.end());
            if (shouldResetStreak(latestDate)) {
                habit.streak = 0;
                changed = true;
            }
        }
    }

    if (changed) {
        beginResetModel();
        endResetModel();
        saveHabits();
        emit habitsChanged();
    } else {
        settings.setValue("LastCheckDate", today.toString(Qt::ISODate));
    }
}

int HabitsModel::completedToday() const
{
    int completed = 0;
    QDate today = QDate::currentDate();

    for (const Habit &habit : m_habits) {
        if (habit.completed || habit.completedDates.contains(today)) {
            completed++;
        }
    }

    return completed;
}

int HabitsModel::longestStreak() const
{
    int longest = 0;
    for (const Habit &habit : m_habits) {
        longest = qMax(longest, habit.streak);
    }
    return longest;
}

int HabitsModel::completionRate() const
{
    if (m_habits.isEmpty()) {
        return 0;
    }
    return (completedToday() * 100) / m_habits.size();
}
