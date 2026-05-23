import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: navItem
    Layout.fillWidth: true
    height: 50
    radius: 8
    Layout.leftMargin: 8
    Layout.rightMargin: 8

    property QtObject theme: Theme {}
    property bool isActive: false
    property bool hovered: false
    property string text: ""
    property string icon: ""
    property int animationDuration: 200

    signal clicked()

    readonly property color activeItemColor: theme ? theme.navActiveColor : "#007BFF"
    readonly property color currentTextColor: theme ? theme.textColor : "#212529"
    readonly property color currentTextColorDim: theme ? theme.textSecondaryColor : "#6C757D"
    readonly property color currentHoverColor: theme ? theme.navHoverColor : "#E9ECEF"
    readonly property color itemActiveBgColor: theme ? theme.cardSelectedColor : "#DDEEFF"

    color: "transparent"

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        radius: parent.radius
        color: isActive ? itemActiveBgColor : (hovered ? currentHoverColor : "transparent")

        Rectangle {
            id: highlightEffect
            anchors.fill: parent
            radius: parent.radius
            color: activeItemColor
            opacity: 0

            NumberAnimation {
                id: highlightAnimation
                target: highlightEffect
                property: "opacity"
                from: 0.1
                to: 0
                duration: navItem.animationDuration
                easing.type: Easing.OutQuad
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: navItem.animationDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    Rectangle {
        id: activeIndicator
        width: 4
        height: parent.height * 0.7
        radius: 2
        color: activeItemColor
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        opacity: navItem.isActive ? 1 : 0
        scale: navItem.isActive ? 1 : 0.5

        Behavior on opacity {
            NumberAnimation {
                duration: navItem.animationDuration
                easing.type: Easing.OutCubic
            }
        }
        Behavior on scale {
            NumberAnimation {
                duration: navItem.animationDuration
                easing.type: Easing.OutCubic
            }
        }
        Behavior on color {
            ColorAnimation {
                duration: navItem.animationDuration
                easing.type: Easing.OutCubic
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: navItem.animationDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 14

        Behavior on anchors.leftMargin {
            NumberAnimation {
                duration: navItem.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            width: 32
            height: 32
            radius: 6
            color: navItem.isActive ? Qt.lighter(activeItemColor, 1.8) : (navItem.hovered ? currentHoverColor : "transparent")
            Layout.alignment: Qt.AlignVCenter

            Behavior on color {
                ColorAnimation {
                    duration: navItem.animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            Text {
                id: iconText
                text: navItem.icon
                font.pixelSize: 18
                anchors.centerIn: parent
                color: navItem.isActive ? activeItemColor : currentTextColorDim
                scale: navItem.isActive ? 1.05 : 1.0

                Behavior on scale {
                    NumberAnimation {
                        duration: navItem.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: navItem.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        Text {
            id: labelText
            Layout.fillWidth: true
            text: navItem.text
            color: navItem.isActive ? activeItemColor : currentTextColor
            font.pixelSize: 15
            font.weight: navItem.isActive ? Font.Medium : Font.Normal
            elide: Text.ElideRight
            Layout.alignment: Qt.AlignVCenter
            opacity: navItem.hovered && !navItem.isActive ? 0.95 : 1.0

            Behavior on opacity {
                NumberAnimation {
                    duration: navItem.animationDuration / 2
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: navItem.animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on font.weight {
                NumberAnimation {
                    duration: navItem.animationDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        Item {
            width: 20
            height: 20
            Layout.alignment: Qt.AlignVCenter
            visible: true

            Text {
                text: "\u203A"
                font.pixelSize: 20
                font.weight: Font.Light
                color: navItem.isActive ? activeItemColor : currentTextColorDim
                anchors.centerIn: parent
                opacity: navItem.hovered || navItem.isActive ? 1.0 : 0.6
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                NumberAnimation on x {
                    id: arrowAnimation
                    from: 0
                    to: 3
                    duration: 200
                    easing.type: Easing.OutCubic
                    running: false
                }

                Behavior on color {
                    ColorAnimation {
                        duration: navItem.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: navItem.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: navItem.hovered = true
        onExited: navItem.hovered = false
        onClicked: {
            highlightAnimation.start()
            navItem.clicked()
        }
        onPressed: {
            highlightEffect.opacity = 0.15
        }
        onReleased: {
            highlightEffect.opacity = 0
        }
    }
}
