import QtQuick
import QtQuick.Controls
import QtCore
import unik.Unik 1.0

//import WeekDateSel 1.0
import Cell 1.0

Window {
    id: app
    width: Qt.platform.os==='android'?640:608
    height: Qt.platform.os==='android'?480:1080
    visible: true
    title: "MOVETE"
    color: apps.backgroundColor
    property int fs: width*0.035
    property var currentWeek
    Settings{
        id: apps
        property color backgroundColor: 'black'
        property color fontColor: 'white'
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
        }
        Column{
            spacing: app.fs
            anchors.centerIn: parent
            /*WeekDateSel{
                width: xApp.width
            }*/
            Row{
                spacing: app.fs
                anchors.centerIn: parent
                Repeater{
                    model: 3
                    Cell{

                    }
                }
            }
        }
    }



    Component.onCompleted: {
        let dataBaseFullPath=unik.getPath(3)+'/movete.sqlite'
        unik.sqliteInit(dataBaseFullPath)
        let sql='CREATE TABLE IF NOT EXISTS tabla2
                            (
                                id INTEGER PRIMARY KEY AUTOINCREMENT,
                                nombre TEXT NOT NULL,
                                apellido TEXT NOT NULL,
                                edad NUMERIC NOT NULL,
                                promedio DECIMAL(2,2) NOT NULL
                            )'
        let ejecutado = unik.sqlQuery(sql)
        status.text='Ejecutado: '+ejecutado
        console.log('Ejecutado: '+ejecutado)
    }

    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }

}
