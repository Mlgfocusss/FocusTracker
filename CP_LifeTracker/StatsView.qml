import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: statsView
    color: currentTheme.backgroundColor
    visible: false

    property var colorPalette: [
        currentTheme.buttonPrimaryColor,
        currentTheme.buttonSuccessColor,
        currentTheme.buttonWarningColor,
        currentTheme.statusInProgressColor,
        currentTheme.buttonInfoColor,
        currentTheme.accentColor,
        currentTheme.buttonDangerColor
    ]

    Theme {
        id: currentTheme
    }

    Rectangle {
        id: header
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 70
        color: currentTheme.accentColor

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 3
            radius: 8
            samples: 16
            color: currentTheme.shadowColor
            transparentBorder: true
        }

        RowLayout {
            anchors {
                fill: parent
                leftMargin: 20
                rightMargin: 20
            }

            Text {
                text: qsTr("Statistics Dashboard")
                font {
                    pixelSize: 24
                    bold: true
                    family: "Roboto"
                }
                color: currentTheme.buttonTextLightColor
                Layout.fillWidth: true
            }

            ComboBox {
                id: periodSelector
                model: [qsTr("Last 7 days"), qsTr("Last 30 days"), qsTr("All time")]
                implicitWidth: 150
                implicitHeight: 36

                background: Rectangle {
                    radius: 4
                    color: currentTheme.inputBackgroundColor
                    border.color: periodSelector.activeFocus ? currentTheme.inputBorderFocusColor : currentTheme.inputBorderColor
                    border.width: 1
                }

                contentItem: Text {
                    leftPadding: 10
                    text: periodSelector.displayText
                    font.pixelSize: 14
                    color: currentTheme.inputTextColor
                    verticalAlignment: Text.AlignVCenter
                }

                popup: Popup {
                    y: periodSelector.height
                    width: periodSelector.width
                    implicitHeight: contentItem.implicitHeight
                    padding: 1

                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: periodSelector.popup.visible ? periodSelector.delegateModel : null
                        currentIndex: periodSelector.highlightedIndex

                        ScrollIndicator.vertical: ScrollIndicator { }
                    }

                    background: Rectangle {
                        color: currentTheme.cardColor
                        border.color: currentTheme.borderColor
                        border.width: 1
                        radius: 4
                    }
                }
            }
        }
    }

    ScrollView {
        id: scrollView
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        ColumnLayout {
            width: scrollView.width
            spacing: 20
            anchors.margins: 20

            Item { height: 10 }

            GridLayout {
                columns: statsView.width > 800 ? 4 : statsView.width > 600 ? 2 : 1
                rowSpacing: 20
                columnSpacing: 20
                Layout.fillWidth: true
                Layout.margins: 10

                Repeater {
                    model: [
                        {title: qsTr("Total Habits"), value: HabitsModel ? HabitsModel.totalHabits : 0, icon: "📊", color: colorPalette[0], subtext: qsTr("Active habits")},
                        {title: qsTr("Completed Today"), value: HabitsModel ? HabitsModel.completedToday : 0, icon: "✓", color: colorPalette[1], subtext: qsTr("Done today")},
                        {title: qsTr("Longest Streak"), value: HabitsModel ? HabitsModel.longestStreak : 0, icon: "🔥", color: colorPalette[2], subtext: qsTr("Consecutive days")},
                        {title: qsTr("Completion Rate"), value: (HabitsModel ? HabitsModel.completionRate : 0) + "%", icon: "📈", color: colorPalette[3], subtext: qsTr("Overall success")}
                    ]

                    Rectangle {
                        Layout.fillWidth: true
                        height: 120
                        radius: 10
                        color: currentTheme.cardColor
                        border.width: 1
                        border.color: currentTheme.borderColor

                        layer.enabled: true
                        layer.effect: DropShadow {
                            horizontalOffset: 0
                            verticalOffset: 2
                            radius: 8
                            samples: 16
                            color: currentTheme.shadowColor
                            transparentBorder: true
                        }

                        Rectangle {
                            width: 8
                            anchors {
                                top: parent.top
                                bottom: parent.bottom
                                left: parent.left
                            }
                            color: modelData.color
                            radius: 5
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20
                            spacing: 15

                            Rectangle {
                                width: 60
                                height: 60
                                radius: 30
                                color: modelData.color
                                opacity: 0.15

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.icon
                                    font.pixelSize: 26
                                }
                            }

                            Column {
                                Layout.fillWidth: true
                                spacing: 8

                                Text {
                                    text: modelData.title
                                    font.pixelSize: 16
                                    font.family: "Roboto"
                                    color: currentTheme.textSecondaryColor
                                }

                                Text {
                                    text: modelData.value
                                    font.pixelSize: 32
                                    font.bold: true
                                    font.family: "Roboto"
                                    color: modelData.color
                                }

                                Text {
                                    text: modelData.subtext
                                    font.pixelSize: 14
                                    font.family: "Roboto"
                                    color: currentTheme.textSecondaryColor
                                }
                            }
                        }
                    }
                }
            }

            TabBar {
                id: statsTabs
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10

                background: Rectangle {
                    color: "transparent"
                }

                TabButton {
                    text: qsTr("Current Streaks")
                    width: implicitWidth

                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        font.family: "Roboto"
                        color: parent.checked ? currentTheme.accentColor : currentTheme.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        color: parent.checked ? currentTheme.cardSelectedColor : "transparent"
                        border.color: parent.checked ? currentTheme.accentColor : "transparent"
                        border.width: parent.checked ? 1 : 0
                        radius: 4
                    }
                }

                TabButton {
                    text: qsTr("Progress Summary")
                    width: implicitWidth

                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        font.family: "Roboto"
                        color: parent.checked ? currentTheme.accentColor : currentTheme.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        color: parent.checked ? currentTheme.cardSelectedColor : "transparent"
                        border.color: parent.checked ? currentTheme.accentColor : "transparent"
                        border.width: parent.checked ? 1 : 0
                        radius: 4
                    }
                }

                TabButton {
                    text: qsTr("Weekly Overview")
                    width: implicitWidth

                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        font.family: "Roboto"
                        color: parent.checked ? currentTheme.accentColor : currentTheme.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        color: parent.checked ? currentTheme.cardSelectedColor : "transparent"
                        border.color: parent.checked ? currentTheme.accentColor : "transparent"
                        border.width: parent.checked ? 1 : 0
                        radius: 4
                    }
                }
            }

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                currentIndex: statsTabs.currentIndex

                Rectangle {
                    color: currentTheme.cardColor
                    radius: 10
                    Layout.fillHeight: true
                    Layout.minimumHeight: 300
                    border.width: 1
                    border.color: currentTheme.borderColor

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 8
                        samples: 16
                        color: currentTheme.shadowColor
                        transparentBorder: true
                    }

                    ListView {
                        id: streaksList
                        anchors.fill: parent
                        anchors.margins: 10
                        clip: true
                        model: HabitsModel ? HabitsModel : null

                        headerPositioning: ListView.OverlayHeader
                        header: Rectangle {
                            width: parent.width
                            height: 40
                            color: currentTheme.backgroundSecondaryColor
                            z: 2

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: currentTheme.borderColor
                                anchors.bottom: parent.bottom
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 15
                                anchors.rightMargin: 15

                                Text {
                                    text: qsTr("Habit")
                                    font.bold: true
                                    font.family: "Roboto"
                                    color: currentTheme.textColor
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: qsTr("Current Streak")
                                    font.bold: true
                                    font.family: "Roboto"
                                    color: currentTheme.textColor
                                    Layout.preferredWidth: 100
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                Text {
                                    text: qsTr("Best Streak")
                                    font.bold: true
                                    font.family: "Roboto"
                                    color: currentTheme.textColor
                                    Layout.preferredWidth: 100
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: 50
                            color: index % 2 === 0 ? currentTheme.cardColor : currentTheme.backgroundSecondaryColor

                            Rectangle {
                                width: parent.width
                                height: 1
                                color: currentTheme.borderColor
                                anchors.bottom: parent.bottom
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 15
                                anchors.rightMargin: 15

                                Rectangle {
                                    width: 8
                                    height: 8
                                    radius: 4
                                    color: colorPalette[index % colorPalette.length]
                                }

                                Text {
                                    text: model ? (model.name ? model.name : "") : ""
                                    font.family: "Roboto"
                                    color: currentTheme.textColor
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                    Layout.leftMargin: 10
                                }

                                Rectangle {
                                    Layout.preferredWidth: 100
                                    Layout.preferredHeight: 30
                                    color: (model && model.streak > 0) ? Qt.alpha(colorPalette[2], 0.2) : Qt.alpha(currentTheme.backgroundSecondaryColor, 0.5)
                                    radius: 15

                                    RowLayout {
                                        anchors.centerIn: parent
                                        spacing: 5

                                        Text {
                                            text: "🔥"
                                            visible: model && model.streak > 0
                                            font.pixelSize: 16
                                        }

                                        Text {
                                            text: (model ? model.streak : 0) + ((model && model.streak === 1) ? qsTr(" day") : qsTr(" days"))
                                            color: (model && model.streak > 0) ? colorPalette[2] : currentTheme.textSecondaryColor
                                            font.bold: model && model.streak > 0
                                            font.family: "Roboto"
                                        }
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 100
                                    Layout.preferredHeight: 30
                                    color: Qt.alpha(currentTheme.backgroundSecondaryColor, 0.5)
                                    radius: 15

                                    Text {
                                        anchors.centerIn: parent
                                        text: (model ? model.bestStreak : 0) + ((model && model.bestStreak === 1) ? qsTr(" day") : qsTr(" days"))
                                        color: currentTheme.textSecondaryColor
                                        font.family: "Roboto"
                                    }
                                }
                            }
                        }

                        ScrollIndicator.vertical: ScrollIndicator { }
                    }
                }

                Rectangle {
                    color: currentTheme.cardColor
                    radius: 10
                    Layout.fillHeight: true
                    Layout.minimumHeight: 300
                    border.width: 1
                    border.color: currentTheme.borderColor

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 8
                        samples: 16
                        color: currentTheme.shadowColor
                        transparentBorder: true
                    }

                    Item {
                        anchors.fill: parent
                        anchors.margins: 20

                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Progress summary data will be shown here")
                            font.family: "Roboto"
                            font.pixelSize: 18
                            color: currentTheme.textSecondaryColor
                        }
                    }
                }

                Rectangle {
                    color: currentTheme.cardColor
                    radius: 10
                    Layout.fillHeight: true
                    Layout.minimumHeight: 300
                    border.width: 1
                    border.color: currentTheme.borderColor

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 8
                        samples: 16
                        color: currentTheme.shadowColor
                        transparentBorder: true
                    }

                    GridLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        columns: 7
                        rows: 2

                        Repeater {
                            model: [qsTr("Mon"), qsTr("Tue"), qsTr("Wed"), qsTr("Thu"), qsTr("Fri"), qsTr("Sat"), qsTr("Sun")]

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 30
                                color: currentTheme.backgroundSecondaryColor
                                radius: 4

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.bold: true
                                    font.family: "Roboto"
                                    color: currentTheme.textColor
                                }
                            }
                        }

                        Repeater {
                            model: 7

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: index % 2 === 0 ? currentTheme.backgroundSecondaryColor : currentTheme.cardColor
                                border.color: currentTheme.borderColor
                                border.width: 1
                                radius: 4

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 5

                                    Text {
                                        text: "8"
                                        font.pixelSize: 16
                                        font.bold: true
                                        font.family: "Roboto"
                                        color: currentTheme.textColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    ProgressBar {
                                        from: 0
                                        to: 100
                                        value: 75
                                        Layout.fillWidth: true

                                        background: Rectangle {
                                            color: Qt.alpha(currentTheme.borderColor, 0.3)
                                            radius: 3
                                        }

                                        contentItem: Rectangle {
                                            width: parent.width * parent.value / parent.to
                                            color: colorPalette[1]
                                            radius: 3
                                        }
                                    }

                                    Text {
                                        text: "75%"
                                        font.pixelSize: 14
                                        font.family: "Roboto"
                                        color: currentTheme.textSecondaryColor
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.fillWidth: true
                Layout.margins: 10
                Layout.bottomMargin: 20

                Rectangle {
                    implicitWidth: 130
                    implicitHeight: 40
                    radius: 6
                    color: exportMouseArea.pressed ? Qt.darker(currentTheme.buttonSecondaryColor, 1.1) : currentTheme.buttonSecondaryColor

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Export Stats")
                        font.pixelSize: 14
                        font.family: "Roboto"
                        color: currentTheme.buttonTextLightColor
                    }

                    MouseArea {
                        id: exportMouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: parent.color = Qt.lighter(currentTheme.buttonSecondaryColor, 1.1)
                        onExited: parent.color = currentTheme.buttonSecondaryColor
                    }
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    implicitWidth: 150
                    implicitHeight: 40
                    radius: 6
                    color: backMouseArea.pressed ? Qt.darker(currentTheme.buttonPrimaryColor, 1.1) : currentTheme.buttonPrimaryColor

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Back to Habits")
                        font.pixelSize: 14
                        font.family: "Roboto"
                        color: currentTheme.buttonTextLightColor
                    }

                    MouseArea {
                        id: backMouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: parent.color = Qt.lighter(currentTheme.buttonPrimaryColor, 1.1)
                        onExited: parent.color = currentTheme.buttonPrimaryColor

                        onClicked: {
                            statsView.visible = false
                            mainContent.visible = true
                        }
                    }
                }
            }
        }
    }
}
