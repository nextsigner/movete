import QtQuick
import QtQuick.Controls
import QtCore
import unik.Unik 1.0

import WeekDateSel 1.0
import Cell 1.0

Window {
    id: app
    width: Qt.platform.os==='android'?640:608
    height: Qt.platform.os==='android'?480:1080
    visible: true
    title: "MOVETE"
    color: apps.backgroundColor
    property int fs: width*0.035
    property date hoy
    property int ciHoy: -1
    property bool sqlOpen: false

    property date dateSelected
    property int dSelected: -1
    property int mSelected: -1
    property int aSelected: -1
    onDateSelectedChanged: {
        app.dSelected=app.dateSelected.getDate()
        app.mSelected=app.dateSelected.getMonth()+1
        app.aSelected=app.dateSelected.getFullYear()
    }


    Settings{
        id: apps
        property color backgroundColor: 'black'
        property color fontColor: 'white'
        property date currentWeek
        onCurrentWeekChanged: {
            app.ciHoy=-1
            let nd= new Date(currentWeek.getTime())
            for(var i=0;i<7;i++){
                if(i>=1){
                    nd.setDate(nd.getDate()+1)
                }
                let d=nd.getDate()
                let m=nd.getMonth()+1
                let a=nd.getFullYear()
                colDias.children[i].d=d
                colDias.children[i].m=m
                colDias.children[i].a=a
            }
        }
    }
    Connections{
        target: qmlErrorLogger
        onMessagesChanged:{
            log.text+=''+qmlErrorLogger.messages[qmlErrorLogger.messages.length-1]+'<br>'
        }
    }
    Item{
        id: xApp
        width: parent.width-app.fs*4
        height: parent.height-app.fs*6
        anchors.centerIn: parent
        Text{
            id: status
            text: app.title
            font.pixelSize: app.fs
            color: apps.fontColor
            visible: false
        }
        Column{
            spacing: app.fs
            anchors.centerIn: parent
            WeekDateSel{
                id: wd
                width: xApp.width
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Column{
                id: colDias
                spacing: app.fs
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater{
                    model: 7
                    Cell{
                        width: xApp.width
                        ni:index
                    }
                }
            }
        }
        Rectangle{
            id: btnAddAct
            width: app.fs*4
            height: width
            border.width: 1
            border.color: 'white'
            color: '#333'
            anchors.bottom: parent.bottom
            anchors.bottomMargin: app.fs
            anchors.right: parent.right
            anchors.rightMargin: app.fs
            visible: app.ciHoy>=0
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    //formAddAct.visible=true
                    log.text+='Fecha: '+app.dateSelected.toString()+'<br>'
                    let d=app.dateSelected.getDate()
                    let m=app.dateSelected.getMonth()+1
                    let a=app.dateSelected.getFullYear()
                    for(var i=0;i<colDias.children.length;i++){
                        if(colDias.children.objectName.indexOf('cell_')>=0 && colDias.children.d===d && colDias.children.m===m && colDias.children.a === a){
                            //colDias.children[i].actualizar()
                            //colDias.children[app.ciHoy].showAddActForm()
                            colDias.children[i].showAddActForm()
                        }
                    }


                    /*return
                    const fecha = '9/10/2026';
                    const jsonData = JSON.stringify({ actividad: "Abdominales", realizado: false });
                    let sql = `INSERT INTO registros (fecha, json) VALUES ('${fecha}', '${jsonData}');`;
                    let ejecutado = unik.sqlQuery(sql)
                    //txt0.text+='e: '+ejecutado
                    if(ejecutado){
                        actualizar()
                    }*/
                }
            }
            Text{
                text: "<b>+</b>"
                font.pixelSize: parent.width*0.8
                color: apps.fontColor
                anchors.centerIn: parent
            }
        }
    }
    Item{
        id: itemSqlite
        Component.onCompleted: {
            let dataBaseFullPath=unik.getPath(3)+'/movete.sqlite'
            unik.sqliteInit(dataBaseFullPath)
            let sql='CREATE TABLE IF NOT EXISTS registros
                                (
                                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                                    fecha TEXT NOT NULL,
                                    json TEXT NOT NULL
                                )'
            let ejecutado = unik.sqlQuery(sql)
            app.sqlOpen=ejecutado
            status.text='Ejecutado: '+app.sqlOpen
        }
    }
    Rectangle{
        id: xLog
        color: apps.backgroundColor
        width: parent.width-app.fs*4
        height: parent.height-app.fs*6
        anchors.centerIn: parent
        visible: false
        Flickable{
            width: parent.width
            height: parent.height
            contentWidth: width
            contentHeight: log.contentHeight
            anchors.centerIn: parent
            Text{
                id: log
                width: xLog.width-app.fs
                color: apps.fontColor
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
                onTextChanged: {
                    if(log.text!=='')xLog.visible=true
                }
            }
            Rectangle{
                width: app.fs*2
                height: width
                anchors.right: parent.right
                MouseArea{
                    anchors.fill: parent
                    onClicked: xLog.visible=false
                }
                Text{
                    text: "X"
                    font.pixelSize: parent.width*0.8
                    color: 'black'
                    anchors.centerIn: parent
                }
            }
        }
        Button{
            text: 'Cerrar'
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            onClicked: xLog.visible=false
        }
    }



    Timer{
        id: tCheckHoy
        running: true
        repeat: true
        interval: 1000
        onTriggered: checkHoy()
    }
    Component.onCompleted: {
        let nd=new Date(Date.now())
        app.dateSelected = new Date(nd.getFullYear(), nd.getMonth(), nd.getDate())
        //if(!apps.currentWeek){
            apps.currentWeek=wd.toMonday(nd)
        //}
        app.hoy=new Date(Date.now())
//        let dataBaseFullPath=unik.getPath(3)+'/movete.sqlite'
//        unik.sqliteInit(dataBaseFullPath)
//        let sql='CREATE TABLE IF NOT EXISTS registros
//                            (
//                                id INTEGER PRIMARY KEY AUTOINCREMENT,
//                                fecha TEXT NOT NULL,
//                                json TEXT NOT NULL
//                            )'
//        let ejecutado = unik.sqlQuery(sql)
//        status.text='Ejecutado: '+ejecutado
//        console.log('Ejecutado: '+ejecutado)


//        const fecha = '9/10/2026';
//        const jsonData = JSON.stringify({ actividad: "Abdominales", realizado: false });

//        // Ojo: Si el json tiene comillas dobles, asegúrate de escapar o usar comillas simples adecuadamente
//        sql = `INSERT INTO registros (fecha, json) VALUES ('${fecha}', '${jsonData}');`;
//        ejecutado = unik.sqlQuery(sql)
        //app.color=ejecutado?'blue':'red'


    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    function checkHoy(){
        let d=app.hoy.getDate()
        let m=app.hoy.getMonth()+1
        let a=app.hoy.getFullYear()
        let sHoy=''+d+'/'+m+'/'+a
        for(var i=0;i<7;i++){
            let sCell=''+colDias.children[i].d+'/'+colDias.children[i].m+'/'+colDias.children[i].a
            if(sHoy===sCell){
                if(wd.cw!==wd.cws)app.ciHoy=i
            }
        }
        if(app.sqlOpen){
            let sql='CREATE TABLE IF NOT EXISTS registros
                                (
                                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                                    fecha TEXT NOT NULL,
                                    json TEXT NOT NULL
                                )'
            app.sqlOpen = unik.sqlQuery(sql)
        }
        wd.setCurrentWeek()
        //let nd=new Date(Date.now())
        //app.dateSelected = new Date(nd.getFullYear(), nd.getMonth(), nd.getDate())
    }
    function insertarRegistro(fecha, jsonData){
        //const fecha = '9/10/2026';
        //const jsonData = JSON.stringify({ actividad: "Abdominales", realizado: false });
        // Ojo: Si el json tiene comillas dobles, asegúrate de escapar o usar comillas simples adecuadamente
        let sql = `INSERT INTO registros (fecha, json) VALUES ('${fecha}', '${jsonData}');`;
        return unik.sqlQuery(sql)
    }
}
