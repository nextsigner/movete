import QtQuick

Rectangle{
    id: r
    color: apps.backgroundColor
    anchors.fill: parent
    visible: false
    Column{
        anchors.centerIn: parent
        Text{
            text: "Agregar Actividad"
            font.pixelSize: app.fs
            color: 'white'
        }
        Flow{
            id: flow
            spacing: app.fs*0.5
            width: r.width
            Repeater{
                model:['abdominales', 'sentadillas', 'flexiones', 'hidratarse']
                Rectangle{
                    id: xAct
                    width: app.fs*6
                    height: width
                    border.width: selected?3:1
                    border.color: selected?'red':'white'
                    property bool selected: false
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            xAct.selected=!xAct.selected
                        }
                    }
                }
            }

        }
    }
}
