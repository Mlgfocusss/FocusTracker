import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: sidebarArea
    color: theme.backgroundSecondaryColor

    property string currentActiveTab: "account"
    property int animationDuration: 200
    signal tabSelected(string tab)

    readonly property QtObject theme: Theme {}

    Connections {
        target: ThemeManager
        function onThemeIndexChanged() {
            sidebarArea.color = theme.backgroundSecondaryColor;
        }
    }

    Flickable {
        id: flickable
        width: parent.width
        height: parent.height
        contentWidth: width
        contentHeight: sidebarColumn.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        property real scrollPosition: flickable.contentY / (flickable.contentHeight - flickable.height)
        property bool scrollVisible: flickable.contentHeight > flickable.height

        ColumnLayout {
            id: sidebarColumn
            width: parent.width
            spacing: 4

            Item { height: 20; width: 1 }

            Text {
                text: qsTr("Account")
                color: sidebarArea.theme.textSecondaryColor
                font.pixelSize: 13
                font.weight: Font.Medium
                Layout.leftMargin: 20
                Layout.bottomMargin: 8
                Layout.topMargin: 10

                Behavior on color {
                    ColorAnimation {
                        duration: sidebarArea.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }

            SettingsButton {
                text: qsTr("Account")
                icon: "👤"
                isActive: currentActiveTab === "account"
                onClicked: sidebarArea.tabSelected("account")
                theme: sidebarArea.theme
                animationDuration: sidebarArea.animationDuration
            }

            Item { height: 20; width: 1 }

            Text {
                text: qsTr("Приложение")
                color: sidebarArea.theme.textSecondaryColor
                font.pixelSize: 13
                font.weight: Font.Medium
                Layout.leftMargin: 20
                Layout.bottomMargin: 8

                Behavior on color {
                    ColorAnimation {
                        duration: sidebarArea.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }

            SettingsButton {
                text: qsTr("General")
                icon: "⚙️"
                isActive: currentActiveTab === "general"
                onClicked: sidebarArea.tabSelected("general")
                theme: sidebarArea.theme
                animationDuration: sidebarArea.animationDuration
            }

            SettingsButton {
                text: qsTr("Appearance")
                icon: "🎨"
                isActive: currentActiveTab === "appearance"
                onClicked: sidebarArea.tabSelected("appearance")
                theme: sidebarArea.theme
                animationDuration: sidebarArea.animationDuration
            }

            SettingsButton {
                text: qsTr("Notifications")
                icon: "🔔"
                isActive: currentActiveTab === "notifications"
                onClicked: sidebarArea.tabSelected("notifications")
                theme: sidebarArea.theme
                animationDuration: sidebarArea.animationDuration
            }

            SettingsButton {
                text: qsTr("Дополнительно")
                icon: "➕"
                isActive: currentActiveTab === "additional"
                onClicked: sidebarArea.tabSelected("additional")
                theme: sidebarArea.theme
                animationDuration: sidebarArea.animationDuration
            }

            Item { height: 20; width: 1 }

            Text {
                text: qsTr("Support")
                color: sidebarArea.theme.textSecondaryColor
                font.pixelSize: 13
                font.weight: Font.Medium
                Layout.leftMargin: 20
                Layout.bottomMargin: 8
                Layout.topMargin: 10

                Behavior on color {
                    ColorAnimation {
                        duration: sidebarArea.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }

            SettingsButton {
                text: qsTr("Support Center")
                icon: "ℹ️"
                isActive: currentActiveTab === "support"
                onClicked: sidebarArea.tabSelected("support")
                theme: sidebarArea.theme
                animationDuration: sidebarArea.animationDuration
            }

            SettingsButton {
                text: qsTr("Updates")
                icon: "🔄"
                isActive: currentActiveTab === "updates"
                onClicked: sidebarArea.tabSelected("updates")
                theme: sidebarArea.theme
                animationDuration: sidebarArea.animationDuration
            }

            SettingsButton {
                text: qsTr("О приложении")
                icon: "📱"
                isActive: currentActiveTab === "about"
                onClicked: sidebarArea.tabSelected("about")
                theme: sidebarArea.theme
                animationDuration: sidebarArea.animationDuration
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Item { height: 15; width: 1 }
        }
    }

    Rectangle {
        id: customScrollBar
        visible: flickable.scrollVisible
        width: 4
        radius: 2
        anchors.right: parent.right
        anchors.rightMargin: 2
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "transparent"

        Rectangle {
            id: scrollHandle
            width: mouseArea.containsMouse || mouseArea.pressed ? 6 : 4
            height: Math.max(30, flickable.height * (flickable.height / Math.max(flickable.contentHeight, 1)))
            radius: width / 2
            color: mouseArea.containsMouse || mouseArea.pressed ? sidebarArea.theme.accentColor : sidebarArea.theme.textSecondaryColor
            opacity: mouseArea.containsMouse || mouseArea.pressed ? 0.8 : 0.4

            Behavior on width {
                NumberAnimation { duration: sidebarArea.animationDuration; easing.type: Easing.OutCubic }
            }

            Behavior on opacity {
                NumberAnimation { duration: sidebarArea.animationDuration; easing.type: Easing.OutCubic }
            }

            Behavior on color {
                ColorAnimation { duration: sidebarArea.animationDuration }
            }

            function updatePosition() {
                if (!mouseArea.pressed) {
                    var yPosition = flickable.contentY / Math.max(flickable.contentHeight - flickable.height, 1) * (customScrollBar.height - height)
                    y = Math.max(0, Math.min(yPosition, customScrollBar.height - height))
                }
            }

            Connections {
                target: flickable
                function onContentYChanged() { scrollHandle.updatePosition() }
                function onHeightChanged() { scrollHandle.updatePosition() }
                function onContentHeightChanged() { scrollHandle.updatePosition() }
            }

            Component.onCompleted: updatePosition()
        }

        MouseArea {
            id: scrollTrackArea
            anchors.fill: parent
            onClicked: {
                var newContentY = (mouseY - scrollHandle.height/2) / (height - scrollHandle.height) * (flickable.contentHeight - flickable.height)
                flickable.contentY = Math.max(0, Math.min(newContentY, flickable.contentHeight - flickable.height))
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: scrollHandle
            anchors.margins: -4
            hoverEnabled: true
            drag.target: scrollHandle
            drag.axis: Drag.YAxis
            drag.minimumY: 0
            drag.maximumY: customScrollBar.height - scrollHandle.height

            onPositionChanged: {
                if (pressed) {
                    var contentRatio = scrollHandle.y / (customScrollBar.height - scrollHandle.height)
                    flickable.contentY = contentRatio * (flickable.contentHeight - flickable.height)
                }
            }
        }
    }
}
