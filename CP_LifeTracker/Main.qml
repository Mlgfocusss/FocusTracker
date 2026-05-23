import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

ApplicationWindow {
    id: root
    visible: true
    width: 1920
    height: 1080
    title: "FocusTracker"
    visibility: Window.Maximized

    Theme {
        id: currentTheme
    }

    Settings {
        id: settingsWindow
        rootWindow: root

        onCloseSettings: {
            SettingsManager.applyWindowSize(root)
        }
    }

    AuthWindow {
        id: authWindow
        visible: !AuthManager.isAuthenticated

        onLoginAttempt: function(username, password, rememberMe) {
            AuthManager.login(username, password, rememberMe)
        }

        onRegisterAttempt: function(username, email, password) {
            AuthManager.registerUser(username, email, password)
        }
    }

    Component.onCompleted: {
        SettingsManager.applyWindowSize(root)
        updateUiTranslations()
    }

    Connections {
        target: SettingsManager
        function onWindowSizeChanged(width, height) {
            if (!SettingsManager.startMaximized) {
                root.width = width
                root.height = height
                root.visibility = Window.Windowed
            } else {
                root.visibility = Window.Maximized
            }
        }

        function onAppTranslated() {
            updateUiTranslations()
        }

        function onThemeIndexChanged() {
            console.log("Main.qml: Обновление темы, новый индекс: " + SettingsManager.themeIndex)
        }
    }

    Connections {
        target: AuthManager
        function onAuthStatusChanged() {
            authWindow.visible = !AuthManager.isAuthenticated
        }

        function onAuthError(message) {
            authWindow.showError(message)
        }

        function onAuthSuccess(username) {
            authWindow.visible = false
        }
    }

    function updateUiTranslations() {
        title = qsTr("FocusTracker")
        habitsList.model = null
        habitsList.model = HabitsModel
    }

    AddHabitWindow {
        id: addHabitWindow

        onHabitAdded: function(name, description) {
            HabitsModel.addHabit(name, description)
        }
    }

    SidePanel {
        id: sidePanel
        anchors {
            top: parent.top
            left: parent.left
            bottom: parent.bottom
        }
        z: 10
        visible: AuthManager.isAuthenticated

        onAddHabitClicked: {
            addHabitWindow.show()
        }

        onStatsClicked: {
            habitsListView.visible = false
            habitView.visible = false
            statsView.visible = true
            notesView.visible = false
            tasksView.visible = false
            calendarView.visible = false
        }

        onExitClicked: {
            Qt.quit()
        }

        onSettingsClicked: {
            settingsWindow.show()
        }

        onPageSelected: function(pageName) {
            if (pageName === "habits") {
                habitsListView.visible = false
                habitView.visible = true
                statsView.visible = false
                notesView.visible = false
                tasksView.visible = false
                calendarView.visible = false
            } else if (pageName === "dashboard") {
                habitsListView.visible = true
                habitView.visible = false
                statsView.visible = false
                notesView.visible = false
                tasksView.visible = false
                calendarView.visible = false
            } else if (pageName === "notes") {
                habitsListView.visible = false
                habitView.visible = false
                statsView.visible = false
                notesView.visible = true
                tasksView.visible = false
                calendarView.visible = false
            } else if (pageName === "tasks") {
                habitsListView.visible = false
                habitView.visible = false
                statsView.visible = false
                notesView.visible = false
                tasksView.visible = true
                calendarView.visible = false
            } else if (pageName === "stats") {
                habitsListView.visible = false
                habitView.visible = false
                statsView.visible = true
                notesView.visible = false
                tasksView.visible = false
                calendarView.visible = false
            } else if (pageName === "calendar") {
                habitsListView.visible = false
                habitView.visible = false
                statsView.visible = false
                notesView.visible = false
                tasksView.visible = false
                calendarView.visible = true
            } else {
                habitsListView.visible = true
                habitView.visible = false
                statsView.visible = false
                notesView.visible = false
                tasksView.visible = false
                calendarView.visible = false
            }
        }

        onHabitViewRequested: function(habitData) {
            habitView.habit = habitData
            habitsListView.visible = false
            habitView.visible = true
            statsView.visible = false
            notesView.visible = false
            tasksView.visible = false
            calendarView.visible = false
        }
    }

    Rectangle {
        id: habitsListView
        anchors {
            top: parent.top
            left: sidePanel.right
            right: parent.right
            bottom: parent.bottom
        }
        color: currentTheme.backgroundColor
        visible: AuthManager.isAuthenticated

        Rectangle {
            id: headerBar
            height: 80
            color: currentTheme.cardColor
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
                color: currentTheme.shadowColor
            }

            Text {
                text: qsTr("Dashboard")
                font.pixelSize: 32
                font.bold: true
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: 24
                }
                color: currentTheme.textColor
            }

            Rectangle {
                id: addQuickHabitButton
                width: 48
                height: 48
                radius: 24
                color: currentTheme.buttonPrimaryColor
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 24
                }

                Text {
                    text: "+"
                    font.pixelSize: 28
                    font.bold: true
                    color: currentTheme.buttonTextLightColor
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        parent.scale = 1.05
                    }

                    onExited: {
                        parent.scale = 1.0
                    }

                    onClicked: {
                        addHabitDialog.open()
                    }
                }

                Behavior on scale {
                    NumberAnimation { duration: 100 }
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
                topMargin: 20
                leftMargin: 20
                rightMargin: 20
                bottomMargin: 20
            }
            clip: true
            model: HabitsModel
            spacing: 15

            delegate: Rectangle {
                id: habitCard
                width: habitsList.width
                height: 110
                radius: 12
                color: currentTheme.cardColor
                border.color: currentTheme.borderColor
                border.width: 1

                property string habitName: name
                property string habitDescription: description
                property int habitStreak: streak
                property bool isCompleted: completed

                property color accentColor: isCompleted ? currentTheme.buttonSuccessColor : currentTheme.accentColor

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 2
                    radius: 6.0
                    samples: 17
                    color: currentTheme.shadowColor
                }

                states: [
                    State {
                        name: "hovered"
                        PropertyChanges { target: habitCard; border.color: accentColor; border.width: 2 }
                        PropertyChanges { target: statusIndicator; width: 8 }
                    }
                ]

                transitions: [
                    Transition {
                        PropertyAnimation { properties: "border.color, border.width, width"; duration: 200; easing.type: Easing.OutQuad }
                    }
                ]

                MouseArea {
                    id: hoverArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: habitCard.state = "hovered"
                    onExited: habitCard.state = ""
                    onClicked: {
                        if (!checkBox.containsMouse && !deleteButton.mouseArea.containsMouse) {
                            habitView.habit = HabitsModel.getHabit(index)
                            habitsListView.visible = false
                            habitView.visible = true
                        }
                    }
                }

                Rectangle {
                    id: statusIndicator
                    width: 6
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                        margins: 2
                    }
                    radius: width / 2
                    color: accentColor
                    opacity: isCompleted ? 1.0 : 0.7

                    Behavior on width {
                        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                    }
                }

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 16
                        rightMargin: 16
                        topMargin: 12
                        bottomMargin: 12
                    }
                    spacing: 15

                    Rectangle {
                        id: checkBox
                        width: 30
                        height: 30
                        radius: 15
                        border.width: 2
                        border.color: accentColor
                        color: isCompleted ? accentColor : "transparent"

                        property bool containsMouse: checkBoxArea.containsMouse

                        function toggle() {
                            HabitsModel.setCompleted(index, !isCompleted)
                        }

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        Text {
                            visible: isCompleted
                            anchors.centerIn: parent
                            text: "✓"
                            font.pixelSize: 18
                            color: currentTheme.buttonTextLightColor

                            Behavior on opacity {
                                NumberAnimation { duration: 150 }
                            }
                        }

                        MouseArea {
                            id: checkBoxArea
                            anchors.fill: parent
                            anchors.margins: -5
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: checkBox.toggle()
                        }
                    }

                    Column {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: habitName
                            font {
                                pixelSize: 18
                                bold: true
                                family: "Segoe UI, Arial, sans-serif"
                            }
                            color: currentTheme.textColor
                            width: parent.width
                            elide: Text.ElideRight
                        }

                        Text {
                            text: habitDescription
                            font {
                                pixelSize: 14
                                family: "Segoe UI, Arial, sans-serif"
                            }
                            color: currentTheme.textSecondaryColor
                            width: parent.width
                            elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            visible: habitDescription !== ""
                            lineHeight: 1.2
                        }

                        Row {
                            spacing: 4
                            visible: habitStreak > 0

                            Text {
                                text: qsTr("Current streak:")
                                font.pixelSize: 12
                                color: currentTheme.textSecondaryColor
                            }

                            Text {
                                text: habitStreak + (habitStreak === 1 ? qsTr(" day") : qsTr(" days"))
                                font.pixelSize: 12
                                font.bold: true
                                color: currentTheme.buttonWarningColor
                            }
                        }
                    }

                    Column {
                        spacing: 4
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                        Rectangle {
                            width: 60
                            height: 60
                            radius: width / 2
                            color: currentTheme.cardSelectedColor
                            border.color: habitStreak > 0 ? currentTheme.buttonWarningColor : currentTheme.borderColor
                            border.width: habitStreak > 0 ? 2 : 1

                            Column {
                                anchors.centerIn: parent
                                spacing: 0

                                Text {
                                    text: "🔥"
                                    font.pixelSize: 20
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    visible: habitStreak > 0
                                }

                                Text {
                                    text: habitStreak
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: habitStreak > 0 ? currentTheme.buttonWarningColor : currentTheme.textSecondaryColor
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }

                    Item {
                        id: deleteButton
                        width: 36
                        height: 36
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        opacity: mouseArea.containsMouse ? 1.0 : 0.7
                        visible: hoverArea.containsMouse

                        property alias mouseArea: deleteArea

                        Behavior on opacity {
                            NumberAnimation { duration: 150 }
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: width / 2
                            color: deleteArea.containsMouse ? currentTheme.buttonDangerColor : currentTheme.cardSelectedColor
                            border.color: deleteArea.containsMouse ? Qt.darker(currentTheme.buttonDangerColor, 1.2) : currentTheme.borderColor
                            border.width: 1

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            font.pixelSize: 16
                            color: deleteArea.containsMouse ? currentTheme.buttonTextLightColor : currentTheme.textSecondaryColor

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                        }

                        MouseArea {
                            id: deleteArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                HabitsModel.removeHabit(index)
                            }
                        }
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                text: HabitsModel.totalHabits === 0 ? qsTr("No habits yet. Add your first habit!") : ""
                font {
                    pixelSize: 20
                    family: "Segoe UI, Arial, sans-serif"
                }
                color: currentTheme.textSecondaryColor
            }
        }
    }

    HabitView {
        id: habitView
        anchors {
            top: parent.top
            left: sidePanel.right
            right: parent.right
            bottom: parent.bottom
        }
        visible: false
    }

    StatsView {
        id: statsView
        anchors {
            top: parent.top
            left: sidePanel.right
            right: parent.right
            bottom: parent.bottom
        }
        visible: false
    }

    NotesView {
        id: notesView
        anchors {
            top: parent.top
            left: sidePanel.right
            right: parent.right
            bottom: parent.bottom
        }
        visible: false
        notesModel: notesModelInstance
    }

    TasksView {
        id: tasksView
        anchors {
            top: parent.top
            left: sidePanel.right
            right: parent.right
            bottom: parent.bottom
        }
        visible: false
    }

    CalendarView {
        id: calendarView
        anchors {
            top: parent.top
            left: sidePanel.right
            right: parent.right
            bottom: parent.bottom
        }
        visible: false
    }

    Dialog {
        id: addHabitDialog
        title: qsTr("Add new habit")
        width: 480
        height: 320
        anchors.centerIn: parent
        modal: true
        closePolicy: Dialog.CloseOnEscape | Dialog.CloseOnPressOutside

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
            color: currentTheme.accentColor
            radius: 12

            Rectangle {
                width: parent.width
                height: 12
                color: currentTheme.accentColor
                anchors.bottom: parent.bottom
            }

            Text {
                text: addHabitDialog.title
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

        contentItem: ColumnLayout {
            anchors {
                fill: parent
                margins: 24
            }
            spacing: 20

            Text {
                text: qsTr("Create a new habit to track")
                font {
                    pixelSize: 16
                    family: "Segoe UI, Arial, sans-serif"
                }
                color: currentTheme.textColor
            }

            TextField {
                id: habitNameField
                Layout.fillWidth: true
                placeholderText: qsTr("Habit name")
                font {
                    pixelSize: 16
                    family: "Segoe UI, Arial, sans-serif"
                }
                selectByMouse: true
                padding: 12
                color: currentTheme.inputTextColor
                placeholderTextColor: currentTheme.inputPlaceholderColor

                background: Rectangle {
                    radius: 8
                    color: currentTheme.inputBackgroundColor
                    border.color: parent.focus ? currentTheme.inputBorderFocusColor : currentTheme.inputBorderColor
                    border.width: parent.focus ? 2 : 1
                    implicitHeight: 48

                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }

            TextField {
                id: habitDescField
                Layout.fillWidth: true
                placeholderText: qsTr("Description (optional)")
                font {
                    pixelSize: 16
                    family: "Segoe UI, Arial, sans-serif"
                }
                selectByMouse: true
                padding: 12
                color: currentTheme.inputTextColor
                placeholderTextColor: currentTheme.inputPlaceholderColor

                background: Rectangle {
                    radius: 8
                    color: currentTheme.inputBackgroundColor
                    border.color: parent.focus ? currentTheme.inputBorderFocusColor : currentTheme.inputBorderColor
                    border.width: parent.focus ? 2 : 1
                    implicitHeight: 48

                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }

            Item { Layout.fillHeight: true }
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
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 24
                }
                spacing: 16

                Button {
                    text: qsTr("Cancel")
                    implicitWidth: 120
                    implicitHeight: 48

                    background: Rectangle {
                        radius: 8
                        color: parent.down ? Qt.darker(currentTheme.backgroundSecondaryColor, 1.1) : currentTheme.backgroundSecondaryColor
                        border.color: currentTheme.borderColor
                        border.width: 1
                    }

                    contentItem: Text {
                        text: parent.text
                        font {
                            pixelSize: 16
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: currentTheme.textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        habitNameField.text = ""
                        habitDescField.text = ""
                        addHabitDialog.close()
                    }
                }

                Button {
                    text: qsTr("Create")
                    implicitWidth: 120
                    implicitHeight: 48

                    background: Rectangle {
                        radius: 8
                        color: parent.down ? Qt.darker(currentTheme.accentColor, 1.2) : currentTheme.accentColor
                    }

                    contentItem: Text {
                        text: parent.text
                        font {
                            pixelSize: 16
                            bold: true
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: currentTheme.buttonTextLightColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        if (habitNameField.text.trim() !== "") {
                            HabitsModel.addHabit(habitNameField.text, habitDescField.text)
                            habitNameField.text = ""
                            habitDescField.text = ""
                            addHabitDialog.close()
                        }
                    }
                }
            }
        }
    }
}
