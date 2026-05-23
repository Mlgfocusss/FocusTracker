import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    color: selected ? selectedColor : "transparent"
    radius: 6

    property string icon: ""
    property string text: ""
    property bool expanded: true
    property bool selected: false
    property int animationDuration: 200
    property int buttonSize: 0


    property color hoverColor: Qt.rgba(1, 1, 1, 0.07)
    property color selectedColor: "#282828"
    property color textSelectedColor: "#ffffff"
    property color textNormalColor: "#cccccc"

    signal clicked()

    height: 40

    Behavior on color {
        ColorAnimation { duration: 100 }
    }

    Rectangle {
        id: selectionIndicator
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        width: root.expanded ? 4 : 0
        radius: 2
        color: selected ? textSelectedColor : "transparent"
        visible: root.selected && root.expanded

        Behavior on opacity { NumberAnimation { duration: 150 } }
        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on width { NumberAnimation {duration: 150 }}
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: root.expanded ? 16 : 0
        anchors.rightMargin: root.expanded ? 12 : 0
        spacing: root.expanded ? 14 : 0

        Behavior on anchors.leftMargin { NumberAnimation { duration: root.animationDuration } }
        Behavior on anchors.rightMargin { NumberAnimation { duration: root.animationDuration } }
        Behavior on spacing { NumberAnimation { duration: root.animationDuration } }

        Text {
            id: iconText
            text: root.icon
            font.pixelSize: 18
            color: selected ? textSelectedColor : textNormalColor
            Layout.fillWidth: !root.expanded
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        Text {
            id: buttonText
            text: root.text
            font {
                pixelSize: 15
                weight: Font.Medium
                family: "Segoe UI"
            }
            color: selected ? textSelectedColor : textNormalColor
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            visible: root.expanded
            opacity: root.expanded ? 1.0 : 0.0
            elide: Text.ElideRight

            Behavior on opacity {
                NumberAnimation { duration: root.animationDuration }
            }

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            if (!selected) {
                root.color = hoverColor
            }
        }

        onExited: {
            if (!selected) {
                root.color = "transparent"
            } else {
                root.color = selectedColor
            }
        }

        onPressed: {
            root.color = Qt.darker(selected ? selectedColor : hoverColor, 1.1)
        }

        onReleased: {
            if (containsMouse) {
                root.color = selected ? selectedColor : hoverColor
            } else {
                root.color = selected ? selectedColor : "transparent"
            }
        }

        onClicked: {
            root.clicked()
        }
    }

    states: [
        State {
            name: "selected"
            when: selected
            PropertyChanges {
                target: root
                color: selectedColor
            }
        },
        State {
            name: "hovered"
            when: mouseArea.containsMouse && !selected
            PropertyChanges {
                target: root
                color: hoverColor
            }
        },
        State {
            name: "normal"
            when: !mouseArea.containsMouse && !selected
            PropertyChanges {
                target: root
                color: "transparent"
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "*"
            ColorAnimation {
                target: root
                property: "color"
                duration: 150
            }
        }
    ]
}
