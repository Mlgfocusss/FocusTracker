#ifndef NOTESMODEL_H
#define NOTESMODEL_H

#include <QAbstractListModel>
#include <QDateTime>
#include <QVector>
#include <QColor>
#include <QObject>

class Note {
public:
    Note(const QString &title, const QString &content, const QString &category, const QString &color);

    QString title() const;
    QString content() const;
    QString category() const;
    QString color() const;
    QDateTime createdDate() const;
    QDateTime modifiedDate() const;
    QString formattedDate() const;
    QString formattedTime() const;

    void update(const QString &title, const QString &content, const QString &category, const QString &color);

    QDateTime m_createdDate;
    QDateTime m_modifiedDate;

private:
    QString m_title;
    QString m_content;
    QString m_category;
    QString m_color;
};

class NotesModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        ContentRole,
        CategoryRole,
        ColorRole,
        CreatedDateRole,
        ModifiedDateRole,
        FormattedDateRole,
        FormattedTimeRole
    };

    explicit NotesModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    int count() const;

    Q_INVOKABLE void addNote(const QString &title, const QString &content, const QString &category, const QString &color);
    Q_INVOKABLE void updateNote(int index, const QString &title, const QString &content, const QString &category, const QString &color);
    Q_INVOKABLE void removeNote(int index);
    Q_INVOKABLE void saveNotes();
    Q_INVOKABLE void loadNotes();

signals:
    void countChanged();

private:
    QVector<Note> m_notes;
    QString m_storageFilePath;
};

#endif
