import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: habitsView
    color: theme.backgroundColor

    property var habit: null
    property alias theme: theme

    Theme {
        id: theme
    }

    AddHabitWindow {
        id: addHabitWindow

        onHabitAdded: function(name, description, icon, color, difficulty, frequency, frequencyDays, importance) {
            HabitsModel.addHabit(name, description, icon, color, difficulty, frequency, frequencyDays, importance)
        }

        onHabitEdited: function(index, name, description, icon, color, difficulty, frequency, frequencyDays, importance) {
            HabitsModel.editHabit(index, name, description, icon, color, difficulty, frequency, frequencyDays, importance)
        }
    }

    Rectangle {
        id: headerBar
        height: 80
        color: theme.cardColor
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        z: 1

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 2
            radius: 8.0
            samples: 17
            color: theme.shadowColor
        }

        Text {
            id: headerText
            text: habit ? habit.name : qsTr("Habits")
            font.pixelSize: 32
            font.bold: true
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 24
            }
            color: theme.textColor
        }

        CustomRectButton {
            id: addHabitButton
            width: 140
            height: 40
            text: "Add Habit"
            buttonColor: theme.buttonPrimaryColor
            textColor: theme.buttonTextLightColor
            font.pixelSize: 14
            font.bold: true
            radius: 8
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 24
            }

            onClicked: {
                addHabitWindow.show()
            }
        }
    }

    ListView {
        id: habitsList
        anchors {
            top: headerBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 24
        }
        clip: true
        spacing: 20
        model: HabitsModel

        delegate: HabitItem {
            width: habitsList.width
            habitName: model.name || ""
            habitDescription: model.description || ""
            isCompleted: model.completed || false
            streakCount: model.streak || 0
            itemIndex: index
            habitIcon: model.icon || "🎯"
            habitColor: model.color || "#3B82F6"
            difficulty: model.difficulty || 1
            frequency: model.frequency || 1
            frequencyDays: model.frequencyDays || [true, true, true, true, true, true, true]
            importance: model.importance || 1

            onEditRequested: function(index, name, description, icon, color, difficulty, frequency, frequencyDays, importance) {
                addHabitWindow.showEdit(index, name, description, icon, color, difficulty, frequency, frequencyDays, importance)
            }

            onDeleteRequested: function(index, name) {
                deleteHabitDialog.confirmDelete(index, name)
            }
        }

        Text {
            anchors.centerIn: parent
            text: habitsList.count === 0 ? "No habits yet. Add your first habit!" : ""
            font.pixelSize: 20
            color: theme.textSecondaryColor
        }
    }

    Rectangle {
        id: addQuickHabitButton
        width: 56
        height: 56
        radius: 28
        color: theme.buttonPrimaryColor
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 24
            bottomMargin: 24
        }
        z: 10

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 12.0
            samples: 24
            color: theme.shadowColor
            opacity: 0.7
        }

        Text {
            text: "+"
            font.pixelSize: 32
            font.bold: true
            color: theme.buttonTextLightColor
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onEntered: {
                parent.scale = 1.1
            }

            onExited: {
                parent.scale = 1.0
            }

            onClicked: {
                addHabitWindow.show()
            }
        }

        Behavior on scale {
            NumberAnimation { duration: 150 }
        }
    }

    Dialog {
        id: deleteHabitDialog
        anchors.centerIn: parent
        width: 480
        height: 320
        modal: true
        dim: true
        closePolicy: Dialog.CloseOnEscape | Dialog.CloseOnPressOutside

        property int habitIndex: -1
        property string habitName: ""

        Overlay.modal: Rectangle {
            color: "#90000000"

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }

        background: Rectangle {
            radius: 20
            color: theme.cardColor
            border.color: "transparent"
            border.width: 0

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 8
                radius: 24.0
                samples: 48
                color: theme.shadowColor
                opacity: 0.3
            }
        }

        enter: Transition {
            NumberAnimation {
                property: "scale"
                from: 0.8
                to: 1.0
                duration: 300
                easing.type: Easing.OutBack
            }
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }

        exit: Transition {
            NumberAnimation {
                property: "scale"
                from: 1.0
                to: 0.8
                duration: 200
                easing.type: Easing.InQuart
            }
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 150
            }
        }

        Rectangle {
            id: headerSection
            width: parent.width
            height: 100
            color: theme.errorColor
            radius: 20
            anchors.top: parent.top

            Rectangle {
                width: parent.width
                height: 20
                color: theme.errorColor
                anchors.bottom: parent.bottom
            }

            Rectangle {
                width: 80
                height: 80
                radius: 40
                color: Qt.rgba(1, 1, 1, 0.2)
                anchors.centerIn: parent

                Text {
                    text: "⚠"
                    font.pixelSize: 40
                    color: theme.buttonTextLightColor
                    anchors.centerIn: parent
                }
            }
        }

        Rectangle {
            id: contentSection
            anchors {
                top: headerSection.bottom
                left: parent.left
                right: parent.right
                bottom: footerSection.top
            }
            color: "transparent"

            Column {
                anchors.centerIn: parent
                spacing: 16
                width: parent.width - 48

                Text {
                    width: parent.width
                    text: "Delete Habit"
                    font.pixelSize: 24
                    font.bold: true
                    font.weight: Font.Medium
                    color: theme.textColor
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    width: parent.width
                    text: "Are you sure you want to permanently delete this habit?"
                    font.pixelSize: 16
                    color: theme.textSecondaryColor
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }

                Rectangle {
                    width: parent.width
                    height: 50
                    radius: 12
                    color: theme.backgroundSecondaryColor
                    border.color: theme.borderColor
                    border.width: 1

                    Text {
                        text: "\"" + deleteHabitDialog.habitName + "\""
                        font.pixelSize: 16
                        font.bold: true
                        color: theme.textColor
                        anchors.centerIn: parent
                        elide: Text.ElideMiddle
                        width: parent.width - 24
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Text {
                    width: parent.width
                    text: "This action cannot be undone and all progress will be lost."
                    font.pixelSize: 14
                    color: theme.textSecondaryColor
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    opacity: 0.8
                }
            }
        }

        Rectangle {
            id: footerSection
            width: parent.width
            height: 90
            color: theme.backgroundSecondaryColor
            radius: 20
            anchors.bottom: parent.bottom

            Rectangle {
                width: parent.width
                height: 20
                color: theme.backgroundSecondaryColor
                anchors.top: parent.top
            }

            RowLayout {
                anchors.centerIn: parent
                spacing: 20

                CustomRectButton {
                    text: "Cancel"
                    width: 130
                    height: 48
                    buttonColor: theme.cardColor
                    textColor: theme.textColor
                    font.pixelSize: 16
                    radius: 12
                    border.color: theme.borderColor
                    border.width: 1

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 6.0
                        samples: 12
                        color: "#20000000"
                        opacity: 0.5
                    }

                    onClicked: {
                        deleteHabitDialog.close()
                    }
                }

                CustomRectButton {
                    text: "Delete Forever"
                    width: 150
                    height: 48
                    buttonColor: theme.errorColor
                    textColor: theme.buttonTextLightColor
                    font.pixelSize: 16
                    font.bold: true
                    radius: 12

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 8.0
                        samples: 16
                        color: theme.errorColor
                        opacity: 0.4
                    }

                    onClicked: {
                        HabitsModel.removeHabit(deleteHabitDialog.habitIndex)
                        deleteHabitDialog.close()
                    }
                }
            }
        }

        function confirmDelete(index, name) {
            deleteHabitDialog.habitIndex = index
            deleteHabitDialog.habitName = name || ""
            deleteHabitDialog.open()
        }
    }
}
