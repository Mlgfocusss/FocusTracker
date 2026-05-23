import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    property string title: "Section Title"
    property string description: "Section Description"
    property string icon: "🔧"

    Layout.fillWidth: true
    implicitHeight: sectionColumn.implicitHeight

    default property alias content: contentContainer.children

    ColumnLayout {
        id: sectionColumn
        width: parent.width
        spacing: 15

        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Rectangle {
                width: 40
                height: 40
                radius: 10
                color: bgColorDarker
                border.color: borderColor
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: icon
                    font.pixelSize: 16
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: title
                    color: textColor
                    font.pixelSize: 18
                    font.weight: Font.Bold
                }

                Text {
                    text: description
                    color: textColorDim
                    font.pixelSize: 14
                }
            }
        }

        Item {
            id: contentContainer
            Layout.fillWidth: true
            implicitHeight: childrenRect.height
        }
    }
}
