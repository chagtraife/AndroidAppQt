import QtQuick 2.12
import QtQuick.Window 2.2
import "qrc:/guiComponent"
import QtQuick.Controls 2.12

Item {
    visible: true
    anchors.fill: parent
    property int currentIndexPage: 0

    TitleBar {
        id: titleBar
        currentIndex: currentIndexPage
    }

    Loader {
        id: pageLoader
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        source: currentIndexPage === 0 ? "Connect.qml" : "Tracking.qml"
    }

    Keys.onReleased: {
        switch (event.key) {
        case Qt.Key_Escape:
        case Qt.Key_Back:
        {
            if (currentIndexPage > 0) {
                currentIndexPage--
                event.accepted = true
            } else {
                Qt.quit()
            }
            break
        }
        default:
            break
        }
    }
    BluetoothAlarmDialog {
        id: btAlarmDialog
        anchors.fill: parent
        visible: !connectionHandler.alive
    }
}
