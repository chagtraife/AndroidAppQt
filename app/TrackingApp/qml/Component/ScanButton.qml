import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    width: 100
    height: 100

    Rectangle {
        anchors.centerIn: parent
        width: 80
        height: 80
        color: "#801e90ff"
        radius: 40
    }

    Rectangle {
        anchors.centerIn: parent
        width: 90
        height: 90
        border.color: "#801e90ff"
        color: "transparent"
        radius: 45
    }

    Rectangle {
        anchors.centerIn: parent
        width: 100
        height: 100
        radius: 50
        border.color: "#801e90ff"
        color: "transparent"
    }
}
