import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    width: 28
    height: 28
    radius: 6
    color: mouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.15) : "transparent"

    property string iconText: ""
    property string toolTip: ""
    property color iconColor: "#ffffff"

    signal clicked()

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    Text {
        anchors.centerIn: parent
        text: root.iconText
        font.pixelSize: 14
        color: root.iconColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }

    ToolTip {
        visible: mouseArea.containsMouse && root.toolTip !== ""
        text: root.toolTip
        delay: 500
        timeout: 3000
    }
}
