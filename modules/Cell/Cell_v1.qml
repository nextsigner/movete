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
    property int altoBotones: app.fs*6
    onDChanged: actualizar()
    //onMChanged: actualizar()
    //onAChanged: actualizar()
    FormAddAct{id: formAddAct;parent: visible?xApp:r}
    Column{
        id: col
        //spacing: app.fs*0.25
        anchors.centerIn: parent
        Text{
            id: txt0
            text: r.aDias[r.ni]+' '+r.d+'/'+r.m+'/'+r.a//+'\napp.ciHoy: '+app.ciHoy+' r.ni: '+r.ni
            font.pixelSize: app.fs*2
            color: apps.fontColor

        }
        Row{
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left
            visible: app.ciHoy===r.ni
            Rectangle{
                id: btnAdd
                width: app.fs*4
                height: r.altoBotones
                border.width: 1
                border.color: 'white'
                color: '#333'
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        formAddAct.visible=true
                        return
                        const fecha = '9/10/2026';
                        const jsonData = JSON.stringify({ actividad: "Abdominales", realizado: false });
                        let sql = `INSERT INTO registros (fecha, json) VALUES ('${fecha}', '${jsonData}');`;
                        let ejecutado = unik.sqlQuery(sql)
                        //txt0.text+='e: '+ejecutado
                        if(ejecutado){
                            actualizar()
                        }
                    }
                }
                Text{
                    text: "<b>+</b>"
                    font.pixelSize: parent.width*0.8
                    color: apps.fontColor
                    anchors.centerIn: parent
                }
            }
            Repeater{
                id: repActividades
                Rectangle{
                    id: xCell
                    width: (r.width-btnAdd.width)/repActividades.model.length
                    height: r.altoBotones
                    border.width: 1
                    border.color: 'white'
                    color: '#ff8833'
                    property var j: JSON.parse(modelData)
                    Image{
                        width: parent.height*0.9
                        height: width
                        source: 'file:./imgs/'+xCell.j.data.actividad+'.jpeg'
                        anchors.centerIn: parent
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
