import QtQuick 2.5
import "qrc:/guiComponent"

Item {
    id: root
    anchors.fill: parent

    property bool appIsReady: false
    property bool splashIsReady: false

    property bool ready: appIsReady && splashIsReady
    onReadyChanged: if (ready)
                        readyToGo()

    signal readyToGo

    function appReady() {
        appIsReady = true
    }

    function errorInLoadingApp() {
        Qt.quit()
    }

    Image {
        anchors.centerIn: parent
        width: Math.min(parent.height, parent.width) * 0.6
        height: AppSettings.heightForWidth(width, sourceSize)
        source: "qrc:/resource/logo.png"
    }

    Timer {
        id: splashTimer
        interval: 1000
        onTriggered: splashIsReady = true
    }

    Component.onCompleted: splashTimer.start()
}
