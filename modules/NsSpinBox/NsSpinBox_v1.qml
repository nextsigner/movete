import QtQuick
import QtQuick.Controls

SpinBox {
    id: r
    width: app.fs*8
    property int wi: 100 //Ancho del espacio del dato
    // 1. Campo de texto interno (letra blanca)
    contentItem: TextInput {
        width: r.wi
        text: r.textFromValue(r.value, r.locale)
        font.pixelSize: app.fs*2
        color: "white"
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        readOnly: !r.editable
        validator: r.validator
        inputMethodHints: r.inputMethodHints
    }

    // 2. Fondo y borde general del SpinBox
    background: Rectangle {
        color: "transparent"
        border.color: "white"
        border.width: 1
        radius: 4
    }

    // 3. Botón de incremento (+)
    up.indicator: Rectangle {
        x: r.mirrored ? 0 : parent.width - width
        height: app.fs*4//parent.height
        width: app.fs*4//height // Botón cuadrado
        color: r.up.pressed ? "#444444" : "transparent"
        border.color: "white"
        border.width: 1
        radius: 4
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(r.value<r.to){
                    r.value++
                }
            }
        }

        Text {
            text: "+"
            color: "white"
            font.pixelSize: app.fs * 2//1.2
            anchors.centerIn: parent
        }
    }

    // 4. Botón de decremento (-)
    down.indicator: Rectangle {
        x: r.mirrored ? parent.width - width : 0
        height: app.fs*4//parent.height
        width: app.fs*4//height // Botón cuadrado
        color: r.down.pressed ? "#444444" : "transparent"
        border.color: "white"
        border.width: 1
        radius: 4
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(r.value>1){
                    r.value--
                }
            }
        }

        Text {
            text: "-"
            color: "white"
            font.pixelSize: app.fs * 2//1.2
            anchors.centerIn: parent
        }
    }


}
