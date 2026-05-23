#ifndef AUTHMANAGER_H
#define AUTHMANAGER_H

#include <QObject>
#include <QString>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QCryptographicHash>
#include <QSettings>
#include <QRegularExpression>

class AuthManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isAuthenticated READ isAuthenticated NOTIFY authStatusChanged)
    Q_PROPERTY(QString currentUsername READ currentUsername NOTIFY currentUserChanged)

public:
    explicit AuthManager(QObject *parent = nullptr);
    ~AuthManager();

    bool isAuthenticated() const;
    QString currentUsername() const;

public slots:
    bool login(const QString &username, const QString &password, bool rememberMe = false);
    bool registerUser(const QString &username, const QString &email, const QString &password);
    void logout();
    void initSavedUser();

signals:
    void authStatusChanged();
    void currentUserChanged();
    void authError(const QString &message);
    void authSuccess(const QString &username);

private:
    QString hashPassword(const QString &password);
    bool validateEmail(const QString &email);
    bool initDatabase();
    bool checkUserExists(const QString &username);
    void setAuthenticated(bool status);
    void setCurrentUsername(const QString &username);

    QSqlDatabase m_db;
    bool m_isAuthenticated;
    QString m_currentUsername;
    QString m_salt;
    static const QRegularExpression s_emailRegex;
};

#endif
