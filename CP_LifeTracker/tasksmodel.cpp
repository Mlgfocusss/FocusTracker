#include "tasksmodel.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QDateTime>
#include <QDebug>

Task::Task(const QString &name, const QString &description,
           const QString &dueDate, int priority)
    : m_name(name),
    m_description(description),
    m_dueDate(dueDate),
    m_priority(priority),
    m_completed(false),
    m_hasSubtasks(false),
    m_subtaskCount(0),
    m_completedSubtasks(0)
{
}

QString Task::name() const { return m_name; }
QString Task::description() const { return m_description; }
QString Task::dueDate() const { return m_dueDate; }
int Task::priority() const { return m_priority; }
bool Task::completed() const { return m_completed; }
bool Task::hasSubtasks() const { return m_hasSubtasks; }
int Task::subtaskCount() const { return m_subtaskCount; }
int Task::completedSubtasks() const { return m_completedSubtasks; }

void Task::setName(const QString &name) { m_name = name; }
void Task::setDescription(const QString &description) { m_description = description; }
void Task::setDueDate(const QString &dueDate) { m_dueDate = dueDate; }
void Task::setPriority(int priority) { m_priority = priority; }
void Task::setCompleted(bool completed) { m_completed = completed; }
void Task::setHasSubtasks(bool hasSubtasks) { m_hasSubtasks = hasSubtasks; }
void Task::setSubtaskCount(int count) { m_subtaskCount = count; }
void Task::setCompletedSubtasks(int count) { m_completedSubtasks = count; }

TasksModel::TasksModel(QObject *parent)
    : QAbstractListModel(parent)
{
    loadData();
}

int TasksModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_tasks.size();
}

QVariant TasksModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_tasks.size())
        return QVariant();

    const Task &task = m_tasks.at(index.row());

    switch (role) {
    case NameRole:
        return task.name();
    case DescriptionRole:
        return task.description();
    case DueDateRole:
        return task.dueDate();
    case PriorityRole:
        return task.priority();
    case CompletedRole:
        return task.completed();
    case HasSubtasksRole:
        return task.hasSubtasks();
    case SubtaskCountRole:
        return task.subtaskCount();
    case CompletedSubtasksRole:
        return task.completedSubtasks();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> TasksModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[DescriptionRole] = "description";
    roles[DueDateRole] = "dueDate";
    roles[PriorityRole] = "priority";
    roles[CompletedRole] = "completed";
    roles[HasSubtasksRole] = "hasSubtasks";
    roles[SubtaskCountRole] = "subtaskCount";
    roles[CompletedSubtasksRole] = "completedSubtasks";
    return roles;
}

int TasksModel::count() const
{
    return m_tasks.size();
}

void TasksModel::addTask(const QString &name, const QString &description,
                         const QString &dueDateType, int priority)
{
    QString dueDate = getFormattedDate(dueDateType);

    beginInsertRows(QModelIndex(), m_tasks.size(), m_tasks.size());
    m_tasks.append(Task(name, description, dueDate, priority));
    endInsertRows();

    emit countChanged();
    saveData();
}

void TasksModel::removeTask(int index)
{
    if (index < 0 || index >= m_tasks.size())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_tasks.remove(index);
    endRemoveRows();

    emit countChanged();
    saveData();
}

void TasksModel::setCompleted(int index, bool completed)
{
    if (index < 0 || index >= m_tasks.size())
        return;

    m_tasks[index].setCompleted(completed);
    QModelIndex modelIndex = createIndex(index, 0);
    emit dataChanged(modelIndex, modelIndex, {CompletedRole});

    saveData();
}

void TasksModel::editTask(int index, const QString &name, const QString &description,
                          const QString &dueDateType, int priority)
{
    if (index < 0 || index >= m_tasks.size())
        return;

    QString dueDate = getFormattedDate(dueDateType);

    m_tasks[index].setName(name);
    m_tasks[index].setDescription(description);
    m_tasks[index].setDueDate(dueDate);
    m_tasks[index].setPriority(priority);

    QModelIndex modelIndex = createIndex(index, 0);
    emit dataChanged(modelIndex, modelIndex, {NameRole, DescriptionRole, DueDateRole, PriorityRole});

    saveData();
}

QString TasksModel::getFormattedDate(const QString &dateType)
{
    QDate currentDate = QDate::currentDate();

    if (dateType == "Today") {
        return currentDate.toString("MMM d, yyyy");
    } else if (dateType == "Tomorrow") {
        return currentDate.addDays(1).toString("MMM d, yyyy");
    } else if (dateType == "This Week") {
        QDate endOfWeek = currentDate.addDays(7 - currentDate.dayOfWeek());
        return endOfWeek.toString("MMM d, yyyy");
    } else if (dateType == "Next Week") {
        QDate startOfNextWeek = currentDate.addDays(8 - currentDate.dayOfWeek());
        return startOfNextWeek.toString("MMM d, yyyy");
    }

    return dateType;
}

void TasksModel::saveData()
{
    QJsonArray taskArray;

    for (int i = 0; i < m_tasks.size(); ++i) {
        const Task &task = m_tasks.at(i);
        QJsonObject taskObject;
        taskObject["name"] = task.name();
        taskObject["description"] = task.description();
        taskObject["dueDate"] = task.dueDate();
        taskObject["priority"] = task.priority();
        taskObject["completed"] = task.completed();
        taskObject["hasSubtasks"] = task.hasSubtasks();
        taskObject["subtaskCount"] = task.subtaskCount();
        taskObject["completedSubtasks"] = task.completedSubtasks();

        taskArray.append(taskObject);
    }

    QJsonDocument document(taskArray);

    QString dataLocation = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataLocation);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString filePath = dataLocation + "/tasks.json";
    QFile file(filePath);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qWarning() << "Could not open file for writing:" << filePath << "Error:" << file.errorString();
        return;
    }

    file.write(document.toJson());
    file.close();

    qDebug() << "Data saved successfully to" << filePath;
}

void TasksModel::loadData()
{
    QString dataLocation = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QString filePath = dataLocation + "/tasks.json";
    QFile file(filePath);

    if (!file.exists()) {
        qDebug() << "Tasks file does not exist:" << filePath;
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

    QJsonArray taskArray = document.array();

    beginResetModel();
    m_tasks.clear();

    for (int i = 0; i < taskArray.size(); ++i) {
        QJsonObject taskObject = taskArray.at(i).toObject();

        QString name = taskObject["name"].toString();
        QString description = taskObject["description"].toString();
        QString dueDate = taskObject["dueDate"].toString();
        int priority = taskObject["priority"].toInt();

        Task task(name, description, dueDate, priority);
        task.setCompleted(taskObject["completed"].toBool());
        task.setHasSubtasks(taskObject["hasSubtasks"].toBool(false));
        task.setSubtaskCount(taskObject["subtaskCount"].toInt(0));
        task.setCompletedSubtasks(taskObject["completedSubtasks"].toInt(0));

        m_tasks.append(task);
    }

    endResetModel();
    emit countChanged();

    qDebug() << "Loaded" << m_tasks.size() << "tasks from" << filePath;
}
