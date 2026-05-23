import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects

Item {
    id: accountTab

    property bool isAuthenticated: AuthManager.isAuthenticated
    property string currentUser: AuthManager.currentUsername
    property string userEmail: ""
    property string userAvatar: ""
    property string membershipDuration: "8 дней"
    property string accountType: "Стандарт"
    property bool editingName: false

    Component.onCompleted: {
        if (isAuthenticated) {
            loadUserData()
        } else {
            AuthManager.showAuthWindow()
        }
    }

    function loadUserData() {
        profileImage.source = userAvatar || ""
        profileInitials.visible = !userAvatar

        if (currentUser) {
            const nameParts = currentUser.split(" ")
            if (nameParts.length >= 2) {
                profileInitials.text = nameParts[0][0] + nameParts[1][0]
            } else {
                profileInitials.text = currentUser.substring(0, 2).toUpperCase()
            }
            userName.text = currentUser
            nameEditField.text = currentUser
            userEmailText.text = userEmail || "email@example.com"
        }
    }

    onIsAuthenticatedChanged: {
        if (!isAuthenticated) {
            AuthManager.showAuthWindow()
        } else {
            loadUserData()
        }
    }

    FileDialog {
        id: avatarFileDialog
        title: "Выберите фото для аватарки"
        nameFilters: ["Изображения (*.jpg *.jpeg *.png)"]
        onAccepted: {
            userAvatar = fileUrl.toString()
            profileImage.source = userAvatar
            profileInitials.visible = false
        }
    }

    Dialog {
        id: changePasswordDialog
        anchors.centerIn: parent
        width: 450
        height: 350
        modal: true
        title: "Изменить пароль"

        background: Rectangle {
            color: bgColor
            radius: 20
            border.width: 1
            border.color: Qt.rgba(255, 255, 255, 0.15)
            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 20
                radius: 40.0
                samples: 41
                color: "#40000000"
                transparentBorder: true
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 25

            Text {
                text: "Изменение пароля"
                color: textColor
                font.pixelSize: 24
                font.weight: Font.Bold
                Layout.alignment: Qt.AlignHCenter
            }

            ColumnLayout {
                spacing: 20
                Layout.fillWidth: true

                TextField {
                    id: currentPasswordField
                    Layout.fillWidth: true
                    placeholderText: "Текущий пароль"
                    echoMode: TextInput.Password
                    height: 45
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, 0.05)
                        border.color: parent.activeFocus ? accentColor : Qt.rgba(255, 255, 255, 0.1)
                        border.width: 2
                        radius: 12
                    }
                    color: textColor
                    font.pixelSize: 16
                    leftPadding: 15
                    rightPadding: 15
                }

                TextField {
                    id: newPasswordField
                    Layout.fillWidth: true
                    placeholderText: "Новый пароль"
                    echoMode: TextInput.Password
                    height: 45
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, 0.05)
                        border.color: parent.activeFocus ? accentColor : Qt.rgba(255, 255, 255, 0.1)
                        border.width: 2
                        radius: 12
                    }
                    color: textColor
                    font.pixelSize: 16
                    leftPadding: 15
                    rightPadding: 15
                }

                TextField {
                    id: confirmPasswordField
                    Layout.fillWidth: true
                    placeholderText: "Подтвердите новый пароль"
                    echoMode: TextInput.Password
                    height: 45
                    background: Rectangle {
                        color: Qt.rgba(255, 255, 255, 0.05)
                        border.color: parent.activeFocus ? accentColor : Qt.rgba(255, 255, 255, 0.1)
                        border.width: 2
                        radius: 12
                    }
                    color: textColor
                    font.pixelSize: 16
                    leftPadding: 15
                    rightPadding: 15
                }
            }

            RowLayout {
                spacing: 15
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 20

                CustomRectButton {
                    text: "Отмена"
                    width: 120
                    height: 45
                    buttonColor: Qt.rgba(255, 255, 255, 0.1)
                    textColor: textColor
                    onClicked: {
                        changePasswordDialog.close()
                        currentPasswordField.text = ""
                        newPasswordField.text = ""
                        confirmPasswordField.text = ""
                    }
                }

                CustomRectButton {
                    text: "Изменить"
                    width: 120
                    height: 45
                    enabled: currentPasswordField.text.length > 0 &&
                            newPasswordField.text.length >= 6 &&
                            newPasswordField.text === confirmPasswordField.text
                    onClicked: {
                        console.log("Изменение пароля...")
                        changePasswordDialog.close()
                        currentPasswordField.text = ""
                        newPasswordField.text = ""
                        confirmPasswordField.text = ""
                    }
                }
            }
        }
    }

    Dialog {
        id: confirmLogoutDialog
        anchors.centerIn: parent
        width: 400
        height: 250
        modal: true
        title: "Подтверждение выхода"

        background: Rectangle {
            color: bgColor
            radius: 20
            border.width: 1
            border.color: Qt.rgba(255, 255, 255, 0.15)
            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0
                verticalOffset: 20
                radius: 40.0
                samples: 41
                color: "#40000000"
                transparentBorder: true
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 25

            Text {
                text: "🚪"
                font.pixelSize: 48
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Выйти из аккаунта?"
                color: textColor
                font.pixelSize: 20
                font.weight: Font.Bold
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Вы уверены, что хотите выйти из аккаунта?"
                color: textColorDim
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }

            RowLayout {
                spacing: 15
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 20

                CustomRectButton {
                    text: "Отмена"
                    width: 120
                    height: 45
                    buttonColor: Qt.rgba(255, 255, 255, 0.1)
                    textColor: textColor
                    onClicked: confirmLogoutDialog.close()
                }

                CustomRectButton {
                    text: "Выйти"
                    width: 120
                    height: 45
                    buttonColor: "#e74c3c"
                    onClicked: {
                        AuthManager.logout()
                        confirmLogoutDialog.close()
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(bgColor.r, bgColor.g, bgColor.b, 1.0) }
            GradientStop { position: 0.3; color: Qt.rgba(bgColor.r, bgColor.g, bgColor.b, 0.98) }
            GradientStop { position: 1.0; color: Qt.rgba(bgColor.r, bgColor.g, bgColor.b, 0.95) }
        }
    }

    Flickable {
        anchors.fill: parent
        anchors.margins: 32
        contentWidth: width
        contentHeight: accountColumn.height + 100
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: accountColumn
            width: parent.width
            spacing: 32

            Rectangle {
                Layout.fillWidth: true
                height: profileSection.height + 48
                color: Qt.rgba(255, 255, 255, 0.08)
                radius: 20
                border.width: 1
                border.color: Qt.rgba(255, 255, 255, 0.12)

                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(255, 255, 255, 0.05) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 12
                    radius: 28.0
                    samples: 32
                    color: "#18000000"
                    transparentBorder: true
                }

                ColumnLayout {
                    id: profileSection
                    anchors.centerIn: parent
                    width: parent.width - 48
                    spacing: 28

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 40

                        Rectangle {
                            id: avatarContainer
                            width: 120
                            height: 120
                            radius: 60

                            gradient: Gradient {
                                GradientStop { position: 0.0; color: Qt.lighter(accentColor, 1.3) }
                                GradientStop { position: 0.5; color: accentColor }
                                GradientStop { position: 1.0; color: Qt.darker(accentColor, 1.2) }
                            }

                            layer.enabled: true
                            layer.effect: DropShadow {
                                horizontalOffset: 0
                                verticalOffset: 8
                                radius: 24.0
                                samples: 32
                                color: "#35000000"
                                transparentBorder: true
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: "transparent"
                                border.width: 2
                                border.color: Qt.rgba(255, 255, 255, 0.25)
                            }

                            Image {
                                id: profileImage
                                anchors.fill: parent
                                anchors.margins: 2
                                fillMode: Image.PreserveAspectCrop
                                visible: status === Image.Ready
                                layer.enabled: true
                                layer.effect: OpacityMask {
                                    maskSource: Rectangle {
                                        width: profileImage.width
                                        height: profileImage.height
                                        radius: profileImage.width / 2
                                        visible: false
                                    }
                                }
                            }

                            Text {
                                id: profileInitials
                                anchors.centerIn: parent
                                text: "ПИ"
                                color: "white"
                                font.pixelSize: 48
                                font.weight: Font.Bold
                                style: Text.Raised
                                styleColor: "#50000000"
                            }

                            Rectangle {
                                id: uploadButton
                                width: 40
                                height: 40
                                radius: 20
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                anchors.rightMargin: -2
                                anchors.bottomMargin: -2

                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.lighter(bgColor, 1.2) }
                                    GradientStop { position: 1.0; color: bgColor }
                                }

                                border.width: 2
                                border.color: Qt.rgba(255, 255, 255, 0.2)

                                layer.enabled: true
                                layer.effect: DropShadow {
                                    horizontalOffset: 0
                                    verticalOffset: 4
                                    radius: 12.0
                                    samples: 16
                                    color: "#45000000"
                                    transparentBorder: true
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "📷"
                                    font.pixelSize: 18
                                }

                                PropertyAnimation {
                                    id: uploadButtonHover
                                    target: uploadButton
                                    property: "scale"
                                    duration: 200
                                    easing.type: Easing.OutBack
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: {
                                        uploadButtonHover.to = 1.15
                                        uploadButtonHover.start()
                                    }
                                    onExited: {
                                        uploadButtonHover.to = 1.0
                                        uploadButtonHover.start()
                                    }
                                    onClicked: avatarFileDialog.open()

                                    ToolTip {
                                        visible: parent.containsMouse
                                        text: "Загрузить аватарку"
                                        delay: 300
                                    }
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 16

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 16

                                Text {
                                    id: userName
                                    text: "Загрузка..."
                                    color: textColor
                                    font.pixelSize: 32
                                    font.weight: Font.Bold
                                    style: Text.Raised
                                    styleColor: "#25000000"
                                    visible: !editingName
                                }

                                TextField {
                                    id: nameEditField
                                    visible: editingName
                                    font.pixelSize: 32
                                    font.weight: Font.Bold
                                    color: textColor
                                    Layout.fillWidth: true

                                    background: Rectangle {
                                        color: Qt.rgba(255, 255, 255, 0.1)
                                        border.color: parent.activeFocus ? accentColor : Qt.rgba(255, 255, 255, 0.2)
                                        border.width: 2
                                        radius: 8
                                    }

                                    onAccepted: {
                                        if (text.length > 0) {
                                            userName.text = text
                                            currentUser = text
                                            editingName = false
                                            loadUserData()
                                        }
                                    }

                                    Keys.onEscapePressed: {
                                        text = userName.text
                                        editingName = false
                                    }
                                }

                                RoundButton {
                                    id: editNameButton
                                    flat: true
                                    width: 36
                                    height: 36
                                    text: editingName ? "✓" : "✏️"

                                    contentItem: Text {
                                        text: parent.text
                                        font.pixelSize: 14
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    background: Rectangle {
                                        radius: width/2
                                        color: parent.hovered ? Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.25) : "transparent"
                                        border.width: parent.hovered ? 1 : 0
                                        border.color: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.5)

                                        Behavior on color {
                                            ColorAnimation { duration: 200 }
                                        }
                                    }

                                    onClicked: {
                                        if (editingName) {
                                            if (nameEditField.text.length > 0) {
                                                userName.text = nameEditField.text
                                                currentUser = nameEditField.text
                                                editingName = false
                                                loadUserData()
                                            }
                                        } else {
                                            editingName = true
                                            nameEditField.text = userName.text
                                            nameEditField.forceActiveFocus()
                                        }
                                    }

                                    ToolTip {
                                        visible: parent.hovered
                                        text: editingName ? "Сохранить имя" : "Редактировать имя"
                                        delay: 300
                                    }
                                }
                            }

                            Text {
                                id: userEmailText
                                text: "Загрузка..."
                                color: textColorDim
                                font.pixelSize: 18
                                font.weight: Font.Medium
                            }

                            Item { height: 12; width: 1 }

                            RowLayout {
                                spacing: 12

                                Rectangle {
                                    width: 12
                                    height: 12
                                    radius: 6

                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: Qt.lighter(activeItemColor, 1.4) }
                                        GradientStop { position: 1.0; color: activeItemColor }
                                    }

                                    layer.enabled: true
                                    layer.effect: DropShadow {
                                        horizontalOffset: 0
                                        verticalOffset: 2
                                        radius: 6.0
                                        samples: 12
                                        color: "#70000000"
                                        transparentBorder: true
                                    }

                                    SequentialAnimation on opacity {
                                        running: true
                                        loops: Animation.Infinite
                                        NumberAnimation { to: 0.6; duration: 1500 }
                                        NumberAnimation { to: 1.0; duration: 1500 }
                                    }
                                }

                                Text {
                                    text: "Активный аккаунт"
                                    color: activeItemColor
                                    font.pixelSize: 16
                                    font.weight: Font.Bold
                                }

                                Rectangle {
                                    width: 4
                                    height: 4
                                    radius: 2
                                    color: textColorDim
                                }

                                Text {
                                    text: "С нами уже:"
                                    color: textColorDim
                                    font.pixelSize: 16
                                }

                                Text {
                                    text: membershipDuration
                                    color: accentColor
                                    font.pixelSize: 16
                                    font.weight: Font.Bold
                                }
                            }

                            Rectangle {
                                width: 140
                                height: 36
                                radius: 18

                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.25) }
                                    GradientStop { position: 1.0; color: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.15) }
                                }

                                border.width: 1
                                border.color: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.5)

                                RowLayout {
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Text {
                                        text: "👤"
                                        font.pixelSize: 16
                                    }

                                    Text {
                                        text: accountType
                                        color: accentColor
                                        font.pixelSize: 14
                                        font.weight: Font.Bold
                                    }
                                }
                            }
                        }
                    }
                }
            }

            SettingSection {
                id: securitySection
                title: "Безопасность аккаунта"
                icon: "🔒"
                description: "Управление настройками безопасности и доступа"

                Rectangle {
                    Layout.fillWidth: true
                    height: passwordRow.height + 32
                    color: Qt.rgba(255, 255, 255, 0.04)
                    radius: 16
                    border.width: 1
                    border.color: Qt.rgba(255, 255, 255, 0.08)
                    Layout.topMargin: 20

                    RowLayout {
                        id: passwordRow
                        anchors.centerIn: parent
                        width: parent.width - 32
                        spacing: 24

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            RowLayout {
                                spacing: 10

                                Text {
                                    text: "Пароль"
                                    color: textColor
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                }

                                Rectangle {
                                    width: 10
                                    height: 10
                                    radius: 5
                                    color: "#f39c12"

                                    SequentialAnimation on opacity {
                                        running: true
                                        loops: Animation.Infinite
                                        NumberAnimation { to: 0.4; duration: 1000 }
                                        NumberAnimation { to: 1.0; duration: 1000 }
                                    }
                                }
                            }

                            Text {
                                text: "Последнее изменение 30 дней назад"
                                color: "#f39c12"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                            }
                        }

                        CustomRectButton {
                            text: "Изменить пароль"
                            width: 180
                            height: 44
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            onClicked: changePasswordDialog.open()
                        }
                    }
                }
            }

            SettingSection {
                id: accountDataSection
                title: "Управление аккаунтом"
                icon: "⚙️"
                description: "Основные действия с вашим аккаунтом"

                Rectangle {
                    Layout.fillWidth: true
                    height: deleteRow.height + 32
                    color: Qt.rgba(231, 76, 60, 0.08)
                    radius: 16
                    border.width: 1
                    border.color: Qt.rgba(231, 76, 60, 0.25)
                    Layout.topMargin: 20

                    RowLayout {
                        id: deleteRow
                        anchors.centerIn: parent
                        width: parent.width - 32
                        spacing: 24

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: "Удаление аккаунта"
                                color: textColor
                                font.pixelSize: 18
                                font.weight: Font.Bold
                            }

                            Text {
                                text: "Полное удаление аккаунта и всех данных"
                                color: textColorDim
                                font.pixelSize: 14
                            }
                        }

                        CustomRectButton {
                            text: "Удалить аккаунт"
                            width: 160
                            height: 44
                            buttonColor: "#e74c3c"
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            onClicked: console.log("Удаление аккаунта...")
                        }
                    }
                }
            }

            SettingSection {
                id: logoutSection
                title: "Выход из аккаунта"
                icon: "🚪"
                description: "Завершить сеанс работы"

                Rectangle {
                    Layout.fillWidth: true
                    height: logoutRow.height + 32
                    color: Qt.rgba(255, 255, 255, 0.04)
                    radius: 16
                    border.width: 1
                    border.color: Qt.rgba(255, 255, 255, 0.08)
                    Layout.topMargin: 20

                    RowLayout {
                        id: logoutRow
                        anchors.centerIn: parent
                        width: parent.width - 32
                        spacing: 24

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                text: "Выйти из аккаунта"
                                color: textColor
                                font.pixelSize: 18
                                font.weight: Font.Bold
                            }

                            Text {
                                text: "Завершить текущий сеанс работы"
                                color: textColorDim
                                font.pixelSize: 14
                            }
                        }

                        CustomRectButton {
                            text: "Выйти"
                            width: 120
                            height: 44
                            buttonColor: Qt.rgba(255, 255, 255, 0.1)
                            textColor: textColor
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            onClicked: confirmLogoutDialog.open()
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: infoColumn.height + 32
                color: Qt.rgba(255, 255, 255, 0.04)
                radius: 16
                border.width: 1
                border.color: Qt.rgba(255, 255, 255, 0.08)
                Layout.topMargin: 20

                ColumnLayout {
                    id: infoColumn
                    anchors.centerIn: parent
                    width: parent.width - 32
                    spacing: 16

                    Text {
                        text: "ℹ️ Информация об аккаунте"
                        color: textColor
                        font.pixelSize: 18
                        font.weight: Font.Bold
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text {
                            text: "ID аккаунта:"
                            color: textColorDim
                            font.pixelSize: 14
                        }

                        Text {
                            text: "#" + Math.floor(Math.random() * 1000000).toString().padStart(6, '0')
                            color: textColor
                            font.pixelSize: 14
                            font.weight: Font.Medium
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text {
                            text: "Дата регистрации:"
                            color: textColorDim
                            font.pixelSize: 14
                        }

                        Text {
                            text: new Date().toLocaleDateString('ru-RU')
                            color: textColor
                            font.pixelSize: 14
                            font.weight: Font.Medium
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: Qt.rgba(255, 255, 255, 0.1)
                        Layout.topMargin: 8
                        Layout.bottomMargin: 8
                    }

                    Text {
                        text: "Спасибо, что пользуетесь нашим сервисом! 💙"
                        color: accentColor
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }

    component SettingSection: ColumnLayout {
        property string title: ""
        property string icon: ""
        property string description: ""

        Layout.fillWidth: true
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            Text {
                text: icon
                font.pixelSize: 24
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: title
                    color: textColor
                    font.pixelSize: 22
                    font.weight: Font.Bold
                }

                Text {
                    text: description
                    color: textColorDim
                    font.pixelSize: 16
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Qt.rgba(255, 255, 255, 0.1)
        }
    }
}
