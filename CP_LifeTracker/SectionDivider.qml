import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: 4

    property string text: ""
    property bool expanded: true
    property int animationDuration: 200

    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: "#ffffff"
        opacity: 0.2
        Layout.topMargin: 10
        Layout.bottomMargin: 2
    }

    Text {
        text: root.text
        font {
            pixelSize: 12
            bold: true
            letterSpacing: 1
            family: "Segoe UI"
        }
        color: "#95a5a6"
        visible: root.expanded
        opacity: root.expanded ? 0.8 : 0.0
        Layout.leftMargin: 12
        Layout.topMargin: 4
        Layout.bottomMargin: 4

        Behavior on opacity {
            NumberAnimation { duration: root.animationDuration }
        }
    }
}
