import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: sidePanel
    color: theme.backgroundSecondaryColor
    radius: 0

    property int rightRadius: 0

    signal addHabitClicked()
    signal statsClicked()
    signal exitClicked()
    signal profileClicked()
    signal settingsClicked()
    signal pageSelected(string pageName)
    signal habitViewRequested(var habit)

    property bool expanded: true
    property bool isVisible: true
    property int minimizedWidth: 70
    property int maximizedWidth: 260
    property string currentPage: "habits"
    property int animationDuration: 250
    property real minWidthPercentage: 0.4
    property real maxWidthPercentage: 0.8

    width: isVisible ? (expanded ? maximizedWidth : minimizedWidth) : 0
    clip: true

    Theme {
        id: theme
    }

    Behavior on width {
        NumberAnimation {
            duration: animationDuration
            easing.type: Easing.OutCubic
        }
    }

    function updateUiTranslations() {
        appTitleText.text = qsTr("FocusTracker")
        expandCollapseButton.toolTip = sidePanel.expanded ? qsTr("Collapse") : qsTr("Expand")
        hideButton.toolTip = qsTr("Hide panel")
        addHabitButton.text = qsTr("Add New Habit")
        dashboardButton.text = qsTr("Dashboard")
        habitsButton.text = qsTr("Habits")
        tasksButton.text = qsTr("Tasks")
        calendarButton.text = qsTr("Calendar")
        notesButton.text = qsTr("Notes")
        toolsHeader.text = qsTr("TOOLS")
        scheduleButton.text = qsTr("Work Schedule")
        goalsButton.text = qsTr("Goals & Plans")
        searchButton.text = qsTr("Search")
        statsButton.text = qsTr("Statistics")
        settingsButton.text = qsTr("Settings")
        archiveButton.text = qsTr("Archive")
        trashButton.text = qsTr("Trash")
        exitButton.text = qsTr("Exit")
    }

    Rectangle {
        id: resizeHandle
        width: 6
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        color: theme.borderColor
        opacity: mouseArea.containsMouse || mouseArea.pressed ? 0.8 : 0.0
        visible: sidePanel.isVisible && sidePanel.expanded

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            anchors.margins: -8
            cursorShape: Qt.SizeHorCursor
            hoverEnabled: true
            property int startX: 0
            property int startWidth: 0

            onPressed: {
                startX = mouseX
                startWidth = sidePanel.width
            }

            onPositionChanged: {
                if (pressed) {
                    var newWidth = startWidth + (mouseX - startX)
                    var minWidth = 200

                    if (newWidth < sidePanel.minimizedWidth * 1.1) {
                        sidePanel.expanded = false
                    } else {
                        sidePanel.expanded = true
                        var parentWidth = sidePanel.parent ? sidePanel.parent.width : 1000
                        sidePanel.maximizedWidth = Math.min(
                            Math.max(newWidth, minWidth),
                            parentWidth * sidePanel.maxWidthPercentage
                        )
                    }
                }
            }
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors {
            fill: parent
            leftMargin: sidePanel.expanded ? 14 : 8
            rightMargin: sidePanel.expanded ? 14 : 8
            topMargin: 12
            bottomMargin: 12
        }
        spacing: 0

        Behavior on anchors.leftMargin {
            NumberAnimation { duration: animationDuration }
        }

        Behavior on anchors.rightMargin {
            NumberAnimation { duration: animationDuration }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            Layout.preferredHeight: 40

            ProfileButton {
                id: profileButton
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                visible: true
                opacity: 1.0
                onClicked: sidePanel.profileClicked()

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 2
                    radius: 5.0
                    samples: 9
                    color: "#30000000"
                }
            }

            Text {
                id: appTitleText
                text: qsTr("FocusTracker")
                font {
                    pixelSize: 20
                    weight: Font.DemiBold
                    family: "Segoe UI"
                }
                color: theme.textColor
                visible: sidePanel.expanded
                opacity: sidePanel.expanded ? 1.0 : 0.0
                elide: Text.ElideRight
                Layout.fillWidth: true

                Behavior on opacity {
                    NumberAnimation { duration: animationDuration }
                }
            }

            Item {
                Layout.fillWidth: true
                visible: sidePanel.expanded
            }

            NavIconButton {
                id: expandCollapseButton
                iconText: sidePanel.expanded ? "◀" : "▶"
                toolTip: sidePanel.expanded ? qsTr("Collapse") : qsTr("Expand")
                visible: sidePanel.expanded
                opacity: sidePanel.expanded ? 1.0 : 0.0
                onClicked: {
                    sidePanel.expanded = !sidePanel.expanded
                }

                Behavior on opacity {
                    NumberAnimation { duration: animationDuration }
                }
            }

            NavIconButton {
                id: hideButton
                iconText: "×"
                toolTip: qsTr("Hide panel")
                visible: sidePanel.expanded
                opacity: sidePanel.expanded ? 1.0 : 0.0
                onClicked: {
                    sidePanel.isVisible = false
                }

                Behavior on opacity {
                    NumberAnimation { duration: animationDuration }
                }
            }
        }

        Item {
            height: sidePanel.expanded ? 8 : 12
            Layout.fillWidth: true

            Behavior on height {
                NumberAnimation { duration: animationDuration }
            }
        }

        NavButton {
            id: addHabitButton
            icon: "+"
            text: qsTr("Add New Habit")
            color: theme.accentColor
            expanded: sidePanel.expanded
            animationDuration: sidePanel.animationDuration
            buttonSize: width
            Layout.fillWidth: true
            Layout.preferredHeight: 46
            Layout.alignment: Qt.AlignHCenter
            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 2
                radius: 4.0
                samples: 8
                color: "#20000000"
            }
            onClicked: {
                sidePanel.addHabitClicked()
            }
        }

        Item {
            height: 12
            Layout.fillWidth: true
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 3

            NavButton {
                id: dashboardButton
                icon: "🏠"
                text: qsTr("Dashboard")
                expanded: sidePanel.expanded
                selected: currentPage === "dashboard"
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textColor
                onClicked: {
                    sidePanel.currentPage = "dashboard"
                    sidePanel.pageSelected("dashboard")
                }
            }

            NavButton {
                id: habitsButton
                icon: "✓"
                text: qsTr("Habits")
                expanded: sidePanel.expanded
                selected: currentPage === "habits"
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textColor
                onClicked: {
                    sidePanel.currentPage = "habits"
                    sidePanel.habitViewRequested(null)
                }
            }

            NavButton {
                id: tasksButton
                icon: "📝"
                text: qsTr("Tasks")
                expanded: sidePanel.expanded
                selected: currentPage === "tasks"
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textColor
                onClicked: {
                    sidePanel.currentPage = "tasks"
                    sidePanel.pageSelected("tasks")
                }
            }

            NavButton {
                id: calendarButton
                icon: "📅"
                text: qsTr("Calendar")
                expanded: sidePanel.expanded
                selected: currentPage === "calendar"
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textColor
                onClicked: {
                    sidePanel.currentPage = "calendar"
                    sidePanel.pageSelected("calendar")
                }
            }

            NavButton {
                id: notesButton
                icon: "📓"
                text: qsTr("Notes")
                expanded: sidePanel.expanded
                selected: currentPage === "notes"
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textColor
                onClicked: {
                    sidePanel.currentPage = "notes"
                    sidePanel.pageSelected("notes")
                }
            }

            Item {
                height: 8
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: theme.borderColor
                opacity: 0.7
                Behavior on opacity {
                    NumberAnimation { duration: animationDuration }
                }
            }

            Item {
                height: 8
                Layout.fillWidth: true
            }

            Text {
                id: toolsHeader
                text: qsTr("TOOLS")
                font {
                    pixelSize: 12
                    letterSpacing: 1.5
                    family: "Segoe UI"
                    weight: Font.DemiBold
                }
                color: theme.textSecondaryColor
                visible: sidePanel.expanded
                opacity: sidePanel.expanded ? 1.0 : 0.0
                Layout.leftMargin: 12
                Layout.fillWidth: true
                elide: Text.ElideRight

                Behavior on opacity {
                    NumberAnimation { duration: animationDuration }
                }
            }

            Item {
                height: 6
                Layout.fillWidth: true
                visible: sidePanel.expanded
            }

            NavButton {
                id: scheduleButton
                icon: "⏰"
                text: qsTr("Work Schedule")
                expanded: sidePanel.expanded
                selected: currentPage === "schedule"
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textColor
                onClicked: {
                    sidePanel.currentPage = "schedule"
                    sidePanel.pageSelected("schedule")
                }
            }

            NavButton {
                id: goalsButton
                icon: "🎯"
                text: qsTr("Goals & Plans")
                expanded: sidePanel.expanded
                selected: currentPage === "goals"
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textColor
                onClicked: {
                    sidePanel.currentPage = "goals"
                    sidePanel.pageSelected("goals")
                }
            }

            NavButton {
                id: searchButton
                icon: "🔍"
                text: qsTr("Search")
                expanded: sidePanel.expanded
                selected: currentPage === "search"
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textColor
                onClicked: {
                    sidePanel.currentPage = "search"
                    sidePanel.pageSelected("search")
                }
            }

            NavButton {
                id: statsButton
                icon: "📊"
                text: qsTr("Statistics")
                expanded: sidePanel.expanded
                selected: currentPage === "stats"
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textColor
                onClicked: {
                    sidePanel.currentPage = "stats"
                    sidePanel.pageSelected("stats")
                    sidePanel.statsClicked()
                }
            }

            Item {
                height: 4
                Layout.fillWidth: true
            }

            NavButton {
                id: settingsButton
                icon: "⚙️"
                text: qsTr("Settings")
                expanded: sidePanel.expanded
                selected: false
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textColor
                onClicked: {
                    sidePanel.settingsClicked()
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Item {
                height: 6
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: theme.borderColor
                opacity: 0.7
                Behavior on opacity {
                    NumberAnimation { duration: animationDuration }
                }
            }

            Item {
                height: 8
                Layout.fillWidth: true
            }

            NavButton {
                id: archiveButton
                icon: "🗄️"
                text: qsTr("Archive")
                expanded: sidePanel.expanded
                selected: currentPage === "archive"
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textSecondaryColor
                onClicked: {
                    sidePanel.currentPage = "archive"
                    sidePanel.pageSelected("archive")
                }
            }

            NavButton {
                id: trashButton
                icon: "🗑️"
                text: qsTr("Trash")
                expanded: sidePanel.expanded
                selected: currentPage === "trash"
                animationDuration: sidePanel.animationDuration
                buttonSize: width
                Layout.fillWidth: true
                Layout.preferredHeight: 42
                selectedColor: theme.cardSelectedColor
                textSelectedColor: theme.textColor
                textNormalColor: theme.textSecondaryColor
                onClicked: {
                    sidePanel.currentPage = "trash"
                    sidePanel.pageSelected("trash")
                }
            }

            Item {
                height: 8
                Layout.fillWidth: true
            }

            Rectangle {
                id: exitButtonWrapper
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                radius: 8
                color: "transparent"
                border.width: 2
                border.color: theme.buttonDangerColor

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 6
                    color: exitMouseArea.containsMouse ? Qt.lighter(theme.buttonDangerColor, 1.1) : theme.buttonDangerColor

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: sidePanel.expanded ? 12 : 0
                        anchors.rightMargin: sidePanel.expanded ? 12 : 0
                        spacing: sidePanel.expanded ? 10 : 0

                        Text {
                            text: "✕"
                            font {
                                pixelSize: 18
                                bold: true
                            }
                            color: "#ffffff"
                            Layout.fillWidth: !sidePanel.expanded
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Text {
                            id: exitButtonText
                            text: qsTr("Exit")
                            font {
                                pixelSize: 14
                                weight: Font.DemiBold
                                family: "Segoe UI"
                            }
                            color: "#ffffff"
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true
                            visible: sidePanel.expanded
                            opacity: sidePanel.expanded ? 1.0 : 0.0
                            elide: Text.ElideRight

                            Behavior on opacity {
                                NumberAnimation { duration: animationDuration }
                            }
                        }
                    }

                    MouseArea {
                        id: exitMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            sidePanel.exitClicked()
                        }
                    }
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 3
                    radius: 6.0
                    samples: 13
                    color: "#60000000"
                }
            }
        }
    }

    // Кнопка развертывания внутри панели для свернутого состояния
    Rectangle {
        id: collapseExpandButton
        visible: !sidePanel.expanded && sidePanel.isVisible
        width: 32
        height: 32
        radius: 8
        color: collapseButtonArea.containsMouse ? theme.cardSelectedColor : theme.cardColor
        border.width: 1
        border.color: theme.borderColor
        opacity: collapseButtonArea.containsMouse ? 1.0 : 0.85
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 16
        }
        z: 100

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        Text {
            anchors.centerIn: parent
            text: "▶"
            color: theme.textColor
            font.pixelSize: 16
            font.bold: true
        }

        MouseArea {
            id: collapseButtonArea
            anchors.fill: parent
            anchors.margins: -8
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                sidePanel.expanded = true
            }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 2
            radius: 4.0
            samples: 9
            color: "#40000000"
        }
    }

    Rectangle {
        id: showPanelButton
        visible: !sidePanel.isVisible
        width: 36
        height: 70
        radius: 8
        color: showPanelButtonArea.containsMouse ? theme.cardSelectedColor : theme.backgroundSecondaryColor
        border.width: 1
        border.color: theme.borderColor
        opacity: showPanelButtonArea.containsMouse ? 1.0 : 0.85
        anchors {
            left: parent.right
            top: parent.top
            topMargin: 50
        }
        z: 100

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        Text {
            anchors.centerIn: parent
            text: "▶"
            color: theme.textColor
            font.pixelSize: 16
            font.bold: true
        }

        MouseArea {
            id: showPanelButtonArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                sidePanel.isVisible = true
                sidePanel.expanded = true
            }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 2
            verticalOffset: 2
            radius: 4.0
            samples: 9
            color: "#50000000"
        }
    }

    Connections {
        target: sidePanel.parent
        function onWidthChanged() {
            if (!sidePanel.parent) return;
            var parentWidth = sidePanel.parent.width;

            if (parentWidth < 400) {
                sidePanel.isVisible = false
                sidePanel.expanded = false
            } else if (parentWidth < 600) {
                sidePanel.expanded = false
            }

            if (sidePanel.maximizedWidth > parentWidth * sidePanel.maxWidthPercentage) {
                sidePanel.maximizedWidth = parentWidth * sidePanel.maxWidthPercentage
            }

            var minAllowedWidth = 200
            if (sidePanel.maximizedWidth < minAllowedWidth) {
                sidePanel.maximizedWidth = minAllowedWidth
            }
        }
    }

    Connections {
        target: typeof translationManager !== "undefined" ? translationManager : null
        enabled: typeof translationManager !== "undefined"
        function onLanguageChanged() {
            updateUiTranslations()
        }
    }

    Connections {
        target: typeof SettingsManager !== "undefined" ? SettingsManager : null
        enabled: typeof SettingsManager !== "undefined"
        function onAppTranslated() {
            updateUiTranslations()
        }
    }

    Component.onCompleted: {
        if (sidePanel.parent) {
            var parentWidth = sidePanel.parent.width;
            if (parentWidth < 400) {
                sidePanel.isVisible = false
                sidePanel.expanded = false
            } else if (parentWidth < 600) {
                sidePanel.expanded = false
            }
        } else {
             if (width < minimizedWidth * 1.5 && width !== 0 && isVisible) {
                expanded = false
            }
        }
        updateUiTranslations()
    }
}
