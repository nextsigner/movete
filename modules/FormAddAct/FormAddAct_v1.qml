import QtQuick

Rectangle{
    id: r
    color: apps.backgroundColor
    anchors.fill: parent
    visible: false
    property string cAct: ''
    Column{
        spacing: app.fs
        anchors.centerIn: parent
        Text{
            text: "Agregar Actividad"
            font.pixelSize: app.fs
            color: 'white'
        }
        Flow{
            id: flow
            spacing: app.fs
            width: r.width
            Repeater{
                model:['abdominales', 'sentadillas', 'flexiones', 'hidratarse']
                Rectangle{
                    id: xAct
                    width: app.fs*6
                    height: width
                    color: 'black'
                    border.width: selected?4:1
                    border.color: selected?'red':'white'
                    opacity: selected?1.0:0.75
                    property bool selected: false
                    property string act: modelData
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            //xAct.selected=!xAct.selected
                            updateSel(xAct.act)
                        }
                    }
                    Image{
                        width: parent.height*0.9
                        height: width
                        source: 'file:./imgs/'+modelData+'.jpeg'
                        anchors.centerIn: parent
                    }
                }
            }

        }
    }
    function updateSel(act){
        for(var i=0;i<flow.children.length;i++){
            if(flow.children[i].act===act){
                flow.children[i].selected=true
            }else{
                flow.children[i].selected=false
            }
        }
    }
}
