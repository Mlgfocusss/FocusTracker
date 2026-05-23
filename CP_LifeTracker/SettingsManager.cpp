#include "SettingsManager.h"
#include <QDebug>
#include <QDir>
#include <QWindow>
#include <QStandardPaths>
#include <QCoreApplication>
#include <QLocale>
#include <QTranslator>
#include <QFileInfo>

#ifdef Q_OS_WIN
#include <windows.h>
#include <QSettings>
#endif

SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent)
    , m_settings(new QSettings("LifeTracker", "LifeTracker", this))
{
    initLanguageMap();
    initThemeNames();
    loadSettings();
    applyLanguage(m_language);
}

SettingsManager::~SettingsManager()
{
    saveSettings();
}

void SettingsManager::initLanguageMap()
{
    m_languageCodes["English"] = "en";
    m_languageCodes["Русский"] = "ru";
    m_languageCodes["Español"] = "es";
    m_languageCodes["Français"] = "fr";
    m_languageCodes["Deutsch"] = "de";
    m_languageCodes["中文"] = "zh";
    m_languageCodes["日本語"] = "ja";
}

void SettingsManager::initThemeNames()
{
    m_themeNames << "light" << "dark" << "colorful";
}

void SettingsManager::initDefaultSettings()
{
    m_language = "English";
    m_timeFormat = "24-hour";
    m_firstDayOfWeek = "Monday";
    m_currency = "$ US Dollar";
    m_timezone = "UTC";
    m_resolution = "1366x768";
    m_startMaximized = false;
    m_startWithSystem = true;
    m_minimizeToTray = true;
    m_soundTheme = "None";
    m_soundVolume = 30;
    m_interfaceSounds = true;
    m_taskCompletionSound = true;
    m_themeIndex = 0;
}

void SettingsManager::loadSettings()
{
    initDefaultSettings();

    m_language = m_settings->value("language/interface", m_language).toString();
    m_timeFormat = m_settings->value("language/timeFormat", m_timeFormat).toString();
    m_firstDayOfWeek = m_settings->value("language/firstDayOfWeek", m_firstDayOfWeek).toString();
    m_currency = m_settings->value("language/currency", m_currency).toString();
    m_timezone = m_settings->value("language/timezone", m_timezone).toString();

    m_resolution = m_settings->value("window/resolution", m_resolution).toString();
    m_startMaximized = m_settings->value("window/startMaximized", m_startMaximized).toBool();
    m_startWithSystem = m_settings->value("window/startWithSystem", m_startWithSystem).toBool();
    m_minimizeToTray = m_settings->value("window/minimizeToTray", m_minimizeToTray).toBool();

    m_soundTheme = m_settings->value("sound/theme", m_soundTheme).toString();
    m_soundVolume = m_settings->value("sound/volume", m_soundVolume).toInt();
    m_interfaceSounds = m_settings->value("sound/interfaceSounds", m_interfaceSounds).toBool();
    m_taskCompletionSound = m_settings->value("sound/taskCompletionSound", m_taskCompletionSound).toBool();

    m_themeIndex = m_settings->value("appearance/themeIndex", m_themeIndex).toInt();

    if (m_themeIndex < 0 || m_themeIndex >= m_themeNames.size()) {
        m_themeIndex = 0;
    }

    emit settingsLoaded();
    emit themeChanged(m_themeIndex);
}

void SettingsManager::saveSettings()
{
    m_settings->setValue("language/interface", m_language);
    m_settings->setValue("language/timeFormat", m_timeFormat);
    m_settings->setValue("language/firstDayOfWeek", m_firstDayOfWeek);
    m_settings->setValue("language/currency", m_currency);
    m_settings->setValue("language/timezone", m_timezone);

    m_settings->setValue("window/resolution", m_resolution);
    m_settings->setValue("window/startMaximized", m_startMaximized);
    m_settings->setValue("window/startWithSystem", m_startWithSystem);
    m_settings->setValue("window/minimizeToTray", m_minimizeToTray);

    m_settings->setValue("sound/theme", m_soundTheme);
    m_settings->setValue("sound/volume", m_soundVolume);
    m_settings->setValue("sound/interfaceSounds", m_interfaceSounds);
    m_settings->setValue("sound/taskCompletionSound", m_taskCompletionSound);

    m_settings->setValue("appearance/themeIndex", m_themeIndex);

    m_settings->sync();
}

