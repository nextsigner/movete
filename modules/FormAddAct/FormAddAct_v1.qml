import QtQuick
import QtQuick.Controls
import NsSpinBox 1.0
Rectangle {
    id: r
    color: apps.backgroundColor
    anchors.fill: parent
    visible: false

    property int d: -1
    property int m: -1
    property int a: -1

    // Guardamos la actividad seleccionada y su índice para evitar recorrer el Flow
    property string cAct: ''
    property int selectedIndex: -1

    property int altoBotones: ((r.width-app.fs*0.5)-(flow.spacing*(cantCols-1)))/cantCols
    property int cantCols: 3

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
        Flickable{
            width: mainColumn.width
            height: app.fs*20
            contentWidth: width
            contentHeight: flow.height
            clip: true
            Flow {
                id: flow
                spacing: app.fs
                //width: mainColumn.width
                spacing: app.fs*0.25
                width: r.width-app.fs*0.5

                Repeater {
                    //model: ['hidratarse', 'abdominales', 'sentadillas', 'flexiones']
                    model: [
                        "abdominales.jpeg",
                        "almorzar.jpeg",
                        "aprender_filosofia.jpeg",
                        "aprender.jpeg",
                        "bailando.jpeg",
                        "biceps_3kg.jpeg",
                        "biceps_6kg.jpeg",
                        "buen_momento.jpeg",
                        "cenar.jpeg",
                        "destender_ropa.jpeg",
                        "doblar_ropa.jpeg",
                        "dormir_siesta.jpeg",
                        "ducharse.jpeg",
                        "escuchar_musica.jpeg",
                        "flexiones.jpeg",
                        "fumar.jpeg",
                        "haciendo_la_cama.jpeg",
                        "hidratarse.jpeg",
                        "judo_amateur.jpeg",
                        "judo_competitivo.jpeg",
                        "lavando_ropa.jpeg",
                        "lavar_platos.jpeg",
                        "limpiar_baño.jpeg",
                        "mal_momento.jpeg",
                        "mateando.jpeg",
                        "paseando.jpeg",
                        "pesandose.jpeg",
                        "programar.jpeg",
                        "rotar_tronco.jpeg",
                        "sentadillas_3kg.jpeg",
                        "sentadillas_6kg.jpeg",
                        "sentadillas.jpeg",
                        "tender_ropa.jpeg",
                        "tomar_alcohol.jpeg",
                        "tomar_gaseosa.jpeg",
                        "vuelos_laterales_3kg.jpeg"
                    ];
                    delegate: Rectangle {
                        id: xAct
                        //width: app.fs * 6
                        width: r.altoBotones
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
                            //source: 'file:./imgs/' + modelData + '.jpeg'
                            source: 'file:./imgs/' + modelData
                            anchors.centerIn: parent
                        }
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

                NsSpinBox {
                    id: spSeries
                    fs: app.fs
                    from: 1
                    to: 50
                    value: 1
                    stepSize: 1
                    anchors.verticalCenter: spSeries.verticalCenter
                }
            }
            Row {
                spacing: app.fs
                Text {
                    text: "Cantidad por serie: "
                    font.pixelSize: app.fs
                    color: 'white'
                    anchors.verticalCenter: spSeries.verticalCenter
                }
                NsSpinBox {
                    id: spSeriesCant
                    fs: app.fs
                    from: 1
                    to: 500
                    value: 10
                    stepSize: 1
                    anchors.verticalCenter: spSeries.verticalCenter
                }
            }
            Row{
                spacing: app.fs
                Text {
                    text: "Cantidad total: "+(parseInt(spSeries.value*spSeriesCant.value))
                    font.pixelSize: app.fs
                    color: 'white'
                    anchors.verticalCenter: spSeries.verticalCenter
                }
            }
            Row{
                spacing: app.fs
                Button{
                    text: 'Cancelar'
                    onClicked: r.visible=false
                }
                Button{
                    text: 'Agregar'
                    onClicked: {
                        let j={}
                        const fecha = ""+r.d+"/"+r.m+"/"+r.a;//'9/10/2026';
                        const jsonData = JSON.stringify({ actividad: r.cAct, series: spSeries.value, cantidad: spSeriesCant.value });
                        let sql = `INSERT INTO registros (fecha, json) VALUES ('${fecha}', '${jsonData}');`;
                        let ejecutado = unik.sqlQuery(sql)
                        //log.text+='Ejecutado: '+ejecutado+'\nSQL:'+sql
                        //txt0.text+='e: '+ejecutado
                        if(ejecutado){
                            r.visible=false
                            r.parent.actualizar()
                        }
                    }
                }
            }
            Item{width: 1; height: app.fs*2}
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
        }
    }
}
