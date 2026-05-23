import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Rectangle {
    id: windowHeader
    implicitHeight: 60
    radius: 12

    property Window window
    property string currentTab: "account"

    signal minimizeRequested()
    signal closeRequested()

    Theme {
        id: localTheme
    }

    readonly property color bgColorDarker: localTheme.backgroundSecondaryColor
    readonly property color textColor: localTheme.textColor
    readonly property color textColorDim: localTheme.textSecondaryColor
    readonly property color hoverColor: localTheme.navHoverColor

    color: bgColorDarker

    Rectangle {
        width: parent.width
        height: parent.height / 2
        color: windowHeader.bgColorDarker
        anchors.bottom: parent.bottom
        radius: parent.radius
        clip: true
        Rectangle {
            width: parent.width
            height: parent.height * 2
            color: windowHeader.bgColorDarker
        }
    }

    function getTabDisplayName(tab) {
        switch(tab) {
            case "account": return qsTr("Account");
            case "general": return qsTr("General");
            case "appearance": return qsTr("Appearance");
            case "notifications": return qsTr("Notifications");
            case "additional": return qsTr("Additional");
            case "support": return qsTr("Support Center");
            case "updates": return qsTr("Updates");
            case "about": return qsTr("About");
            default: return "";
        }
    }

    function getTabSection(tab) {
        switch(tab) {
            case "account": return "";
            case "general":
            case "appearance":
            case "notifications":
            case "additional": return qsTr("Application");
            case "support":
            case "updates":
            case "about": return qsTr("Support");
            default: return "";
        }
    }

    RowLayout {
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        spacing: 12

        Text {
            text: "⚙️"
            font.pixelSize: 24
            color: windowHeader.textColor
        }

        Text {
            text: {
                var tabName = getTabDisplayName(currentTab);
                var section = getTabSection(currentTab);

                if (section) {
                    return qsTr("Settings") + " | " + section + " | " + tabName;
                } else {
                    return qsTr("Settings") + " | " + tabName;
                }
            }
            color: windowHeader.textColor
            font.pixelSize: 18
            font.weight: Font.Medium
        }
    }

    MouseArea {
        id: dragArea
        property point clickPos
        property bool isDragging: false
        anchors.fill: parent

        onPressed: {
            clickPos = Qt.point(mouse.x, mouse.y)
            isDragging = true
        }

        onReleased: {
            isDragging = false
        }

        onPositionChanged: {
            if (isDragging && windowHeader.window) {
                var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                windowHeader.window.x += delta.x
                windowHeader.window.y += delta.y
            }
        }
    }

    Row {
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        spacing: 15

        Rectangle {
            width: 30
            height: 30
            color: "transparent"
            radius: 15

            Rectangle {
                anchors.centerIn: parent
                width: 10
                height: 2
                color: windowHeader.textColorDim
                radius: 1
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: parent.color = windowHeader.hoverColor
                onExited: parent.color = "transparent"
                onClicked: {
                    windowHeader.minimizeRequested()
                }
            }
        }

        Rectangle {
            width: 30
            height: 30
            color: "transparent"
            radius: 15

            Text {
                text: "×"
                color: windowHeader.textColorDim
                font.pixelSize: 24
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: parent.color = windowHeader.hoverColor
                onExited: parent.color = "transparent"
                onClicked: {
                    windowHeader.closeRequested()
                }
            }
        }
    }
}
