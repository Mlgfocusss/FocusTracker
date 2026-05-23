import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: tasksView
    color: theme.backgroundColor

    Theme {
        id: theme
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
            text: qsTr("Tasks")
            font.pixelSize: 32
            font.bold: true
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 24
            }
            color: theme.textColor
        }

        Rectangle {
            id: addQuickTaskButton
            width: 48
            height: 48
            radius: 24
            color: theme.buttonPrimaryColor
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 24
            }

            Text {
                text: "+"
                font.pixelSize: 28
                font.bold: true
                color: theme.buttonTextLightColor
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
                    taskNameField.text = ""
                    taskDescField.text = ""
                    dueDateCombo.currentIndex = 0
                    priorityCombo.currentIndex = 0
                    addTaskDialog.open()
                }
            }

            Behavior on scale {
                NumberAnimation { duration: 100 }
            }
        }
    }

    Row {
        id: filterControls
        anchors {
            top: headerBar.bottom
            left: parent.left
            right: parent.right
            margins: 24
        }
        height: 40
        spacing: 16

        CustomRectButton {
            id: addTaskButton
            width: 140
            height: 40
            text: "Add Task"
            buttonColor: theme.buttonPrimaryColor
            textColor: theme.buttonTextLightColor
            font.pixelSize: 14
            font.bold: true
            radius: 8

            onClicked: {
                taskNameField.text = ""
                taskDescField.text = ""
                dueDateCombo.currentIndex = 0
                priorityCombo.currentIndex = 0
                addTaskDialog.open()
            }
        }

        CustomComboBox {
            id: filterDropdown
            width: 160
            height: 40
            model: ["All Tasks", "Today", "Tomorrow", "This Week", "Completed"]
            borderColorNormal: theme.inputBorderColor
            borderColorFocused: theme.inputBorderFocusColor
            bgColorNormal: theme.inputBackgroundColor
            dropdownBgColor: theme.cardColor
            radius: 8

            onCurrentIndexChanged: {
                applyFiltersAndSort()
            }
        }

        Rectangle {
            height: 36
            width: 1
            color: theme.borderColor
            anchors.verticalCenter: parent.verticalCenter
        }

        CustomComboBox {
            id: sortDropdown
            width: 160
            height: 40
            model: ["Sort: Due Date", "Sort: Priority", "Sort: Name"]
            borderColorNormal: theme.inputBorderColor
            borderColorFocused: theme.inputBorderFocusColor
            bgColorNormal: theme.inputBackgroundColor
            dropdownBgColor: theme.cardColor
            radius: 8

            onCurrentIndexChanged: {
                applyFiltersAndSort()
            }
        }
    }

    ListModel {
        id: filteredTasksModel
    }

    function applyFiltersAndSort() {
        filteredTasksModel.clear()

        var allTasks = []

        for (var i = 0; i < TasksModel.count; i++) {
            // Create a properly defined task object with explicit role names
            var task = {}

            // Use the correct role values from the C++ model
            task.name = TasksModel.data(TasksModel.index(i, 0), 257)  // NameRole = Qt.UserRole + 1 (256 + 1)
            task.description = TasksModel.data(TasksModel.index(i, 0), 258)  // DescriptionRole
            task.dueDate = TasksModel.data(TasksModel.index(i, 0), 259)  // DueDateRole
            task.priority = TasksModel.data(TasksModel.index(i, 0), 260)  // PriorityRole
            task.completed = TasksModel.data(TasksModel.index(i, 0), 261)  // CompletedRole
            task.originalIndex = i
            task.hasSubtasks = TasksModel.data(TasksModel.index(i, 0), 262) || false  // HasSubtasksRole
            task.subtaskCount = TasksModel.data(TasksModel.index(i, 0), 263) || 0  // SubtaskCountRole
            task.completedSubtasks = TasksModel.data(TasksModel.index(i, 0), 264) || 0  // CompletedSubtasksRole

            allTasks.push(task)
        }

        var filteredTasks = allTasks.filter(function(task) {
            if (filterDropdown.currentIndex === 0) {
                return true;
            } else if (filterDropdown.currentIndex === 1) {
                return task.dueDate === "Today";
            } else if (filterDropdown.currentIndex === 2) {
                return task.dueDate === "Tomorrow";
            } else if (filterDropdown.currentIndex === 3) {
                return task.dueDate === "This Week";
            } else if (filterDropdown.currentIndex === 4) {
                return task.completed;
            }
            return false;
        });

        sortTasks(filteredTasks);

        for (var j = 0; j < filteredTasks.length; j++) {
            filteredTasksModel.append(filteredTasks[j]);
        }
    }

    function dueDateValue(dueDate) {
        if (dueDate === "Today") return 0;
        if (dueDate === "Tomorrow") return 1;
        if (dueDate === "This Week") return 2;
        if (dueDate === "Next Week") return 3;
        if (dueDate === "Custom") return 4;
        return 5;
    }

    function sortTasks(tasksArray) {
        if (sortDropdown.currentIndex === 0) {
            tasksArray.sort(function(a, b) {
                return dueDateValue(a.dueDate) - dueDateValue(b.dueDate);
            });
        } else if (sortDropdown.currentIndex === 1) {
            tasksArray.sort(function(a, b) {
                return b.priority - a.priority;
            });
        } else if (sortDropdown.currentIndex === 2) {
            tasksArray.sort(function(a, b) {
                if (a.name < b.name) return -1;
                if (a.name > b.name) return 1;
                return 0;
            });
        }
    }

    Connections {
        target: TasksModel
        function onCountChanged() {
            applyFiltersAndSort()
        }
        function onDataChanged() {
            applyFiltersAndSort()
        }
    }

    Component.onCompleted: {
        applyFiltersAndSort()
    }

    ListView {
        id: tasksList
        anchors {
            top: filterControls.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 24
        }
        clip: true
        spacing: 16
        model: filteredTasksModel

        section.property: "dueDate"
        section.criteria: ViewSection.FullString
        section.delegate: Rectangle {
            width: parent.width
            height: 40
            color: "transparent"

            Text {
                text: section
                font.pixelSize: 16
                font.bold: true
                color: theme.textSecondaryColor
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                height: 1
                color: theme.borderColor
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    leftMargin: 0
                    rightMargin: 0
                }
            }
        }

        delegate: TaskItem {
            width: tasksList.width
            taskName: model.name || ""
            taskDescription: model.description || ""
            taskDueDate: model.dueDate || "Today"
            taskPriority: model.priority || 0
            isCompleted: model.completed || false
            itemIndex: model.originalIndex
            hasSubtasks: model.hasSubtasks || false
            subtaskCount: model.subtaskCount || 0
            completedSubtasks: model.completedSubtasks || 0

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 2
                radius: 6.0
                samples: 14
                color: theme.shadowColor
                opacity: 0.5
            }
        }

        ScrollBar.vertical: ScrollBar {
            active: true
            policy: ScrollBar.AsNeeded
            width: 8
            opacity: 0.5
        }

        Text {
            anchors.centerIn: parent
            text: tasksList.count === 0 ? "No tasks yet. Add your first task!" : ""
            font.pixelSize: 20
            color: theme.textSecondaryColor
        }
    }

    Dialog {
        id: addTaskDialog
        title: "Add New Task"
        anchors.centerIn: parent
        width: 500
        height: 420
        modal: true
        dim: true
        closePolicy: Dialog.CloseOnEscape | Dialog.CloseOnPressOutside

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

            Text {
                text: addTaskDialog.title
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

        contentItem: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 18

            Text {
                text: "Create a new task"
                font.pixelSize: 16
                color: theme.textColor
            }

            TextField {
                id: taskNameField
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                placeholderText: "Task name"
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
                id: taskDescField
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
                    text: "Due Date:"
                    font.pixelSize: 16
                    color: theme.textColor
                    Layout.preferredWidth: 80
                }

                CustomComboBox {
                    id: dueDateCombo
                    Layout.fillWidth: true
                    height: 48
                    model: ["Today", "Tomorrow", "This Week", "Next Week", "Custom"]
                    currentIndex: 0
                    borderColorNormal: theme.inputBorderColor
                    borderColorFocused: theme.inputBorderFocusColor
                    bgColorNormal: theme.inputBackgroundColor
                    dropdownBgColor: theme.cardColor
                    radius: 8
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                Text {
                    text: "Priority:"
                    font.pixelSize: 16
                    color: theme.textColor
                    Layout.preferredWidth: 80
                }

                CustomComboBox {
                    id: priorityCombo
                    Layout.fillWidth: true
                    height: 48
                    model: ["Low", "Medium", "High", "Urgent"]
                    currentIndex: 0
                    borderColorNormal: theme.inputBorderColor
                    borderColorFocused: theme.inputBorderFocusColor
                    bgColorNormal: theme.inputBackgroundColor
                    dropdownBgColor: theme.cardColor
                    radius: 8
                }
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
                        addTaskDialog.close()
                    }
                }

                CustomRectButton {
                    text: "Create"
                    width: 110
                    height: 44
                    buttonColor: theme.buttonPrimaryColor
                    textColor: theme.buttonTextLightColor
                    font.bold: true
                    radius: 8

                    onClicked: {
                        if (taskNameField.text.trim() !== "") {
                            var dueDate = dueDateCombo.currentText
                            var priority = priorityCombo.currentIndex

                            TasksModel.addTask(taskNameField.text, taskDescField.text, dueDate, priority)
                            addTaskDialog.close()
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: editTaskDialog
        title: "Edit Task"
        anchors.centerIn: parent
        width: 500
        height: 420
        modal: true
        dim: true
        closePolicy: Dialog.CloseOnEscape | Dialog.CloseOnPressOutside

        property int taskIndex: -1

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

            Text {
                text: editTaskDialog.title
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

        contentItem: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 18

            Text {
                text: "Edit task details"
                font.pixelSize: 16
                color: theme.textColor
            }

            TextField {
                id: editTaskNameField
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                placeholderText: "Task name"
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
                id: editTaskDescField
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
                    text: "Due Date:"
                    font.pixelSize: 16
                    color: theme.textColor
                    Layout.preferredWidth: 80
                }

                CustomComboBox {
                    id: editDueDateCombo
                    Layout.fillWidth: true
                    height: 48
                    model: ["Today", "Tomorrow", "This Week", "Next Week", "Custom"]
                    borderColorNormal: theme.inputBorderColor
                    borderColorFocused: theme.inputBorderFocusColor
                    bgColorNormal: theme.inputBackgroundColor
                    dropdownBgColor: theme.cardColor
                    radius: 8
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 16

                Text {
                    text: "Priority:"
                    font.pixelSize: 16
                    color: theme.textColor
                    Layout.preferredWidth: 80
                }

                CustomComboBox {
                    id: editPriorityCombo
                    Layout.fillWidth: true
                    height: 48
                    model: ["Low", "Medium", "High", "Urgent"]
                    borderColorNormal: theme.inputBorderColor
                    borderColorFocused: theme.inputBorderFocusColor
                    bgColorNormal: theme.inputBackgroundColor
                    dropdownBgColor: theme.cardColor
                    radius: 8
                }
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
                        editTaskDialog.close()
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
                        if (editTaskNameField.text.trim() !== "") {
                            var dueDate = editDueDateCombo.currentText
                            var priority = editPriorityCombo.currentIndex

                            TasksModel.editTask(
                                editTaskDialog.taskIndex,
                                editTaskNameField.text,
                                editTaskDescField.text,
                                dueDate,
                                priority
                            )

                            editTaskDialog.close()
                        }
                    }
                }
            }
        }

        function openEditDialog(index, name, description, dueDate, priority) {
            editTaskDialog.taskIndex = index
            editTaskNameField.text = name || ""
            editTaskDescField.text = description || ""

            var dueDateIndex = 0
            for (var i = 0; i < editDueDateCombo.model.length; i++) {
                if (editDueDateCombo.model[i] === dueDate) {
                    dueDateIndex = i
                    break
                }
            }
            editDueDateCombo.currentIndex = dueDateIndex

            editPriorityCombo.currentIndex = priority || 0
            editTaskDialog.open()
        }
    }

    Dialog {
        id: deleteTaskDialog
        title: "Delete Task"
        anchors.centerIn: parent
        width: 420
        height: 220
        modal: true
        dim: true
        closePolicy: Dialog.CloseOnEscape | Dialog.CloseOnPressOutside

        property int taskIndex: -1
        property string taskName: ""

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
                text: deleteTaskDialog.title
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
                width: parent.width
                text: "Are you sure you want to delete this task?"
                font.pixelSize: 16
                color: theme.textColor
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "\"" + deleteTaskDialog.taskName + "\""
                font.pixelSize: 16
                font.bold: true
                color: theme.textColor
                wrapMode: Text.WordWrap
            }

            Text {
                width: parent.width
                text: "This action cannot be undone."
                font.pixelSize: 14
                color: theme.textSecondaryColor
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
                        deleteTaskDialog.close()
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
                        TasksModel.removeTask(deleteTaskDialog.taskIndex)
                        deleteTaskDialog.close()
                    }
                }
            }
        }

        function confirmDelete(index, name) {
            deleteTaskDialog.taskIndex = index
            deleteTaskDialog.taskName = name || ""
            deleteTaskDialog.open()
        }
    }
}
