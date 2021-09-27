import QtQuick 2.12
import QtQuick.Window 2.2
import "qrc:/guiComponent"
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

import QtSensors 5.9

Window {
    id: wroot
    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("TrackingApp")
    color: AppSettings.backgroundColor

    Component.onCompleted: {
        AppSettings.wWidth = Qt.binding(function () {
            return width
        })
        AppSettings.wHeight = Qt.binding(function () {
            return height
        })
    }

    Loader {
        id: splashLoader
        anchors.fill: parent
        source: "SplashScreen.qml"
        visible: true
        onStatusChanged: {
            if (status === Loader.Ready) {
                appLoader.setSource("MainMenu.qml")
            }
        }
    }

    Connections {
        target: splashLoader.item
        onReadyToGo: {
            appLoader.visible = true
            splashLoader.visible = false
            splashLoader.setSource("")
            appLoader.item.forceActiveFocus()
        }
    }
    Loader {
        id: appLoader
        anchors.fill: parent
        visible: false
        onStatusChanged: {
            if (status === Loader.Ready)
                splashLoader.item.appReady()
            if (status === Loader.Error)
                splashLoader.item.errorInLoadingApp()
        }
    }
}