QSize SettingsManager::getWindowSize() const
{
    if (m_resolution.isEmpty()) return QSize(1366, 768);

    QStringList parts = m_resolution.split('x');
    if (parts.size() != 2) return QSize(1366, 768);

    bool widthOk, heightOk;
    int width = parts.at(0).toInt(&widthOk);
    int height = parts.at(1).toInt(&heightOk);

    if (!widthOk || !heightOk) return QSize(1366, 768);

    return QSize(width, height);
}

void SettingsManager::applyWindowSize(QObject* window)
{
    if (!window) {
        qWarning() << "Cannot apply window size: window object is null";
        return;
    }

    QWindow* qWindow = qobject_cast<QWindow*>(window);
    if (!qWindow) {
        QWindow* win = window->property("window").value<QWindow*>();
        if (!win) {
            qWarning() << "Could not get QWindow from object";
            return;
        }
        qWindow = win;
    }

    QSize size = getWindowSize();

    if (m_startMaximized) {
        qWindow->setVisibility(QWindow::Maximized);
    } else {
        if (qWindow->visibility() == QWindow::Maximized) {
            qWindow->setVisibility(QWindow::Windowed);
        }
        qWindow->resize(size);
    }

    emit windowSizeChanged(size.width(), size.height());
    emit settingsApplied();
}

void SettingsManager::setupStartupWithSystem(bool enable)
{
#ifdef Q_OS_WIN
    QSettings settings("HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Run", QSettings::NativeFormat);
    QString appPath = QDir::toNativeSeparators(QCoreApplication::applicationFilePath());
    QString appName = QCoreApplication::applicationName();

    if (enable) {
        settings.setValue(appName, appPath);
    } else {
        settings.remove(appName);
    }
#endif
}

void SettingsManager::applyLanguage(const QString &language)
{
    QString langCode = getLanguageCode(language);

    QCoreApplication::removeTranslator(&m_translator);

    if (langCode == "en") {
        emit appTranslated();
        return;
    }

    bool loaded = false;

    QString qmFileFromResource = ":/i18n/translations/lifetracker_" + langCode + ".qm";
    if (m_translator.load(qmFileFromResource)) {
        QCoreApplication::installTranslator(&m_translator);
        qDebug() << "Loaded translation from resource:" << qmFileFromResource;
        loaded = true;
    }

    if (!loaded) {
        QString altPath = ":/translations/lifetracker_" + langCode + ".qm";
        if (m_translator.load(altPath)) {
            QCoreApplication::installTranslator(&m_translator);
            qDebug() << "Loaded translation from alt resource path:" << altPath;
            loaded = true;
        }
    }

    if (!loaded) {
        QString appDirPath = QCoreApplication::applicationDirPath() + "/translations/lifetracker_" + langCode + ".qm";
        if (QFileInfo::exists(appDirPath) && m_translator.load(appDirPath)) {
            QCoreApplication::installTranslator(&m_translator);
            qDebug() << "Loaded translation from app directory:" << appDirPath;
            loaded = true;
        }
    }

    if (!loaded) {
        QString dataPath = QStandardPaths::locate(QStandardPaths::AppDataLocation,
                                                  QString("translations/lifetracker_%1.qm").arg(langCode));
        if (!dataPath.isEmpty() && m_translator.load(dataPath)) {
            QCoreApplication::installTranslator(&m_translator);
            qDebug() << "Loaded translation from standard location:" << dataPath;
            loaded = true;
        }
    }

    if (!loaded) {
        qWarning() << "Failed to load any translation for language:" << langCode;
    }

    emit appTranslated();
}

QString SettingsManager::translateLanguageName(const QString &langCode)
{
    for (auto it = m_languageCodes.begin(); it != m_languageCodes.end(); ++it) {
        if (it.value() == langCode) {
            return it.key();
        }
    }
    return "English";
}

QString SettingsManager::getLanguageCode(const QString &langName)
{
    return m_languageCodes.value(langName, "en");
}

void SettingsManager::retranslateApp()
{
    applyLanguage(m_language);
}

void SettingsManager::setTheme(int index)
{
    setThemeIndex(index);
}

