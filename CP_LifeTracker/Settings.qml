import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

Window {
    id: settingsWindow
    title: ""
    width: 1000
    height: 600
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint
    modality: Qt.ApplicationModal

    property var availableLanguages: ["English", "Русский", "Español", "Français", "Deutsch", "中文", "日本語"]
    property var availableTimeFormats: ["12-hour (AM/PM)", "24-hour"]
    property var availableDaysOfWeek: ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    property var availableTimezones: ["Europe/Stockholm", "Europe/Moscow", "America/New_York", "Asia/Tokyo"]

    property int animationDuration: 200

    Theme {
        id: currentTheme
    }

    property color accentColor: currentTheme.accentColor
    property color bgColor: currentTheme.backgroundColor
    property color bgColorDarker: currentTheme.backgroundSecondaryColor
    property color textColor: currentTheme.textColor
    property color textColorDim: currentTheme.textSecondaryColor
    property color borderColor: currentTheme.borderColor
    property color hoverColor: currentTheme.navHoverColor
    property color selectedColor: currentTheme.cardSelectedColor
    property color sidebarColor: currentTheme.backgroundSecondaryColor
    property color activeItemColor: currentTheme.accentColor

    property string currentTab: "general"
    property var rootWindow: null


    Connections {
        target: SettingsManager
        function onThemeIndexChanged() {
            console.log("SettingsWindow (via SettingsManager.onThemeIndexChanged): Обнаружено изменение themeIndex из C++. Новый SettingsManager.themeIndex: " + SettingsManager.themeIndex);
        }
    }

    Component.onCompleted: {
        console.log("SettingsWindow: Component COMPLETED. Загрузка настроек...");
        SettingsManager.loadSettings();
        console.log("SettingsWindow: Начальный settingsWindow.bgColor после loadSettings(): " + settingsWindow.bgColor + " (currentTheme.backgroundColor: " + currentTheme.backgroundColor + ")");
    }

    function show() {
        showAnimation.start()
        x = (Screen.width - width) / 2
        y = (Screen.height - height) / 2
        visible = true
    }

    function hide() {
        SettingsManager.saveSettings()
        SettingsManager.applyWindowSize(rootWindow)
        hideAnimation.start()
    }

    Connections {
        target: SettingsManager
        function onResolutionChanged() {
            if (rootWindow) {
                SettingsManager.applyWindowSize(rootWindow)
            }
        }

        function onAppTranslated() {
            contentLoader.reload()
        }
    }

    signal closeSettings()

    PropertyAnimation {
        id: showAnimation
        target: settingsRoot
        property: "opacity"
        from: 0
        to: 1
        duration: animationDuration
        easing.type: Easing.OutCubic
    }

    PropertyAnimation {
        id: hideAnimation
        target: settingsRoot
        property: "opacity"
        from: 1
        to: 0
        duration: animationDuration
        easing.type: Easing.InCubic
        onStopped: visible = false
    }

    Rectangle {
        id: settingsRoot
        width: parent.width
        height: parent.height
        color: settingsWindow.bgColor
        radius: 12
        anchors.centerIn: parent
        opacity: 0

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 3
            radius: 15.0
            samples: 24
            color: "#80000000"
            transparentBorder: true
        }

        WindowHeader {
            id: windowHeader
            width: parent.width
            height: 60
            onCloseRequested: settingsWindow.hide()
            onMinimizeRequested: settingsWindow.hide()
            currentTab: settingsWindow.currentTab
        }

        Item {
            id: contentContainer
            anchors.top: windowHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            Loader {
                id: contentLoader
                anchors.fill: parent
                sourceComponent: contentComponent

                function reload() {
                    var oldTab = currentTab
                    sourceComponent = null
                    currentTab = oldTab
                    sourceComponent = contentComponent
                }
            }

            Component {
                id: contentComponent

                Row {
                    anchors.fill: parent
                    spacing: 0

                    SidebarArea {
                        id: sidebarArea
                        width: 250
                        height: parent.height
                        onTabSelected: currentTab = tab
                        currentActiveTab: currentTab
                    }

                    ContentArea {
                        id: contentArea
                        width: parent.width - sidebarArea.width
                        height: parent.height
                        currentTab: settingsWindow.currentTab
                        availableLanguages: settingsWindow.availableLanguages
                        availableDaysOfWeek: settingsWindow.availableDaysOfWeek
                        availableTimeFormats: settingsWindow.availableTimeFormats
                        availableTimezones: settingsWindow.availableTimezones
                    }
                }
            }
        }
    }
}
