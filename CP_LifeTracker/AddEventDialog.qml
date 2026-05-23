import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Dialog {
    id: addEventDialog
    title: "Add New Event"
    anchors.centerIn: parent
    width: 540
    height: 700
    modal: true
    dim: true
    closePolicy: Dialog.CloseOnEscape | Dialog.CloseOnPressOutside

    property alias titleField: eventTitleField
    property alias descField: eventDescField
    property alias dateField: eventDateField
    property alias timeField: eventTimeField
    property alias durationField: durationField
    property alias categoryCombo: categoryCombo

    Theme {
        id: theme
    }

    Overlay.modal: Rectangle {
        color: "#90000000"

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    background: Rectangle {
        radius: 20
        color: theme.cardColor
        border.color: theme.borderColor
        border.width: 1

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 12
            radius: 32.0
            samples: 64
            color: "#30000000"
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.lighter(theme.cardColor, 1.02) }
                GradientStop { position: 1.0; color: theme.cardColor }
            }
        }
    }

    header: Rectangle {
        height: 80
        radius: 20

        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.lighter(theme.accentColor, 1.1) }
            GradientStop { position: 1.0; color: theme.accentColor }
        }

        Rectangle {
            width: parent.width
            height: 20
            color: theme.accentColor
            anchors.bottom: parent.bottom
        }

        Text {
            text: addEventDialog.title
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 36
            }
            font {
                pixelSize: 26
                bold: true
                family: "Segoe UI, Arial, sans-serif"
            }
            color: theme.buttonTextLightColor

            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 1
                radius: 2.0
                samples: 4
                color: "#40000000"
            }
        }

        Rectangle {
            width: 4
            height: 32
            color: theme.buttonTextLightColor
            opacity: 0.8
            radius: 2
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 20
            }
        }
    }

    contentItem: Item {
        ColumnLayout {
            id: contentColumn
            anchors {
                fill: parent
                margins: 32
            }
            spacing: 20

            Text {
                text: "Create a new event"
                font {
                    pixelSize: 20
                    weight: Font.Medium
                    family: "Segoe UI, Arial, sans-serif"
                }
                color: theme.inputTextColor
                opacity: 0.9
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "Event Title *"
                    font {
                        pixelSize: 15
                        weight: Font.Medium
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: theme.inputTextColor
                }

                TextField {
                    id: eventTitleField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 52
                    placeholderText: "Enter event title"
                    font {
                        pixelSize: 16
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    selectByMouse: true
                    color: theme.inputTextColor
                    placeholderTextColor: theme.inputPlaceholderColor
                    leftPadding: 18
                    rightPadding: 18

                    background: Rectangle {
                        radius: 12
                        color: theme.inputBackgroundColor
                        border.color: parent.focus ? theme.inputBorderFocusColor : theme.inputBorderColor
                        border.width: parent.focus ? 2 : 1

                        Behavior on border.color {
                            ColorAnimation { duration: 200 }
                        }

                        Behavior on border.width {
                            NumberAnimation { duration: 200 }
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: "transparent"
                            border.width: parent.focus ? 1 : 0
                            border.color: Qt.lighter(theme.inputBorderFocusColor, 1.3)
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "Description"
                    font {
                        pixelSize: 15
                        weight: Font.Medium
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: theme.inputTextColor
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    radius: 12
                    color: theme.inputBackgroundColor
                    border.color: eventDescField.focus ? theme.inputBorderFocusColor : theme.inputBorderColor
                    border.width: eventDescField.focus ? 2 : 1

                    Behavior on border.color {
                        ColorAnimation { duration: 200 }
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: "transparent"
                        border.width: parent.border.width === 2 ? 1 : 0
                        border.color: Qt.lighter(theme.inputBorderFocusColor, 1.3)
                    }

                    TextArea {
                        id: eventDescField
                        anchors {
                            fill: parent
                            margins: 4
                        }
                        placeholderText: "Add description (optional)"
                        font {
                            pixelSize: 16
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        selectByMouse: true
                        color: theme.inputTextColor
                        placeholderTextColor: theme.inputPlaceholderColor
                        padding: 16
                        wrapMode: TextArea.Wrap
                        background: null
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 20

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Date"
                        font {
                            pixelSize: 15
                            weight: Font.Medium
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: theme.inputTextColor
                    }

                    TextField {
                        id: eventDateField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 52
                        placeholderText: "yyyy-MM-dd"
                        font {
                            pixelSize: 16
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        selectByMouse: true
                        color: theme.inputTextColor
                        placeholderTextColor: theme.inputPlaceholderColor
                        leftPadding: 18
                        rightPadding: 18

                        background: Rectangle {
                            radius: 12
                            color: theme.inputBackgroundColor
                            border.color: parent.focus ? theme.inputBorderFocusColor : theme.inputBorderColor
                            border.width: parent.focus ? 2 : 1

                            Behavior on border.color {
                                ColorAnimation { duration: 200 }
                            }

                            Behavior on border.width {
                                NumberAnimation { duration: 200 }
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: "transparent"
                                border.width: parent.focus ? 1 : 0
                                border.color: Qt.lighter(theme.inputBorderFocusColor, 1.3)
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Time"
                        font {
                            pixelSize: 15
                            weight: Font.Medium
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: theme.inputTextColor
                    }

                    TextField {
                        id: eventTimeField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 52
                        placeholderText: "HH:MM"
                        font {
                            pixelSize: 16
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        selectByMouse: true
                        color: theme.inputTextColor
                        placeholderTextColor: theme.inputPlaceholderColor
                        leftPadding: 18
                        rightPadding: 18

                        background: Rectangle {
                            radius: 12
                            color: theme.inputBackgroundColor
                            border.color: parent.focus ? theme.inputBorderFocusColor : theme.inputBorderColor
                            border.width: parent.focus ? 2 : 1

                            Behavior on border.color {
                                ColorAnimation { duration: 200 }
                            }

                            Behavior on border.width {
                                NumberAnimation { duration: 200 }
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 20

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Duration (minutes)"
                        font {
                            pixelSize: 15
                            weight: Font.Medium
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: theme.inputTextColor
                    }

                    TextField {
                        id: durationField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 52
                        placeholderText: "Default: 60"
                        font {
                            pixelSize: 16
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        selectByMouse: true
                        color: theme.inputTextColor
                        placeholderTextColor: theme.inputPlaceholderColor
                        leftPadding: 18
                        rightPadding: 18

                        background: Rectangle {
                            radius: 12
                            color: theme.inputBackgroundColor
                            border.color: parent.focus ? theme.inputBorderFocusColor : theme.inputBorderColor
                            border.width: parent.focus ? 2 : 1

                            Behavior on border.color {
                                ColorAnimation { duration: 200 }
                            }

                            Behavior on border.width {
                                NumberAnimation { duration: 200 }
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Category"
                        font {
                            pixelSize: 15
                            weight: Font.Medium
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: theme.inputTextColor
                    }

                    CustomComboBox {
                        id: categoryCombo
                        Layout.fillWidth: true
                        height: 52
                        model: ["General", "Work", "Personal", "Health", "Travel", "Education"]
                        currentIndex: 0
                        textColor: theme.inputTextColor
                        borderColorNormal: theme.inputBorderColor
                        borderColorFocused: theme.inputBorderFocusColor
                        bgColorNormal: theme.inputBackgroundColor
                        dropdownBgColor: theme.cardColor
                        radius: 12
                    }
                }
            }
        }
    }

    footer: Rectangle {
        height: 88
        radius: 20

        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.lighter(theme.backgroundSecondaryColor, 1.02) }
            GradientStop { position: 1.0; color: theme.backgroundSecondaryColor }
        }

        Rectangle {
            width: parent.width
            height: 20
            color: theme.backgroundSecondaryColor
            anchors.top: parent.top
        }

        RowLayout {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 32
            }
            spacing: 20

            CustomRectButton {
                text: "Cancel"
                width: 130
                height: 52
                buttonColor: theme.backgroundSecondaryColor
                textColor: theme.inputTextColor
                radius: 12
                font {
                    pixelSize: 16
                    family: "Segoe UI, Arial, sans-serif"
                }

                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 3
                    radius: 8.0
                    samples: 16
                    color: "#15000000"
                }

                onClicked: {
                    addEventDialog.close()
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: parent.onClicked()

                    onEntered: {
                        parent.buttonColor = Qt.lighter(theme.backgroundSecondaryColor, 1.1)
                    }

                    onExited: {
                        parent.buttonColor = theme.backgroundSecondaryColor
                    }
                }
            }

            CustomRectButton {
                text: "Create Event"
                width: 150
                height: 52
                buttonColor: theme.buttonPrimaryColor
                textColor: theme.buttonTextLightColor
                font {
                    bold: true
                    pixelSize: 16
                    family: "Segoe UI, Arial, sans-serif"
                }
                radius: 12
                enabled: eventTitleField.text.trim() !== ""
                opacity: enabled ? 1.0 : 0.6

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }

                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 4
                    radius: 12.0
                    samples: 24
                    color: enabled ? "#50000000" : "#20000000"
                }

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"
                    border.width: parent.enabled ? 1 : 0
                    border.color: Qt.lighter(theme.buttonPrimaryColor, 1.2)
                    opacity: 0.5
                }

                onClicked: {
                    if (eventTitleField.text.trim() !== "" && EventsModel) {
                        var duration = parseInt(durationField.text) || 60

                        EventsModel.addEvent(
                            eventTitleField.text,
                            eventDescField.text,
                            eventDateField.text,
                            eventTimeField.text,
                            duration,
                            categoryCombo.currentText,
                            false
                        )
                        addEventDialog.close()
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: parent.enabled
                    onClicked: parent.onClicked()

                    onEntered: {
                        if (parent.enabled) {
                            parent.buttonColor = Qt.lighter(theme.buttonPrimaryColor, 1.1)
                        }
                    }

                    onExited: {
                        parent.buttonColor = theme.buttonPrimaryColor
                    }
                }
            }
        }
    }
}
