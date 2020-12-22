import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    width: 40
    height: 40
    RadialGradient {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "red"
            }
            GradientStop {
                position: 0.5
                color: "transparent"
            }
        }
    }
}
