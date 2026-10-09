import QtQuick


Rectangle {
    id: r
    color: apps.backgroundColor
    border.color: apps.fontColor
    border.width: 1
    radius: 8

    // Texto informativo opcional para visualizar la fecha actual
    Column {
        anchors.centerIn: parent
        spacing: app.fs
        Text {
            text: "Desliza hacia la izquierda o derecha"
            font.pixelSize: app.fs
            color: apps.fontColor
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: {
                if (!app.currentWeek || isNaN(new Date(app.currentWeek).getTime())) {
                    return "Semana: No asignada"
                }
                let d = new Date(app.currentWeek)
                return "Semana del " + d.toLocaleDateString()
            }
            font.pixelSize: app.fs*2
            color: apps.fontColor
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Área táctil para detectar el deslizamiento horizontal
    MouseArea {
        id: mouseArea
        anchors.fill: parent

        property real startX: 0
        property real threshold: 50 // Umbral mínimo en píxeles para validar el gesto

        onPressed: (mouse) => {
                       startX = mouse.x
                   }

        onReleased: (mouse) => {
                        let delta = mouse.x - startX

                        // Validar si el arrastre supera el umbral establecido
                        if (Math.abs(delta) > threshold) {
                            // Obtener fecha actual o usar la fecha de hoy si app.currentWeek está vacía
                            let currentDate = app.currentWeek ? new Date(app.currentWeek) : new Date()
                            if (isNaN(currentDate.getTime())) {
                                currentDate = new Date()
                            }

                            if (delta > 0) {
                                // Deslizamiento hacia la DERECHA -> Semana anterior (-7 días)
                                currentDate.setDate(currentDate.getDate() - 7)
                            } else {
                                // Deslizamiento hacia la IZQUIERDA -> Semana siguiente (+7 días)
                                currentDate.setDate(currentDate.getDate() + 7)
                            }

                            // Actualizar la propiedad en la ventana principal
                            app.currentWeek = currentDate
                        }
                    }
    }


}

