import QtQuick 2.0
import QtGraphicalEffects 1.12

Item {
    width: 100
    height: 100
    Rectangle {
        anchors.centerIn: parent
        width: 10
        height: 10
        radius: 5
        color: "#800000ff"
    }
    Canvas {
        id: aa
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()

            var centerX = width / 2
            var centerY = height / 2
            var radius = width / 2

            //            // draw a radial gradient color
            //            var gradient = ctx.createRadialGradient(centreX, centreY, 0,
            //                                                    centreX, centreY, radius)
            //            gradient.addColorStop(0, 'blue')
            //            gradient.addColorStop(1, 'transparent')
            //            ctx.fillStyle = gradient
            //            ctx.arc(centreX, centreY, width, 0,
            //                    (Math.PI / parseFloat("4")), false)
            //            ctx.fill()
            ctx.beginPath()
            // move the cursor to the center
            ctx.moveTo(centerX, centerY)
            // add the arc including the line to the beginning of the arc
            ctx.arc(centerX, centerY, radius, -Math.PI / 8, Math.PI / 8, false)
            // add the line back to the center
            ctx.lineTo(centerX, centerY)
            // fill the piece
            var gradient = ctx.createRadialGradient(centerX, centerX, 0,
                                                    centerX, centerX, radius)
            gradient.addColorStop(0, 'blue')
            gradient.addColorStop(1, 'transparent')
            ctx.fillStyle = gradient
            ctx.fill()
        }
    }
}
