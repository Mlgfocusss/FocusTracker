import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: customSwitchRoot

    property bool checked: false
    property color trackColor: "#555555"
    property color trackColorActive: accentColor
    property color thumbColor: "white"

    width: 44
    height: 24

    Rectangle {
        id: track
        width: parent.width
        height: parent.height
        radius: height / 2
        color: customSwitchRoot.checked ? customSwitchRoot.trackColorActive : customSwitchRoot.trackColor

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    Rectangle {
        id: thumb
        width: customSwitchRoot.height - 4
        height: width
        radius: width / 2
        color: customSwitchRoot.thumbColor
        x: customSwitchRoot.checked ? customSwitchRoot.width - thumb.width - 2 : 2
        y: 2

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 1
            radius: 3.0
            samples: 17
            color: "#30000000"
            transparentBorder: true
        }

        Behavior on x {
            NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            customSwitchRoot.checked = !customSwitchRoot.checked
        }
    }
}
