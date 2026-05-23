import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Item {
    id: notesViewRoot

    property var colorOptions: [
        "#10B981",
        "#3B82F6",
        "#8B5CF6",
        "#EC4899",
        "#F59E0B",
        "#EF4444",
        "#64748B"
    ]

    property var categoryOptions: [
        qsTr("Personal"),
        qsTr("Work"),
        qsTr("Ideas"),
        qsTr("Goals"),
        qsTr("Tasks"),
        qsTr("Other")
    ]

    Theme {
        id: currentTheme
    }

    property alias notesModel: notesGrid.model

    Rectangle {
        anchors.fill: parent
        color: currentTheme.backgroundColor

        Rectangle {
            id: headerBar
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: 80
            color: currentTheme.cardColor

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 2
                radius: 4.0
                samples: 9
                color: currentTheme.shadowColor
            }

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: 24
                    rightMargin: 24
                }
                spacing: 16

                Text {
                    id: headerText
                    text: qsTr("Notes")
                    font {
                        pixelSize: 32
                        bold: true
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: currentTheme.textColor
                }

                Item { Layout.fillWidth: true }

                CustomRectButton {
                    id: addNoteButton
                    width: 140
                    height: 48
                    text: qsTr("+ Add Note")
                    buttonColor: currentTheme.accentColor

                    onClicked: {
                        addNoteDialog.currentNoteTitle = ""
                        addNoteDialog.currentNoteContent = ""
                        addNoteDialog.currentNoteCategory = categoryOptions[0]
                        addNoteDialog.currentNoteColor = colorOptions[0]
                        addNoteDialog.isEditing = false
                        addNoteDialog.editIndex = -1
                        addNoteDialog.open()
                    }
                }
            }
        }

        ScrollView {
            id: notesScrollView
            anchors {
                top: headerBar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                topMargin: 20
                leftMargin: 20
                rightMargin: 20
                bottomMargin: 20
            }
            clip: true

            GridView {
                id: notesGrid
                anchors.fill: parent
                cellWidth: Math.max(300, (width - 20) / Math.floor(width / 320))
                cellHeight: 220

                delegate: NoteCard {
                    onViewRequested: function(index) {
                        viewNoteDialog.noteTitle = model.title
                        viewNoteDialog.noteContent = model.content
                        viewNoteDialog.noteCategory = model.category
                        viewNoteDialog.noteColor = model.color
                        viewNoteDialog.noteDate = model.formattedDate
                        viewNoteDialog.noteTime = model.formattedTime
                        viewNoteDialog.viewIndex = index
                        viewNoteDialog.open()
                    }

                    onEditRequested: function(index) {
                        addNoteDialog.currentNoteTitle = model.title
                        addNoteDialog.currentNoteContent = model.content
                        addNoteDialog.currentNoteCategory = model.category
                        addNoteDialog.currentNoteColor = model.color
                        addNoteDialog.isEditing = true
                        addNoteDialog.editIndex = index
                        addNoteDialog.open()
                    }

                    onDeleteRequested: function(index) {
                        deleteNoteDialog.deleteIndex = index
                        deleteNoteDialog.open()
                    }
                }

                add: Transition {
                    NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 300 }
                    NumberAnimation { properties: "scale"; from: 0.8; to: 1; duration: 300 }
                }

                remove: Transition {
                    NumberAnimation { properties: "opacity"; to: 0; duration: 300 }
                    NumberAnimation { properties: "scale"; to: 0.8; duration: 300 }
                }

                displaced: Transition {
                    NumberAnimation { properties: "x,y"; duration: 300; easing.type: Easing.OutQuad }
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: notesGrid.model.count === 0 ? qsTr("No notes yet. Create your first note!") : ""
            font {
                pixelSize: 20
                family: "Segoe UI, Arial, sans-serif"
            }
            color: currentTheme.textSecondaryColor
        }
    }

    Dialog {
        id: viewNoteDialog
        title: noteTitle
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        modal: true
        closePolicy: Dialog.CloseOnEscape | Dialog.CloseOnPressOutside
        padding: 0
        topPadding: 0
        bottomPadding: 0
        leftPadding: 0
        rightPadding: 0

        property string noteTitle: ""
        property string noteContent: ""
        property string noteCategory: ""
        property string noteColor: "#3B82F6"
        property string noteDate: ""
        property string noteTime: ""
        property int viewIndex: -1

        background: Rectangle {
            color: currentTheme.backgroundColor

            Rectangle {
                width: parent.width
                height: parent.height
                color: currentTheme.cardColor

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 4
                    radius: 12.0
                    samples: 25
                    color: currentTheme.shadowColor
                }
            }
        }

        header: Rectangle {
            height: 80
            color: viewNoteDialog.noteColor

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 2
                radius: 8.0
                samples: 17
                color: currentTheme.shadowColor
            }

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: 24
                    rightMargin: 24
                }
                spacing: 16

                Text {
                    text: viewNoteDialog.title
                    font {
                        pixelSize: 28
                        bold: true
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: currentTheme.buttonTextLightColor
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: categoryText.implicitWidth + 20
                    height: 32
                    radius: 16
                    color: Qt.alpha("#FFFFFF", 0.2)
                    visible: viewNoteDialog.noteCategory !== ""

                    Text {
                        id: categoryText
                        anchors.centerIn: parent
                        text: viewNoteDialog.noteCategory
                        font {
                            pixelSize: 14
                            bold: true
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: currentTheme.buttonTextLightColor
                    }
                }

                CustomRectButton {
                    text: qsTr("Edit")
                    width: 100
                    height: 40
                    buttonColor: Qt.alpha("#FFFFFF", 0.2)

                    onClicked: {
                        addNoteDialog.currentNoteTitle = viewNoteDialog.noteTitle
                        addNoteDialog.currentNoteContent = viewNoteDialog.noteContent
                        addNoteDialog.currentNoteCategory = viewNoteDialog.noteCategory
                        addNoteDialog.currentNoteColor = viewNoteDialog.noteColor
                        addNoteDialog.isEditing = true
                        addNoteDialog.editIndex = viewNoteDialog.viewIndex
                        viewNoteDialog.close()
                        addNoteDialog.open()
                    }
                }

                CustomRectButton {
                    text: qsTr("Close")
                    width: 100
                    height: 40
                    buttonColor: Qt.alpha("#FFFFFF", 0.2)

                    onClicked: {
                        viewNoteDialog.close()
                    }
                }
            }
        }

        contentItem: Item {
            ScrollView {
                anchors {
                    fill: parent
                    margins: 32
                }
                clip: true

                Text {
                    width: viewNoteDialog.width - 64
                    text: viewNoteDialog.noteContent
                    wrapMode: Text.WordWrap
                    font {
                        pixelSize: 18
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: currentTheme.textColor
                    lineHeight: 1.5
                }
            }
        }

        footer: Rectangle {
            height: 60
            color: currentTheme.backgroundSecondaryColor

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: -2
                radius: 8.0
                samples: 17
                color: currentTheme.shadowColor
            }

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: 24
                    rightMargin: 24
                }
                spacing: 16

                Text {
                    text: viewNoteDialog.noteDate + " • " + viewNoteDialog.noteTime
                    font {
                        pixelSize: 14
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: currentTheme.textSecondaryColor
                    Layout.fillWidth: true
                }
            }
        }
    }

    AddNoteDialog {
        id: addNoteDialog
        colorOptions: notesViewRoot.colorOptions
        categoryOptions: notesViewRoot.categoryOptions
        notesModel: notesGrid.model
        currentTheme: currentTheme
    }

    Dialog {
        id: deleteNoteDialog
        title: qsTr("Delete Note")
        width: 400
        height: 200
        anchors.centerIn: parent
        modal: true
        closePolicy: Dialog.CloseOnEscape

        property int deleteIndex: -1

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
            height: 70
            color: currentTheme.buttonDangerColor
            radius: 12

            Rectangle {
                width: parent.width
                height: 12
                color: currentTheme.buttonDangerColor
                anchors.bottom: parent.bottom
            }

            Text {
                text: deleteNoteDialog.title
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 24
                }
                font {
                    pixelSize: 22
                    bold: true
                    family: "Segoe UI, Arial, sans-serif"
                }
                color: currentTheme.buttonTextLightColor
            }
        }

        contentItem: Item {
            anchors.fill: parent

            Text {
                anchors {
                    centerIn: parent
                    margins: 24
                }
                text: qsTr("Are you sure you want to delete this note?")
                font {
                    pixelSize: 16
                    family: "Segoe UI, Arial, sans-serif"
                }
                color: currentTheme.textColor
                wrapMode: Text.WordWrap
                width: parent.width - 48
                horizontalAlignment: Text.AlignHCenter
            }
        }

        footer: Rectangle {
            height: 70
            color: currentTheme.backgroundSecondaryColor
            radius: 12

            Rectangle {
                width: parent.width
                height: 12
                color: currentTheme.backgroundSecondaryColor
                anchors.top: parent.top
            }

            RowLayout {
                anchors {
                    centerIn: parent
                }
                spacing: 16

                CustomRectButton {
                    text: qsTr("Cancel")
                    width: 120
                    height: 48
                    buttonColor: currentTheme.backgroundSecondaryColor
                    textColor: currentTheme.textColor

                    onClicked: {
                        deleteNoteDialog.close()
                    }
                }

                CustomRectButton {
                    text: qsTr("Delete")
                    width: 120
                    height: 48
                    buttonColor: currentTheme.buttonDangerColor

                    onClicked: {
                        if (deleteNoteDialog.deleteIndex >= 0) {
                            notesGrid.model.removeNote(deleteNoteDialog.deleteIndex)
                            deleteNoteDialog.close()
                        }
                    }
                }
            }
        }
    }
}
