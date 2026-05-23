import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: noteCard
    width: notesGrid.cellWidth - 20
    height: notesGrid.cellHeight - 20
    radius: 16
    color: currentTheme.cardColor
    border.color: model.color
    border.width: 1

    property string noteTitle: model.title
    property string noteContent: model.content
    property string noteCategory: model.category
    property string noteColor: model.color
    property string noteDate: model.formattedDate
    property string noteTime: model.formattedTime
    property int noteIndex: index
    property bool isHovered: hoverArea.containsMouse || noteEditButton.containsMouse || noteDeleteButton.containsMouse
    property bool isPressed: false

    signal editRequested(int index)
    signal deleteRequested(int index)
    signal viewRequested(int index)
    signal clicked(int index)

    transform: [
        Scale {
            id: pressScale
            origin.x: width / 2
            origin.y: height / 2
            xScale: noteCard.isPressed ? 0.97 : 1.0
            yScale: noteCard.isPressed ? 0.97 : 1.0

            Behavior on xScale {
                NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
            }
            Behavior on yScale {
                NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
            }
        }
    ]

    states: [
        State {
            name: "hovered"
            when: isHovered
            PropertyChanges { target: noteCard; border.width: 2 }
            PropertyChanges { target: noteCard; elevation: 10 }
            PropertyChanges { target: actionButtons; opacity: 1 }
        }
    ]

    transitions: [
        Transition {
            PropertyAnimation { properties: "border.width, elevation, opacity"; duration: 150; easing.type: Easing.OutQuad }
        }
    ]

    property int elevation: isHovered ? 10 : 4

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: isHovered ? 4 : 2
        radius: noteCard.elevation
        samples: Math.min(17, noteCard.elevation * 2 + 1)
        color: currentTheme.shadowColor
        Behavior on verticalOffset {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }
        Behavior on radius {
            NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onClicked: {
            if (!noteDeleteButton.containsMouse && !noteEditButton.containsMouse) {
                noteCard.viewRequested(noteIndex)
            }
        }
        onPressed: {
            if (!noteDeleteButton.containsMouse && !noteEditButton.containsMouse) {
                noteCard.isPressed = true
            }
        }
        onReleased: {
            noteCard.isPressed = false
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: 16
            topMargin: 12
        }
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: noteTitle
                font {
                    pixelSize: 18
                    bold: true
                    family: "Segoe UI, Arial, sans-serif"
                }
                color: currentTheme.textColor
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Rectangle {
                visible: noteCategory !== ""
                width: categoryText.implicitWidth + 16
                height: 24
                radius: 12
                color: Qt.alpha(noteColor, 0.2)

                Text {
                    id: categoryText
                    anchors.centerIn: parent
                    text: noteCategory
                    font {
                        pixelSize: 12
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: noteColor
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: currentTheme.borderColor
            opacity: 0.5
        }

        Text {
            id: contentText
            text: noteContent
            font {
                pixelSize: 14
                family: "Segoe UI, Arial, sans-serif"
            }
            color: currentTheme.textSecondaryColor
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            maximumLineCount: 6
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            OpacityMask {
                anchors.fill: parent
                source: contentText
                maskSource: Rectangle {
                    width: contentText.width
                    height: contentText.height
                    gradient: Gradient {
                        GradientStop { position: 0.85; color: "#FF000000" }
                        GradientStop { position: 1.0; color: "#00000000" }
                    }
                }
                visible: contentText.lineCount > 6
            }
        }

        RowLayout {
            id: footerRow
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: noteDate + " • " + noteTime
                font {
                    pixelSize: 12
                    family: "Segoe UI, Arial, sans-serif"
                }
                color: currentTheme.textSecondaryColor
                Layout.fillWidth: true
            }

            Row {
                id: actionButtons
                spacing: 8
                opacity: noteCard.isHovered ? 1 : 0
                z: 10

                Rectangle {
                    id: noteEditButton
                    width: 32
                    height: 32
                    radius: 16
                    color: editArea.containsMouse ?
                        Qt.lighter(currentTheme.accentColor, 1.1) :
                        currentTheme.accentColor

                    property bool containsMouse: editArea.containsMouse

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "✎"
                        font {
                            pixelSize: 14
                            bold: true
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: "white"
                    }

                    MouseArea {
                        id: editArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        preventStealing: true

                        onClicked: {
                            noteCard.editRequested(noteIndex)
                            mouse.accepted = true
                        }
                    }
                }

                Rectangle {
                    id: noteDeleteButton
                    width: 32
                    height: 32
                    radius: 16
                    color: deleteArea.containsMouse ?
                        currentTheme.buttonDangerColor :
                        Qt.alpha(currentTheme.buttonDangerColor, 0.8)

                    property bool containsMouse: deleteArea.containsMouse

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font {
                            pixelSize: 14
                            bold: true
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: "white"
                    }

                    MouseArea {
                        id: deleteArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        preventStealing: true

                        onClicked: {
                            noteCard.deleteRequested(noteIndex)
                            mouse.accepted = true
                        }
                    }
                }
            }
        }
    }
}
