import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: customComboBoxRoot
    property alias model: comboBox.model
    property alias currentIndex: comboBox.currentIndex
    property alias currentText: comboBox.currentText
    property color borderColorNormal: theme.inputBorderColor
    property color borderColorFocused: theme.inputBorderFocusColor
    property color bgColorNormal: theme.inputBackgroundColor
    property color dropdownBgColor: theme.cardColor
    property int popupHeight: 200

    Theme {
        id: theme
    }

    property color textColor: theme.inputTextColor
    property color textColorDim: theme.textSecondaryColor
    property color bgColor: theme.cardColor
    property color bgColorDarker: theme.backgroundSecondaryColor
    property color accentColor: theme.accentColor

    width: 200
    height: 40
    radius: 8
    color: customComboBoxRoot.bgColorNormal
    border.width: 1
    border.color: comboBox.activeFocus ? customComboBoxRoot.borderColorFocused : customComboBoxRoot.borderColorNormal

    Behavior on border.color {
        ColorAnimation { duration: 150 }
    }

    layer.enabled: true
    layer.effect: DropShadow {
        horizontalOffset: 0
        verticalOffset: 1
        radius: 4.0
        samples: 9
        color: theme.shadowColor
        transparentBorder: true
    }

    Rectangle {
        id: blurBackground
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"

        layer.enabled: true
        layer.effect: FastBlur {
            radius: 40
            transparentBorder: true
        }
    }

    ComboBox {
        id: comboBox
        anchors.fill: parent

        background: Rectangle {
            color: "transparent"
        }

        contentItem: Text {
            leftPadding: 12
            rightPadding: 36
            text: comboBox.displayText
            font.pixelSize: 14
            font.weight: Font.Medium
            color: textColor
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        indicator: Item {
            x: comboBox.width - width - 8
            y: (comboBox.height - height) / 2
            width: 24
            height: 24

            Rectangle {
                anchors.centerIn: parent
                width: 22
                height: 22
                radius: 11
                color: comboBox.pressed ?
                    Qt.alpha(customComboBoxRoot.borderColorFocused, 0.2) :
                    "transparent"

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            Text {
                anchors.centerIn: parent
                text: "▼"
                font.pixelSize: 10
                color: comboBox.pressed ?
                    customComboBoxRoot.borderColorFocused :
                    textColorDim

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
        }

        popup: Popup {
            y: comboBox.height + 2
            width: comboBox.width
            implicitHeight: Math.min(contentItem.implicitHeight + 2, customComboBoxRoot.popupHeight)
            padding: 1

            contentItem: ListView {
                id: listView
                clip: true
                implicitHeight: contentHeight
                model: comboBox.popup.visible ? comboBox.delegateModel : null
                currentIndex: comboBox.highlightedIndex

                Item {
                    id: customScrollBar
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 12
                    opacity: listView.contentHeight > listView.height ? 1 : 0

                    Behavior on opacity {
                        NumberAnimation { duration: 200 }
                    }

                    Rectangle {
                        id: scrollHandle
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 8
                        height: Math.max(20, (parent.height - 8) * (listView.height / Math.max(listView.contentHeight, 1)) / 2)
                        radius: width / 2
                        color: scrollHandleArea.containsMouse || scrollHandleArea.pressed ? customComboBoxRoot.borderColorFocused : textColorDim
                        opacity: scrollHandleArea.containsMouse || scrollHandleArea.pressed ? 0.8 : 0.4

                        Behavior on opacity {
                            NumberAnimation { duration: 150 }
                        }

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }

                        function updatePosition() {
                            if (!scrollHandleArea.pressed) {
                                var yPosition = 4 + (listView.contentY / Math.max(listView.contentHeight - listView.height, 1)) * (customScrollBar.height - 8 - height)
                                y = Math.max(4, Math.min(yPosition, customScrollBar.height - 4 - height))
                            }
                        }

                        Connections {
                            target: listView
                            function onContentYChanged() { scrollHandle.updatePosition() }
                            function onHeightChanged() { scrollHandle.updatePosition() }
                            function onContentHeightChanged() { scrollHandle.updatePosition() }
                        }

                        Component.onCompleted: updatePosition()
                    }

                    MouseArea {
                        id: scrollTrackArea
                        anchors.fill: parent
                        onClicked: {
                            var newContentY = (mouseY - scrollHandle.height/2) / (parent.height - 8 - scrollHandle.height) * (listView.contentHeight - listView.height)
                            listView.contentY = Math.max(0, Math.min(newContentY, listView.contentHeight - listView.height))
                        }
                    }

                    MouseArea {
                        id: scrollHandleArea
                        anchors.fill: scrollHandle
                        anchors.margins: -4
                        hoverEnabled: true
                        drag.target: scrollHandle
                        drag.axis: Drag.YAxis
                        drag.minimumY: 4
                        drag.maximumY: customScrollBar.height - 4 - scrollHandle.height

                        onPositionChanged: {
                            if (pressed) {
                                var contentRatio = (scrollHandle.y - 4) / (customScrollBar.height - 8 - scrollHandle.height)
                                listView.contentY = contentRatio * (listView.contentHeight - listView.height)
                            }
                        }
                    }
                }
            }

            background: Rectangle {
                color: customComboBoxRoot.dropdownBgColor
                border.color: customComboBoxRoot.borderColorNormal
                border.width: 1
                radius: 8

                Rectangle {
                    id: popupBlurBackground
                    anchors.fill: parent
                    radius: parent.radius
                    color: "transparent"

                    layer.enabled: true
                    layer.effect: FastBlur {
                        radius: 60
                        transparentBorder: true
                    }
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 3
                    radius: 8.0
                    samples: 17
                    color: theme.shadowColor
                    transparentBorder: true
                }
            }
        }

        delegate: ItemDelegate {
            width: comboBox.width
            height: 36

            contentItem: Text {
                text: modelData
                color: textColor
                font.pixelSize: 14
                font.weight: comboBox.currentIndex === index ? Font.Medium : Font.Normal
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                leftPadding: 12
            }

            highlighted: comboBox.highlightedIndex === index

            background: Rectangle {
                color: highlighted ?
                    Qt.alpha(customComboBoxRoot.borderColorFocused, 0.15) :
                    "transparent"
                radius: 4

                Rectangle {
                    width: 3
                    height: parent.height * 0.6
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 1.5
                    color: customComboBoxRoot.borderColorFocused
                    visible: comboBox.currentIndex === index
                }
            }
        }
    }
}
