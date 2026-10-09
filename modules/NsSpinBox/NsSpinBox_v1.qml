import QtQuick
import QtQuick.Controls

SpinBox {
    id: r
    width: fs*8+(fs*(''+r.value).length)//app.fs*8
    //property int wi: 100 //Ancho del espacio del dato
    // 1. Campo de texto interno (letra blanca)
    property int fs: 20
    contentItem: TextInput {
        height: r.fs*2
        text: r.textFromValue(r.value, r.locale)
        font.pixelSize: r.fs
        color: "white"
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        readOnly: !r.editable
        validator: r.validator
        inputMethodHints: r.inputMethodHints
    }

    // 2. Fondo y borde general del SpinBox
    background: Rectangle {
        width: r.width
        height: r.fs*2
        color: "transparent"
        border.color: "white"
        border.width: 1
        radius: 4
    }

    // 3. Botón de incremento (+)
    up.indicator: Rectangle {
        x: r.mirrored ? 0 : parent.width - width
        height: r.fs*2
        width: app.fs*4//height // Botón cuadrado
        color: r.up.pressed ? "#444444" : "transparent"
        border.color: "white"
        border.width: 1
        radius: 4
        anchors.verticalCenter: parent.verticalCenter
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
            font.pixelSize: r.fs
            anchors.centerIn: parent
        }
    }

    // 4. Botón de decremento (-)
    down.indicator: Rectangle {
        x: r.mirrored ? parent.width - width : 0
        height: r.fs*2
        width: app.fs*4//height // Botón cuadrado
        color: r.down.pressed ? "#444444" : "transparent"
        border.color: "white"
        border.width: 1
        radius: 4
        anchors.verticalCenter: parent.verticalCenter
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
            font.pixelSize: r.fs
            anchors.centerIn: parent
        }
    }


}
