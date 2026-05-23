import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Dialog {
    id: addNoteDialog
    title: isEditing ? qsTr("Edit Note") : qsTr("Add New Note")
    width: 600
    height: 500
    anchors.centerIn: parent
    modal: true
    closePolicy: Dialog.CloseOnEscape | Dialog.CloseOnPressOutside

    property string currentNoteTitle: ""
    property string currentNoteContent: ""
    property string currentNoteCategory: ""
    property string currentNoteColor: ""
    property bool isEditing: false
    property int editIndex: -1
    property var colorOptions: []
    property var categoryOptions: []
    property var notesModel
    property var currentTheme

    //signal closed()

    function open() {
        visible = true
    }

    function close() {
        visible = false
        closed()
    }

    background: Rectangle {
        radius: 12
        color: currentTheme.cardColor
        border.color: currentTheme.borderColor
        border.width: 1

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 8.0
            samples: 17
            color: currentTheme.shadowColor
        }
    }

    header: Rectangle {
        height: 76
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: isEditing ? currentTheme.accentGradientStartColor : currentTheme.accentColor
            radius: 12

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: isEditing ? currentTheme.accentGradientStartColor : currentTheme.accentColor }
                GradientStop { position: 1.0; color: isEditing ? Qt.lighter(currentTheme.accentGradientStartColor, 1.2) : Qt.lighter(currentTheme.accentColor, 1.2) }
            }

            Rectangle {
                width: parent.width
                height: 12
                color: parent.color
                anchors.bottom: parent.bottom
            }
        }

        RowLayout {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: 24
                rightMargin: 24
            }
            spacing: 12

            Text {
                text: addNoteDialog.title
                font {
                    pixelSize: 24
                    bold: true
                    family: "Segoe UI, Arial, sans-serif"
                }
                color: currentTheme.buttonTextLightColor
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: "#FFFFFF20"
                visible: isEditing

                Text {
                    anchors.centerIn: parent
                    text: "✎"
                    font.pixelSize: 16
                    color: currentTheme.buttonTextLightColor
                }
            }
        }
    }

    contentItem: Item {
        ColumnLayout {
            anchors {
                fill: parent
                margins: 24
            }
            spacing: 20

            Rectangle {
                Layout.fillWidth: true
                height: titleField.height + 16
                radius: 10
                color: currentTheme.inputBackgroundColor
                border.color: titleField.focus ? currentTheme.inputBorderFocusColor : currentTheme.inputBorderColor
                border.width: titleField.focus ? 2 : 1

                Behavior on border.color {
                    ColorAnimation { duration: 150 }
                }

                TextField {
                    id: titleField
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 4
                    }
                    placeholderText: qsTr("Note title")
                    text: currentNoteTitle
                    font {
                        pixelSize: 18
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    selectByMouse: true
                    padding: 12
                    color: currentTheme.inputTextColor
                    placeholderTextColor: currentTheme.inputPlaceholderColor
                    background: null
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: qsTr("Category & Color")
                    font {
                        pixelSize: 14
                        family: "Segoe UI, Arial, sans-serif"
                        bold: true
                    }
                    color: currentTheme.textSecondaryColor
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    CustomComboBox {
                        id: categoryComboBox
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        model: categoryOptions
                        currentIndex: categoryOptions.indexOf(currentNoteCategory) !== -1 ?
                                    categoryOptions.indexOf(currentNoteCategory) : 0
                        textColor: currentTheme.inputTextColor
                        borderColorNormal: currentTheme.inputBorderColor
                        borderColorFocused: currentTheme.inputBorderFocusColor
                        bgColorNormal: currentTheme.inputBackgroundColor
                        dropdownBgColor: currentTheme.cardColor
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        radius: 8
                        color: currentTheme.inputBackgroundColor
                        border.color: currentTheme.inputBorderColor
                        border.width: 1

                        ScrollView {
                            anchors {
                                fill: parent
                                margins: 8
                            }
                            clip: true
                            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                            Flow {
                                id: colorSelector
                                width: parent.width
                                spacing: 8
                                anchors.verticalCenter: parent.verticalCenter

                                Repeater {
                                    model: colorOptions

                                    Rectangle {
                                        width: 32
                                        height: 32
                                        radius: width / 2
                                        color: modelData
                                        border.width: currentNoteColor === modelData ? 3 : 0
                                        border.color: "#FFFFFF"

                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: parent.width - 8
                                            height: width
                                            radius: width / 2
                                            color: modelData
                                            visible: currentNoteColor === modelData
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                currentNoteColor = modelData
                                            }
                                        }

                                        Text {
                                            anchors.centerIn: parent
                                            text: "✓"
                                            color: "#FFFFFF"
                                            visible: currentNoteColor === modelData
                                            font {
                                                pixelSize: 16
                                                bold: true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8

                Text {
                    text: qsTr("Content")
                    font {
                        pixelSize: 14
                        family: "Segoe UI, Arial, sans-serif"
                        bold: true
                    }
                    color: currentTheme.textSecondaryColor
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 10
                    color: currentTheme.inputBackgroundColor
                    border.color: noteContentField.focus ? currentTheme.inputBorderFocusColor : currentTheme.inputBorderColor
                    border.width: noteContentField.focus ? 2 : 1

                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }

                    ScrollView {
                        anchors {
                            fill: parent
                            margins: 4
                        }
                        clip: true

                        TextArea {
                            id: noteContentField
                            text: currentNoteContent
                            placeholderText: qsTr("Write your note here...")
                            font {
                                pixelSize: 16
                                family: "Segoe UI, Arial, sans-serif"
                            }
                            wrapMode: TextArea.Wrap
                            selectByMouse: true
                            padding: 12
                            color: currentTheme.inputTextColor
                            placeholderTextColor: currentTheme.inputPlaceholderColor
                            background: null
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                height: 4
            }
        }
    }

    footer: Rectangle {
        height: 76
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: currentTheme.backgroundSecondaryColor
            radius: 12

            Rectangle {
                width: parent.width
                height: 12
                color: currentTheme.backgroundSecondaryColor
                anchors.top: parent.top
            }
        }

        RowLayout {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 24
            }
            spacing: 16

            CustomRectButton {
                text: qsTr("Cancel")
                width: 120
                height: 48
                buttonColor: currentTheme.backgroundSecondaryColor
                textColor: currentTheme.textColor

                onClicked: {
                    addNoteDialog.close()
                }
            }

            CustomRectButton {
                text: isEditing ? qsTr("Save") : qsTr("Create")
                width: 120
                height: 48
                buttonColor: currentTheme.accentColor
                enabled: titleField.text.trim() !== ""

                opacity: enabled ? 1.0 : 0.7

                Behavior on opacity {
                    NumberAnimation { duration: 150 }
                }

                onClicked: {
                    if (titleField.text.trim() !== "") {
                        if (isEditing) {
                            notesModel.updateNote(
                                editIndex,
                                titleField.text,
                                noteContentField.text,
                                categoryComboBox.currentText,
                                currentNoteColor
                            )
                        } else {
                            notesModel.addNote(
                                titleField.text,
                                noteContentField.text,
                                categoryComboBox.currentText,
                                currentNoteColor
                            )
                        }
                        addNoteDialog.close()
                    }
                }
            }
        }
    }
}
