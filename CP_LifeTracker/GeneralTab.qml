import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Item {
    id: generalTab

    Theme {
        id: theme
        themeIndex: SettingsManager.themeIndex
    }

    property var availableLanguages: ["English", "Русский", "Español", "Français", "Deutsch", "中文", "日本語"]
    property var availableTimeFormats: ["12-hour", "24-hour"]
    property var availableDaysOfWeek: ["Monday", "Sunday"]
    property var availableTimezones: ["UTC", "UTC+1", "UTC+2", "UTC+3", "UTC+4", "UTC-5", "UTC-8"]
    property var availableResolutions: ["800x600", "1024x768", "1280x720", "1366x768", "1920x1080", "2560x1440"]
    property var availableSoundThemes: ["None", "Minimalist", "Classic", "Nature", "Urban"]

    Connections {
        target: SettingsManager
        function onAppTranslated() {
            updateUiTranslations()
        }
    }

    Connections {
        target: SettingsManager
        function onThemeIndexChanged() {
            theme.themeIndex = SettingsManager.themeIndex
        }
    }

    function updateUiTranslations() {
        availableSoundThemes = ["None", "Minimalist", "Classic", "Nature", "Urban"]
    }

    Component.onCompleted: {
        updateUiTranslations()
    }

    component ThemeCard : Rectangle {
        id: themeCard

        property string themeName: ""
        property string themeIcon: ""
        property int themeValue: -1
        property bool isSelected: false

        property color baseColor: theme.cardColor
        property color borderColorNormal: theme.buttonBorderColor
        property color borderColorSelected: theme.accentColor
        property color textColorNormal: theme.textColor
        property color textColorSelected: theme.accentColor
        property color highlightColor: Qt.lighter(theme.accentColor, 1.9)
        property color iconShadowColor: theme.shadowColor

        radius: 12
        color: isSelected ? highlightColor : baseColor
        border.width: 2
        border.color: isSelected ? borderColorSelected : borderColorNormal

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 3
            radius: 8.0
            samples: 17
            color: theme.shadowColor
            transparentBorder: true
        }

        Behavior on color {
            ColorAnimation { duration: 250
            easing.type: Easing.OutQuad }
        }

        Behavior on border.color {
            ColorAnimation { duration: 250
                easing.type: Easing.OutQuad }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        Rectangle {
            id: hoverEffect
            anchors.fill: parent
            radius: parent.radius
            color: "#000000"
            opacity: 0

            Behavior on opacity {
                NumberAnimation { duration: 200
                    easing.type: Easing.OutQuad }
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 12

            Item {
                id: iconContainer
                width: 60
                height: 60
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    id: iconBackground
                    anchors.centerIn: parent
                    width: 54
                    height: 54
                    radius: width / 2
                    color: isSelected ? Qt.alpha(theme.accentColor, 0.15) : "transparent"
                    scale: isSelected ? 1.1 : 1.0

                    Behavior on color {
                        ColorAnimation { duration: 300
                            easing.type: Easing.OutQuad }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: themeIcon
                    font.pixelSize: 32
                    scale: isSelected ? 1.1 : 1.0

                    Behavior on scale {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                    }

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 1
                        radius: 4.0
                        samples: 9
                        color: iconShadowColor
                    }
                }
            }

            Text {
                text: themeName
                font.pixelSize: 16
                font.weight: Font.Medium
                color: isSelected ? textColorSelected : textColorNormal
                Layout.alignment: Qt.AlignHCenter

                Behavior on color {
                    ColorAnimation { duration: 250
                        easing.type: Easing.OutQuad }
                }
            }
        }

        Rectangle {
            id: selectedIndicator
            width: 22
            height: 22
            radius: 11
            color: theme.accentColor
            visible: true
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10
            opacity: isSelected ? 1 : 0
            scale: isSelected ? 1 : 0.5

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutBack
                }
            }

            Text {
                text: "✓"
                color: "white"
                font.pixelSize: 14
                font.weight: Font.Bold
                anchors.centerIn: parent
                scale: isSelected ? 1 : 0

                Behavior on scale {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutBack
                    }
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: {
                hoverEffect.opacity = 0.05
                if (!isSelected) {
                    themeCard.scale = 1.02
                    iconBackground.scale = 1.1
                }
            }

            onExited: {
                hoverEffect.opacity = 0
                themeCard.scale = 1.0
                iconBackground.scale = 1.0
            }

            onPressed: {
                hoverEffect.opacity = 0.1
                themeCard.scale = 0.98
            }

            onReleased: {
                hoverEffect.opacity = mouseArea.containsMouse ? 0.05 : 0
                themeCard.scale = mouseArea.containsMouse ? 1.02 : 1.0
            }

            onClicked: {
                SettingsManager.setThemeIndex(themeValue);
            }
        }
    }

    Flickable {
        anchors.fill: parent
        anchors.margins: 30
        contentWidth: width
        contentHeight: generalColumn.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: generalColumn
            width: parent.width
            spacing: 35

            SettingSection {
                title: qsTr("Language and Region")
                icon: "🌐"
                description: qsTr("Interface language and regional settings")

                GridLayout {
                    columns: 2
                    rowSpacing: 20
                    columnSpacing: 30
                    Layout.fillWidth: true
                    Layout.topMargin: 15

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Interface Language")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("Choose language for the application interface")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    CustomComboBox {
                         id: languageComboBox
                         model: availableLanguages
                         currentIndex: {
                             var idx = availableLanguages.indexOf(SettingsManager.language);
                             return idx >= 0 ? idx : 0;
                         }
                         width: 200
                         Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                         onCurrentTextChanged: {
                             if (currentText !== SettingsManager.language) {
                                 SettingsManager.language = currentText;
                             }
                         }
                     }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Time Format")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("Display time in 12 or 24-hour format")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    CustomComboBox {
                        model: availableTimeFormats
                        currentIndex: availableTimeFormats.indexOf(SettingsManager.timeFormat)
                        width: 200
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onCurrentTextChanged: SettingsManager.timeFormat = currentText
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("First Day of Week")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("Day of the week that starts the calendar")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    CustomComboBox {
                        model: availableDaysOfWeek
                        currentIndex: availableDaysOfWeek.indexOf(SettingsManager.firstDayOfWeek)
                        width: 200
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onCurrentTextChanged: SettingsManager.firstDayOfWeek = currentText
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Time Zone")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("Determines time display for all events")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    CustomComboBox {
                        model: availableTimezones
                        currentIndex: availableTimezones.indexOf(SettingsManager.timezone)
                        width: 200
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onCurrentTextChanged: SettingsManager.timezone = currentText
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: borderColor
                Layout.topMargin: 5
                Layout.bottomMargin: 5
            }

            SettingSection {
                title: qsTr("Window Settings")
                icon: "🖥️"
                description: qsTr("Application display and operation settings")

                GridLayout {
                    columns: 2
                    rowSpacing: 20
                    columnSpacing: 30
                    Layout.fillWidth: true
                    Layout.topMargin: 15

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Window Resolution")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("Main application window size")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    CustomComboBox {
                        id: resolutionComboBox
                        model: availableResolutions
                        currentIndex: availableResolutions.indexOf(SettingsManager.resolution)
                        width: 200
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onCurrentTextChanged: {
                            SettingsManager.resolution = currentText
                            SettingsManager.applyWindowSize(root)
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Launch Maximized")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("Start application in fullscreen mode")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    CustomSwitch {
                        checked: SettingsManager.startMaximized
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onCheckedChanged: {
                            SettingsManager.startMaximized = checked
                            SettingsManager.applyWindowSize(root)
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Start with System")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("Automatically start when computer boots")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    CustomSwitch {
                        checked: SettingsManager.startWithSystem
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onCheckedChanged: SettingsManager.startWithSystem = checked
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Minimize to Tray")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("When closing the window, minimize to tray instead of exiting")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    CustomSwitch {
                        checked: SettingsManager.minimizeToTray
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onCheckedChanged: SettingsManager.minimizeToTray = checked
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: borderColor
                Layout.topMargin: 5
                Layout.bottomMargin: 5
            }

            SettingSection {
                title: qsTr("Sounds")
                icon: "🔊"
                description: qsTr("Sound settings")

                GridLayout {
                    columns: 2
                    rowSpacing: 20
                    columnSpacing: 30
                    Layout.fillWidth: true
                    Layout.topMargin: 15

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Background Sounds")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("Sound accompaniment during work")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    CustomComboBox {
                        model: availableSoundThemes
                        currentIndex: availableSoundThemes.indexOf(SettingsManager.soundTheme)
                        width: 200
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onCurrentTextChanged: SettingsManager.soundTheme = currentText
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Background Sound Volume")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("Volume level of background sound")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    RowLayout {
                        spacing: 10
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                        Text {
                            text: "0%"
                            color: textColorDim
                            font.pixelSize: 14
                        }

                        Slider {
                            width: 130
                            from: 0
                            to: 100
                            value: SettingsManager.soundVolume
                            stepSize: 1
                            onValueChanged: SettingsManager.soundVolume = value
                        }

                        Text {
                            text: "100%"
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Interface Sounds")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("Sounds when pressing buttons and interacting with elements")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    CustomSwitch {
                        checked: SettingsManager.interfaceSounds
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onCheckedChanged: SettingsManager.interfaceSounds = checked
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: qsTr("Task Completion Sound")
                            color: textColor
                            font.pixelSize: 16
                            font.weight: Font.Medium
                        }

                        Text {
                            text: qsTr("Play a sound when marking a task as completed")
                            color: textColorDim
                            font.pixelSize: 14
                        }
                    }

                    CustomSwitch {
                        checked: SettingsManager.taskCompletionSound
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onCheckedChanged: SettingsManager.taskCompletionSound = checked
                    }
                }
            }

            Item { height: 30; width: 1 }
        }
    }
}
