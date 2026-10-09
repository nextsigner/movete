import QtQuick
import QtQuick.Controls
import QtCore
import unik.Unik 1.0

import Cell 1.0

Window {
    id: app
    width: Qt.platform.os==='android'?640:608
    height: Qt.platform.os==='android'?480:1080
    visible: true
    title: "MOVETE"
    color: apps.backgroundColor
    property int fs: width*0.035
    property var uAppsList: []
    property bool isRunikStart: true
    Settings{
        id: apps
        property color backgroundColor: 'black'
        property color fontColor: 'white'
        property string uIdApp: ''
    }
    Rectangle{
        id: xApp
        color: 'transparent'
        //anchors.fill: parent
        width: parent.width-app.fs*4
        height: parent.height-app.fs*6
        anchors.centerIn: parent
        Text{
            text: app.title
            font.pixelSize: app.fs
            color: apps.fontColor
        }
        Row{
            spacing: app.fs
            Repeater{
                model: 3
                Cell{

                }
            }
        }
    }




    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }

    }
