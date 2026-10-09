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
        spacing: app.fs*0.25
        anchors.centerIn: parent
        Text{
            id: txt0
            text: r.aDias[r.ni]+' '+r.d+'/'+r.m+'/'+r.a//+'\napp.ciHoy: '+app.ciHoy+' r.ni: '+r.ni
            font.pixelSize: app.fs*2
            color: apps.fontColor

        }
        Text{
            id: txt1
            text: '?'
            font.pixelSize: app.fs*2
            color: apps.fontColor
        }
    }
    function actualizar(){
        let sql='SELECT json FROM registros WHERE fecha = "'+d+'/'+m+'/'+a+'";'
        let cons=unik.getSqlData(sql);
        if(cons.length){
            txt1.text+=' L:'+cons[0]
        }
    }
}
