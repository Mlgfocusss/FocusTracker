#include "authmanager.h"
#include <QStandardPaths>
#include <QDebug>
#include <QDir>
#include <QDateTime>
#include <QCoreApplication>

const QRegularExpression AuthManager::s_emailRegex("\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b");

AuthManager::AuthManager(QObject *parent)
    : QObject(parent)
    , m_isAuthenticated(false)
    , m_currentUsername("")
    , m_salt("LifeTracker2025Salt")
{
    QString appDir = QCoreApplication::applicationDirPath();
    QString pluginsDir = appDir + "/sqldrivers";

    QCoreApplication::addLibraryPath(appDir);
    QCoreApplication::addLibraryPath(pluginsDir);

    if (!initDatabase()) {
        qWarning() << "Failed to initialize database";
    }
}

void AuthManager::initSavedUser()
{
    QSettings settings;
    QString savedUser = settings.value("auth/username").toString();
    bool rememberMe = settings.value("auth/rememberMe", false).toBool();

    if (rememberMe && !savedUser.isEmpty()) {
        setCurrentUsername(savedUser);
        setAuthenticated(true);
        qDebug() << "Auto-login for user:" << savedUser;
    } else {
        setAuthenticated(false);
        setCurrentUsername("");
    }
}

AuthManager::~AuthManager()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
}

bool AuthManager::isAuthenticated() const
{
    return m_isAuthenticated;
}

QString AuthManager::currentUsername() const
{
    return m_currentUsername;
}

void AuthManager::setAuthenticated(bool status)
{
    if (m_isAuthenticated != status) {
        m_isAuthenticated = status;
        emit authStatusChanged();
    }
}

void AuthManager::setCurrentUsername(const QString &username)
{
    if (m_currentUsername != username) {
        m_currentUsername = username;
        emit currentUserChanged();
    }
}

bool AuthManager::login(const QString &username, const QString &password, bool rememberMe)
{
    if (username.isEmpty() || password.isEmpty()) {
        emit authError("Username and password cannot be empty");
        return false;
    }

    QSqlQuery query(m_db);
    query.prepare("SELECT password FROM users WHERE username = :username");
    query.bindValue(":username", username);

    if (!query.exec()) {
        emit authError("Database error: " + query.lastError().text());
        return false;
    }

    if (!query.next()) {
        emit authError("User not found");
        return false;
    }

    QString storedPassword = query.value(0).toString();
    QString hashedPassword = hashPassword(password);

    if (storedPassword != hashedPassword) {
        emit authError("Invalid password");
        return false;
    }

    setCurrentUsername(username);
    setAuthenticated(true);

    QSettings settings;
    settings.setValue("auth/rememberMe", rememberMe);
    if (rememberMe) {
        settings.setValue("auth/username", username);
    } else {
        settings.remove("auth/username");
    }

    emit authSuccess(username);
    return true;
}

bool AuthManager::registerUser(const QString &username, const QString &email, const QString &password)
{
    if (username.isEmpty() || email.isEmpty() || password.isEmpty()) {
        emit authError("All fields are required");
        return false;
    }

    if (!validateEmail(email)) {
        emit authError("Invalid email format");
        return false;
    }

    if (password.length() < 6) {
        emit authError("Password must be at least 6 characters");
        return false;
    }

    if (checkUserExists(username)) {
        emit authError("Username already exists");
        return false;
    }

    QSqlQuery query(m_db);
    query.prepare("INSERT INTO users (username, email, password, created) VALUES (:username, :email, :password, :created)");
    query.bindValue(":username", username);
    query.bindValue(":email", email);
    query.bindValue(":password", hashPassword(password));
    query.bindValue(":created", QDateTime::currentDateTime().toString(Qt::ISODate));

    if (!query.exec()) {
        emit authError("Failed to register user: " + query.lastError().text());
        return false;
    }

    setCurrentUsername(username);
    setAuthenticated(true);
    emit authSuccess(username);
    return true;
}

void AuthManager::logout()
{
    setAuthenticated(false);
    setCurrentUsername("");

    QSettings settings;
    settings.remove("auth/username");
    settings.remove("auth/rememberMe");
}

QString AuthManager::hashPassword(const QString &password)
{
    QByteArray passwordBytes = password.toUtf8();
    QByteArray saltBytes = m_salt.toUtf8();

    QByteArray combined = passwordBytes + saltBytes;
    QByteArray hashedPass = QCryptographicHash::hash(combined, QCryptographicHash::Sha256);

    hashedPass = QCryptographicHash::hash(hashedPass + saltBytes, QCryptographicHash::Sha256);

    return QString(hashedPass.toHex());
}

bool AuthManager::validateEmail(const QString &email)
{
    return s_emailRegex.match(email).hasMatch();
}

bool AuthManager::initDatabase()
{
    QStringList drivers = QSqlDatabase::drivers();

    if (!drivers.contains("QSQLITE")) {
        qWarning() << "SQLite driver not available";
        return false;
    }

    if (m_db.isOpen()) {
        m_db.close();
    }

    if (QSqlDatabase::contains("qt_sql_default_connection")) {
        m_db = QSqlDatabase::database("qt_sql_default_connection");
    } else {
        m_db = QSqlDatabase::addDatabase("QSQLITE");
    }

    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) {
        dir.mkpath(dataPath);
    }

    QString dbPath = dir.filePath("userdata.db");
    m_db.setDatabaseName(dbPath);

    if (!m_db.open()) {
        qWarning() << "Failed to open database:" << m_db.lastError().text();
        return false;
    }

    QSqlQuery query(m_db);
    if (!query.exec("CREATE TABLE IF NOT EXISTS users ("
                    "username TEXT PRIMARY KEY, "
                    "email TEXT NOT NULL, "
                    "password TEXT NOT NULL, "
                    "created TEXT NOT NULL)")) {
        qWarning() << "Failed to create users table:" << query.lastError().text();
        return false;
    }

    return true;
}

bool AuthManager::checkUserExists(const QString &username)
{
    QSqlQuery query(m_db);
    query.prepare("SELECT COUNT(*) FROM users WHERE username = :username");
    query.bindValue(":username", username);

    if (!query.exec() || !query.next()) {
        qWarning() << "Error checking if user exists:" << query.lastError().text();
        return false;
    }

    return query.value(0).toInt() > 0;
}
