import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    width: active ? 8 : 6
    height: parent.height
    color: "transparent"
    radius: width / 2
    anchors.right: parent.right
    anchors.rightMargin: 2
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    property real position: 0
    property real pageSize: 0.3
    property bool active: false
    property real initialDragY: 0
    property real initialHandlePos: 0
    property bool hovering: handleArea.containsMouse || barArea.containsMouse
    property bool dragging: handleArea.pressed

    signal scrollPositionMoved(real position)

    Behavior on width {
        NumberAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }

    Rectangle {
        id: trackBackground
        anchors.fill: parent
        color: "#18000000"
        radius: width / 2
        visible: root.active || root.hovering
        opacity: root.active || root.hovering ? 0.5 : 0

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }

        layer.enabled: true
        layer.effect: FastBlur {
            radius: 12
            transparentBorder: true
        }
    }

    Rectangle {
        id: handle
        width: parent.width
        radius: width / 2
        color: handleArea.containsMouse || handleArea.pressed ?
            (isDarkTheme ? Qt.darker(accentColorDark, 1.1) : Qt.darker(accentColorLight, 1.1)) :
            (isDarkTheme ? "#777777" : "#999999")
        opacity: handleArea.containsMouse || handleArea.pressed || root.active ? 0.85 : 0.65
        y: root.position * (root.height - height)
        height: Math.max(root.height * 0.08, Math.min(40, root.pageSize * root.height))
        visible: root.active || root.hovering

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }

        Behavior on color {
            ColorAnimation { duration: 100 }
        }

        Behavior on y {
            enabled: !handleArea.pressed
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutQuad
            }
        }

        Rectangle {
            id: handleDecoration
            anchors.centerIn: parent
            width: parent.width * 0.35
            height: parent.height * 0.5
            radius: width / 2
            color: handleArea.containsMouse || handleArea.pressed ?
                "#FFFFFF" :
                (isDarkTheme ? "#AAAAAA" : "#FFFFFF")
            opacity: handleArea.containsMouse || handleArea.pressed ? 0.75 : 0.45

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }

            layer.enabled: true
            layer.effect: FastBlur {
                radius: 2
                transparentBorder: true
            }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 0
            radius: 3.0
            samples: 7
            color: "#40000000"
            transparentBorder: true
        }
    }

    MouseArea {
        id: handleArea
        anchors.fill: handle
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        preventStealing: true

        onPressed: {
            root.initialDragY = mouseY
            root.initialHandlePos = handle.y
            root.active = true
        }

        onPositionChanged: {
            if (pressed) {
                var newY = root.initialHandlePos + (mouseY - root.initialDragY)
                newY = Math.max(0, Math.min(newY, root.height - handle.height))
                handle.y = newY
                root.position = handle.y / (root.height - handle.height)
                root.scrollPositionMoved(root.position)
            }
        }

        onReleased: {
            if (!root.hovering) {
                root.fadeOutTimer.restart()
            }
        }
    }

    MouseArea {
        id: barArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        propagateComposedEvents: true

        onEntered: {
            root.active = true
        }

        onExited: {
            if (!handleArea.containsMouse && !handleArea.pressed) {
                root.fadeOutTimer.restart()
            }
        }

        onPressed: {
            if (mouseY < handle.y || mouseY > handle.y + handle.height) {
                var newPosition = (mouseY - handle.height / 2) / (root.height - handle.height)
                newPosition = Math.max(0, Math.min(1, newPosition))
                root.position = newPosition
                root.scrollPositionMoved(root.position)
            } else {
                mouse.accepted = false
            }
        }

        onWheel: {
            var delta = wheel.angleDelta.y > 0 ? -0.1 : 0.1
            var newPosition = Math.max(0, Math.min(1, root.position + delta))
            if (newPosition !== root.position) {
                root.position = newPosition
                root.scrollPositionMoved(newPosition)
            }
        }
    }

    Timer {
        id: fadeOutTimer
        interval: 1000
        repeat: false
        onTriggered: {
            if (!root.hovering && !root.dragging) {
                root.active = false
            }
        }
    }

    function updateScrollPosition(newPosition) {
        var boundedPosition = Math.max(0, Math.min(1, newPosition))
        if (boundedPosition !== root.position) {
            root.position = boundedPosition
            return true
        }
        return false
    }

    function showScrollbar() {
        root.active = true
        fadeOutTimer.stop()
    }

    function hideScrollbarDelayed() {
        if (!root.hovering && !root.dragging) {
            fadeOutTimer.restart()
        }
    }
}
