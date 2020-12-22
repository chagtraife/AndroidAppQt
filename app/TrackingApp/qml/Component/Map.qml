import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    anchors.fill: parent
    property int rMap: Math.max(parent.width, parent.height)
    property int numRound: 5
    property int rRound: rMap / (2 * numRound)
    RadialGradient {
        anchors.centerIn: parent
        height: parent.height
        width: parent.height
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "green"
            }
            GradientStop {
                position: 1
                color: "black" //"transparent"
            }
        }
    }

    Item {
        id: name
        anchors.centerIn: parent
        width: 2 * rRound * numRound
        height: 2 * rRound * numRound
        Canvas {
            id: kkk
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()

                var centerX = width / 2
                var centerY = height / 2
                var radius = width / 2

                // draw a radial gradient color
                var gradient = ctx.createConicalGradient(centerX, centerY,
                                                         0, centerX,
                                                         centerY, radius)
                gradient.addColorStop(0, 'green')
                gradient.addColorStop(0.1, 'transparent')
                ctx.fillStyle = gradient
                ctx.moveTo(centerX, centerY)
                ctx.arc(centerX, centerY, width / 2, 0, Math.PI * 2, false)
                ctx.lineTo(centerX, centerY)
                ctx.fill()
            }
        }
        RotationAnimator on rotation {
            loops: Animation.Infinite
            from: 0
            to: 360
            duration: 5000
        }
    }
    Repeater {
        id: round
        model: numRound
        Rectangle {
            anchors.centerIn: parent
            width: 2 * rRound * (index + 1)
            height: 2 * rRound * (index + 1)
            radius: rRound * (index + 1)
            border.color: "#32cd32"
            color: "transparent"
        }
    }
    Rectangle {
        id: verticalAxis
        anchors.centerIn: parent
        height: parent.height
        width: 1
        color: "#32cd32"
    }
    Rectangle {
        id: horizontalAxis
        anchors.centerIn: parent
        width: parent.width
        height: 1
        color: "#32cd32"
    }

    //    Component: Rectangle {
    //        id: scanRound
    //        anchors.centerIn: parent
    //        width: 2 * rRound * numRound
    //        height: 2 * rRound * numRound
    //        radius: rRound * numRound
    //        clip: true
    //    }
    //    ConicalGradient {
    //        //        anchors.centerIn: parent
    //        //        height: 2 * rRound * numRound
    //        //        width: 2 * rRound * numRound
    //        source: scanRound
    //        angle: 45.0
    //        gradient: Gradient {
    //            GradientStop {
    //                position: 0.0
    //                color: "green"
    //            }
    //            GradientStop {
    //                position: 1.0
    //                color: "transparent"
    //            }
    //        }
    //    }
}
