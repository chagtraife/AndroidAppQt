import QtQuick 2.0
import QtSensors 5.9
import "qrc:/guiComponent"

Item {
    id: conent
    anchors.fill: parent
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

    Compass {
        id: compass
        property int angle: 0
        // Turn on the sensor
        active: true
        onReadingChanged: {
            compass.angle = (reading.azimuth + 270) % 360
        }
        onAngleChanged: {
            scope.rotation = compass.angle
        }
    }
    Target {
        x: 200
        y: 100
    }
}
