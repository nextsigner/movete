import QtQuick

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
    onDChanged: actualizar()
    //onMChanged: actualizar()
    //onAChanged: actualizar()
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
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater{
                id: repActividades
                Rectangle{
                    width: r.width/repActividades.model.length
                    height: app.fs*6
                    border.width: 1
                    border.color: 'white'
                    color: '#ff8833'
                    Text{
                        text: JSON.parse(modelData).actividad
                        color: 'black'
                        font.pixelSize: 10
                        anchors.centerIn: parent
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
        let sql='SELECT json FROM registros WHERE fecha = "'+d+'/'+m+'/'+a+'";'
        let cons=unik.getSqlData(sql);
        if(cons.length>0){
            let a=[]
            for(var i=0;i<cons.length;i++){
                //txt1.text+=' L:'+cons[0].col[0]
                a.push(cons[i].col[0])
            }
            repActividades.model=a

        }
    }
}
