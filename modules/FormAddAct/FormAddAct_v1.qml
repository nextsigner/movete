import QtQuick
import QtQuick.Controls

Rectangle {
    id: r
    color: apps.backgroundColor
    anchors.fill: parent
    visible: false

    // Guardamos la actividad seleccionada y su índice para evitar recorrer el Flow
    property string cAct: ''
    property int selectedIndex: -1

    onVisibleChanged: {
        if (!visible) {
            r.cAct = ''
            r.selectedIndex = -1
        }
    }

    Column {
        id: mainColumn
        spacing: app.fs
        anchors.centerIn: parent
        width: parent.width * 0.9 // Evitamos desbordamientos

        Text {
            text: "Agregar Actividad"
            font.pixelSize: app.fs
            color: 'white'
        }

        Flow {
            id: flow
            spacing: app.fs
            width: mainColumn.width

            Repeater {
                model: ['hidratarse', 'abdominales', 'sentadillas', 'flexiones']

                delegate: Rectangle {
                    id: xAct
                    width: app.fs * 6
                    height: width
                    color: 'black'

                    // Usamos r.selectedIndex en lugar de buscar en children
                    property bool selected: (r.selectedIndex === index)

                    border.width: selected ? 4 : 1
                    border.color: selected ? 'red' : 'white'
                    opacity: selected ? 1.0 : 0.75

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            r.selectedIndex = index
                            r.cAct = modelData
                        }
                    }

                    Image {
                        width: parent.height * 0.9
                        height: width
                        source: 'file:./imgs/' + modelData + '.jpeg'
                        anchors.centerIn: parent
                    }
                }
            }
        }

        Column {
            visible: r.cAct !== ''
            spacing: app.fs / 2

            Text {
                text: "Actividad: " + r.cAct
                font.pixelSize: app.fs
                color: 'white'
            }

            Row {
                spacing: app.fs
                Text {
                    text: "Series: "
                    font.pixelSize: app.fs
                    color: 'white'
                    anchors.verticalCenter: spSeries.verticalCenter
                }

                SpinBox {
                    id: spSeries
                    from: 1
                    to: 50
                    value: 1
                    stepSize: 1

                    // 1. Campo de texto interno (letra blanca)
                    contentItem: TextInput {
                        text: spSeries.textFromValue(spSeries.value, spSeries.locale)
                        font.pixelSize: app.fs*2
                        color: "white"
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        readOnly: !spSeries.editable
                        validator: spSeries.validator
                        inputMethodHints: spSeries.inputMethodHints
                    }

                    // 2. Fondo y borde general del SpinBox
                    background: Rectangle {
                        color: "transparent"
                        border.color: "white"
                        border.width: 1
                        radius: 4
                    }

                    // 3. Botón de incremento (+)
                    up.indicator: Rectangle {
                        x: spSeries.mirrored ? 0 : parent.width - width
                        height: parent.height
                        width: height // Botón cuadrado
                        color: spSeries.up.pressed ? "#444444" : "transparent"
                        border.color: "white"
                        border.width: 1
                        radius: 4

                        Text {
                            text: "+"
                            color: "white"
                            font.pixelSize: app.fs * 1.2
                            anchors.centerIn: parent
                        }
                    }

                    // 4. Botón de decremento (-)
                    down.indicator: Rectangle {
                        x: spSeries.mirrored ? parent.width - width : 0
                        height: parent.height
                        width: height // Botón cuadrado
                        color: spSeries.down.pressed ? "#444444" : "transparent"
                        border.color: "white"
                        border.width: 1
                        radius: 4

                        Text {
                            text: "-"
                            color: "white"
                            font.pixelSize: app.fs * 1.2
                            anchors.centerIn: parent
                        }
                    }

                    onValueChanged: {
                        console.log("El valor actual es:", spSeries.value)
                    }
                }
            }
        }
    }
}
