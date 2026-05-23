#include "notesmodel.h"
#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QDir>

Note::Note(const QString &title, const QString &content, const QString &category, const QString &color)
    : m_title(title)
    , m_content(content)
    , m_category(category)
    , m_color(color)
    , m_createdDate(QDateTime::currentDateTime())
    , m_modifiedDate(QDateTime::currentDateTime())
{
}

QString Note::title() const
{
    return m_title;
}

QString Note::content() const
{
    return m_content;
}

QString Note::category() const
{
    return m_category;
}

QString Note::color() const
{
    return m_color;
}

QDateTime Note::createdDate() const
{
    return m_createdDate;
}

QDateTime Note::modifiedDate() const
{
    return m_modifiedDate;
}

QString Note::formattedDate() const
{
    return m_modifiedDate.toString("MMM d, yyyy");
}

QString Note::formattedTime() const
{
    return m_modifiedDate.toString("HH:mm");
}

void Note::update(const QString &title, const QString &content, const QString &category, const QString &color)
{
    m_title = title;
    m_content = content;
    m_category = category;
    m_color = color;
    m_modifiedDate = QDateTime::currentDateTime();
}

NotesModel::NotesModel(QObject *parent)
    : QAbstractListModel(parent)
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    m_storageFilePath = dataPath + "/notes.json";

    loadNotes();
}

int NotesModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_notes.count();
}

QVariant NotesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_notes.count())
        return QVariant();

    const Note &note = m_notes.at(index.row());

    switch (role) {
    case TitleRole:
        return note.title();
    case ContentRole:
        return note.content();
    case CategoryRole:
        return note.category();
    case ColorRole:
        return note.color();
    case CreatedDateRole:
        return note.createdDate();
    case ModifiedDateRole:
        return note.modifiedDate();
    case FormattedDateRole:
        return note.formattedDate();
    case FormattedTimeRole:
        return note.formattedTime();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> NotesModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[ContentRole] = "content";
    roles[CategoryRole] = "category";
    roles[ColorRole] = "color";
    roles[CreatedDateRole] = "createdDate";
    roles[ModifiedDateRole] = "modifiedDate";
    roles[FormattedDateRole] = "formattedDate";
    roles[FormattedTimeRole] = "formattedTime";
    return roles;
}

int NotesModel::count() const
{
    return m_notes.count();
}

void NotesModel::addNote(const QString &title, const QString &content, const QString &category, const QString &color)
{
    beginInsertRows(QModelIndex(), m_notes.count(), m_notes.count());
    m_notes.append(Note(title, content, category, color));
    endInsertRows();

    emit countChanged();
    saveNotes();
}

void NotesModel::updateNote(int index, const QString &title, const QString &content, const QString &category, const QString &color)
{
    if (index < 0 || index >= m_notes.count())
        return;

    m_notes[index].update(title, content, category, color);

    QModelIndex modelIndex = createIndex(index, 0);
    emit dataChanged(modelIndex, modelIndex);
    saveNotes();
}

void NotesModel::removeNote(int index)
{
    if (index < 0 || index >= m_notes.count())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_notes.removeAt(index);
    endRemoveRows();

    emit countChanged();
    saveNotes();
}

void NotesModel::saveNotes()
{
    QJsonArray notesArray;

    int size = m_notes.size();
    for (int i = 0; i < size; ++i) {
        const Note &note = m_notes.at(i);
        QJsonObject noteObject;
        noteObject["title"] = note.title();
        noteObject["content"] = note.content();
        noteObject["category"] = note.category();
        noteObject["color"] = note.color();
        noteObject["created"] = note.createdDate().toString(Qt::ISODate);
        noteObject["modified"] = note.modifiedDate().toString(Qt::ISODate);

        notesArray.append(noteObject);
    }

    QJsonDocument document(notesArray);
    QFile file(m_storageFilePath);

    if (file.open(QIODevice::WriteOnly)) {
        file.write(document.toJson());
        file.close();
    }
}

void NotesModel::loadNotes()
{
    QFile file(m_storageFilePath);

    if (!file.exists())
        return;

    if (file.open(QIODevice::ReadOnly)) {
        QByteArray data = file.readAll();
        file.close();

        QJsonDocument document = QJsonDocument::fromJson(data);
        if (!document.isArray())
            return;

        beginResetModel();
        m_notes.clear();

        QJsonArray notesArray = document.array();
        for (int i = 0; i < notesArray.size(); ++i) {
            QJsonValue value = notesArray.at(i);
            if (!value.isObject())
                continue;

            QJsonObject noteObject = value.toObject();

            QString title = noteObject["title"].toString();
            QString content = noteObject["content"].toString();
            QString category = noteObject["category"].toString();
            QString color = noteObject["color"].toString();

            Note note(title, content, category, color);

            QDateTime created = QDateTime::fromString(noteObject["created"].toString(), Qt::ISODate);
            QDateTime modified = QDateTime::fromString(noteObject["modified"].toString(), Qt::ISODate);

            if (created.isValid()) {
                note.m_createdDate = created;
            }
            if (modified.isValid()) {
                note.m_modifiedDate = modified;
            }

            m_notes.append(note);
        }

        endResetModel();
        emit countChanged();
    }
}
