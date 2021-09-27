import QtQuick 2.5
import Shared 1.0
import "qrc:/guiComponent"

Item {
    Rectangle {
        id: viewContainer
        anchors.top: parent.top
        anchors.bottom: connectionHandler.requiresAddressType ? addressTypeButton.top : searchButton.top
        anchors.topMargin: AppSettings.fieldMargin
        anchors.bottomMargin: AppSettings.fieldMargin
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - AppSettings.fieldMargin * 2
        color: AppSettings.viewColor
        radius: AppSettings.buttonRadius

        Text {
            id: title
            width: parent.width
            height: AppSettings.fieldHeight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: AppSettings.textColor
            font.pixelSize: AppSettings.mediumFontSize
            text: qsTr("FOUND DEVICES")

            BottomLine {
                height: 1
                width: parent.width
                color: "#898989"
            }
        }

        ListView {
            id: devices
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: title.bottom
            model: deviceFinder.devices
            clip: true

            delegate: Rectangle {
                id: box
                height: AppSettings.fieldHeight * 1.2
                width: parent.width
                color: index % 2 === 0 ? AppSettings.delegate1Color : AppSettings.delegate2Color

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        deviceFinder.connectToService(modelData.deviceAddress)
                        //enter tracking
                        currentIndexPage = 1
                    }
                }

                Text {
                    id: device
                    font.pixelSize: AppSettings.smallFontSize
                    text: modelData.deviceName
                    anchors.top: parent.top
                    anchors.topMargin: parent.height * 0.1
                    anchors.leftMargin: parent.height * 0.1
                    anchors.left: parent.left
                    color: AppSettings.textColor
                }

                Text {
                    id: deviceAddress
                    font.pixelSize: AppSettings.smallFontSize
                    text: modelData.deviceAddress
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.1
                    anchors.rightMargin: parent.height * 0.1
                    anchors.right: parent.right
                    color: Qt.darker(AppSettings.textColor)
                }
            }
        }
    }

    Button {
        id: addressTypeButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: searchButton.top
        anchors.bottomMargin: AppSettings.fieldMargin * 0.5
        width: viewContainer.width
        height: AppSettings.fieldHeight
        visible: connectionHandler.requiresAddressType // only required on BlueZ
        state: "public"
        onClicked: state == "public" ? state = "random" : state = "public"

        states: [
            State {
                name: "public"
                PropertyChanges {
                    target: addressTypeText
                    text: qsTr("Public Address")
                }
                PropertyChanges {
                    target: deviceHandler
                    addressType: AddressType.PublicAddress
                }
            },
            State {
                name: "random"
                PropertyChanges {
                    target: addressTypeText
                    text: qsTr("Random Address")
                }
                PropertyChanges {
                    target: deviceHandler
                    addressType: AddressType.RandomAddress
                }
            }
        ]

        Text {
            id: addressTypeText
            anchors.centerIn: parent
            font.pixelSize: AppSettings.tinyFontSize
            color: AppSettings.textColor
        }
    }

    Button {
        id: searchButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: AppSettings.fieldMargin
        width: viewContainer.width
        height: AppSettings.fieldHeight
        enabled: !deviceFinder.scanning
        onClicked: deviceFinder.startSearch()

        Text {
            anchors.centerIn: parent
            font.pixelSize: AppSettings.tinyFontSize
            text: searchButton.enabled ? qsTr("START SEARCH") : qsTr(
                                             "Scanning for device")
            color: searchButton.enabled ? AppSettings.textColor : AppSettings.disabledTextColor
        }
    }
}
