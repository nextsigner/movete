import QtQuick
import FormAddAct 1.0

Rectangle{
    id: r
    width: 50
    height: col.height+app.fs
    color: app.ciHoy===ni?'green':'black'
    border.width: 2
    border.color: apps.fontColor
    property int ni: -1
    property var aDias: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo']
    property int d: -1
    property int m: -1
    property int a: -1
    property int altoBotones: (r.width-(flowActs.spacing*(cantCols-1)))/cantCols
    property int cantCols: 4
    onDChanged: actualizar()
    //onMChanged: actualizar()
    //onAChanged: actualizar()
    FormAddAct{id: formAddAct;parent: visible?xApp:r}
    Column{
        id: col
        spacing: app.fs*0.25
        anchors.centerIn: parent
        Text{
            id: txt0
            text: r.aDias[r.ni]+' '+r.d+'/'+r.m+'/'+r.a//+'\napp.ciHoy: '+app.ciHoy+' r.ni: '+r.ni
            font.pixelSize: app.ciHoy===r.ni?app.fs*2:app.fs
            color: apps.fontColor
            anchors.horizontalCenter: parent.horizontalCenter

        }
        Flow{
            id: flowActs
            spacing: app.fs*0.25
            width: r.width-app.fs*0.5
            anchors.left: parent.left
            visible: app.ciHoy===r.ni
            Repeater{
                id: repActividades
                Rectangle{
                    id: xCell
                    width: r.altoBotones
                    height: r.altoBotones
                    border.width: 1
                    border.color: 'white'
                    color: 'transparent'
                    property var j: JSON.parse(modelData)
                    Image{
                        width: parent.width
                        height: width
                        source: 'file:./imgs/'+xCell.j.data.actividad+'.jpeg'
                        anchors.centerIn: parent
                    }
                    Rectangle{
                        width: app.fs
                        height: width
                        radius: width*0.5
                        color: apps.backgroundColor
                        Text{
                            text: ''+xCell.j.data.series
                            font.pixelSize: parent.width*0.45
                            color: apps.fontColor
                            anchors.centerIn: parent
                        }
                    }
                    Text{
                        text: JSON.parse(modelData).data.actividad
                        color: 'black'
                        font.pixelSize: 10
                        anchors.centerIn: parent
                        visible: false
                    }
                }
            }

        }
        /*Text{
            id: txt1
            text: '?'
            font.pixelSize: app.fs*2
            color: apps.fontColor
        }*/
    }
    Rectangle{
        width: txt0.contentHeight-4
        height: width
        anchors.right: parent.right
        anchors.rightMargin: 2
        anchors.verticalCenter: parent.verticalCenter
        MouseArea{
            anchors.fill: parent
            onClicked: {
                //let sql='DELETE from registros'
                const fechaAEliminar = "9/10/2026";

                // El string de la consulta SQL directa
                let sql = 'DELETE FROM registros WHERE fecha = "'+fechaAEliminar+'";'
                let ejecutado = unik.sqlQuery(sql)
                if(ejecutado){
                    actualizar()
                }
            }
        }
        Text{
            text: "X"
            font.pixelSize: parent.width*0.9
            color: 'black'
            anchors.centerIn: parent
        }

    }
    function actualizar(){
        let sql='SELECT id, json FROM registros WHERE fecha = "'+r.d+'/'+r.m+'/'+r.a+'";'
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
        repActividades.model=a

        //}
    }
    function showAddActForm(){
        formAddAct.visible=true
    }
}
