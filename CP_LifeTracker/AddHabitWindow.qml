import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

Window {
    id: addHabitWindow
    title: ""
    width: 1100
    height: 750
    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint
    modality: Qt.ApplicationModal

    property int animationDuration: 300
    property bool editMode: false
    property int editIndex: -1
    property string initialName: ""
    property string initialDescription: ""
    property string initialIcon: icons[0]
    property string initialColor: colorOptions[0]
    property int initialDifficulty: 1
    property int initialFrequency: 1
    property var initialFrequencyDays: [true, true, true, true, true, true, true]
    property int initialImportance: 1

    property string selectedIcon: initialIcon
    property string selectedColor: initialColor

    property var icons: [
        "🏃", "💧", "🎯", "📚", "🧘", "💊", "🚶", "🧠",
        "💪", "🏋️", "🚴", "🧹", "✏️", "💼", "🎨", "🎵",
        "💻", "📱", "🌱", "🌞", "🌙", "⏰", "💤", "🧺",
        "🚿", "🦷", "💰", "🧘‍♂️", "🍽️", "🥦", "🥗", "🥛"
    ]

    property var colorOptions: [
        "#3B82F6", "#EF4444", "#10B981", "#F59E0B",
        "#8B5CF6", "#EC4899", "#6366F1", "#14B8A6",
        "#F97316", "#A855F7", "#06B6D4", "#D946EF"
    ]

    property var colorNames: [
        "Blue", "Red", "Green", "Orange",
        "Purple", "Pink", "Indigo", "Teal",
        "Amber", "Violet", "Cyan", "Magenta"
    ]

    property var frequencyOptions: ["Daily", "Weekly", "Monthly", "Custom"]
    property var difficultyLabels: ["Easy", "Medium", "Hard", "Very Hard"]
    property var importanceLabels: ["Low", "Medium", "High"]
    property var weekdayNames: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    property var weekdayLetters: ["M", "T", "W", "T", "F", "S", "S"]

    signal habitAdded(string name, string description, string icon, string color, int difficulty, int frequency, var frequencyDays, int importance)
    signal habitEdited(int index, string name, string description, string icon, string color, int difficulty, int frequency, var frequencyDays, int importance)

    Theme {
        id: currentTheme
    }

    property color accentColor: currentTheme.accentColor
    property color bgColor: currentTheme.backgroundColor
    property color bgColorDarker: currentTheme.backgroundSecondaryColor
    property color textColor: currentTheme.textColor
    property color textColorDim: currentTheme.textSecondaryColor
    property color borderColor: currentTheme.borderColor
    property color inputBg: currentTheme.inputBackgroundColor
    property color inputBorder: currentTheme.inputBorderColor
    property color inputBorderFocus: currentTheme.inputBorderFocusColor
    property bool isDarkTheme: currentTheme.isDarkTheme
    property color accentColorLight: currentTheme.accentColorLight
    property color accentColorDark: currentTheme.accentColorDark

    function show() {
        resetFields()
        x = (Screen.width - width) / 2
        y = (Screen.height - height) / 2
        visible = true
        showAnimation.start()
    }

    function showEdit(index, name, description, icon, color, difficulty, frequency, frequencyDays, importance) {
        editMode = true
        editIndex = index
        initialName = name
        initialDescription = description
        initialIcon = icon
        initialColor = color
        initialDifficulty = difficulty
        initialFrequency = frequency
        initialFrequencyDays = frequencyDays
        initialImportance = importance

        nameInput.text = name
        descriptionInput.text = description
        selectedIcon = icon
        selectedColor = color
        difficultySlider.value = difficulty
        frequencyComboBox.currentIndex = frequency - 1

        for(let i = 0; i < 7; i++) {
            weekdayRepeater.itemAt(i).checked = frequencyDays[i]
        }
        importanceSlider.value = importance

        show()
    }

    function hide() {
        hideAnimation.start()
    }

    function resetFields() {
        editMode = false
        editIndex = -1
        nameInput.text = ""
        descriptionInput.text = ""
        selectedIcon = icons[0]
        selectedColor = colorOptions[0]
        difficultySlider.value = 1
        frequencyComboBox.currentIndex = 0
        for(let i = 0; i < 7; i++) {
            weekdayRepeater.itemAt(i).checked = true
        }
        importanceSlider.value = 1
    }

    function addOrEditHabit() {
        if (nameInput.text.trim() === "") {
            errorMessage.text = qsTr("Habit name cannot be empty")
            errorMessage.visible = true
            errorShake.start()
            return
        }

        let frequencyDays = []
        for(let i = 0; i < 7; i++) {
            frequencyDays.push(weekdayRepeater.itemAt(i).checked)
        }

        if (editMode) {
            habitEdited(editIndex, nameInput.text, descriptionInput.text, selectedIcon,
                       selectedColor, Math.floor(difficultySlider.value),
                       frequencyComboBox.currentIndex + 1, frequencyDays,
                       Math.floor(importanceSlider.value))
        } else {
            habitAdded(nameInput.text, descriptionInput.text, selectedIcon,
                      selectedColor, Math.floor(difficultySlider.value),
                      frequencyComboBox.currentIndex + 1, frequencyDays,
                      Math.floor(importanceSlider.value))
        }
        hide()
    }

    SequentialAnimation {
        id: errorShake
        NumberAnimation { target: nameInput; property: "anchors.leftMargin"; to: 45; duration: 50 }
        NumberAnimation { target: nameInput; property: "anchors.leftMargin"; to: 35; duration: 50 }
        NumberAnimation { target: nameInput; property: "anchors.leftMargin"; to: 45; duration: 50 }
        NumberAnimation { target: nameInput; property: "anchors.leftMargin"; to: 40; duration: 50 }
    }

    PropertyAnimation {
        id: showAnimation
        target: addHabitRoot
        property: "scale"
        from: 0.9
        to: 1.0
        duration: animationDuration
        easing.type: Easing.OutBack
    }

    PropertyAnimation {
        id: hideAnimation
        target: addHabitRoot
        property: "scale"
        from: 1.0
        to: 0.9
        duration: animationDuration
        easing.type: Easing.InBack
        onStopped: visible = false
    }

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: isDarkTheme ? "#AA000000" : "#66000000"
        opacity: addHabitRoot.scale
    }

    Rectangle {
        id: addHabitRoot
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        color: addHabitWindow.bgColor
        radius: 28
        scale: 0

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 20
            radius: 48.0
            samples: 96
            color: "#90000000"
            transparentBorder: true
        }

        Rectangle {
            id: windowHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 90
            color: "transparent"
            radius: 28

            Rectangle {
                anchors.fill: parent
                color: addHabitWindow.bgColorDarker
                radius: 28
                Rectangle {
                    width: parent.width
                    height: parent.height - parent.radius
                    color: parent.color
                    anchors.bottom: parent.bottom
                }
            }

            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 45
                anchors.verticalCenter: parent.verticalCenter
                spacing: 20

                Rectangle {
                    width: 50
                    height: 50
                    radius: 16
                    color: addHabitWindow.accentColor

                    Text {
                        anchors.centerIn: parent
                        text: editMode ? "✏️" : "➕"
                        font.pixelSize: 24
                    }

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 4
                        radius: 12.0
                        samples: 24
                        color: addHabitWindow.accentColor + "60"
                        transparentBorder: true
                    }
                }

                Column {
                    spacing: 4
                    Text {
                        text: editMode ? qsTr("Edit Habit") : qsTr("Add New Habit")
                        font.pixelSize: 26
                        font.weight: Font.Bold
                        color: addHabitWindow.textColor
                    }
                    Text {
                        text: editMode ? qsTr("Modify your habit details") : qsTr("Create a new healthy habit")
                        font.pixelSize: 14
                        color: addHabitWindow.textColorDim
                    }
                }
            }

            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 35
                anchors.verticalCenter: parent.verticalCenter
                width: 48
                height: 48
                radius: 24
                color: closeArea.containsMouse ? (isDarkTheme ? "#30FFFFFF" : "#20000000") : "transparent"

                Behavior on color { ColorAnimation { duration: 200 } }

                Text {
                    text: "✕"
                    anchors.centerIn: parent
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    color: addHabitWindow.textColor
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    onClicked: addHabitWindow.hide()
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        Rectangle {
            id: actionButtons
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 100
            color: addHabitWindow.bgColorDarker
            radius: 28

            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: parent.radius
                color: parent.color
            }

            RowLayout {
                anchors.centerIn: parent
                spacing: 20

                CustomRectButton {
                    text: qsTr("Cancel")
                    implicitWidth: 200
                    implicitHeight: 60
                    buttonColor: addHabitWindow.inputBg
                    textColor: addHabitWindow.textColor
                    font.pixelSize: 16
                    font.weight: Font.Medium
                    onClicked: addHabitWindow.hide()
                }

                CustomRectButton {
                    text: editMode ? qsTr("💾 Save Changes") : qsTr("✨ Add Habit")
                    implicitWidth: 200
                    implicitHeight: 60
                    buttonColor: addHabitWindow.accentColor
                    textColor: "white"
                    font.pixelSize: 16
                    font.weight: Font.Bold
                    onClicked: addHabitWindow.addOrEditHabit()
                }
            }
        }

        ScrollView {
            id: contentScrollView
            anchors.top: windowHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: actionButtons.top
            anchors.margins: 25
            clip: true

            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ColumnLayout {
                width: contentScrollView.width - 10
                spacing: 35

                Item { Layout.preferredHeight: 10 }

                // BASIC INFORMATION SECTION
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 25

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 3
                        radius: 1.5
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: addHabitWindow.accentColor }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }

                    Text {
                        text: "🎯 " + qsTr("Basic Information")
                        font.pixelSize: 24
                        font.weight: Font.Bold
                        color: addHabitWindow.textColor
                        Layout.leftMargin: 5
                    }

                    // Icon & Color Selection
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 18

                        Text {
                            text: qsTr("Choose Icon & Color")
                            font.pixelSize: 16
                            font.weight: Font.Medium
                            color: addHabitWindow.textColorDim
                            Layout.leftMargin: 5
                        }

                        // Icons Grid
                        Flow {
                            Layout.fillWidth: true
                            spacing: 14

                            Repeater {
                                model: icons

                                Rectangle {
                                    width: 62
                                    height: 62
                                    radius: 20
                                    color: selectedIcon === modelData ? addHabitWindow.accentColor : addHabitWindow.inputBg
                                    border.color: selectedIcon === modelData ? addHabitWindow.accentColor : addHabitWindow.inputBorder
                                    border.width: selectedIcon === modelData ? 3 : 2
                                    scale: iconArea.containsMouse ? 1.05 : 1.0

                                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                                    Behavior on color { ColorAnimation { duration: 200 } }
                                    Behavior on border.color { ColorAnimation { duration: 200 } }

                                    layer.enabled: selectedIcon === modelData
                                    layer.effect: DropShadow {
                                        horizontalOffset: 0
                                        verticalOffset: 6
                                        radius: 12.0
                                        samples: 24
                                        color: addHabitWindow.accentColor + "50"
                                        transparentBorder: true
                                    }

                                    Text {
                                        text: modelData
                                        anchors.centerIn: parent
                                        font.pixelSize: 28
                                    }

                                    MouseArea {
                                        id: iconArea
                                        anchors.fill: parent
                                        onClicked: selectedIcon = modelData
                                        cursorShape: Qt.PointingHandCursor
                                        hoverEnabled: true
                                    }
                                }
                            }
                        }

                        // Colors Grid
                        Flow {
                            Layout.fillWidth: true
                            spacing: 14
                            Layout.topMargin: 10

                            Repeater {
                                model: colorOptions

                                Rectangle {
                                    width: 62
                                    height: 62
                                    radius: 20
                                    color: modelData
                                    border.color: selectedColor === modelData ? "white" : "transparent"
                                    border.width: 5
                                    scale: colorArea.containsMouse ? 1.08 : 1.0

                                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                                    Behavior on border.width { NumberAnimation { duration: 200 } }

                                    layer.enabled: true
                                    layer.effect: DropShadow {
                                        horizontalOffset: 0
                                        verticalOffset: 6
                                        radius: 12.0
                                        samples: 24
                                        color: modelData + "60"
                                        transparentBorder: true
                                    }

                                    Rectangle {
                                        visible: selectedColor === modelData
                                        width: 28
                                        height: 28
                                        radius: 14
                                        color: "white"
                                        anchors.centerIn: parent

                                        Text {
                                            text: "✓"
                                            anchors.centerIn: parent
                                            font.pixelSize: 18
                                            font.weight: Font.Bold
                                            color: modelData
                                        }
                                    }

                                    MouseArea {
                                        id: colorArea
                                        anchors.fill: parent
                                        onClicked: selectedColor = modelData
                                        cursorShape: Qt.PointingHandCursor
                                        hoverEnabled: true
                                    }
                                }
                            }
                        }
                    }

                    // Name Input
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text {
                            text: "📝 " + qsTr("Habit Name") + " *"
                            font.pixelSize: 16
                            font.weight: Font.Medium
                            color: addHabitWindow.textColor
                            Layout.leftMargin: 5
                        }

                        TextField {
                            id: nameInput
                            Layout.fillWidth: true
                            Layout.preferredHeight: 65
                            placeholderText: qsTr("e.g., Morning Exercise, Read Books...")
                            color: addHabitWindow.textColor
                            placeholderTextColor: addHabitWindow.textColorDim
                            font.pixelSize: 16
                            selectByMouse: true
                            leftPadding: 22
                            rightPadding: 22

                            background: Rectangle {
                                color: addHabitWindow.inputBg
                                border.width: 2
                                border.color: parent.activeFocus ? addHabitWindow.accentColor : addHabitWindow.inputBorder
                                radius: 18

                                Behavior on border.color { ColorAnimation { duration: 200 } }

                                layer.enabled: parent.activeFocus
                                layer.effect: DropShadow {
                                    horizontalOffset: 0
                                    verticalOffset: 0
                                    radius: 16.0
                                    samples: 32
                                    color: addHabitWindow.accentColor + "40"
                                    transparentBorder: true
                                }
                            }

                            onTextChanged: {
                                if (text.trim() !== "") {
                                    errorMessage.visible = false
                                }
                            }
                        }

                        Text {
                            id: errorMessage
                            text: "⚠️ " + qsTr("Habit name cannot be empty")
                            color: currentTheme.buttonDangerColor
                            font.pixelSize: 13
                            font.italic: true
                            visible: false
                            Layout.leftMargin: 10
                        }
                    }

                    // Description Input
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text {
                            text: "💭 " + qsTr("Description")
                            font.pixelSize: 16
                            font.weight: Font.Medium
                            color: addHabitWindow.textColor
                            Layout.leftMargin: 5
                        }

                        TextArea {
                            id: descriptionInput
                            Layout.fillWidth: true
                            Layout.preferredHeight: 110
                            placeholderText: qsTr("Describe your habit goals and motivation...")
                            color: addHabitWindow.textColor
                            placeholderTextColor: addHabitWindow.textColorDim
                            wrapMode: TextEdit.Wrap
                            font.pixelSize: 15
                            selectByMouse: true
                            leftPadding: 22
                            rightPadding: 22
                            topPadding: 18
                            bottomPadding: 18

                            background: Rectangle {
                                color: addHabitWindow.inputBg
                                border.width: 2
                                border.color: parent.activeFocus ? addHabitWindow.accentColor : addHabitWindow.inputBorder
                                radius: 18

                                Behavior on border.color { ColorAnimation { duration: 200 } }

                                layer.enabled: parent.activeFocus
                                layer.effect: DropShadow {
                                    horizontalOffset: 0
                                    verticalOffset: 0
                                    radius: 16.0
                                    samples: 32
                                    color: addHabitWindow.accentColor + "40"
                                    transparentBorder: true
                                }
                            }
                        }
                    }
                }

                // ADVANCED SETTINGS SECTION
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 25
                    Layout.topMargin: 15

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 3
                        radius: 1.5
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: addHabitWindow.accentColor }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }

                    Text {
                        text: "⚙️ " + qsTr("Advanced Settings")
                        font.pixelSize: 24
                        font.weight: Font.Bold
                        color: addHabitWindow.textColor
                        Layout.leftMargin: 5
                    }

                    // Difficulty Slider
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 18

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 15

                            Text {
                                text: "💪 " + qsTr("Difficulty")
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                color: addHabitWindow.textColor
                            }

                            Rectangle {
                                Layout.preferredWidth: 110
                                Layout.preferredHeight: 32
                                radius: 16
                                color: addHabitWindow.accentColor

                                Text {
                                    anchors.centerIn: parent
                                    text: difficultyLabels[Math.floor(difficultySlider.value) - 1]
                                    font.pixelSize: 13
                                    font.weight: Font.Bold
                                    color: "white"
                                }
                            }
                        }

                        Slider {
                            id: difficultySlider
                            Layout.fillWidth: true
                            from: 1
                            to: 4
                            stepSize: 1
                            value: 1
                            snapMode: Slider.SnapAlways

                            background: Rectangle {
                                x: difficultySlider.leftPadding
                                y: difficultySlider.topPadding + difficultySlider.availableHeight / 2 - height / 2
                                width: difficultySlider.availableWidth
                                height: 10
                                radius: 5
                                color: addHabitWindow.inputBorder

                                Rectangle {
                                    width: difficultySlider.visualPosition * parent.width
                                    height: parent.height
                                    radius: 5
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop { position: 0.0; color: "#10B981" }
                                        GradientStop { position: 0.5; color: "#F59E0B" }
                                        GradientStop { position: 1.0; color: "#EF4444" }
                                    }
                                }

                                // Difficulty markers
                                Row {
                                    anchors.fill: parent
                                    Repeater {
                                        model: 3
                                        Rectangle {
                                            width: parent.width / 3
                                            height: parent.height
                                            color: "transparent"
                                            Rectangle {
                                                width: 3
                                                height: parent.height + 4
                                                color: addHabitWindow.bgColor
                                                anchors.right: parent.right
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }
                                    }
                                }
                            }

                            handle: Rectangle {
                                x: difficultySlider.leftPadding + difficultySlider.visualPosition * (difficultySlider.availableWidth - width)
                                y: difficultySlider.topPadding + difficultySlider.availableHeight / 2 - height / 2
                                width: 34
                                height: 34
                                radius: 17
                                color: difficultySlider.pressed ? Qt.lighter("white", 1.1) : "white"
                                border.color: addHabitWindow.accentColor
                                border.width: 4

                                Behavior on width { NumberAnimation { duration: 100 } }
                                Behavior on height { NumberAnimation { duration: 100 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: Math.floor(difficultySlider.value)
                                    font.pixelSize: 14
                                    font.weight: Font.Bold
                                    color: addHabitWindow.accentColor
                                }

                                layer.enabled: true
                                layer.effect: DropShadow {
                                    horizontalOffset: 0
                                    verticalOffset: 4
                                    radius: 10.0
                                    samples: 20
                                    color: "#80000000"
                                    transparentBorder: true
                                }
                            }
                        }

                        // Difficulty labels
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: -8
                            spacing: 0

                            Repeater {
                                model: difficultyLabels
                                Text {
                                    Layout.fillWidth: true
                                    text: modelData
                                    font.pixelSize: 11
                                    color: addHabitWindow.textColorDim
                                    horizontalAlignment: index === 0 ? Text.AlignLeft :
                                                       index === difficultyLabels.length - 1 ? Text.AlignRight :
                                                       Text.AlignHCenter
                                }
                            }
                        }
                    }

                    // Frequency
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 15

                        Text {
                            text: "📅 " + qsTr("Frequency")
                            font.pixelSize: 16
                            font.weight: Font.Medium
                            color: addHabitWindow.textColor
                            Layout.leftMargin: 5
                        }

                        CustomComboBox {
                            id: frequencyComboBox
                            model: frequencyOptions
                            Layout.fillWidth: true
                            Layout.preferredHeight: 55
                        }

                        // Weekday Selection
                        ColumnLayout {
                            Layout.fillWidth: true
                            visible: frequencyComboBox.currentIndex === 1 || frequencyComboBox.currentIndex === 3
                            spacing: 12

                            Text {
                                text: qsTr("Select Days")
                                font.pixelSize: 14
                                color: addHabitWindow.textColorDim
                                Layout.leftMargin: 5
                            }

                            Row {
                                Layout.fillWidth: true
                                spacing: 12

                                Repeater {
                                    id: weekdayRepeater
                                    model: 7

                                    Rectangle {
                                        width: (parent.parent.width - parent.spacing * 6) / 7
                                        height: width
                                        radius: width / 2
                                        color: checked ? addHabitWindow.accentColor : "transparent"
                                        border.color: checked ? addHabitWindow.accentColor : addHabitWindow.inputBorder
                                        border.width: 3
                                        scale: dayArea.containsMouse ? 1.08 : 1.0

                                        property bool checked: true

                                        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
                                        Behavior on color { ColorAnimation { duration: 200 } }
                                        Behavior on border.color { ColorAnimation { duration: 200 } }

                                        layer.enabled: checked
                                        layer.effect: DropShadow {
                                            horizontalOffset: 0
                                            verticalOffset: 4
                                            radius: 8.0
                                            samples: 16
                                            color: addHabitWindow.accentColor + "50"
                                            transparentBorder: true
                                        }

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 2

                                            Text {
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                text: weekdayLetters[index]
                                                color: checked ? "white" : addHabitWindow.textColor
                                                font.pixelSize: 20
                                                font.weight: Font.Bold
                                            }
                                        }

                                        MouseArea {
                                            id: dayArea
                                            anchors.fill: parent
                                            onClicked: parent.checked = !parent.checked
                                            cursorShape: Qt.PointingHandCursor
                                            hoverEnabled: true
                                        }

                                        // Tooltip
                                        Rectangle {
                                            visible: dayArea.containsMouse
                                            anchors.bottom: parent.top
                                            anchors.bottomMargin: 8
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: dayText.width + 16
                                            height: 28
                                            radius: 8
                                            color: addHabitWindow.textColor
                                            opacity: 0.9

                                            Text {
                                                id: dayText
                                                anchors.centerIn: parent
                                                text: weekdayNames[index]
                                                color: addHabitWindow.bgColor
                                                font.pixelSize: 11
                                                font.weight: Font.Medium
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Importance Slider
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 18

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 15

                            Text {
                                text: "⭐ " + qsTr("Importance")
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                color: addHabitWindow.textColor
                            }

                            Rectangle {
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: 32
                                radius: 16
                                color: {
                                    var val = Math.floor(importanceSlider.value)
                                    return val === 1 ? "#10B981" : val === 2 ? "#F59E0B" : "#EF4444"
                                }

                                Behavior on color { ColorAnimation { duration: 200 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: importanceLabels[Math.floor(importanceSlider.value) - 1]
                                    font.pixelSize: 13
                                    font.weight: Font.Bold
                                    color: "white"
                                }
                            }
                        }

                        Slider {
                            id: importanceSlider
                            Layout.fillWidth: true
                            from: 1
                            to: 3
                            stepSize: 1
                            value: 1
                            snapMode: Slider.SnapAlways

                            background: Rectangle {
                                x: importanceSlider.leftPadding
                                y: importanceSlider.topPadding + importanceSlider.availableHeight / 2 - height / 2
                                width: importanceSlider.availableWidth
                                height: 10
                                radius: 5
                                color: addHabitWindow.inputBorder

                                Rectangle {
                                    width: importanceSlider.visualPosition * parent.width
                                    height: parent.height
                                    radius: 5
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop { position: 0.0; color: "#10B981" }
                                        GradientStop { position: 0.5; color: "#F59E0B" }
                                        GradientStop { position: 1.0; color: "#EF4444" }
                                    }
                                }

                                // Importance markers
                                Row {
                                    anchors.fill: parent
                                    Repeater {
                                        model: 2
                                        Rectangle {
                                            width: parent.width / 2
                                            height: parent.height
                                            color: "transparent"
                                            Rectangle {
                                                width: 3
                                                height: parent.height + 4
                                                color: addHabitWindow.bgColor
                                                anchors.right: parent.right
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }
                                    }
                                }
                            }

                            handle: Rectangle {
                                x: importanceSlider.leftPadding + importanceSlider.visualPosition * (importanceSlider.availableWidth - width)
                                y: importanceSlider.topPadding + importanceSlider.availableHeight / 2 - height / 2
                                width: 34
                                height: 34
                                radius: 17
                                color: importanceSlider.pressed ? Qt.lighter("white", 1.1) : "white"
                                border.color: {
                                    var val = Math.floor(importanceSlider.value)
                                    return val === 1 ? "#10B981" : val === 2 ? "#F59E0B" : "#EF4444"
                                }
                                border.width: 4

                                Behavior on width { NumberAnimation { duration: 100 } }
                                Behavior on height { NumberAnimation { duration: 100 } }
                                Behavior on border.color { ColorAnimation { duration: 200 } }

                                Text {
                                    anchors.centerIn: parent
                                    text: ["⭐", "⭐⭐", "⭐⭐⭐"][Math.floor(importanceSlider.value) - 1]
                                    font.pixelSize: 12
                                }

                                layer.enabled: true
                                layer.effect: DropShadow {
                                    horizontalOffset: 0
                                    verticalOffset: 4
                                    radius: 10.0
                                    samples: 20
                                    color: "#80000000"
                                    transparentBorder: true
                                }
                            }
                        }

                        // Importance labels
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: -8
                            spacing: 0

                            Repeater {
                                model: importanceLabels
                                Text {
                                    Layout.fillWidth: true
                                    text: modelData
                                    font.pixelSize: 11
                                    color: addHabitWindow.textColorDim
                                    horizontalAlignment: index === 0 ? Text.AlignLeft :
                                                       index === importanceLabels.length - 1 ? Text.AlignRight :
                                                       Text.AlignHCenter
                                }
                            }
                        }
                    }

                    // Quick Tips
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: tipText.height + 40
                        radius: 18
                        color: Qt.alpha(addHabitWindow.accentColor, 0.1)
                        border.color: Qt.alpha(addHabitWindow.accentColor, 0.3)
                        border.width: 2

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 15

                            Text {
                                text: "💡"
                                font.pixelSize: 28
                            }

                            Text {
                                id: tipText
                                Layout.fillWidth: true
                                text: qsTr("Tip: Start with easy habits and build consistency. You can always adjust the difficulty later!")
                                font.pixelSize: 13
                                color: addHabitWindow.textColor
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }

                Item { Layout.preferredHeight: 20 }
            }
        }
    }
}
