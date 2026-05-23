import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: habitItem
    height: 140
    radius: 16
    color: theme.cardColor
    border.color: isCompleted ? theme.successColor : "transparent"
    border.width: isCompleted ? 3 : 0

    property string habitName: ""
    property string habitDescription: ""
    property bool isCompleted: false
    property int streakCount: 0
    property int itemIndex: -1
    property string habitIcon: "🎯"
    property string habitColor: "#3B82F6"
    property int difficulty: 1
    property int frequency: 1
    property var frequencyDays: [true, true, true, true, true, true, true]
    property int importance: 1

    signal editRequested(int index, string name, string description, string icon, string color, int difficulty, int frequency, var frequencyDays, int importance)
    signal deleteRequested(int index, string name)

    Theme {
        id: theme
    }

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 4
        radius: 12.0
        samples: 24
        color: isCompleted ? theme.successColor : theme.shadowColor
        opacity: isCompleted ? 0.3 : 0.15
    }

    MouseArea {
        id: mainArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            parent.scale = 1.02
        }

        onExited: {
            parent.scale = 1.0
        }
    }

    Behavior on scale {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }

    Rectangle {
        id: accentBar
        width: 6
        height: parent.height
        color: habitColor
        radius: 16
        anchors.left: parent.left

        Rectangle {
            width: parent.width
            height: parent.height - parent.radius
            color: parent.color
            anchors.right: parent.right
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        anchors.leftMargin: 26
        spacing: 20

        Rectangle {
            id: iconContainer
            width: 72
            height: 72
            radius: 20
            color: Qt.rgba(habitColor.r, habitColor.g, habitColor.b, 0.15)
            border.color: habitColor
            border.width: 2

            Text {
                text: habitIcon
                font.pixelSize: 36
                anchors.centerIn: parent
            }

            Rectangle {
                id: checkBox
                width: 28
                height: 28
                radius: 14
                color: isCompleted ? theme.successColor : theme.cardColor
                border.color: isCompleted ? theme.successColor : theme.borderColor
                border.width: 2
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: -6
                anchors.bottomMargin: -6

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 2
                    radius: 6.0
                    samples: 12
                    color: theme.shadowColor
                    opacity: 0.3
                }

                Text {
                    text: "✓"
                    color: theme.buttonTextLightColor
                    font.pixelSize: 18
                    font.bold: true
                    anchors.centerIn: parent
                    visible: isCompleted
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        parent.scale = 1.15
                    }

                    onExited: {
                        parent.scale = 1.0
                    }

                    onClicked: {
                        HabitsModel.setCompleted(itemIndex, !isCompleted)
                    }
                }

                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }

                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    id: nameText
                    text: habitName
                    font.pixelSize: 20
                    font.bold: true
                    color: isCompleted ? theme.textSecondaryColor : theme.textColor
                    elide: Text.ElideRight
                    Layout.fillWidth: true

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Rectangle {
                    id: importanceBadge
                    width: 60
                    height: 24
                    radius: 12
                    color: {
                        if (importance === 3) return "#EF4444"
                        if (importance === 2) return "#F59E0B"
                        return "#10B981"
                    }
                    opacity: 0.9

                    Text {
                        text: {
                            if (importance === 3) return "High"
                            if (importance === 2) return "Med"
                            return "Low"
                        }
                        font.pixelSize: 11
                        font.bold: true
                        color: "white"
                        anchors.centerIn: parent
                    }
                }
            }

            Text {
                id: descText
                text: habitDescription
                font.pixelSize: 14
                color: theme.textSecondaryColor
                elide: Text.ElideRight
                Layout.fillWidth: true
                visible: habitDescription !== ""
                opacity: 0.9
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    width: 100
                    height: 32
                    radius: 16
                    color: streakCount > 0 ? Qt.rgba(habitColor.r, habitColor.g, habitColor.b, 0.2) : theme.backgroundSecondaryColor

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: "🔥"
                            font.pixelSize: 16
                            opacity: streakCount > 0 ? 1.0 : 0.5
                        }

                        Text {
                            text: streakCount
                            font.pixelSize: 15
                            font.bold: true
                            color: streakCount > 0 ? habitColor : theme.textSecondaryColor
                        }
                    }

                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                }

                Rectangle {
                    width: 90
                    height: 32
                    radius: 16
                    color: theme.backgroundSecondaryColor

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: {
                                if (difficulty === 4) return "💀"
                                if (difficulty === 3) return "😰"
                                if (difficulty === 2) return "😊"
                                return "😌"
                            }
                            font.pixelSize: 14
                        }

                        Text {
                            text: {
                                if (difficulty === 4) return "V.Hard"
                                if (difficulty === 3) return "Hard"
                                if (difficulty === 2) return "Medium"
                                return "Easy"
                            }
                            font.pixelSize: 12
                            font.bold: true
                            color: theme.textSecondaryColor
                        }
                    }
                }

                Rectangle {
                    width: contentRow.width + 16
                    height: 32
                    radius: 16
                    color: theme.backgroundSecondaryColor

                    Row {
                        id: contentRow
                        anchors.centerIn: parent
                        spacing: 4

                        property var weekdayLetters: ["M", "T", "W", "T", "F", "S", "S"]
                        property var activeColor: habitColor

                        Repeater {
                            model: {
                                if (frequency === 1) return 7
                                if (frequency === 2) {
                                    var count = 0
                                    for (var i = 0; i < frequencyDays.length; i++) {
                                        if (frequencyDays[i]) count++
                                    }
                                    return count
                                }
                                return 0
                            }

                            Text {
                                text: {
                                    if (frequency === 1) {
                                        return contentRow.weekdayLetters[index]
                                    } else if (frequency === 2) {
                                        var activeIndex = 0
                                        for (var i = 0; i < frequencyDays.length; i++) {
                                            if (frequencyDays[i]) {
                                                if (activeIndex === index) {
                                                    return contentRow.weekdayLetters[i]
                                                }
                                                activeIndex++
                                            }
                                        }
                                    }
                                    return ""
                                }
                                font.pixelSize: 11
                                font.bold: true
                                color: contentRow.activeColor
                            }
                        }

                        Text {
                            text: {
                                if (frequency === 3) return "📅 Monthly"
                                if (frequency === 4) return "🎯 Custom"
                                return ""
                            }
                            font.pixelSize: 11
                            font.bold: true
                            color: habitColor
                            visible: frequency >= 3
                        }
                    }
                }
            }
        }

        RowLayout {
            spacing: 10

            Rectangle {
                id: editButton
                width: 40
                height: 40
                radius: 10
                color: "transparent"
                border.color: theme.borderColor
                border.width: 2

                Text {
                    text: "✎"
                    font.pixelSize: 18
                    color: theme.textSecondaryColor
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        parent.color = theme.backgroundSecondaryColor
                        parent.scale = 1.1
                    }

                    onExited: {
                        parent.color = "transparent"
                        parent.scale = 1.0
                    }

                    onClicked: {
                        editRequested(itemIndex,
                                    habitName,
                                    habitDescription,
                                    habitIcon,
                                    habitColor,
                                    difficulty,
                                    frequency,
                                    frequencyDays,
                                    importance)
                    }
                }

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
            }

            Rectangle {
                id: deleteButton
                width: 40
                height: 40
                radius: 10
                color: "transparent"
                border.color: theme.errorColor
                border.width: 2

                Text {
                    text: "✗"
                    font.pixelSize: 18
                    color: theme.errorColor
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        parent.color = theme.errorColor
                        parent.scale = 1.1
                        parent.children[0].color = theme.buttonTextLightColor
                    }

                    onExited: {
                        parent.color = "transparent"
                        parent.scale = 1.0
                        parent.children[0].color = theme.errorColor
                    }

                    onClicked: {
                        deleteRequested(itemIndex, habitName)
                    }
                }

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
            }
        }
    }
}
