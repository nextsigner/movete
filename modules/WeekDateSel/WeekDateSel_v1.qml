import QtQuick

Item {
    id: root
    width: 500
    height: 300

    // Contenedor visual del componente
    Rectangle {
        anchors.fill: parent
        color: "#f8f9fa"
        border.color: "#ced4da"
        border.width: 1
        radius: 8

        // Texto informativo opcional para visualizar la fecha actual
        Column {
            anchors.centerIn: parent
            spacing: 10


//            Text {
//                text: "Desliza hacia la izquierda o derecha"
//                font.pixelSize: 14
//                color: "#6c757d"
//                horizontalAlignment: Text.AlignHCenter
//                anchors.horizontalCenter: parent.horizontalCenter
//            }

//            Text {
//                text: {
//                    if (!app.                             || isNaN(new Date(app.currentWeek).getTime())) {
//                        return "Semana: No asignada"
//                    }
//                    let d = new Date(app.currentWeek)
//                    return "Semana del " + d.toLocaleDateString()
//                }
//                font.pixelSize: 20
//                color: "#212529"
//                horizontalAlignment: Text.AlignHCenter
//                anchors.horizontalCenter: parent.horizontalCenter
//            }
//        }

        // Área táctil para detectar el deslizamiento horizontal
//        MouseArea {
//            id: mouseArea
//            anchors.fill: parent

//            property real startX: 0
//            property real threshold: 50 // Umbral mínimo en píxeles para validar el gesto

//            onPressed: (mouse) => {
//                startX = mouse.x
//            }

//            onReleased: (mouse) => {
//                let delta = mouse.x - startX

//                // Validar si el arrastre supera el umbral establecido
//                if (Math.abs(delta) > threshold) {
//                    // Obtener fecha actual o usar la fecha de hoy si app.currentWeek está vacía
//                    let currentDate = app.currentWeek ? new Date(app.currentWeek) : new Date()
//                    if (isNaN(currentDate.getTime())) {
//                        currentDate = new Date()
//                    }

//                    if (delta > 0) {
//                        // Deslizamiento hacia la DERECHA -> Semana anterior (-7 días)
//                        currentDate.setDate(currentDate.getDate() - 7)
//                    } else {
//                        // Deslizamiento hacia la IZQUIERDA -> Semana siguiente (+7 días)
//                        currentDate.setDate(currentDate.getDate() + 7)
//                    }

//                    // Actualizar la propiedad en la ventana principal
//                    app.currentWeek = currentDate
//                }
//            }
//        }


    }

}
