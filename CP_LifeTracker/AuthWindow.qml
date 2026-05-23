import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: authPanel
    anchors.fill: parent
    color: "transparent"

    signal loginAttempt(string username, string password, bool rememberMe)
    signal registerAttempt(string username, string email, string password)

    property bool isLoginMode: true
    property string errorMessage: ""

    function showError(message) {
        errorMessage = message
        errorTimer.restart()
    }

    Timer {
        id: errorTimer
        interval: 5000
        onTriggered: errorMessage = ""
    }

    Theme {
        id: theme
    }

    Rectangle {
        anchors.fill: parent
        radius: 0
        clip: true
        color: theme.backgroundColor

        Rectangle {
            anchors.fill: parent
            opacity: 0.03
            gradient: Gradient {
                GradientStop { position: 0.0; color: theme.accentColor }
                GradientStop { position: 1.0; color: theme.textColor }
            }
        }

        Canvas {
            id: backgroundPattern
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                ctx.strokeStyle = Qt.rgba(theme.accentColor.r, theme.accentColor.g, theme.accentColor.b, 0.05);
                ctx.lineWidth = 1;

                var size = 60;
                for (var x = 0; x < width + size; x += size) {
                    for (var y = 0; y < height + size; y += size) {
                        ctx.beginPath();
                        ctx.arc(x, y, 1, 0, 2 * Math.PI);
                        ctx.stroke();
                    }
                }
            }
        }

        Rectangle {
            width: 120
            height: 120
            radius: 60
            color: theme.cardColor
            border.color: theme.accentColor
            border.width: 2
            anchors {
                right: parent.right
                top: parent.top
                margins: 60
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 4
                radius: 8.0
                samples: 17
                color: theme.shadowColor
            }

            Text {
                anchors.centerIn: parent
                text: "💼"
                font.pixelSize: 48
            }

            NumberAnimation on rotation {
                from: 0
                to: 360
                duration: 25000
                loops: Animation.Infinite
            }
        }

        Rectangle {
            width: 80
            height: 80
            radius: 40
            color: theme.cardColor
            border.color: theme.accentColor
            border.width: 2
            anchors {
                left: parent.left
                bottom: parent.bottom
                margins: 80
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 4
                radius: 8.0
                samples: 17
                color: theme.shadowColor
            }

            Text {
                anchors.centerIn: parent
                text: "📈"
                font.pixelSize: 32
            }

            NumberAnimation on rotation {
                from: 360
                to: 0
                duration: 20000
                loops: Animation.Infinite
            }
        }

        Row {
            anchors.fill: parent
            spacing: 0

            WelcomePanel {
                id: leftPanel
                width: parent.width * 0.6
                height: parent.height
            }

            AuthForm {
                id: rightPanel
                width: parent.width * 0.4
                height: parent.height
                isLoginMode: authPanel.isLoginMode
                errorMessage: authPanel.errorMessage

                onLoginAttempt: function(username, password, rememberMe) {
                    authPanel.loginAttempt(username, password, rememberMe)
                }

                onRegisterAttempt: function(username, email, password) {
                    authPanel.registerAttempt(username, email, password)
                }

                onModeChanged: function(loginMode) {
                    authPanel.isLoginMode = loginMode
                    authPanel.errorMessage = ""
                }
            }
        }
    }
}
