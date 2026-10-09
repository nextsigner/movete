import QtQuick

Rectangle{
    id: r
    width: 50
    height: txt0.contentHeight+app.fs
    color: 'green'
    border.width: 2
    border.color: apps.fontColor
    property int ni: -1
    property var aDias: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo']
    Text{
        id: txt0
        text: r.aDias[r.ni]
        font.pixelSize: app.fs
        color: apps.fontColor
        anchors.centerIn: parent
    }
}
