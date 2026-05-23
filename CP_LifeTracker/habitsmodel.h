#ifndef HABITSMODEL_H
#define HABITSMODEL_H

#include <QAbstractListModel>
#include <QDate>
#include <QVariantList>
#include <QVariantMap>

struct Habit {
    QString name;
    QString description;
    bool completed;
    int streak;
    QList<QDate> completedDates;
    QString icon;
    QString color;
    int difficulty;
    int frequency;
    QList<bool> frequencyDays;
    int importance;
};

class HabitsModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int completedToday READ completedToday NOTIFY habitsChanged)
    Q_PROPERTY(int longestStreak READ longestStreak NOTIFY habitsChanged)
    Q_PROPERTY(int completionRate READ completionRate NOTIFY habitsChanged)

public:
    enum HabitRoles {
        NameRole = Qt::UserRole + 1,
        DescriptionRole,
        CompletedRole,
        StreakRole,
        IconRole,
        ColorRole,
        DifficultyRole,
        FrequencyRole,
        FrequencyDaysRole,
        ImportanceRole
    };

    explicit HabitsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addHabit(const QString &name, const QString &description,
                              const QString &icon = "🎯", const QString &color = "#3B82F6",
                              int difficulty = 1, int frequency = 1,
                              const QVariantList &frequencyDays = QVariantList(), int importance = 1);

    Q_INVOKABLE void editHabit(int index, const QString &name, const QString &description,
                               const QString &icon, const QString &color,
                               int difficulty, int frequency,
                               const QVariantList &frequencyDays, int importance);

    Q_INVOKABLE void removeHabit(int index);
    Q_INVOKABLE void setCompleted(int index, bool completed);
    Q_INVOKABLE QVariantMap getHabitData(int index) const;

    int completedToday() const;
    int longestStreak() const;
    int completionRate() const;

signals:
    void habitsChanged();

private:
    void updateStreak(int index);
    void saveHabits();
    void loadHabits();
    void checkAndResetDaily();
    bool shouldResetStreak(const QDate &lastCompletedDate) const;

    QList<Habit> m_habits;
};

#endif
