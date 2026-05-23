#ifndef TASKSMODEL_H
#define TASKSMODEL_H

#include <QAbstractListModel>
#include <QDateTime>
#include <QVector>

class Task
{
public:
    Task(const QString &name, const QString &description,
         const QString &dueDate, int priority);

    QString name() const;
    QString description() const;
    QString dueDate() const;
    int priority() const;
    bool completed() const;
    bool hasSubtasks() const;
    int subtaskCount() const;
    int completedSubtasks() const;

    void setName(const QString &name);
    void setDescription(const QString &description);
    void setDueDate(const QString &dueDate);
    void setPriority(int priority);
    void setCompleted(bool completed);
    void setHasSubtasks(bool hasSubtasks);
    void setSubtaskCount(int count);
    void setCompletedSubtasks(int count);

private:
    QString m_name;
    QString m_description;
    QString m_dueDate;
    int m_priority;
    bool m_completed;
    bool m_hasSubtasks;
    int m_subtaskCount;
    int m_completedSubtasks;
};

class TasksModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum TaskRoles {
        NameRole = Qt::UserRole + 1,
        DescriptionRole,
        DueDateRole,
        PriorityRole,
        CompletedRole,
        HasSubtasksRole,
        SubtaskCountRole,
        CompletedSubtasksRole
    };

    explicit TasksModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    int count() const;

    Q_INVOKABLE void addTask(const QString &name, const QString &description,
                             const QString &dueDate, int priority);
    Q_INVOKABLE void removeTask(int index);
    Q_INVOKABLE void setCompleted(int index, bool completed);
    Q_INVOKABLE void editTask(int index, const QString &name, const QString &description,
                              const QString &dueDate, int priority);

signals:
    void countChanged();

private:
    QVector<Task> m_tasks;
    void saveData();
    void loadData();

    QString getFormattedDate(const QString &dateType);
};

#endif // TASKSMODEL_H
