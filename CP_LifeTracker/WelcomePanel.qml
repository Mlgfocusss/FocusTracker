import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: welcomePanel
    color: "transparent"

    Theme {
        id: theme
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.03
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0.2, 0.4, 1.0, 0.15) }
            GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.08) }
            GradientStop { position: 0.7; color: Qt.rgba(1.0, 0.3, 0.8, 0.12) }
            GradientStop { position: 1.0; color: Qt.rgba(0.3, 1.0, 0.6, 0.18) }
        }
    }

    Canvas {
        id: floatingParticles
        anchors.fill: parent
        opacity: 0.12

        property var particles: []
        property int particleCount: 35

        Component.onCompleted: {
            for (var i = 0; i < particleCount; i++) {
                particles.push({
                    x: Math.random() * width,
                    y: Math.random() * height,
                    vx: (Math.random() - 0.5) * 0.4,
                    vy: (Math.random() - 0.5) * 0.4,
                    size: Math.random() * 3 + 1,
                    opacity: Math.random() * 0.8 + 0.2,
                    pulse: Math.random() * Math.PI * 2
                });
            }
            animationTimer.start();
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            for (var i = 0; i < particles.length; i++) {
                var p = particles[i];
                var alpha = p.opacity * (0.5 + 0.5 * Math.sin(p.pulse));

                ctx.fillStyle = Qt.rgba(1, 1, 1, alpha * 0.3);
                ctx.strokeStyle = Qt.rgba(1, 1, 1, alpha * 0.6);
                ctx.lineWidth = 1;

                ctx.beginPath();
                ctx.arc(p.x, p.y, p.size, 0, 2 * Math.PI);
                ctx.fill();
                ctx.stroke();
            }
        }

        Timer {
            id: animationTimer
            interval: 50
            repeat: true
            onTriggered: {
                for (var i = 0; i < floatingParticles.particles.length; i++) {
                    var p = floatingParticles.particles[i];
                    p.x += p.vx;
                    p.y += p.vy;
                    p.pulse += 0.05;

                    if (p.x < 0 || p.x > floatingParticles.width) p.vx *= -1;
                    if (p.y < 0 || p.y > floatingParticles.height) p.vy *= -1;
                }
                floatingParticles.requestPaint();
            }
        }
    }

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentColumn.height + 100
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: contentColumn
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 60
            width: Math.min(1000, parent.width * 0.92)
            y: 40

            Column {
                spacing: 40
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: 180
                    height: 180
                    radius: 90
                    anchors.horizontalCenter: parent.horizontalCenter

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.4) }
                        GradientStop { position: 0.3; color: Qt.rgba(0.8, 0.9, 1.0, 0.3) }
                        GradientStop { position: 0.7; color: Qt.rgba(1.0, 0.8, 0.9, 0.25) }
                        GradientStop { position: 1.0; color: Qt.rgba(0.9, 1.0, 0.8, 0.15) }
                    }

                    border.color: Qt.rgba(1, 1, 1, 0.7)
                    border.width: 3

                    Rectangle {
                        width: 140
                        height: 140
                        radius: 70
                        anchors.centerIn: parent
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.25) }
                            GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.15) }
                            GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.05) }
                        }
                        border.color: Qt.rgba(1, 1, 1, 0.4)
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            text: "🚀"
                            font.pixelSize: 70

                            SequentialAnimation on scale {
                                loops: Animation.Infinite
                                NumberAnimation { from: 1.0; to: 1.1; duration: 2000; easing.type: Easing.InOutSine }
                                NumberAnimation { from: 1.1; to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
                            }
                        }

                        NumberAnimation on rotation {
                            from: 0
                            to: 360
                            duration: 25000
                            loops: Animation.Infinite
                        }
                    }

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 15
                        radius: 30
                        samples: 61
                        color: Qt.rgba(0, 0, 0, 0.4)
                    }

                    SequentialAnimation on scale {
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 1.05; duration: 5000; easing.type: Easing.InOutSine }
                        NumberAnimation { from: 1.05; to: 1.0; duration: 5000; easing.type: Easing.InOutSine }
                    }
                }

                Column {
                    spacing: 25
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "FocusTracker"
                        font {
                            pixelSize: 90
                            bold: true
                            family: "Segoe UI, Arial, sans-serif"
                        }
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 6
                            verticalOffset: 12
                            radius: 24
                            samples: 49
                            color: Qt.rgba(0, 0, 0, 0.7)
                        }

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            NumberAnimation { from: 0.9; to: 1.0; duration: 3000; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 1.0; to: 0.9; duration: 3000; easing.type: Easing.InOutSine }
                        }
                    }

                    Rectangle {
                        width: 120
                        height: 8
                        radius: 4
                        anchors.horizontalCenter: parent.horizontalCenter
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: Qt.rgba(0.3, 0.7, 1.0, 0.8) }
                            GradientStop { position: 0.25; color: Qt.rgba(1.0, 0.4, 0.8, 0.9) }
                            GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 1.0) }
                            GradientStop { position: 0.75; color: Qt.rgba(0.8, 1.0, 0.4, 0.9) }
                            GradientStop { position: 1.0; color: Qt.rgba(1.0, 0.6, 0.3, 0.8) }
                        }

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0
                            verticalOffset: 4
                            radius: 8
                            samples: 17
                            color: Qt.rgba(0, 0, 0, 0.3)
                        }

                        SequentialAnimation on scale {
                            loops: Animation.Infinite
                            NumberAnimation { from: 1.0; to: 1.08; duration: 4000; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 1.08; to: 1.0; duration: 4000; easing.type: Easing.InOutSine }
                        }
                    }

                    Text {
                        text: qsTr("Превратите свою жизнь в увлекательное путешествие развития")
                        font {
                            pixelSize: 26
                            family: "Segoe UI, Arial, sans-serif"
                            weight: Font.Medium
                        }
                        color: Qt.rgba(1, 1, 1, 0.95)
                        anchors.horizontalCenter: parent.horizontalCenter
                        wrapMode: Text.WordWrap
                        width: Math.min(750, parent.parent.parent.width * 0.88)
                        horizontalAlignment: Text.AlignHCenter
                        lineHeight: 1.4

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 2
                            verticalOffset: 3
                            radius: 6
                            samples: 13
                            color: Qt.rgba(0, 0, 0, 0.3)
                        }
                    }
                }
            }

            Rectangle {
                width: Math.min(650, parent.width * 0.85)
                height: 8
                radius: 4
                anchors.horizontalCenter: parent.horizontalCenter
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.1; color: Qt.rgba(0.3, 0.7, 1.0, 0.3) }
                    GradientStop { position: 0.3; color: Qt.rgba(1.0, 0.4, 0.8, 0.5) }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.8) }
                    GradientStop { position: 0.7; color: Qt.rgba(0.8, 1.0, 0.4, 0.5) }
                    GradientStop { position: 0.9; color: Qt.rgba(1.0, 0.6, 0.3, 0.3) }
                    GradientStop { position: 1.0; color: "transparent" }
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 2
                    radius: 6
                    samples: 13
                    color: Qt.rgba(0, 0, 0, 0.2)
                }
            }

            Grid {
                columns: 2
                columnSpacing: 40
                rowSpacing: 40
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: [
                        { icon: "📊", title: "Умная Аналитика", desc: "Подробные графики прогресса и тенденций для отслеживания роста", color: Qt.rgba(0.2, 0.6, 1.0, 0.85) },
                        { icon: "🎯", title: "Привычки и Задачи", desc: "Создавайте и отслеживайте привычки и задачи", color: Qt.rgba(1.0, 0.4, 0.2, 0.85) },
                        { icon: "📝", title: "События и Заметки", desc: "Управляйте событиями и ведите заметки в едином пространстве", color: Qt.rgba(0.4, 0.8, 0.4, 0.85) },
                    ]

                    Rectangle {
                        width: 300
                        height: 220
                        radius: 30

                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.3) }
                            GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.2) }
                            GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.15) }
                            GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.08) }
                        }

                        border.color: Qt.rgba(1, 1, 1, 0.5)
                        border.width: 3

                        Rectangle {
                            width: parent.width - 12
                            height: parent.height - 12
                            radius: 24
                            anchors.centerIn: parent
                            color: "transparent"
                            border.color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.8)
                            border.width: 2
                            opacity: 0.7
                        }

                        Rectangle {
                            width: parent.width - 24
                            height: parent.height - 24
                            radius: 18
                            anchors.centerIn: parent
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.12) }
                                GradientStop { position: 0.5; color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.08) }
                                GradientStop { position: 1.0; color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.04) }
                            }
                            border.color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.3)
                            border.width: 1
                        }

                        Column {
                            anchors.centerIn: parent
                            spacing: 18
                            width: parent.width - 50

                            Rectangle {
                                width: 80
                                height: 80
                                radius: 40
                                anchors.horizontalCenter: parent.horizontalCenter
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.9) }
                                    GradientStop { position: 0.5; color: modelData.color }
                                    GradientStop { position: 1.0; color: Qt.rgba(modelData.color.r * 0.8, modelData.color.g * 0.8, modelData.color.b * 0.8, 1.0) }
                                }
                                border.color: Qt.rgba(1, 1, 1, 0.6)
                                border.width: 3

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.icon
                                    font.pixelSize: 36

                                    SequentialAnimation on scale {
                                        loops: Animation.Infinite
                                        NumberAnimation { from: 1.0; to: 1.1; duration: 2500; easing.type: Easing.InOutSine }
                                        NumberAnimation { from: 1.1; to: 1.0; duration: 2500; easing.type: Easing.InOutSine }
                                    }
                                }

                                layer.enabled: true
                                layer.effect: DropShadow {
                                    transparentBorder: true
                                    horizontalOffset: 0
                                    verticalOffset: 4
                                    radius: 12
                                    samples: 25
                                    color: Qt.rgba(0, 0, 0, 0.4)
                                }
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.title
                                font {
                                    pixelSize: 20
                                    bold: true
                                    family: "Segoe UI, Arial, sans-serif"
                                }
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter

                                layer.enabled: true
                                layer.effect: DropShadow {
                                    transparentBorder: true
                                    horizontalOffset: 2
                                    verticalOffset: 2
                                    radius: 4
                                    samples: 9
                                    color: Qt.rgba(0, 0, 0, 0.5)
                                }
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.desc
                                font {
                                    pixelSize: 14
                                    family: "Segoe UI, Arial, sans-serif"
                                }
                                color: Qt.rgba(1, 1, 1, 0.9)
                                wrapMode: Text.WordWrap
                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter
                                lineHeight: 1.35
                            }
                        }

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0
                            verticalOffset: 8
                            radius: 20
                            samples: 41
                            color: Qt.rgba(0, 0, 0, 0.25)
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                scaleAnimation.to = 1.06
                                scaleAnimation.start()
                            }
                            onExited: {
                                scaleAnimation.to = 1.0
                                scaleAnimation.start()
                            }

                            NumberAnimation {
                                id: scaleAnimation
                                target: parent
                                property: "scale"
                                duration: 300
                                easing.type: Easing.OutCubic
                            }
                        }

                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            NumberAnimation { from: 0.95; to: 1.0; duration: 4000; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 1.0; to: 0.95; duration: 4000; easing.type: Easing.InOutSine }
                        }
                    }
                }
            }

            Rectangle {
                width: Math.min(550, parent.width * 0.8)
                height: 6
                radius: 3
                anchors.horizontalCenter: parent.horizontalCenter
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.2; color: Qt.rgba(0.8, 0.4, 1.0, 0.4) }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.8) }
                    GradientStop { position: 0.8; color: Qt.rgba(0.4, 1.0, 0.8, 0.4) }
                    GradientStop { position: 1.0; color: "transparent" }
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 2
                    radius: 4
                    samples: 9
                    color: Qt.rgba(0, 0, 0, 0.2)
                }
            }

            Column {
                spacing: 35
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(650, parent.width * 0.92)

                Text {
                    text: qsTr("Почему выбирают LifeTracker?")
                    font {
                        pixelSize: 32
                        bold: true
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 3
                        verticalOffset: 4
                        radius: 8
                        samples: 17
                        color: Qt.rgba(0, 0, 0, 0.5)
                    }
                }

                Column {
                    spacing: 25
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width

                    Repeater {
                        model: [
                            { icon: "✨", text: qsTr("Красивый интуитивный интерфейс с 3 темами оформления"), color: Qt.rgba(0.8, 0.4, 1.0, 0.8) },
                            { icon: "📈", text: qsTr("Детальная статистика с подробнной аналитикой"), color: Qt.rgba(0.2, 0.8, 1.0, 0.8) },
                            { icon: "🌍", text: qsTr("Поддержка нескольких языков и гибкие настройки"), color: Qt.rgba(1.0, 0.6, 0.2, 0.8) },
                            { icon: "🔒", text: qsTr("Ваши данные в безопасности с шифрованием"), color: Qt.rgba(0.3, 1.0, 0.3, 0.8) }
                        ]

                        Rectangle {
                            width: parent.width
                            height: 85
                            radius: 25
                            anchors.horizontalCenter: parent.horizontalCenter

                            gradient: Gradient {
                                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.22) }
                                GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.15) }
                                GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.12) }
                                GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.06) }
                            }

                            border.color: Qt.rgba(1, 1, 1, 0.4)
                            border.width: 2

                            Rectangle {
                                width: parent.width - 8
                                height: parent.height - 8
                                radius: 21
                                anchors.centerIn: parent
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.1) }
                                    GradientStop { position: 0.5; color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.06) }
                                    GradientStop { position: 1.0; color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.03) }
                                }
                                border.color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.3)
                                border.width: 1
                            }

                            Row {
                                anchors.centerIn: parent
                                spacing: 25

                                Rectangle {
                                    width: 60
                                    height: 60
                                    radius: 30
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.9) }
                                        GradientStop { position: 0.5; color: modelData.color }
                                        GradientStop { position: 1.0; color: Qt.rgba(modelData.color.r * 0.8, modelData.color.g * 0.8, modelData.color.b * 0.8, 1.0) }
                                    }
                                    border.color: Qt.rgba(1, 1, 1, 0.7)
                                    border.width: 2

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.icon
                                        font.pixelSize: 28

                                        SequentialAnimation on rotation {
                                            loops: Animation.Infinite
                                            NumberAnimation { from: 0; to: 5; duration: 2000; easing.type: Easing.InOutSine }
                                            NumberAnimation { from: 5; to: -5; duration: 2000; easing.type: Easing.InOutSine }
                                            NumberAnimation { from: -5; to: 0; duration: 2000; easing.type: Easing.InOutSine }
                                        }
                                    }

                                    layer.enabled: true
                                    layer.effect: DropShadow {
                                        transparentBorder: true
                                        horizontalOffset: 0
                                        verticalOffset: 3
                                        radius: 8
                                        samples: 17
                                        color: Qt.rgba(0, 0, 0, 0.3)
                                    }
                                }

                                Text {
                                    text: modelData.text
                                    font {
                                        pixelSize: 16
                                        family: "Segoe UI, Arial, sans-serif"
                                        weight: Font.Medium
                                    }
                                    color: Qt.rgba(1, 1, 1, 0.95)
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.parent.width - 110
                                    wrapMode: Text.WordWrap
                                    lineHeight: 1.3
                                }
                            }

                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true
                                horizontalOffset: 0
                                verticalOffset: 4
                                radius: 12
                                samples: 25
                                color: Qt.rgba(0, 0, 0, 0.18)
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    hoverScaleAnimation.to = 1.03
                                    hoverScaleAnimation.start()
                                }
                                onExited: {
                                    hoverScaleAnimation.to = 1.0
                                    hoverScaleAnimation.start()
                                }

                                NumberAnimation {
                                    id: hoverScaleAnimation
                                    target: parent
                                    property: "scale"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                            }

                            SequentialAnimation on opacity {
                                loops: Animation.Infinite
                                NumberAnimation { from: 0.92; to: 1.0; duration: 5000; easing.type: Easing.InOutSine }
                                NumberAnimation { from: 1.0; to: 0.92; duration: 5000; easing.type: Easing.InOutSine }
                            }
                        }
                    }
                }
            }
        }
                       }
                    }
