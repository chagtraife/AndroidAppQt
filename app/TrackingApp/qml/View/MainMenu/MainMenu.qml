import QtQuick 2.12
import QtQuick.Window 2.12
import "qrc:/guiComponent"
import QtQuick.Controls 2.13

Window {
    visible: true
    width: Screen.width //360
    height: Screen.height //640
    title: qsTr("Hello World")

    Rectangle {
        id: header
        anchors.top: parent.top
        width: parent.width
        height: 70
        color: "green"
        MouseArea {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            width: 60
            height: 60
            Image {
                id: optionIcon
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/resource/M_menu.png"
            }
            onClicked: {
                console.log("Option")
            }
        }
        Text {
            id: appName
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Tracking App")
            color: "white"
        }
    }
    Component.onCompleted: {
        console.log("Screen.width", Screen.width)
        console.log("Screen.height", Screen.height)
    }

    Item {
        id: conent
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Map {
            id: background
            anchors.fill: parent
        }

        Scope {
            id: scope
            anchors.centerIn: parent
            width: 100
            height: 100
        }
        Target {
            x: 200
            y: 100
        }
    }
}
