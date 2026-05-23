import QtQuick 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: profileButton

    signal clicked()

    width: 36
    height: 36
    radius: width / 2
    color: "#1abc9c"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            profileButton.clicked()
        }
    }

    Text {
        anchors.centerIn: parent
        text: "👤"
        font.pixelSize: 18
        color: "#ffffff"
    }

    Rectangle {
        visible: mouseArea.containsMouse
        anchors.fill: parent
        radius: parent.radius
        color: "#ffffff"
        opacity: 0.2
    }
}