QStringList SettingsManager::availableLanguages() const
{
    QStringList langs;
    for (auto it = m_languageCodes.begin(); it != m_languageCodes.end(); ++it) {
        langs.append(it.key());
    }
    return langs;
}

QStringList SettingsManager::availableThemes() const
{
    return m_themeNames;
}

QString SettingsManager::language() const { return m_language; }
QString SettingsManager::timeFormat() const { return m_timeFormat; }
QString SettingsManager::firstDayOfWeek() const { return m_firstDayOfWeek; }
QString SettingsManager::currency() const { return m_currency; }
QString SettingsManager::timezone() const { return m_timezone; }
QString SettingsManager::resolution() const { return m_resolution; }
bool SettingsManager::startMaximized() const { return m_startMaximized; }
bool SettingsManager::startWithSystem() const { return m_startWithSystem; }
bool SettingsManager::minimizeToTray() const { return m_minimizeToTray; }
QString SettingsManager::soundTheme() const { return m_soundTheme; }
int SettingsManager::soundVolume() const { return m_soundVolume; }
bool SettingsManager::interfaceSounds() const { return m_interfaceSounds; }
bool SettingsManager::taskCompletionSound() const { return m_taskCompletionSound; }
int SettingsManager::themeIndex() const { return m_themeIndex; }

void SettingsManager::setLanguage(const QString &language) {
    if (m_language != language) {
        m_language = language;
        applyLanguage(language);
        emit languageChanged();
    }
}

void SettingsManager::setTimeFormat(const QString &timeFormat) {
    if (m_timeFormat != timeFormat) {
        m_timeFormat = timeFormat;
        emit timeFormatChanged();
    }
}

void SettingsManager::setFirstDayOfWeek(const QString &firstDayOfWeek) {
    if (m_firstDayOfWeek != firstDayOfWeek) {
        m_firstDayOfWeek = firstDayOfWeek;
        emit firstDayOfWeekChanged();
    }
}

void SettingsManager::setCurrency(const QString &currency) {
    if (m_currency != currency) {
        m_currency = currency;
        emit currencyChanged();
    }
}

void SettingsManager::setTimezone(const QString &timezone) {
    if (m_timezone != timezone) {
        m_timezone = timezone;
        emit timezoneChanged();
    }
}

void SettingsManager::setResolution(const QString &resolution) {
    if (m_resolution != resolution) {
        m_resolution = resolution;
        emit resolutionChanged();
    }
}

void SettingsManager::setStartMaximized(bool startMaximized) {
    if (m_startMaximized != startMaximized) {
        m_startMaximized = startMaximized;
        emit startMaximizedChanged();
    }
}

void SettingsManager::setStartWithSystem(bool startWithSystem) {
    if (m_startWithSystem != startWithSystem) {
        m_startWithSystem = startWithSystem;
        setupStartupWithSystem(startWithSystem);
        emit startWithSystemChanged();
    }
}

void SettingsManager::setMinimizeToTray(bool minimizeToTray) {
    if (m_minimizeToTray != minimizeToTray) {
        m_minimizeToTray = minimizeToTray;
        emit minimizeToTrayChanged();
    }
}

void SettingsManager::setSoundTheme(const QString &soundTheme) {
    if (m_soundTheme != soundTheme) {
        m_soundTheme = soundTheme;
        emit soundThemeChanged();
    }
}

void SettingsManager::setSoundVolume(int soundVolume) {
    if (m_soundVolume != soundVolume) {
        m_soundVolume = soundVolume;
        emit soundVolumeChanged();
    }
}

void SettingsManager::setInterfaceSounds(bool interfaceSounds) {
    if (m_interfaceSounds != interfaceSounds) {
        m_interfaceSounds = interfaceSounds;
        emit interfaceSoundsChanged();
    }
}

void SettingsManager::setTaskCompletionSound(bool taskCompletionSound) {
    if (m_taskCompletionSound != taskCompletionSound) {
        m_taskCompletionSound = taskCompletionSound;
        emit taskCompletionSoundChanged();
    }
}

void SettingsManager::setThemeIndex(int themeIndex) {
    if (themeIndex < 0 || themeIndex >= m_themeNames.size()) {
        return;
    }

    if (m_themeIndex != themeIndex) {
        m_themeIndex = themeIndex;
        saveSettings();
        emit themeIndexChanged();
        emit themeChanged(m_themeIndex);
    }
}
