import QtQuick
import QtQuick.Controls
import NsSpinBox 1.0
Rectangle {
    id: r
    color: apps.backgroundColor
    anchors.fill: parent
    visible: false

    property int fs: app.fs*1.5

    property int d: -1
    property int m: -1
    property int a: -1

    // Guardamos la actividad seleccionada y su índice para evitar recorrer el Flow
    property string cAct: ''
    property int selectedIndex: -1
    property int cActIdSelected: -1

    property int altoBotones: ((r.width-app.fs*0.5)-(flow.spacing*(cantCols-1)))/cantCols
    property int cantCols: 2
    property var j//: ({})

    onJChanged: {
        r.cActIdSelected=r.j.id
        r.cAct=r.j.data.actividad
        //log.text+='r.cActIdSelected: '+r.cActIdSelected
        //log.text+='r.cAct: '+r.cAct
        //log.text+='JSON 2: '+JSON.stringify(r.j, null, 2)
        actualizar()
        r.visible=true
    }
    onVisibleChanged: {
        if (!visible) {
            r.cAct = ''
            r.selectedIndex = -1
        }else{
            //repActsDeFecha
        }
    }
    Column {
        id: mainColumn
        spacing: app.fs
        anchors.centerIn: parent
        width: parent.width * 0.9 // Evitamos desbordamientos

        Text {
            text: "Actividades del día: "+r.d+'/'+r.m+'/'+r.a
            font.pixelSize: r.fs
            color: 'white'
        }
        Flickable{
            width: r.width-app.fs*0.5
            height: app.fs*20
            contentWidth: width
            contentHeight: flow.height
            clip: true
            Flow {
                id: flow
                spacing: app.fs//*0.25
                width: r.width-app.fs*0.5

                Repeater {
                    id: repActsDeFecha
                    delegate: Rectangle {
                        id: xAct
                        //width: app.fs * 6
                        width: r.altoBotones
                        height: colFlow.height+app.fs//width
                        color: 'black'

                        // Usamos r.selectedIndex en lugar de buscar en children
                        property bool selected: (r.selectedIndex === index)
                        property var j: JSON.parse(modelData)

                        border.width: selected ? 4 : 1
                        border.color: selected ? 'red' : 'white'
                        opacity: selected ? 1.0 : 0.75

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                r.selectedIndex = index
                                r.cAct = (""+xAct.j.data.actividad).replace('.jpeg', '')
                                r.j=xAct.j
                                //log.text+='Id seleccionado: '+xAct.j.id+'<br>'
                            }
                        }
                        Column{
                            id: colFlow
                            anchors.centerIn: parent
                            Image {
                                id: img1
                                width: parent.parent.width*0.9//height * 0.9
                                height: width
                                //source: 'file:./imgs/' + modelData
                                source: 'file:./imgs/'+xAct.j.data.actividad+'.jpeg'
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text{
                                text: "<b>"+(""+modelData).toUpperCase().replace('.JPEG', '').replace(/_/g, ' ')+"</b>"
                                width: img1.width
                                color: apps.fontColor
                                font.pixelSize: app.fs*1.5
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                Timer{
                                    running: parent.contentWidth>(img1.width-app.fs)
                                    repeat: true
                                    interval: 100
                                    onTriggered: parent.font.pixelSize-=2
                                }
                            }
                        }
                    }
                }
            }

        }
        Column {
            spacing: app.fs / 2
            Text {
                text: "Actividad Seleccionada:\n" + r.cAct.toUpperCase().replace(/_/g, ' ')
                font.pixelSize: r.fs
                color: 'white'
                width: r.width-app.fs*2
                wrapMode: Text.WordWrap
                visible: r.cAct !== ''
            }
            Row{
                spacing: app.fs
                visible: r.cAct !== ''
                Rectangle{
                    width: app.fs*10
                    height: width
                    color: 'transparent'
                    anchors.verticalCenter: parent.verticalCenter
                    Image{
                        anchors.fill: parent
                        source: r.cAct!==''?'file:./imgs/'+r.cAct+'.jpeg':''
                    }
                }
                Button{
                    text: 'Eliminar Actividad Seleccionada'
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        const sql = "DELETE FROM registros WHERE fecha = '"+r.d+'/'+r.m+'/'+r.a+"' AND id = "+r.cActIdSelected+";";
                        let ejecutado = unik.sqlQuery(sql)
                        if(ejecutado){
                            r.cAct=''
                            r.actualizar()
                        }
                        //log.text+='Eliminado '+ejecutado+'<br>'
                    }
                }
            }
            Item{width: 1; height: app.fs*2; visible: r.cAct !== ''}
            Row{
                spacing: app.fs
                Button{
                    text: 'Eliminar Todo'
                    onClicked: {
                        const fechaAEliminar = ""+r.d+"/"+r.m+"/"+r.a//"9/10/2026";

                        // El string de la consulta SQL directa
                        let sql = 'DELETE FROM registros WHERE fecha = "'+fechaAEliminar+'";'
                        let ejecutado = unik.sqlQuery(sql)
                        if(ejecutado){
                            r.visible=false
                            r.parent.actualizar()
                        }
                    }
                }
                Button{
                    text: 'Listo'
                    onClicked: {
                        r.visible=false
                    }
                }
            }
        }
    }
    function actualizar(){
        if(!app.sqlOpen)return
        let sql='SELECT id, json FROM registros WHERE fecha = "'+r.d+'/'+r.m+'/'+r.a+'";'
        //log.text+='<br>SQL: '+sql+'<br>'
        let cons=unik.getSqlData(sql);
        //if(cons.length>0){
        let a=[]
        let json={}
        for(var i=0;i<cons.length;i++){
            //txt1.text+=' L:'+cons[0].col[0]
            json.id=cons[i].col[0]
            json.data=JSON.parse(cons[i].col[1])
            a.push(JSON.stringify(json))
        }
        repActsDeFecha.model=a
    }
}
