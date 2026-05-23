import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: taskItem
    height: expanded ? contentLayout.implicitHeight + 40 : 70
    color: theme.cardColor
    radius: 12

    property string taskName: "Task Name"
    property string taskDescription: "Task Description"
    property string taskDueDate: "Today"
    property int taskPriority: 0
    property bool isCompleted: false
    property int itemIndex: 0
    property bool expanded: taskDescription.length > 0
    property real progress: 0.0
    property bool hasSubtasks: false
    property int subtaskCount: 0
    property int completedSubtasks: 0

    property var priorityColors: [
        theme.priorityLowColor,
        theme.priorityMediumColor,
        theme.priorityHighColor,
        theme.priorityUrgentColor
    ]

    property var priorityLabels: ["Low", "Medium", "High", "Urgent"]
    property var priorityIcons: ["↓", "→", "↑", "!"]

    Behavior on height {
        NumberAnimation { duration: 200; easing.type: Easing.OutQuint }
    }

    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 3
        radius: 8.0
        samples: 17
        color: Qt.rgba(0, 0, 0, 0.12)
        transparentBorder: true
    }

    MouseArea {
        id: taskItemArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (!actionsArea.contains(Qt.point(mouse.x, mouse.y)) &&
                !checkboxArea.contains(Qt.point(mouse.x, mouse.y))) {
                taskItem.expanded = !taskItem.expanded
            }
        }
    }

    states: [
        State {
            name: "hovered"
            when: taskItemArea.containsMouse && !taskItemArea.pressed
            PropertyChanges {
                target: taskItem
                color: Qt.lighter(theme.cardColor, 1.03)
            }
        },
        State {
            name: "pressed"
            when: taskItemArea.pressed
            PropertyChanges {
                target: taskItem
                color: Qt.darker(theme.cardColor, 1.03)
            }
        }
    ]

    transitions: Transition {
        ColorAnimation { duration: 150 }
    }

    Rectangle {
        id: priorityIndicator
        width: 6
        radius: 3
        color: priorityColors[taskPriority]
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: 0
            topMargin: 0
            bottomMargin: 0
        }
    }

    Rectangle {
        id: taskCheckbox
        width: 26
        height: 26
        radius: 13
        color: isCompleted ? theme.accentColor : "transparent"
        border.width: 2
        border.color: isCompleted ? theme.accentColor : theme.inputBorderColor
        anchors {
            left: priorityIndicator.right
            leftMargin: 16
            top: parent.top
            topMargin: 22
        }

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        Text {
            id: checkmarkText
            anchors.centerIn: parent
            text: "✓"
            color: "white"
            font.pixelSize: 14
            font.bold: true
            visible: isCompleted
            opacity: isCompleted ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }

        MouseArea {
            id: checkboxArea
            anchors.fill: parent
            anchors.margins: -8
            onClicked: {
                isCompleted = !isCompleted
                TasksModel.setCompleted(itemIndex, isCompleted)
            }

            Rectangle {
                id: rippleEffect
                anchors.centerIn: parent
                width: 40
                height: 40
                radius: width / 2
                color: theme.accentColor
                opacity: 0
                scale: 0.8

                PropertyAnimation {
                    id: rippleAnimation
                    target: rippleEffect
                    properties: "opacity,scale"
                    from: 0.3; to: 0
                    duration: 300
                    easing.type: Easing.OutQuad
                }
            }

            onPressed: {
                rippleAnimation.stop()
                rippleEffect.opacity = 0.3
                rippleEffect.scale = 0.8
                taskCheckbox.opacity = 0.8
                taskCheckbox.scale = 0.9
            }

            onReleased: {
                rippleAnimation.start()
                taskCheckbox.opacity = 1
                taskCheckbox.scale = 1
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }

        Behavior on scale {
            NumberAnimation { duration: 150 }
        }
    }

    ColumnLayout {
        id: contentLayout
        anchors {
            left: taskCheckbox.right
            right: parent.right
            top: parent.top
            margins: 12
        }
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Item {
                id: taskNameContainer
                Layout.fillWidth: true
                height: taskNameText.height

                Text {
                    id: taskNameText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    text: taskName
                    font.pixelSize: 16
                    font.weight: Font.Medium
                    color: isCompleted ? theme.textSecondaryColor : theme.textColor
                    elide: Text.ElideRight
                }

                Rectangle {
                    id: strikethrough
                    visible: isCompleted
                    height: 1.5
                    color: theme.textSecondaryColor
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: taskNameText.verticalCenter
                    }

                    SequentialAnimation on opacity {
                        running: isCompleted
                        loops: 1
                        NumberAnimation { from: 0; to: 1; duration: 300 }
                    }
                }
            }

            Item {
                id: priorityContainer
                width: priorityBadge.width
                height: priorityBadge.height
                visible: taskPriority > 0

                Rectangle {
                    id: priorityBadge
                    anchors.centerIn: parent
                    width: priorityText.width + 20
                    height: 26
                    radius: 13
                    color: Qt.rgba(
                        priorityColors[taskPriority].r,
                        priorityColors[taskPriority].g,
                        priorityColors[taskPriority].b,
                        0.15
                    )
                }

                Text {
                    id: priorityText
                    anchors.centerIn: priorityBadge
                    text: priorityIcons[taskPriority] + " " + priorityLabels[taskPriority]
                    color: priorityColors[taskPriority]
                    font.pixelSize: 12
                    font.bold: true
                }

                Component.onCompleted: {
                    scale = 1
                }

                SequentialAnimation on scale {
                    running: true
                    loops: 1
                    NumberAnimation { from: 0; to: 1; duration: 300; easing.type: Easing.OutBack }
                }
            }

            Item {
                id: actionsArea
                width: actionsRow.width
                height: actionsRow.height

                Row {
                    id: actionsRow
                    spacing: 8

                    Rectangle {
                        id: editButton
                        width: 34
                        height: 34
                        radius: 17
                        color: editMouseArea.containsMouse ?
                               Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.15) :
                               "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "✎"
                            font.pixelSize: 16
                            color: theme.accentColor
                        }

                        MouseArea {
                            id: editMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                editTaskDialog.openEditDialog(itemIndex, taskName, taskDescription, taskDueDate, taskPriority)
                            }
                        }

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }

                    Rectangle {
                        id: deleteButton
                        width: 34
                        height: 34
                        radius: 17
                        color: deleteMouseArea.containsMouse ?
                               Qt.rgba(theme.errorColor.r, theme.errorColor.g, theme.errorColor.b, 0.15) :
                               "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "×"
                            font.pixelSize: 24
                            color: theme.errorColor
                        }

                        MouseArea {
                            id: deleteMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                deleteTaskDialog.confirmDelete(itemIndex, taskName)
                            }
                        }

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 6

            Text {
                id: calendarIcon
                text: "📅"
                font.pixelSize: 14
                color: theme.accentColor
            }

            Text {
                id: taskDueDateText
                text: "Due: " + taskDueDate
                font.pixelSize: 13
                color: theme.textSecondaryColor
            }

            Rectangle {
                width: 4
                height: 4
                radius: 2
                color: theme.textSecondaryColor
                visible: hasSubtasks
            }

            Text {
                id: subtasksText
                visible: hasSubtasks
                text: completedSubtasks + "/" + subtaskCount + " subtasks"
                font.pixelSize: 13
                color: theme.textSecondaryColor
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                visible: hasSubtasks
                text: Math.round(completedSubtasks/subtaskCount * 100) + "%"
                font.pixelSize: 13
                font.bold: true
                color: theme.accentColor
            }
        }

        Rectangle {
            visible: hasSubtasks
            Layout.fillWidth: true
            height: 6
            radius: 3
            color: Qt.rgba(theme.inputBorderColor.r, theme.inputBorderColor.g, theme.inputBorderColor.b, 0.3)

            Rectangle {
                width: parent.width * (subtaskCount > 0 ? completedSubtasks/subtaskCount : 0)
                height: parent.height
                radius: 3
                color: theme.accentColor

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 1
                    radius: 3.0
                    samples: 7
                    color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.4)
                    transparentBorder: true
                }

                Behavior on width {
                    NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: theme.borderColor
            visible: expanded && taskDescription.length > 0
            opacity: expanded ? 0.6 : 0

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }

        Text {
            id: taskDescriptionText
            Layout.fillWidth: true
            text: taskDescription
            font.pixelSize: 14
            color: theme.textColor
            wrapMode: Text.WordWrap
            lineHeight: 1.3
            visible: expanded && taskDescription.length > 0
            opacity: expanded ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation { duration: 300 }
            }
        }
    }
}
