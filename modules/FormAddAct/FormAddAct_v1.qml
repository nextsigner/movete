import QtQuick
import QtQuick.Controls
import NsSpinBox 1.0
Rectangle {
    id: r
    color: apps.backgroundColor
    anchors.fill: parent
    visible: false

    property int fs: app.fs*1.5

    property int d: -1
    property int m: -1
    property int a: -1

    // Guardamos la actividad seleccionada y su índice para evitar recorrer el Flow
    property string cAct: ''
    property int selectedIndex: -1

    property int altoBotones: ((r.width-app.fs*0.5)-(flow.spacing*(cantCols-1)))/cantCols
    property int cantCols: 2

    onVisibleChanged: {
        if (!visible) {
            r.cAct = ''
            r.selectedIndex = -1
        }else{
            actualizarActs()
        }
    }
    Column {
        id: mainColumn
        spacing: app.fs
        anchors.centerIn: parent
        width: parent.width * 0.9 // Evitamos desbordamientos

        Text {
            text: "Agregar Actividad"
            font.pixelSize: r.fs
            color: 'white'
        }
        Flickable{
            width: r.width-app.fs*0.5
            height: app.fs*30
            contentWidth: width
            contentHeight: flow.height
            clip: true
            Flow {
                id: flow
                spacing: app.fs//*0.25
                width: r.width-app.fs*0.5

                Repeater {
                    id: repActs
                    //model: ['hidratarse', 'abdominales', 'sentadillas', 'flexiones']
                    //Prompt para icono:
                    //Creame una imagen tipo ícono para mi app. Debe ser de 128x128 pixeles. No tiene que ser un dibujo detallado. Fondo negro, figura blanca y naranja. Este ícono debe representar de manera gráfica sin texto alguno la siguiente accción: ""

                    delegate: Rectangle {
                        id: xAct
                        //width: app.fs * 6
                        width: r.altoBotones
                        height: colFlow.height+app.fs//width
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
                                r.cAct = (""+modelData).replace('.jpeg', '')
                            }
                        }
                        Column{
                            id: colFlow
                            anchors.centerIn: parent
                            Image {
                                id: img1
                                width: parent.parent.width*0.9//height * 0.9
                                height: width
                                source: 'file:./imgs/' + modelData
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text{
                                text: "<b>"+(""+modelData).toUpperCase().replace('.JPEG', '').replace(/_/g, ' ')+"</b>"
                                width: img1.width
                                color: apps.fontColor
                                font.pixelSize: app.fs*1.5
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                Timer{
                                    running: parent.contentWidth>(img1.width-app.fs)
                                    repeat: true
                                    interval: 100
                                    onTriggered: parent.font.pixelSize-=2
                                }
                            }
                        }
                    }
                }
            }

        }
        Column {
            visible: r.cAct !== ''
            spacing: app.fs / 2
            Text {
                text: "Actividad: " + r.cAct.toUpperCase().replace(/_/g, ' ')
                font.pixelSize: r.fs
                color: 'white'
            }
            Row {
                spacing: app.fs
                Text {
                    text: "Series: "
                    font.pixelSize: r.fs
                    color: 'white'
                    anchors.verticalCenter: spSeries.verticalCenter
                }

                NsSpinBox {
                    id: spSeries
                    fs: app.fs*2
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
                    font.pixelSize: r.fs
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
                    font.pixelSize: r.fs
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
                        let d = new Date(Date.now())
                        const fecha = ""+r.d+"/"+r.m+"/"+r.a;//'9/10/2026';
                        const jsonData = JSON.stringify({
                                                            actividad: r.cAct,
                                                            series: spSeries.value,
                                                            cantidad: spSeriesCant.value,
                                                            ms: d.getTime()
                                                        });
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
    function actualizarActs(){
        let aActs=[
                "hidratarse.jpeg",
                "bicicleta_fija.jpeg",
                "abdominales.jpeg",
                "saltando_en_el_lugar.jpeg",
                "levantar_rodillas.jpeg",
                "biceps_3kg.jpeg",
                "biceps_6kg.jpeg",

                "acostado_bicicleta.jpeg",
                "acostado_tijera_1.jpeg",
                "acostado_tijera_2.jpeg",
                "acostado_circulo_1.jpeg",
                "acostado_circulo_2.jpeg",

                "rotar_cuello.jpeg",
                "rotar_tronco.jpeg",
                "rotar_hombros_1.jpeg",
                "rotar_hombros_2.jpeg",
                "rotar_hombros_3.jpeg",
                "sentadillas_3kg.jpeg",
                "sentadillas_6kg.jpeg",
                "sentadillas.jpeg",
                "flexiones.jpeg",
                "vuelos_laterales_3kg.jpeg",
                "pesandose.jpeg",
                "judo_amateur.jpeg",
                "judo_competitivo.jpeg",

                "mateando.jpeg",
                "programar.jpeg",
                "dormir_siesta.jpeg",
                "ducharse.jpeg",
                "escuchar_musica.jpeg",

                "lavar_platos.jpeg",
                "tender_ropa.jpeg",
                "haciendo_la_cama.jpeg",
                "destender_ropa.jpeg",
                "doblar_ropa.jpeg",
                "lavando_ropa.jpeg",
                "limpiar_baño.jpeg",

                "almorzar.jpeg",
                "cenar.jpeg",

                "aprender_filosofia.jpeg",
                "aprender.jpeg",

                "buen_momento.jpeg",
                "bailando.jpeg",
                "mal_momento.jpeg",
                "paseando.jpeg",

                "tomar_gaseosa.jpeg",
                "tomar_alcohol.jpeg",
                "fumar.jpeg"
            ];
        let a=[]
        let sql='SELECT act, COUNT(*) AS total
FROM actividades
GROUP BY act
ORDER BY total DESC;'
        let cons=unik.getSqlData(sql);
        //if(cons.length>0){
        let aActsRanking=[]
        let json={}
        for(var i=0;i<cons.length;i++){
            //txt1.text+=' L:'+cons[0].col[0]
            //json.id=cons[i].col[0]
            //json.data=JSON.parse(cons[i].col[1])
            aActsRanking.push(ons[i].col[0])
        }
        for(i=0;i<aActsRanking.length;i++){
            a.push(aActsRanking[i])
        }
        for(i=0;i<aActs.length;i++){
            if(aActsRanking.indexOf(aActs[i])<0){
                a.push(aActs[i])
            }
        }
        //log.text+='a: ['+a.toString().split(',').join(' | ')+']'

        repActs.model=a
    }
}
