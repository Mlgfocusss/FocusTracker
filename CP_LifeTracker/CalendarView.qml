import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: calendarView
    color: theme.backgroundColor

    property alias theme: theme
    property date currentDate: new Date()
    property date selectedDate: new Date()
    property int currentMonth: currentDate.getMonth()
    property int currentYear: currentDate.getFullYear()

    Theme {
        id: theme
    }

    Rectangle {
        id: headerBar
        height: 90
        color: theme.themeIndex === 0 ? "#4A5568" : "#2D3748"
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
            verticalOffset: 4
            radius: 16.0
            samples: 32
            color: theme.shadowColor
        }

        Rectangle {
            width: parent.width
            height: 1
            color: theme.borderColor
            anchors.bottom: parent.bottom
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 32
            spacing: 32

            Text {
                id: headerText
                text: qsTr("Calendar")
                font.pixelSize: 36
                font.bold: true
                color: "#FFFFFF"
                Layout.fillWidth: true
            }

            Rectangle {
                id: addEventButton
                width: 56
                height: 56
                radius: 28
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.lighter(theme.buttonPrimaryColor, 1.2) }
                    GradientStop { position: 1.0; color: theme.buttonPrimaryColor }
                }
                opacity: addEventMouse.containsMouse ? 0.9 : 1.0

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 2
                    radius: 8.0
                    samples: 16
                    color: Qt.rgba(0, 0, 0, 0.25)
                }

                Text {
                    text: "+"
                    font.pixelSize: 32
                    font.bold: true
                    color: theme.buttonTextLightColor
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: addEventMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        parent.scale = 1.1
                    }

                    onExited: {
                        parent.scale = 1.0
                    }

                    onClicked: {
                        addEventDialog.openDialog(selectedDate)
                    }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }

                Behavior on scale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutBack }
                }
            }
        }
    }

    Rectangle {
        id: separator1
        height: 2
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: theme.borderColor }
            GradientStop { position: 1.0; color: "transparent" }
        }
        anchors {
            top: headerBar.bottom
            left: parent.left
            right: parent.right
            leftMargin: 32
            rightMargin: 32
        }
    }

    RowLayout {
        id: calendarControls
        anchors {
            top: separator1.bottom
            left: parent.left
            right: parent.right
            margins: 32
            topMargin: 24
        }
        height: 70
        spacing: 24

        Rectangle {
            id: prevButton
            width: 50
            height: 50
            radius: 16
            color: prevMouse.containsMouse ? theme.navHoverColor : theme.cardColor
            border.color: theme.borderColor
            border.width: 1

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 3
                radius: 8.0
                samples: 16
                color: theme.shadowColor
            }

            Text {
                text: "‹"
                font.pixelSize: 28
                font.bold: true
                color: theme.textColor
                anchors.centerIn: parent
            }

            MouseArea {
                id: prevMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onClicked: {
                    if (currentMonth === 0) {
                        currentMonth = 11
                        currentYear--
                    } else {
                        currentMonth--
                    }
                    updateCalendar()
                }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        Text {
            id: monthYearText
            text: getMonthName(currentMonth) + " " + currentYear
            font.pixelSize: 32
            font.bold: true
            color: theme.textColor
            Layout.fillWidth: true
        }

        Rectangle {
            id: nextButton
            width: 50
            height: 50
            radius: 16
            color: nextMouse.containsMouse ? theme.navHoverColor : theme.cardColor
            border.color: theme.borderColor
            border.width: 1

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 3
                radius: 8.0
                samples: 16
                color: theme.shadowColor
            }

            Text {
                text: "›"
                font.pixelSize: 28
                font.bold: true
                color: theme.textColor
                anchors.centerIn: parent
            }

            MouseArea {
                id: nextMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onClicked: {
                    if (currentMonth === 11) {
                        currentMonth = 0
                        currentYear++
                    } else {
                        currentMonth++
                    }
                    updateCalendar()
                }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }

        Rectangle {
            id: todayButton
            width: 120
            height: 50
            radius: 16
            color: todayMouse.containsMouse ? theme.buttonPrimaryColor : theme.cardColor
            border.color: theme.buttonPrimaryColor
            border.width: 2

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 3
                radius: 8.0
                samples: 16
                color: theme.shadowColor
            }

            Text {
                text: "Today"
                font.pixelSize: 16
                font.bold: true
                color: todayMouse.containsMouse ? theme.buttonTextLightColor : theme.buttonPrimaryColor
                anchors.centerIn: parent
            }

            MouseArea {
                id: todayMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onClicked: {
                    var today = new Date()
                    currentMonth = today.getMonth()
                    currentYear = today.getFullYear()
                    selectedDate = today
                    updateCalendar()
                }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }

    RowLayout {
        anchors {
            top: calendarControls.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 32
        }
        spacing: 32

        Rectangle {
            id: calendarContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: theme.cardColor
            radius: 20
            border.color: theme.borderColor
            border.width: 1

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 6
                radius: 20.0
                samples: 40
                color: theme.shadowColor
            }

            Column {
                anchors.fill: parent
                anchors.margins: 32

                Row {
                    width: parent.width
                    height: 60

                    Repeater {
                        model: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                        Rectangle {
                            width: parent.width / 7
                            height: 60
                            color: "transparent"

                            Text {
                                text: modelData
                                font.pixelSize: 18
                                font.bold: true
                                color: theme.textSecondaryColor
                                anchors.centerIn: parent
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 2
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 0.5; color: theme.borderColor }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                    radius: 1
                }

                GridLayout {
                    id: calendarGrid
                    width: parent.width
                    height: parent.height - 62
                    columns: 7
                    rows: 6
                    columnSpacing: 4
                    rowSpacing: 4

                    Repeater {
                        id: calendarRepeater
                        model: 42

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 12
                            color: {
                                if (isSelected) {
                                    return theme.accentColor
                                }
                                if (dayMouseArea.containsMouse && isCurrentMonth) {
                                    return theme.navHoverColor
                                }
                                if (isToday) {
                                    return Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.15)
                                }
                                return "transparent"
                            }
                            border.color: isToday && !isSelected ? theme.accentColor : "transparent"
                            border.width: isToday && !isSelected ? 2 : 0

                            property int dayNumber: 0
                            property bool isCurrentMonth: false
                            property bool isToday: false
                            property bool isSelected: false
                            property bool hasEvents: false

                            layer.enabled: isSelected || (dayMouseArea.containsMouse && isCurrentMonth)
                            layer.effect: DropShadow {
                                transparentBorder: true
                                horizontalOffset: 0
                                verticalOffset: 2
                                radius: 6.0
                                samples: 12
                                color: theme.shadowColor
                            }

                            Text {
                                id: dayText
                                text: parent.dayNumber
                                font.pixelSize: 18
                                font.bold: parent.isToday || parent.isSelected
                                color: {
                                    if (parent.isSelected) {
                                        return theme.buttonTextLightColor
                                    }
                                    if (!parent.isCurrentMonth) {
                                        return theme.textSecondaryColor
                                    }
                                    if (parent.isToday) {
                                        return theme.accentColor
                                    }
                                    return theme.textColor
                                }
                                anchors {
                                    top: parent.top
                                    left: parent.left
                                    margins: 12
                                }
                            }

                            Rectangle {
                                width: 10
                                height: 10
                                radius: 5
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: parent.isSelected ? theme.buttonTextLightColor : theme.accentColor }
                                    GradientStop { position: 1.0; color: parent.isSelected ? Qt.rgba(1,1,1,0.8) : Qt.darker(theme.accentColor, 1.2) }
                                }
                                visible: parent.hasEvents
                                anchors {
                                    bottom: parent.bottom
                                    right: parent.right
                                    margins: 8
                                }

                                layer.enabled: true
                                layer.effect: DropShadow {
                                    transparentBorder: true
                                    horizontalOffset: 0
                                    verticalOffset: 1
                                    radius: 2.0
                                    samples: 4
                                    color: theme.shadowColor
                                }
                            }

                            MouseArea {
                                id: dayMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: parent.isCurrentMonth ? Qt.PointingHandCursor : Qt.ArrowCursor

                                onClicked: {
                                    if (parent.isCurrentMonth) {
                                        var newDate = new Date(currentYear, currentMonth, parent.dayNumber)
                                        selectedDate = newDate
                                        updateCalendar()
                                        updateEventsList()
                                    }
                                }
                            }

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }

                            Behavior on scale {
                                NumberAnimation { duration: 150 }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: eventsPanel
            Layout.preferredWidth: 400
            Layout.fillHeight: true
            color: theme.cardColor
            radius: 20
            border.color: theme.borderColor
            border.width: 1

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 6
                radius: 20.0
                samples: 40
                color: theme.shadowColor
            }

            Column {
                anchors.fill: parent
                anchors.margins: 32
                spacing: 24

                Row {
                    width: parent.width
                    spacing: 16

                    Rectangle {
                        width: 8
                        height: 32
                        radius: 4
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: theme.accentGradientStartColor }
                            GradientStop { position: 1.0; color: theme.accentGradientEndColor }
                        }
                        anchors.verticalCenter: parent.verticalCenter

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0
                            verticalOffset: 2
                            radius: 4.0
                            samples: 8
                            color: theme.shadowColor
                        }
                    }

                    Text {
                        text: "Events for " + Qt.formatDate(selectedDate, "MMM dd, yyyy")
                        font.pixelSize: 20
                        font.bold: true
                        color: theme.textColor
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 2
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 0.5; color: theme.borderColor }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                    radius: 1
                }

                ListView {
                    id: eventsList
                    width: parent.width
                    height: parent.height - 100
                    clip: true
                    spacing: 20
                    model: ListModel {
                        id: eventsListModel
                    }

                    delegate: Rectangle {
                        width: eventsList.width
                        height: Math.max(80, eventContent.height + 32)
                        radius: 16
                        color: theme.cardColor
                        border.color: theme.borderColor
                        border.width: 1

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0
                            verticalOffset: 4
                            radius: 12.0
                            samples: 24
                            color: theme.shadowColor
                        }

                        Rectangle {
                            id: timeIndicator
                            width: 6
                            height: parent.height - 16
                            radius: 3
                            color: getCategoryColor(model.category)
                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: 8
                            }

                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true
                                horizontalOffset: 0
                                verticalOffset: 1
                                radius: 3.0
                                samples: 6
                                color: theme.shadowColor
                            }
                        }

                        Column {
                            id: eventContent
                            anchors {
                                left: timeIndicator.right
                                right: timeColumn.left
                                top: parent.top
                                margins: 20
                            }
                            spacing: 8

                            Text {
                                text: model.title
                                font.pixelSize: 18
                                font.bold: true
                                color: theme.textColor
                                elide: Text.ElideRight
                                width: parent.width
                            }

                            Text {
                                text: model.description
                                font.pixelSize: 15
                                color: theme.textSecondaryColor
                                width: parent.width
                                wrapMode: Text.WordWrap
                                visible: model.description !== ""
                                maximumLineCount: 3
                                elide: Text.ElideRight
                            }

                            Row {
                                spacing: 8

                                Rectangle {
                                    width: childrenRect.width + 16
                                    height: 28
                                    radius: 14
                                    color: Qt.rgba(getCategoryColor(model.category).r, getCategoryColor(model.category).g, getCategoryColor(model.category).b, 0.15)
                                    border.color: getCategoryColor(model.category)
                                    border.width: 1

                                    Text {
                                        text: model.category
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: getCategoryColor(model.category)
                                        anchors.centerIn: parent
                                    }
                                }
                            }
                        }

                        Column {
                            id: timeColumn
                            anchors {
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                                rightMargin: 20
                            }
                            spacing: 8

                            Rectangle {
                                width: Math.max(80, timeText.width + 20)
                                height: 36
                                radius: 18
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.2) }
                                    GradientStop { position: 1.0; color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.1) }
                                }
                                border.color: theme.accentColor
                                border.width: 1

                                Text {
                                    id: timeText
                                    text: model.allDay ? "All Day" : model.time
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: theme.accentColor
                                    anchors.centerIn: parent
                                }
                            }

                            Text {
                                text: model.allDay ? "" : (model.duration + " min")
                                font.pixelSize: 12
                                color: theme.textSecondaryColor
                                anchors.horizontalCenter: parent.horizontalCenter
                                visible: !model.allDay && model.duration > 0
                            }
                        }

                        MouseArea {
                            id: eventMouse
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onClicked: {
                                editEventDialog.openEditDialog(
                                    model.originalIndex,
                                    model.title,
                                    model.description,
                                    model.date,
                                    model.time,
                                    model.duration,
                                    model.category,
                                    model.allDay
                                )
                            }
                        }

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }

                        Behavior on scale {
                            NumberAnimation { duration: 150 }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        active: true
                        policy: ScrollBar.AsNeeded
                        width: 8
                        opacity: 0.7

                        background: Rectangle {
                            color: theme.backgroundSecondaryColor
                            radius: 4
                        }

                        contentItem: Rectangle {
                            color: theme.textSecondaryColor
                            radius: 4
                        }
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: Math.max(300, childrenRect.width + 60)
                        height: childrenRect.height + 60
                        color: theme.backgroundSecondaryColor
                        radius: 20
                        border.color: theme.borderColor
                        border.width: 1
                        visible: eventsList.count === 0

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0
                            verticalOffset: 4
                            radius: 12.0
                            samples: 24
                            color: theme.shadowColor
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: 16

                            Rectangle {
                                width: 64
                                height: 64
                                radius: 32
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(theme.textSecondaryColor.r, theme.textSecondaryColor.g, theme.textSecondaryColor.b, 0.15) }
                                    GradientStop { position: 1.0; color: Qt.rgba(theme.textSecondaryColor.r, theme.textSecondaryColor.g, theme.textSecondaryColor.b, 0.05) }
                                }
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    text: "📅"
                                    font.pixelSize: 28
                                    anchors.centerIn: parent
                                }
                            }

                            Text {
                                text: "No events for this date"
                                font.pixelSize: 18
                                font.bold: true
                                color: theme.textSecondaryColor
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "Click the + button to add one"
                                font.pixelSize: 15
                                color: theme.textSecondaryColor
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
        }
    }

    function getMonthName(month) {
        var months = ["January", "February", "March", "April", "May", "June",
                     "July", "August", "September", "October", "November", "December"]
        return months[month]
    }

    function updateCalendar() {
        var firstDay = new Date(currentYear, currentMonth, 1)
        var lastDay = new Date(currentYear, currentMonth + 1, 0)
        var startDate = new Date(firstDay)
        startDate.setDate(startDate.getDate() - firstDay.getDay())

        var today = new Date()
        var todayStr = Qt.formatDate(today, "yyyy-MM-dd")
        var selectedStr = Qt.formatDate(selectedDate, "yyyy-MM-dd")

        for (var i = 0; i < 42; i++) {
            var currentDate = new Date(startDate)
            currentDate.setDate(startDate.getDate() + i)

            var dayItem = calendarRepeater.itemAt(i)
            if (dayItem) {
                dayItem.dayNumber = currentDate.getDate()
                dayItem.isCurrentMonth = currentDate.getMonth() === currentMonth
                dayItem.isToday = Qt.formatDate(currentDate, "yyyy-MM-dd") === todayStr
                dayItem.isSelected = Qt.formatDate(currentDate, "yyyy-MM-dd") === selectedStr
                dayItem.hasEvents = hasEventsForDate(currentDate)
            }
        }

        updateEventsList()
    }

    function hasEventsForDate(date) {
        if (!EventsModel) return false

        var dateStr = Qt.formatDate(date, "yyyy-MM-dd")
        for (var i = 0; i < EventsModel.count; i++) {
            var eventDate = EventsModel.data(EventsModel.index(i, 0), 259)
            if (eventDate === dateStr) {
                return true
            }
        }
        return false
    }

    function updateEventsList() {
        eventsListModel.clear()

        if (!EventsModel) return

        var selectedStr = Qt.formatDate(selectedDate, "yyyy-MM-dd")

        for (var i = 0; i < EventsModel.count; i++) {
            var eventDate = EventsModel.data(EventsModel.index(i, 0), 259)
            if (eventDate === selectedStr) {
                var event = {
                    originalIndex: i,
                    title: EventsModel.data(EventsModel.index(i, 0), 257),
                    description: EventsModel.data(EventsModel.index(i, 0), 258),
                    date: eventDate,
                    time: EventsModel.data(EventsModel.index(i, 0), 260),
                    duration: EventsModel.data(EventsModel.index(i, 0), 261),
                    category: EventsModel.data(EventsModel.index(i, 0), 262),
                    allDay: EventsModel.data(EventsModel.index(i, 0), 263)
                }
                eventsListModel.append(event)
            }
        }
    }

    function getCategoryColor(category) {
        switch (category) {
            case "Work": return "#3498db"
            case "Personal": return "#e74c3c"
            case "Health": return "#2ecc71"
            case "Travel": return "#f39c12"
            case "Education": return "#9b59b6"
            default: return theme.accentColor
        }
    }

    Connections {
        target: EventsModel
        function onCountChanged() {
            updateCalendar()
        }
        function onDataChanged() {
            updateCalendar()
        }
    }

    Component.onCompleted: {
        updateCalendar()
    }

    AddEventDialog {
        id: addEventDialog

        function openDialog(date) {
            dateField.text = Qt.formatDate(date, "yyyy-MM-dd")
            open()
        }

        onClosed: {
            updateCalendar()
        }
    }

    EditEventDialog {
        id: editEventDialog

        onClosed: {
            updateCalendar()
        }
    }
}
