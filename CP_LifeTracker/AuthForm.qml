import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: authForm

    property bool isLoginMode: true
    property string errorMessage: ""

    signal loginAttempt(string username, string password, bool rememberMe)
    signal registerAttempt(string username, string email, string password)
    signal modeChanged(bool loginMode)
    signal settingsClicked()
    signal helpClicked()

    Theme {
        id: theme
    }

    color: theme.backgroundColor
    focus: true

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.03) }
            GradientStop { position: 0.5; color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.01) }
            GradientStop { position: 1.0; color: Qt.rgba(theme.backgroundColor.r, theme.backgroundColor.g, theme.backgroundColor.b, 1.0) }
        }
    }

    Canvas {
        id: backgroundElements
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            ctx.fillStyle = Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.02);
            for (var i = 0; i < 25; i++) {
                var x = Math.random() * width;
                var y = Math.random() * height;
                var size = Math.random() * 3 + 1;
                ctx.beginPath();
                ctx.arc(x, y, size, 0, 2 * Math.PI);
                ctx.fill();
            }

            ctx.strokeStyle = Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.05);
            ctx.lineWidth = 1;
            for (var j = 0; j < 8; j++) {
                var startX = Math.random() * width;
                var startY = Math.random() * height;
                var endX = Math.random() * width;
                var endY = Math.random() * height;
                ctx.beginPath();
                ctx.moveTo(startX, startY);
                ctx.lineTo(endX, endY);
                ctx.stroke();
            }
        }
    }

    Rectangle {
        anchors {
            top: parent.top
            right: parent.right
            margins: 20
        }
        width: 90
        height: 40
        radius: 20
        color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.08)
        border.color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.2)
        border.width: 1
        z: 100

        Row {
            anchors.centerIn: parent
            spacing: 6

            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: helpButtonArea.containsMouse ? Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.15) : "transparent"
                border.color: theme.accentColor
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "?"
                    font.pixelSize: 20
                    font.bold: true
                    color: theme.accentColor
                }

                MouseArea {
                    id: helpButtonArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: authForm.helpClicked()
                }

                Behavior on color { ColorAnimation { duration: 200 } }

                ToolTip {
                    id: helpTooltip
                    text: qsTr("Get help and support")
                    visible: helpButtonArea.containsMouse
                    delay: 500
                }
            }

            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: settingsButtonArea.containsMouse ? Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.15) : "transparent"
                border.color: theme.accentColor
                border.width: 2

                Text {
                    anchors.centerIn: parent
                    text: "⚙"
                    font.pixelSize: 16
                    color: theme.accentColor
                }

                MouseArea {
                    id: settingsButtonArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: authForm.settingsClicked()
                }

                Behavior on color { ColorAnimation { duration: 200 } }

                ToolTip {
                    id: settingsTooltip
                    text: qsTr("Open application settings")
                    visible: settingsButtonArea.containsMouse
                    delay: 500
                }
            }
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: 40
        }
        spacing: 40

        Column {
            Layout.alignment: Qt.AlignHCenter
            spacing: 32

            Rectangle {
                width: 140
                height: 140
                radius: 70
                anchors.horizontalCenter: parent.horizontalCenter
                gradient: Gradient {
                    GradientStop { position: 0.0; color: theme.cardColor }
                    GradientStop { position: 1.0; color: Qt.darker(theme.cardColor, 1.1) }
                }
                border.color: theme.accentColor
                border.width: 3

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 15
                    radius: 25.0
                    samples: 51
                    color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.4)
                }

                Rectangle {
                    width: 100
                    height: 100
                    radius: 50
                    anchors.centerIn: parent
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: theme.accentColor }
                        GradientStop { position: 1.0; color: Qt.darker(theme.accentColor, 1.3) }
                    }

                    Rectangle {
                        width: 80
                        height: 80
                        radius: 40
                        anchors.centerIn: parent
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.lighter(theme.accentColor, 1.1) }
                            GradientStop { position: 1.0; color: theme.accentColor }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: isLoginMode ? "🔐" : "🚀"
                            font.pixelSize: 38
                        }
                    }
                }

                Rectangle {
                    width: 20
                    height: 20
                    radius: 10
                    color: theme.accentColor
                    anchors {
                        top: parent.top
                        right: parent.right
                        topMargin: 10
                        rightMargin: 15
                    }
                    opacity: 0.6
                }

                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: theme.accentColor
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        bottomMargin: 20
                        leftMargin: 10
                    }
                    opacity: 0.4
                }
            }

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12

                Text {
                    text: isLoginMode ? qsTr("Welcome Back") : qsTr("Join LifeTracker")
                    font {
                        pixelSize: 36
                        bold: true
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: theme.textColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    width: 60
                    height: 4
                    radius: 2
                    color: theme.accentColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: 0.7
                }

                Text {
                    text: isLoginMode ? qsTr("Continue your transformation journey") : qsTr("Start your journey to better habits")
                    font {
                        pixelSize: 18
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: theme.textSecondaryColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    width: Math.min(400, authForm.width * 0.8)
                }
            }
        }

        Column {
            Layout.fillWidth: true
            spacing: 20

            TextField {
                id: usernameField
                width: parent.width
                placeholderText: qsTr("Username")
                font {
                    pixelSize: 17
                    family: "Segoe UI, Arial, sans-serif"
                }
                selectByMouse: true
                leftPadding: 65
                rightPadding: 25
                topPadding: 20
                bottomPadding: 20

                background: Rectangle {
                    radius: 14
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: theme.inputBackgroundColor }
                        GradientStop { position: 1.0; color: Qt.darker(theme.inputBackgroundColor, 1.02) }
                    }
                    border.color: parent.focus ? theme.accentColor : theme.inputBorderColor
                    border.width: parent.focus ? 3 : 1
                    implicitHeight: 60

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: parent.focus ? 6 : 3
                        radius: parent.focus ? 12.0 : 6.0
                        samples: parent.focus ? 25 : 13
                        color: parent.focus ? Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.4) : theme.shadowColor
                    }

                    Rectangle {
                        width: 42
                        height: 42
                        radius: 21
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: theme.cardSelectedColor }
                            GradientStop { position: 1.0; color: Qt.darker(theme.cardSelectedColor, 1.1) }
                        }
                        border.color: theme.accentColor
                        border.width: 2
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            margins: 9
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "👤"
                            font.pixelSize: 20
                        }
                    }
                }

                color: theme.inputTextColor
                placeholderTextColor: theme.inputPlaceholderColor
            }

            TextField {
                id: emailField
                width: parent.width
                placeholderText: qsTr("Email Address")
                font {
                    pixelSize: 17
                    family: "Segoe UI, Arial, sans-serif"
                }
                selectByMouse: true
                leftPadding: 65
                rightPadding: 25
                topPadding: 20
                bottomPadding: 20
                visible: !isLoginMode
                height: !isLoginMode ? 60 : 0
                opacity: !isLoginMode ? 1.0 : 0.0

                Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
                Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }

                background: Rectangle {
                    radius: 14
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: theme.inputBackgroundColor }
                        GradientStop { position: 1.0; color: Qt.darker(theme.inputBackgroundColor, 1.02) }
                    }
                    border.color: parent.focus ? theme.accentColor : theme.inputBorderColor
                    border.width: parent.focus ? 3 : 1
                    implicitHeight: 60

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: parent.focus ? 6 : 3
                        radius: parent.focus ? 12.0 : 6.0
                        samples: parent.focus ? 25 : 13
                        color: parent.focus ? Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.4) : theme.shadowColor
                    }

                    Rectangle {
                        width: 42
                        height: 42
                        radius: 21
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: theme.cardSelectedColor }
                            GradientStop { position: 1.0; color: Qt.darker(theme.cardSelectedColor, 1.1) }
                        }
                        border.color: theme.accentColor
                        border.width: 2
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            margins: 9
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "📧"
                            font.pixelSize: 20
                        }
                    }
                }

                color: theme.inputTextColor
                placeholderTextColor: theme.inputPlaceholderColor
            }

            TextField {
                id: passwordField
                width: parent.width
                placeholderText: qsTr("Password")
                font {
                    pixelSize: 17
                    family: "Segoe UI, Arial, sans-serif"
                }
                selectByMouse: true
                echoMode: showPasswordButton.passwordVisible ? TextInput.Normal : TextInput.Password
                leftPadding: 65
                rightPadding: 60
                topPadding: 20
                bottomPadding: 20

                background: Rectangle {
                    radius: 14
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: theme.inputBackgroundColor }
                        GradientStop { position: 1.0; color: Qt.darker(theme.inputBackgroundColor, 1.02) }
                    }
                    border.color: parent.focus ? theme.accentColor : theme.inputBorderColor
                    border.width: parent.focus ? 3 : 1
                    implicitHeight: 60

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: parent.focus ? 6 : 3
                        radius: parent.focus ? 12.0 : 6.0
                        samples: parent.focus ? 25 : 13
                        color: parent.focus ? Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.4) : theme.shadowColor
                    }

                    Rectangle {
                        width: 42
                        height: 42
                        radius: 21
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: theme.cardSelectedColor }
                            GradientStop { position: 1.0; color: Qt.darker(theme.cardSelectedColor, 1.1) }
                        }
                        border.color: theme.accentColor
                        border.width: 2
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            margins: 9
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "🔒"
                            font.pixelSize: 20
                        }
                    }

                    Rectangle {
                        id: showPasswordButton
                        width: 34
                        height: 34
                        radius: 17
                        color: passwordVisible ? theme.accentColor : theme.cardSelectedColor
                        border.color: passwordVisible ? Qt.darker(theme.accentColor, 1.1) : theme.accentColor
                        border.width: 2
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            margins: 13
                        }

                        property bool passwordVisible: false

                        Rectangle {
                            width: 16
                            height: 16
                            radius: showPasswordButton.passwordVisible ? 0 : 8
                            color: showPasswordButton.passwordVisible ? "transparent" : theme.buttonTextLightColor
                            anchors.centerIn: parent
                            border.color: theme.buttonTextLightColor
                            border.width: showPasswordButton.passwordVisible ? 2 : 0

                            Behavior on radius { NumberAnimation { duration: 200 } }
                            Behavior on color { ColorAnimation { duration: 200 } }
                            Behavior on border.width { NumberAnimation { duration: 200 } }
                        }

                        MouseArea {
                            id: showPasswordArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: showPasswordButton.passwordVisible = !showPasswordButton.passwordVisible
                        }

                        Behavior on color {
                            ColorAnimation { duration: 250 }
                        }

                        ToolTip {
                            visible: showPasswordArea.containsMouse
                            text: showPasswordButton.passwordVisible ? qsTr("Hide password") : qsTr("Show password")
                            delay: 500
                        }
                    }
                }

                color: theme.inputTextColor
                placeholderTextColor: theme.inputPlaceholderColor
            }

            Rectangle {
                width: parent.width
                height: 56
                color: "transparent"
                visible: isLoginMode
                opacity: isLoginMode ? 1.0 : 0.0

                Behavior on opacity { NumberAnimation { duration: 400 } }

                Rectangle {
                    width: parent.width
                    height: 56
                    radius: 14
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: rememberMeArea.containsMouse || rememberMeCheckBox.checked ? Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.08) : "transparent" }
                        GradientStop { position: 1.0; color: rememberMeArea.containsMouse || rememberMeCheckBox.checked ? Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.12) : "transparent" }
                    }
                    border.color: rememberMeCheckBox.checked ? theme.accentColor : Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.3)
                    border.width: rememberMeCheckBox.checked ? 2 : 1

                    Behavior on border.color { ColorAnimation { duration: 250 } }

                    MouseArea {
                        id: rememberMeArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: rememberMeCheckBox.checked = !rememberMeCheckBox.checked
                    }

                    Row {
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            margins: 16
                        }
                        spacing: 16

                        Rectangle {
                            width: 38
                            height: 38
                            radius: 6
                            gradient: Gradient {
                                GradientStop {
                                    position: 0.0
                                    color: rememberMeCheckBox.checked ? theme.accentColor : theme.cardColor
                                }
                                GradientStop {
                                    position: 1.0
                                    color: rememberMeCheckBox.checked ? Qt.darker(theme.accentColor, 1.3) : Qt.darker(theme.cardColor, 1.1)
                                }
                            }
                            border.color: rememberMeCheckBox.checked ? Qt.darker(theme.accentColor, 1.1) : theme.inputBorderColor
                            border.width: 3
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.centerIn: parent
                                text: "✓"
                                font {
                                    pixelSize: 18
                                    bold: true
                                }
                                color: theme.buttonTextLightColor
                                visible: rememberMeCheckBox.checked
                                scale: rememberMeCheckBox.checked ? 1.0 : 0.0
                                Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
                            }
                        }

                        Text {
                            text: qsTr("Remember me")
                            font {
                                pixelSize: 16
                                bold: true
                                family: "Segoe UI, Arial, sans-serif"
                            }
                            color: theme.textColor
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    CheckBox {
                        id: rememberMeCheckBox
                        anchors.fill: parent
                        opacity: 0
                    }
                }
            }
        }

        Column {
            Layout.fillWidth: true
            spacing: 16

            Rectangle {
                width: parent.width
                height: 64
                radius: 16
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: mainButtonArea.pressed ? Qt.darker(theme.accentColor, 1.4) : theme.accentColor
                    }
                    GradientStop {
                        position: 0.5
                        color: mainButtonArea.pressed ? Qt.darker(theme.accentColor, 1.3) : Qt.lighter(theme.accentColor, 1.1)
                    }
                    GradientStop {
                        position: 1.0
                        color: mainButtonArea.pressed ? Qt.darker(theme.accentColor, 1.6) : Qt.darker(theme.accentColor, 1.2)
                    }
                }
                border.color: Qt.darker(theme.accentColor, 1.2)
                border.width: 2

                Rectangle {
                    width: parent.width - 6
                    height: parent.height - 6
                    radius: 13
                    anchors.centerIn: parent
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.1) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 12

                    Text {
                        text: isLoginMode ? "🚪" : "🎯"
                        font.pixelSize: 24
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: isLoginMode ? qsTr("Sign In") : qsTr("Create Account")
                        font {
                            pixelSize: 19
                            bold: true
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: theme.buttonTextLightColor
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: mainButtonArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (isLoginMode) {
                            authForm.loginAttempt(usernameField.text, passwordField.text, rememberMeCheckBox.checked)
                        } else {
                            authForm.registerAttempt(usernameField.text, emailField.text, passwordField.text)
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 60
                radius: 15
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: secondaryButtonArea.pressed ? Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.15) : Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.05)
                    }
                    GradientStop {
                        position: 0.5
                        color: secondaryButtonArea.pressed ? Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.12) : Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.08)
                    }
                    GradientStop {
                        position: 1.0
                        color: secondaryButtonArea.pressed ? Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.18) : Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.03)
                    }
                }
                border.color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.4)
                border.width: 2

                Rectangle {
                    width: parent.width - 4
                    height: parent.height - 4
                    radius: 13
                    anchors.centerIn: parent
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.05) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }

                Behavior on border.color { ColorAnimation { duration: 200 } }

                Row {
                    anchors.centerIn: parent
                    spacing: 12

                    Text {
                        text: isLoginMode ? "✨" : "🔙"
                        font.pixelSize: 22
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: isLoginMode ? qsTr("Create New Account") : qsTr("Back to Sign In")
                        font {
                            pixelSize: 17
                            bold: true
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: theme.accentColor
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    id: secondaryButtonArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        authForm.modeChanged(!isLoginMode)
                        usernameField.text = ""
                        emailField.text = ""
                        passwordField.text = ""
                        rememberMeCheckBox.checked = false
                        showPasswordButton.passwordVisible = false
                    }
                }
            }
        }
    }

    Rectangle {
        id: errorNotification
        width: parent.width - 80
        height: errorMessage !== "" ? 90 : 0
        radius: 16
        gradient: Gradient {
            GradientStop { position: 0.0; color: theme.buttonDangerColor }
            GradientStop { position: 0.5; color: Qt.lighter(theme.buttonDangerColor, 1.1) }
            GradientStop { position: 1.0; color: Qt.darker(theme.buttonDangerColor, 1.3) }
        }
        opacity: errorMessage !== "" ? 1.0 : 0.0
        visible: opacity > 0
        border.color: Qt.darker(theme.buttonDangerColor, 1.4)
        border.width: 3
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 40
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 8
            radius: 16.0
            samples: 33
            color: Qt.rgba(theme.buttonDangerColor.r, theme.buttonDangerColor.g, theme.buttonDangerColor.b, 0.6)
        }

        Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
        Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }

        Rectangle {
            width: parent.width - 6
            height: parent.height - 6
            radius: 13
            anchors.centerIn: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.1) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Row {
            anchors.centerIn: parent
            spacing: 16

            Text {
                text: "⚠️"
                font.pixelSize: 24
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: errorMessage
                font {
                    pixelSize: 16
                    bold: true
                    family: "Segoe UI, Arial, sans-serif"
                }
                color: theme.buttonTextLightColor
                anchors.verticalCenter: parent.verticalCenter
                wrapMode: Text.WordWrap
                width: Math.min(280, errorNotification.width - 80)
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
                       onClicked: authForm.errorMessage = ""
                   }
               }

               Keys.onPressed: {
                   if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                       if (isLoginMode) {
                           authForm.loginAttempt(usernameField.text, passwordField.text, rememberMeCheckBox.checked)
                       } else {
                           authForm.registerAttempt(usernameField.text, emailField.text, passwordField.text)
                       }
                       event.accepted = true
                   } else if (event.key === Qt.Key_Escape) {
                       authForm.errorMessage = ""
                       event.accepted = true
                   }
               }

               Timer {
                   id: errorTimer
                   interval: 5000
                   repeat: false
                   onTriggered: authForm.errorMessage = ""
               }

               onErrorMessageChanged: {
                   if (errorMessage !== "") {
                       errorTimer.restart()
                   } else {
                       errorTimer.stop()
                   }
               }

               Component.onCompleted: {
                   usernameField.forceActiveFocus()
               }
            }
