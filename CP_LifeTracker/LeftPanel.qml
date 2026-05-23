import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: leftPanel
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            width: 400
            height: 400
            radius: 200
            color: Qt.rgba(255, 255, 255, 0.1)
            anchors {
                centerIn: parent
                horizontalCenterOffset: -100
                verticalCenterOffset: -50
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 8
                radius: 25
                samples: 51
                color: Qt.rgba(0, 0, 0, 0.15)
            }
        }

        Rectangle {
            width: 280
            height: 280
            radius: 140
            color: Qt.rgba(255, 255, 255, 0.08)
            anchors {
                centerIn: parent
                horizontalCenterOffset: 120
                verticalCenterOffset: 80
            }
        }

        Column {
            anchors {
                centerIn: parent
                verticalCenterOffset: -80
            }
            spacing: 30

            Rectangle {
                width: 140
                height: 140
                radius: 70
                color: Qt.rgba(255, 255, 255, 0.2)
                border.color: Qt.rgba(255, 255, 255, 0.4)
                border.width: 3
                anchors.horizontalCenter: parent.horizontalCenter

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 6
                    radius: 18
                    samples: 37
                    color: Qt.rgba(0, 0, 0, 0.2)
                }

                Text {
                    anchors.centerIn: parent
                    text: "📊"
                    font.pixelSize: 60
                }
            }

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                Text {
                    text: qsTr("LifeTracker")
                    font {
                        pixelSize: 48
                        bold: true
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: "#ffffff"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: qsTr("Track • Analyze • Improve")
                    font {
                        pixelSize: 20
                        family: "Segoe UI, Arial, sans-serif"
                        letterSpacing: 2
                    }
                    color: Qt.rgba(255, 255, 255, 0.9)
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Column {
            anchors {
                bottom: parent.bottom
                left: parent.left
                margins: 60
            }
            spacing: 24

            Row {
                spacing: 16

                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: "#4ade80"

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 6
                        samples: 13
                        color: Qt.rgba(74, 222, 128, 0.5)
                    }
                }

                Text {
                    text: qsTr("Secure & Private")
                    font {
                        pixelSize: 16
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: Qt.rgba(255, 255, 255, 0.9)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                spacing: 16

                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: "#60a5fa"

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 6
                        samples: 13
                        color: Qt.rgba(96, 165, 250, 0.5)
                    }
                }

                Text {
                    text: qsTr("Cross-Platform Sync")
                    font {
                        pixelSize: 16
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: Qt.rgba(255, 255, 255, 0.9)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                spacing: 16

                Rectangle {
                    width: 12
                    height: 12
                    radius: 6
                    color: "#f59e0b"

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 6
                        samples: 13
                        color: Qt.rgba(245, 158, 11, 0.5)
                    }
                }

                Text {
                    text: qsTr("Advanced Analytics")
                    font {
                        pixelSize: 16
                        family: "Segoe UI, Arial, sans-serif"
                    }
                    color: Qt.rgba(255, 255, 255, 0.9)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
