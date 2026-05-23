import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Dialog {
    id: editEventDialog
    title: "Edit Event"
    anchors.centerIn: parent
    width: 500
    height: 550
    modal: true
    dim: true
    closePolicy: Dialog.CloseOnEscape | Dialog.CloseOnPressOutside

    property int eventIndex: -1
    property alias deleteEventDialog: deleteEventDialog

    Theme {
        id: theme
    }

    Overlay.modal: Rectangle {
        color: "#80000000"
    }

    background: Rectangle {
        radius: 12
        color: theme.cardColor
        border.color: theme.borderColor
        border.width: 1
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 2
            radius: 12.0
            samples: 24
            color: theme.shadowColor
        }
    }

    header: Rectangle {
        height: 70
        color: theme.accentColor
        radius: 12

        Rectangle {
            width: parent.width
            height: 12
            color: theme.accentColor
            anchors.bottom: parent.bottom
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 24

            Text {
                text: editEventDialog.title
                font {
                    pixelSize: 24
                    bold: true
                }
                color: theme.buttonTextLightColor
                Layout.fillWidth: true
            }

            Rectangle {
                width: 40
                height: 40
                radius: 20
                color: theme.errorColor

                Text {
                    text: "×"
                    font.pixelSize: 24
                    font.bold: true
                    color: theme.buttonTextLightColor
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        deleteEventDialog.confirmDelete(editEventDialog.eventIndex, editEventTitleField.text)
                    }
                }
            }
        }
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 18

        Text {
            text: "Edit event details"
            font.pixelSize: 16
            color: theme.textColor
        }

        TextField {
            id: editEventTitleField
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            placeholderText: "Event title"
            font.pixelSize: 16
            selectByMouse: true
            color: theme.inputTextColor
            leftPadding: 16
            rightPadding: 16

            background: Rectangle {
                radius: 8
                color: theme.inputBackgroundColor
                border.color: parent.focus ? theme.inputBorderFocusColor : theme.inputBorderColor
                border.width: parent.focus ? 2 : 1

                Behavior on border.color {
                    ColorAnimation { duration: 150 }
                }

                Behavior on border.width {
                    NumberAnimation { duration: 150 }
                }
            }
        }

        TextField {
            id: editEventDescField
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            placeholderText: "Description (optional)"
            font.pixelSize: 16
            selectByMouse: true
            color: theme.inputTextColor
            leftPadding: 16
            rightPadding: 16
            wrapMode: TextEdit.Wrap
            verticalAlignment: TextInput.AlignTop

            background: Rectangle {
                radius: 8
                color: theme.inputBackgroundColor
                border.color: parent.focus ? theme.inputBorderFocusColor : theme.inputBorderColor
                border.width: parent.focus ? 2 : 1

                Behavior on border.color {
                    ColorAnimation { duration: 150 }
                }

                Behavior on border.width {
                    NumberAnimation { duration: 150 }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            Text {
                text: "Date:"
                font.pixelSize: 16
                color: theme.textColor
                Layout.preferredWidth: 80
            }

            TextField {
                id: editEventDateField
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                placeholderText: "yyyy-MM-dd"
                font.pixelSize: 16
                selectByMouse: true
                color: theme.inputTextColor
                leftPadding: 16
                rightPadding: 16

                background: Rectangle {
                    radius: 8
                    color: theme.inputBackgroundColor
                    border.color: parent.focus ? theme.inputBorderFocusColor : theme.inputBorderColor
                    border.width: parent.focus ? 2 : 1

                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }

                    Behavior on border.width {
                        NumberAnimation { duration: 150 }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            Text {
                text: "Time:"
                font.pixelSize: 16
                color: theme.textColor
                Layout.preferredWidth: 80
            }

            TextField {
                id: editEventTimeField
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                placeholderText: "HH:MM"
                font.pixelSize: 16
                selectByMouse: true
                color: theme.inputTextColor
                leftPadding: 16
                rightPadding: 16
                enabled: !editAllDayCheck.checked

                background: Rectangle {
                    radius: 8
                    color: editAllDayCheck.checked ? theme.backgroundSecondaryColor : theme.inputBackgroundColor
                    border.color: parent.focus ? theme.inputBorderFocusColor : theme.inputBorderColor
                    border.width: parent.focus ? 2 : 1

                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }

                    Behavior on border.width {
                        NumberAnimation { duration: 150 }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            Text {
                text: "Duration:"
                font.pixelSize: 16
                color: theme.textColor
                Layout.preferredWidth: 80
            }

            TextField {
                id: editDurationField
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                placeholderText: "Minutes"
                font.pixelSize: 16
                selectByMouse: true
                color: theme.inputTextColor
                leftPadding: 16
                rightPadding: 16
                enabled: !editAllDayCheck.checked

                background: Rectangle {
                    radius: 8
                    color: editAllDayCheck.checked ? theme.backgroundSecondaryColor : theme.inputBackgroundColor
                    border.color: parent.focus ? theme.inputBorderFocusColor : theme.inputBorderColor
                    border.width: parent.focus ? 2 : 1

                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }

                    Behavior on border.width {
                        NumberAnimation { duration: 150 }
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            Text {
                text: "Category:"
                font.pixelSize: 16
                color: theme.textColor
                Layout.preferredWidth: 80
            }

            CustomComboBox {
                id: editCategoryCombo
                Layout.fillWidth: true
                height: 48
                model: ["General", "Work", "Personal", "Health", "Travel", "Education"]
                currentIndex: 0
                borderColorNormal: theme.inputBorderColor
                borderColorFocused: theme.inputBorderFocusColor
                bgColorNormal: theme.inputBackgroundColor
                dropdownBgColor: theme.cardColor
                radius: 8
            }
        }

        CheckBox {
            id: editAllDayCheck
            text: "All Day Event"
            font.pixelSize: 16
            Layout.fillWidth: true
        }

        Item { Layout.fillHeight: true }
    }

    footer: Rectangle {
        height: 70
        color: theme.backgroundSecondaryColor
        radius: 12

        Rectangle {
            width: parent.width
            height: 12
            color: theme.backgroundSecondaryColor
            anchors.top: parent.top
        }

        RowLayout {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 24
            }
            spacing: 16

            CustomRectButton {
                text: "Cancel"
                width: 110
                height: 44
                buttonColor: theme.backgroundSecondaryColor
                textColor: theme.textColor
                radius: 8

                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 1
                    radius: 3.0
                    samples: 8
                    color: "#20000000"
                }

                onClicked: {
                    editEventDialog.close()
                }
            }

            CustomRectButton {
                text: "Save"
                width: 110
                height: 44
                buttonColor: theme.buttonPrimaryColor
                textColor: theme.buttonTextLightColor
                font.bold: true
                radius: 8

                onClicked: {
                    if (editEventTitleField.text.trim() !== "") {
                        var duration = editAllDayCheck.checked ? 0 : parseInt(editDurationField.text) || 60
                        var time = editAllDayCheck.checked ? "00:00" : editEventTimeField.text

                        EventsModel.editEvent(
                            editEventDialog.eventIndex,
                            editEventTitleField.text,
                            editEventDescField.text,
                            editEventDateField.text,
                            time,
                            duration,
                            editCategoryCombo.currentText,
                            editAllDayCheck.checked
                        )
                        editEventDialog.close()
                    }
                }
            }
        }
    }

    function openEditDialog(index, title, description, date, time, duration, category, allDay) {
        eventIndex = index
        editEventTitleField.text = title
        editEventDescField.text = description
        editEventDateField.text = date
        editEventTimeField.text = time
        editDurationField.text = duration.toString()

        for (var i = 0; i < editCategoryCombo.model.length; i++) {
            if (editCategoryCombo.model[i] === category) {
                editCategoryCombo.currentIndex = i
                break
            }
        }

        editAllDayCheck.checked = allDay
        open()
    }

    Dialog {
        id: deleteEventDialog
        title: "Delete Event"
        anchors.centerIn: parent
        width: 400
        height: 200
        modal: true
        dim: true
        closePolicy: Dialog.CloseOnEscape | Dialog.CloseOnPressOutside

        property int eventIndex: -1
        property string eventTitle: ""

        Overlay.modal: Rectangle {
            color: "#80000000"
        }

        background: Rectangle {
            radius: 12
            color: theme.cardColor
            border.color: theme.borderColor
            border.width: 1
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 2
                radius: 12.0
                samples: 24
                color: theme.shadowColor
            }
        }

        header: Rectangle {
            height: 70
            color: theme.errorColor
            radius: 12

            Rectangle {
                width: parent.width
                height: 12
                color: theme.errorColor
                anchors.bottom: parent.bottom
            }

            Text {
                text: deleteEventDialog.title
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 24
                }
                font {
                    pixelSize: 24
                    bold: true
                }
                color: theme.buttonTextLightColor
            }
        }

        contentItem: Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            Text {
                text: "Are you sure you want to delete this event?"
                font.pixelSize: 16
                color: theme.textColor
                width: parent.width
                wrapMode: Text.WordWrap
            }

            Text {
                text: "\"" + deleteEventDialog.eventTitle + "\""
                font.pixelSize: 18
                font.bold: true
                color: theme.errorColor
                width: parent.width
                wrapMode: Text.WordWrap
            }

            Text {
                text: "This action cannot be undone."
                font.pixelSize: 14
                color: theme.textSecondaryColor
                width: parent.width
                wrapMode: Text.WordWrap
            }
        }

        footer: Rectangle {
            height: 70
            color: theme.backgroundSecondaryColor
            radius: 12

            Rectangle {
                width: parent.width
                height: 12
                color: theme.backgroundSecondaryColor
                anchors.top: parent.top
            }

            RowLayout {
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 24
                }
                spacing: 16

                CustomRectButton {
                    text: "Cancel"
                    width: 110
                    height: 44
                    buttonColor: theme.backgroundSecondaryColor
                    textColor: theme.textColor
                    radius: 8

                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 1
                        radius: 3.0
                        samples: 8
                        color: "#20000000"
                    }

                    onClicked: {
                        deleteEventDialog.close()
                        editEventDialog.close()
                    }
                }

                CustomRectButton {
                    text: "Delete"
                    width: 110
                    height: 44
                    buttonColor: theme.errorColor
                    textColor: theme.buttonTextLightColor
                    font.bold: true
                    radius: 8

                    onClicked: {
                        EventsModel.removeEvent(deleteEventDialog.eventIndex)
                        deleteEventDialog.close()
                        editEventDialog.close()
                    }
                }
            }
        }

        function confirmDelete(index, title) {
            eventIndex = index
            eventTitle = title
            open()
        }
    }
}
