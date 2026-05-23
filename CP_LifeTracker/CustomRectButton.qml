import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root

    property string text: "Button"
    property color buttonColor: accentColor
    property color textColor: "white"
    property bool enabled: true
    property alias font: buttonText.font

    signal clicked()

    height: 40
    width: 150
    radius: 8
    color: enabled ? (mouseArea.containsMouse ? Qt.lighter(buttonColor, 1.1) : buttonColor) : Qt.darker(buttonColor, 1.5)
    opacity: enabled ? 1.0 : 0.7

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 2
        radius: 5.0
        samples: 12
        color: "#40000000"
        transparentBorder: true
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
        text: root.text
        color: root.textColor
        font.pixelSize: 14
        font.weight: Font.Medium
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        enabled: root.enabled
        onClicked: root.clicked()

        onPressed: {
            root.opacity = 0.8
        }

        onReleased: {
            root.opacity = 1.0
        }
    }
}
