import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import QtQuick.Dialogs

Item {
    id: appearanceTab
    width: parent.width
    height: parent.height
    property var availableFonts: ["Inter", "Poppins", "Roboto", "Open Sans", "Montserrat", "SF Pro", "Ubuntu"]
    property var fontSizes: ["Small", "Medium", "Large", "Extra Large"]
    property int containerMaxWidth: 1000
    property int containerMargins: 30
    property int topPadding: 10

    readonly property int currentThemeIndex: SettingsManager.themeIndex

    Theme {
        id: theme
        themeIndex: currentThemeIndex
    }

    component ThemeCard : Rectangle {
        id: themeCard

        property string themeName: ""
        property string themeIcon: ""
        property int themeValue: -1
        property bool isSelected: SettingsManager.themeIndex === themeValue

        property color baseColor: theme.cardColor
        property color borderColorNormal: theme.buttonBorderColor
        property color borderColorSelected: theme.accentColor
        property color textColorNormal: theme.textColor
        property color textColorSelected: theme.accentColor
        property color highlightColor: Qt.alpha(theme.accentColor, 0.15)
        property color iconShadowColor: theme.shadowColor

        radius: 14
        color: isSelected ? highlightColor : baseColor
        border.width: 2
        border.color: isSelected ? borderColorSelected : borderColorNormal

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 3
            radius: 8.0
            samples: 17
            color: theme.shadowColor
            transparentBorder: true
        }

        Behavior on color {
            ColorAnimation { duration: 250
                easing.type: Easing.OutQuad }
        }

        Behavior on border.color {
            ColorAnimation { duration: 250
                easing.type: Easing.OutQuad }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        Rectangle {
            id: hoverEffect
            anchors.fill: parent
            radius: parent.radius
            color: "#000000"
            opacity: 0

            Behavior on opacity {
                NumberAnimation { duration: 200
                    easing.type: Easing.OutQuad }
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 12

            Item {
                id: iconContainer
                width: 60
                height: 60
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    id: iconBackground
                    anchors.centerIn: parent
                    width: 54
                    height: 54
                    radius: width / 2
                    color: isSelected ? Qt.alpha(theme.accentColor, 0.15) : "transparent"
                    scale: isSelected ? 1.1 : 1.0

                    Behavior on color {
                        ColorAnimation { duration: 300
                            easing.type: Easing.OutQuad }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: themeIcon
                    font.pixelSize: 32
                    scale: isSelected ? 1.1 : 1.0

                    Behavior on scale {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                    }

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0
                        verticalOffset: 1
                        radius: 4.0
                        samples: 9
                        color: iconShadowColor
                    }
                }
            }

            Text {
                text: themeName
                font.pixelSize: 16
                font.weight: Font.Medium
                color: isSelected ? textColorSelected : textColorNormal
                Layout.alignment: Qt.AlignHCenter

                Behavior on color {
                    ColorAnimation { duration: 250
                        easing.type: Easing.OutQuad }
                }
            }
        }

        Rectangle {
            id: selectedIndicator
            width: 22
            height: 22
            radius: 11
            color: theme.accentColor
            visible: true
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10
            opacity: isSelected ? 1 : 0
            scale: isSelected ? 1 : 0.5

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutBack
                }
            }

            Text {
                text: "✓"
                color: "white"
                font.pixelSize: 14
                font.weight: Font.Bold
                anchors.centerIn: parent
                scale: isSelected ? 1 : 0

                Behavior on scale {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutBack
                    }
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: {
                hoverEffect.opacity = 0.05
                if (!isSelected) {
                    themeCard.scale = 1.02
                    iconBackground.scale = 1.1
                }
            }

            onExited: {
                hoverEffect.opacity = 0
                themeCard.scale = 1.0
                iconBackground.scale = 1.0
            }

            onPressed: {
                hoverEffect.opacity = 0.1
                themeCard.scale = 0.98
            }

            onReleased: {
                hoverEffect.opacity = mouseArea.containsMouse ? 0.05 : 0
                themeCard.scale = mouseArea.containsMouse ? 1.02 : 1.0
            }

            onClicked: {
                if (!isSelected) {
                    SettingsManager.setThemeIndex(themeValue)
                    selectAnimation.start()
                }
            }

            SequentialAnimation {
                id: selectAnimation
                ParallelAnimation {
                    NumberAnimation {
                        target: themeCard
                        property: "scale"
                        to: 0.92
                        duration: 120
                        easing.type: Easing.OutQuad
                    }
                    NumberAnimation {
                        target: themeCard
                        property: "rotation"
                        to: -3
                        duration: 120
                        easing.type: Easing.OutQuad
                    }
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: themeCard
                        property: "scale"
                        to: 1.0
                        duration: 400
                        easing.type: Easing.OutElastic
                        easing.amplitude: 1.2
                        easing.period: 0.3
                    }
                    NumberAnimation {
                        target: themeCard
                        property: "rotation"
                        to: 0
                        duration: 400
                        easing.type: Easing.OutElastic
                        easing.amplitude: 1.2
                        easing.period: 0.3
                    }
                }
            }
        }
    }

    component SettingSection : ColumnLayout {
        property string title: ""
        property string icon: ""
        property string description: ""
        spacing: 5
        Layout.fillWidth: true

        RowLayout {
            spacing: 5
            Layout.fillWidth: true

            Text {
                text: icon
                font.pixelSize: 24
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: title
                font.pixelSize: 20
                font.weight: Font.Bold
                color: theme.textColor
                Layout.fillWidth: true
            }
        }

        Text {
            text: description
            font.pixelSize: 14
            color: theme.textSecondaryColor
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            Layout.topMargin: 5
        }
    }

    FileDialog {
        id: fileDialog
        nameFilters: ["Image files (*.jpg *.jpeg *.png *.bmp)"]
        onAccepted: {
            backgroundPreview.source = fileDialog.selectedFile
        }
    }

    Rectangle {
        id: mainContainer
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width - 2 * containerMargins, containerMaxWidth)
        height: parent.height
        color: "transparent"

        Flickable {
            id: scrollView
            anchors.fill: parent
            contentWidth: width
            contentHeight: contentContainer.height
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            flickDeceleration: 1500
            maximumFlickVelocity: 5000

            Item {
                id: contentContainer
                width: parent.width
                height: mainColumn.height + 2 * topPadding

                ColumnLayout {
                    id: mainColumn
                    width: parent.width
                    spacing: 15
                    anchors.top: parent.top
                    anchors.topMargin: topPadding

                    SettingSection {
                        title: qsTr("Theme")
                        icon: "🎨"
                        description: qsTr("Choose application visual style")
                        Layout.topMargin: topPadding

                        GridLayout {
                            columns: {
                                if (parent.width < 400) return 1
                                if (parent.width < 700) return 2
                                return 3
                            }
                            rowSpacing: 20
                            columnSpacing: 20
                            Layout.fillWidth: true
                            Layout.topMargin: 20

                            ThemeCard {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 120
                                themeName: "Light"
                                themeIcon: "☀️"
                                themeValue: 0
                            }

                            ThemeCard {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 120
                                themeName: "Dark"
                                themeIcon: "🌙"
                                themeValue: 1
                            }

                            ThemeCard {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 120
                                themeName: "Colorful"
                                themeIcon: "✨"
                                themeValue: 2
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.buttonBorderColor
                        opacity: 0.5
                        Layout.topMargin: 10
                        Layout.bottomMargin: 10
                    }

                    SettingSection {
                        title: qsTr("Typography")
                        icon: "🔠"
                        description: qsTr("Font settings for application interface")

                        GridLayout {
                            columns: mainContainer.width < 700 ? 1 : 2
                            rowSpacing: 25
                            columnSpacing: 30
                            Layout.fillWidth: true
                            Layout.topMargin: 20

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Text {
                                    text: qsTr("Font Family")
                                    color: theme.textColor
                                    font.pixelSize: 16
                                    font.weight: Font.Medium
                                }

                                Text {
                                    text: qsTr("Main text font for interface")
                                    color: theme.textSecondaryColor
                                    font.pixelSize: 14
                                }
                            }

                            CustomComboBox {
                                id: fontSelector
                                model: availableFonts
                                currentIndex: 0
                                Layout.alignment: mainContainer.width < 700 ? Qt.AlignLeft : Qt.AlignRight | Qt.AlignVCenter
                                Layout.fillWidth: mainContainer.width < 700
                                width: mainContainer.width < 700 ? parent.width : 220
                                borderColorNormal: theme.inputBorderColor
                                borderColorFocused: theme.accentColor
                                bgColorNormal: theme.inputBackgroundColor
                                dropdownBgColor: theme.inputBackgroundColor
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Text {
                                    text: qsTr("Font Size")
                                    color: theme.textColor
                                    font.pixelSize: 16
                                    font.weight: Font.Medium
                                }

                                Text {
                                    text: qsTr("Text size throughout the application")
                                    color: theme.textSecondaryColor
                                    font.pixelSize: 14
                                }
                            }

                            RowLayout {
                                spacing: 15
                                Layout.alignment: mainContainer.width < 700 ? Qt.AlignLeft : Qt.AlignRight | Qt.AlignVCenter
                                Layout.fillWidth: mainContainer.width < 700
                                layoutDirection: mainContainer.width < 700 ? Qt.LeftToRight : Qt.RightToLeft

                                Repeater {
                                    model: fontSizes

                                    Rectangle {
                                        id: radioBtn
                                        property bool isSelected: index === 1

                                        implicitWidth: radioText.implicitWidth + 30
                                        implicitHeight: 36
                                        radius: 18
                                        color: isSelected ? theme.accentColor : "transparent"
                                        border.width: isSelected ? 0 : 1
                                        border.color: theme.buttonBorderColor

                                        Text {
                                            id: radioText
                                            text: modelData
                                            anchors.centerIn: parent
                                            color: radioBtn.isSelected ? "white" : theme.textColor
                                            font.pixelSize: 14
                                            font.weight: Font.Medium
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor

                                            onPressed: radioBtn.scale = 0.97
                                            onReleased: radioBtn.scale = 1.0
                                        }

                                        Behavior on color {
                                            ColorAnimation { duration: 150 }
                                        }

                                        Behavior on scale {
                                            NumberAnimation { duration: 100 }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: theme.buttonBorderColor
                        opacity: 0.5
                        Layout.topMargin: 10
                        Layout.bottomMargin: 10
                    }
                    SettingSection {
                        id: backgroundSection
                        title: qsTr("Home Background")
                        icon: "🖼️"
                        description: qsTr("Customize the application home screen background")

                        ColumnLayout {
                            spacing: 20
                            Layout.fillWidth: true
                            Layout.topMargin: 20

                            Rectangle {
                                id: backgroundPreview
                                property string source: ""

                                Layout.fillWidth: true
                                Layout.preferredHeight: 240
                                color: theme.backgroundSecondaryColor
                                radius: 14
                                border.width: 1
                                border.color: theme.buttonBorderColor

                                layer.enabled: true
                                layer.effect: DropShadow {
                                    horizontalOffset: 0
                                    verticalOffset: 4
                                    radius: 10.0
                                    samples: 17
                                    color: theme.shadowColor
                                    transparentBorder: true
                                }

                                Behavior on color {
                                    ColorAnimation { duration: 200 }
                                }

                                Image {
                                    id: previewImage
                                    anchors.fill: parent
                                    source: parent.source
                                    fillMode: Image.PreserveAspectCrop
                                    visible: status === Image.Ready
                                    asynchronous: true

                                    layer.enabled: true
                                    layer.effect: OpacityMask {
                                        maskSource: Rectangle {
                                            width: previewImage.width
                                            height: previewImage.height
                                            radius: backgroundPreview.radius
                                        }
                                    }

                                    Behavior on opacity {
                                        NumberAnimation { duration: 300 }
                                    }
                                }

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 15
                                    visible: previewImage.status !== Image.Ready
                                    opacity: previewImage.status !== Image.Ready ? 1 : 0

                                    Behavior on opacity {
                                        NumberAnimation { duration: 200 }
                                    }

                                    Text {
                                        text: "📷"
                                        font.pixelSize: 52
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: theme.textSecondaryColor
                                    }

                                    Text {
                                        text: qsTr("No background selected")
                                        font.pixelSize: 16
                                        font.weight: Font.Medium
                                        color: theme.textSecondaryColor
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }

                            RowLayout {
                                spacing: 20
                                Layout.fillWidth: true

                                CustomRectButton {
                                    text: qsTr("Select Image")
                                    buttonColor: theme.accentColor
                                    Layout.fillWidth: true
                                    height: 40

                                    font {
                                        pixelSize: 14
                                        weight: Font.Medium
                                    }

                                    onClicked: fileDialog.open()
                                }

                                CustomRectButton {
                                    text: qsTr("Remove")
                                    buttonColor: theme.buttonDangerColor
                                    Layout.fillWidth: true
                                    height: 40
                                    enabled: previewImage.status === Image.Ready

                                    font {
                                        pixelSize: 14
                                        weight: Font.Medium
                                    }

                                    onClicked: {
                                        backgroundPreview.source = ""
                                    }
                                }
                            }
                        }
                    }
                    Item { height: 40; width: 1 }
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton
                onWheel: (wheel) => {
                    if (scrollView.contentHeight <= scrollView.height) {
                        return;
                    }
                    var scrollAmount = wheel.angleDelta.y / 2.5
                    var newContentY = scrollView.contentY - scrollAmount

                    if (newContentY < 0) {
                        newContentY = 0
                    } else if (newContentY > scrollView.contentHeight - scrollView.height) {
                        newContentY = scrollView.contentHeight - scrollView.height
                    }
                    scrollView.contentY = newContentY
                    wheel.accepted = true;
                }
            }
        }
    }

    Item {
        id: customScrollBar
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 18
        opacity: scrollView.contentHeight > scrollView.height ? 1 : 0
        visible: scrollView.contentHeight > scrollView.height

        Rectangle {
            id: scrollHandle
            anchors.horizontalCenter: parent.horizontalCenter
            width: 12
            height: Math.max(60, (customScrollBar.height) * (scrollView.height / Math.max(scrollView.contentHeight, 1)))
            radius: width / 2
            color: scrollHandleArea.containsMouse || scrollHandleArea.pressed ?
                   theme.accentColor : "#BABAC0"
            opacity: scrollHandleArea.containsMouse || scrollHandleArea.pressed ? 1.0 : 0.7

            Behavior on opacity { NumberAnimation { duration: 150 } }
            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on y {
                enabled: !scrollHandle.isDragging // Changed from !scrollHandleArea.pressed to use handle's dragging state
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutQuad
                }
            }

            property bool isDragging: false
            property real lastUpdateTime: 0
            property real scrollSpeed: 0
            property real dampingFactor: 0.95

            function updatePosition() {
                if (isDragging || scrollSpeed !== 0) {
                    return;
                }

                var scrollableHeight = scrollView.contentHeight - scrollView.height;
                var trackEffectiveHeight = customScrollBar.height - height;

                if (scrollableHeight <= 0 || trackEffectiveHeight <= 0.001) {
                    y = 0;
                } else {
                    var yPosition = (scrollView.contentY / scrollableHeight) * trackEffectiveHeight;
                    y = Math.max(0, Math.min(yPosition, trackEffectiveHeight));
                }
            }

            function smoothScroll() {
                var scrollableDist = scrollView.contentHeight - scrollView.height;
                if (Math.abs(scrollSpeed) > 0.5 && scrollableDist > 0) {
                    var now = Date.now();
                    var dt = Math.min((now - lastUpdateTime) / 1000.0, 0.033);
                    lastUpdateTime = now;

                    var newContentY = scrollView.contentY + (scrollSpeed * dt);
                    scrollSpeed *= dampingFactor;

                    var atTopBoundary = scrollSpeed < 0 && newContentY <= 0.5 && scrollView.contentY <= 0.5;
                    var atBottomBoundary = scrollSpeed > 0 && newContentY >= scrollableDist - 0.5 && scrollView.contentY >= scrollableDist - 0.5;

                    if (atTopBoundary || atBottomBoundary) {
                        newContentY = scrollSpeed > 0 || atBottomBoundary ? scrollableDist : 0;
                        scrollSpeed = 0;
                    } else if (newContentY < 0) {
                        newContentY = 0;
                        scrollSpeed = 0;
                    } else if (newContentY > scrollableDist) {
                        newContentY = scrollableDist;
                        scrollSpeed = 0;
                    }

                    if (scrollView.contentY !== newContentY) {
                       scrollView.contentY = newContentY;
                    } else if (Math.abs(scrollSpeed) <= 0.5) {
                       scrollSpeed = 0;
                    }

                    if (Math.abs(scrollSpeed) > 0.5) {
                        Qt.callLater(smoothScroll);
                    } else {
                        updatePosition();
                    }
                } else {
                    scrollSpeed = 0;
                    updatePosition();
                }
            }

            Connections {
                target: scrollView
                function onContentYChanged() { scrollHandle.updatePosition() }
                function onHeightChanged() { scrollHandle.updatePosition() }
                function onContentHeightChanged() { scrollHandle.updatePosition() }
            }
            Component.onCompleted: updatePosition()
        }

        MouseArea {
            id: scrollHandleArea
            anchors.fill: scrollHandle
            anchors.margins: -5
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            property real velocity: 0
            property real lastTime: 0
            property real scrollFactor: 0
            property real pressMouseYInParent: 0
            property real pressHandleY: 0
            property real lastGlobalMouseY: 0


            onPressed: (mouse) => {
                scrollHandle.isDragging = true;
                pressHandleY = scrollHandle.y;
                var mappedPoint = scrollHandleArea.mapToItem(customScrollBar, mouse.x, mouse.y);
                pressMouseYInParent = mappedPoint.y;
                lastGlobalMouseY = pressMouseYInParent;

                lastTime = Date.now();
                velocity = 0;

                if (customScrollBar.height - scrollHandle.height <= 0.001) {
                    scrollFactor = 0;
                } else {
                    scrollFactor = (scrollView.contentHeight - scrollView.height) / (customScrollBar.height - scrollHandle.height);
                }
                scrollFactor = Math.max(0, scrollFactor);
            }

            onReleased: () => {
                scrollHandle.isDragging = false;
                var currentTime = Date.now();

                if (scrollFactor > 0 && Math.abs(velocity) > 10) {
                    scrollHandle.scrollSpeed = velocity * scrollFactor * 0.6;
                    scrollHandle.lastUpdateTime = currentTime;
                    if (Math.abs(scrollHandle.scrollSpeed) > 1) {
                        scrollHandle.smoothScroll();
                    } else {
                         scrollHandle.updatePosition();
                    }
                } else {
                    scrollHandle.updatePosition();
                }
            }

            onPositionChanged: (mouse) => {
                if (scrollHandle.isDragging) { // Check scrollHandle's dragging state
                    var currentMouseInParent = scrollHandleArea.mapToItem(customScrollBar, mouse.x, mouse.y);

                    var totalMouseDragDistance = currentMouseInParent.y - pressMouseYInParent;
                    var newHandlePosition = pressHandleY + totalMouseDragDistance;

                    newHandlePosition = Math.max(0, Math.min(newHandlePosition, customScrollBar.height - scrollHandle.height));
                    scrollHandle.y = newHandlePosition;

                    var currentTime = Date.now();
                    var dt = Math.max(0.001, (currentTime - lastTime) / 1000.0);
                    var deltaGlobalMouseY = currentMouseInParent.y - lastGlobalMouseY;

                    velocity = 0.6 * velocity + 0.4 * (deltaGlobalMouseY / dt);

                    lastTime = currentTime;
                    lastGlobalMouseY = currentMouseInParent.y;

                    if (scrollFactor > 0) {
                        var contentPosition = newHandlePosition * scrollFactor;
                        scrollView.contentY = Math.max(0, Math.min(contentPosition, scrollView.contentHeight - scrollView.height));
                    } else if (!(scrollView.contentHeight > scrollView.height)) {
                        scrollView.contentY = 0;
                    }
                }
            }
        }

        MouseArea {
            id: scrollTrackArea
            anchors.fill: parent
            anchors.topMargin: scrollHandle.height / 2
            anchors.bottomMargin: scrollHandle.height / 2

            onClicked: (mouse) => {
                var newHandleY = mouse.y - scrollHandle.height / 2
                newHandleY = Math.max(0, Math.min(newHandleY, customScrollBar.height - scrollHandle.height))

                var contentRatio;
                if (customScrollBar.height - scrollHandle.height <= 0.001) {
                    contentRatio = 0;
                } else {
                    contentRatio = newHandleY / (customScrollBar.height - scrollHandle.height);
                }

                var targetContentY = contentRatio * (scrollView.contentHeight - scrollView.height)
                targetContentY = Math.max(0, Math.min(targetContentY, scrollView.contentHeight - scrollView.height))
                animateScrollTo(targetContentY)
            }

            function animateScrollTo(targetYPos) {
                var animation = Qt.createQmlObject(' \
                    import QtQuick 2.15 \
                    NumberAnimation { \
                        target: scrollView; \
                        property: "contentY"; \
                        to: 0; \
                        duration: 300; \
                        easing.type: Easing.OutCubic \
                    }', scrollTrackArea);
                animation.to = targetYPos;
                animation.start();
            }
        }
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    Connections {
        target: SettingsManager
        function onThemeIndexChanged() {
            theme.update()
        }
    }
}
