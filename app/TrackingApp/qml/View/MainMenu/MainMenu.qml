import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Rectangle{
        id: aaa
        x: 50
        y: 50
        width: 200
        height: 200
        color: "red"
    }

}
