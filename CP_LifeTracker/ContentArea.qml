import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: contentArea
    color: bgColor

    property string currentTab: "account"
    property var availableLanguages: []
    property var availableDaysOfWeek: []
    property var availableTimeFormats: []
    property var availableTimezones: []

    property var tabTexts: [
        qsTr("Account"),
        qsTr("General"),
        qsTr("Appearance"),
        qsTr("Notifications"),
        qsTr("Дополнительно"),
        qsTr("Support Center"),
        qsTr("Updates"),
        qsTr("Roadmap"),
        qsTr("О приложении")
    ]

    Connections {
        target: SettingsManager
        function onAppTranslated() {
            updateUiTranslations()
        }
    }

    function updateUiTranslations() {
        tabTexts = [
            qsTr("Account"),
            qsTr("General"),
            qsTr("Appearance"),
            qsTr("Notifications"),
            qsTr("Дополнительно"),
            qsTr("Support Center"),
            qsTr("Updates"),
            qsTr("Roadmap"),
            qsTr("О приложении")
        ]

        tabLabel0.text = tabTexts[2]
        tabLabel1.text = tabTexts[3]
        tabLabel2.text = tabTexts[4]
        tabLabel3.text = tabTexts[5]
        tabLabel4.text = tabTexts[6]
        tabLabel5.text = tabTexts[7]
        tabLabel6.text = tabTexts[8]
    }

    Component.onCompleted: {
        updateUiTranslations()
    }

    StackLayout {
        anchors.fill: parent
        currentIndex: {
            switch(currentTab) {
                case "account": return 0;
                case "general": return 1;
                case "appearance": return 2;
                case "notifications": return 3;
                case "additional": return 4;
                case "support": return 5;
                case "updates": return 6;
                case "roadmap": return 7;
                case "about": return 8;
                default: return 0;
            }
        }

        AccountTab {}
        GeneralTab {
            availableLanguages: contentArea.availableLanguages
            availableDaysOfWeek: contentArea.availableDaysOfWeek
            availableTimeFormats: contentArea.availableTimeFormats
            availableTimezones: contentArea.availableTimezones
        }

        AppearanceTab {
            availableFonts: ["Inter", "Roboto", "Open Sans", "Montserrat", "SF Pro"]
            fontSizes: ["Small", "Medium", "Large", "Extra Large"]
        }

        Rectangle {
            color: bgColor
            Text {
                id: tabLabel1
                anchors.centerIn: parent
                text: tabTexts[3]
                color: textColor
                font.pixelSize: 20
            }
        }

        Rectangle {
            color: bgColor
            Text {
                id: tabLabel2
                anchors.centerIn: parent
                text: tabTexts[4]
                color: textColor
                font.pixelSize: 20
            }
        }

        Rectangle {
            color: bgColor
            Text {
                id: tabLabel3
                anchors.centerIn: parent
                text: tabTexts[5]
                color: textColor
                font.pixelSize: 20
            }
        }

        Rectangle {
            color: bgColor
            Text {
                id: tabLabel4
                anchors.centerIn: parent
                text: tabTexts[6]
                color: textColor
                font.pixelSize: 20
            }
        }

        Rectangle {
            color: bgColor
            Text {
                id: tabLabel5
                anchors.centerIn: parent
                text: tabTexts[7]
                color: textColor
                font.pixelSize: 20
            }
        }

        Rectangle {
            color: bgColor
            Text {
                id: tabLabel6
                anchors.centerIn: parent
                text: tabTexts[8]
                color: textColor
                font.pixelSize: 20
            }
        }
    }
}
