#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>
#include <QSize>
#include <QString>
#include <QVariant>
#include <QTranslator>
#include <QCoreApplication>
#include <QMap>

class SettingsManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)
    Q_PROPERTY(QString timeFormat READ timeFormat WRITE setTimeFormat NOTIFY timeFormatChanged)
    Q_PROPERTY(QString firstDayOfWeek READ firstDayOfWeek WRITE setFirstDayOfWeek NOTIFY firstDayOfWeekChanged)
    Q_PROPERTY(QString currency READ currency WRITE setCurrency NOTIFY currencyChanged)
    Q_PROPERTY(QString timezone READ timezone WRITE setTimezone NOTIFY timezoneChanged)
    Q_PROPERTY(QString resolution READ resolution WRITE setResolution NOTIFY resolutionChanged)
    Q_PROPERTY(bool startMaximized READ startMaximized WRITE setStartMaximized NOTIFY startMaximizedChanged)
    Q_PROPERTY(bool startWithSystem READ startWithSystem WRITE setStartWithSystem NOTIFY startWithSystemChanged)
    Q_PROPERTY(bool minimizeToTray READ minimizeToTray WRITE setMinimizeToTray NOTIFY minimizeToTrayChanged)
    Q_PROPERTY(QString soundTheme READ soundTheme WRITE setSoundTheme NOTIFY soundThemeChanged)
    Q_PROPERTY(int soundVolume READ soundVolume WRITE setSoundVolume NOTIFY soundVolumeChanged)
    Q_PROPERTY(bool interfaceSounds READ interfaceSounds WRITE setInterfaceSounds NOTIFY interfaceSoundsChanged)
    Q_PROPERTY(bool taskCompletionSound READ taskCompletionSound WRITE setTaskCompletionSound NOTIFY taskCompletionSoundChanged)
    Q_PROPERTY(QStringList availableLanguages READ availableLanguages CONSTANT)
    Q_PROPERTY(int themeIndex READ themeIndex WRITE setThemeIndex NOTIFY themeIndexChanged)
    Q_PROPERTY(QStringList availableThemes READ availableThemes CONSTANT)

public:
    explicit SettingsManager(QObject *parent = nullptr);
    ~SettingsManager();

    QString language() const;
    QString timeFormat() const;
    QString firstDayOfWeek() const;
    QString currency() const;
    QString timezone() const;

    QString resolution() const;
    bool startMaximized() const;
    bool startWithSystem() const;
    bool minimizeToTray() const;

    QString soundTheme() const;
    int soundVolume() const;
    bool interfaceSounds() const;
    bool taskCompletionSound() const;

    int themeIndex() const;
    QStringList availableThemes() const;

    QStringList availableLanguages() const;

    Q_INVOKABLE QSize getWindowSize() const;
    Q_INVOKABLE void saveSettings();
    Q_INVOKABLE void loadSettings();
    Q_INVOKABLE void applyWindowSize(QObject* window);
    Q_INVOKABLE void setupStartupWithSystem(bool enable);
    Q_INVOKABLE QString translateLanguageName(const QString &langCode);
    Q_INVOKABLE QString getLanguageCode(const QString &langName);
    Q_INVOKABLE void retranslateApp();
    Q_INVOKABLE void setTheme(int index);

public slots:
    void setLanguage(const QString &language);
    void setTimeFormat(const QString &timeFormat);
    void setFirstDayOfWeek(const QString &firstDayOfWeek);
    void setCurrency(const QString &currency);
    void setTimezone(const QString &timezone);

    void setResolution(const QString &resolution);
    void setStartMaximized(bool startMaximized);
    void setStartWithSystem(bool startWithSystem);
    void setMinimizeToTray(bool minimizeToTray);

    void setSoundTheme(const QString &soundTheme);
    void setSoundVolume(int soundVolume);
    void setInterfaceSounds(bool interfaceSounds);
    void setTaskCompletionSound(bool taskCompletionSound);
    void setThemeIndex(int themeIndex);

signals:
    void languageChanged();
    void timeFormatChanged();
    void firstDayOfWeekChanged();
    void currencyChanged();
    void timezoneChanged();

    void resolutionChanged();
    void startMaximizedChanged();
    void startWithSystemChanged();
    void minimizeToTrayChanged();
    void windowSizeChanged(int width, int height);

    void soundThemeChanged();
    void soundVolumeChanged();
    void interfaceSoundsChanged();
    void taskCompletionSoundChanged();
    void themeIndexChanged();

    void settingsLoaded();
    void settingsApplied();
    void appTranslated();
    void themeChanged(int index);

private:
    QSettings *m_settings;
    QTranslator m_translator;
    QMap<QString, QString> m_languageCodes;

    QString m_language;
    QString m_timeFormat;
    QString m_firstDayOfWeek;
    QString m_currency;
    QString m_timezone;

    QString m_resolution;
    bool m_startMaximized;
    bool m_startWithSystem;
    bool m_minimizeToTray;

    QString m_soundTheme;
    int m_soundVolume;
    bool m_interfaceSounds;
    bool m_taskCompletionSound;

    int m_themeIndex;
    QStringList m_themeNames;

    void initDefaultSettings();
    void initLanguageMap();
    void applyLanguage(const QString &language);
    void initThemeNames();
};

#endif // SETTINGSMANAGER_H
