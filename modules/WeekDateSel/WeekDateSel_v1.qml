import QtQuick

Rectangle {
    id: r
    height: txt1.contentHeight + txt0.contentHeight + app.fs * 3
    color: apps.backgroundColor
    border.color: apps.fontColor
    border.width: 1
    radius: 8

    // Función auxiliar para obtener el Lunes de cualquier fecha dada
    function toMonday(dateObj) {
        let d = new Date(dateObj)
        let day = d.getDay()
        // Si es domingo (0), retrocedemos 6 días; de lo contrario, restamos el día actual y sumamos 1 (lunes)
        let diff = d.getDate() - day + (day === 0 ? -6 : 1)
        return new Date(d.setDate(diff))
    }

    // Texto informativo opcional para visualizar la fecha actual
    Column {
        anchors.centerIn: parent
        spacing: app.fs
        //        Text {
        //            id: txt1
        //            width: r.width - app.fs
        //            wrapMode: Text.WordWrap
        //            text: {
        //                if (!apps.currentWeek || isNaN(new Date(apps.currentWeek).getTime())) {
        //                    return "Semana: No asignada"
        //                }
        //                // Muestra siempre la fecha normalizada al Lunes de esa semana
        //                let d = r.toMonday(new Date(apps.currentWeek))
        //                return "Semana del " + d.toLocaleDateString()
        //            }
        //            font.pixelSize: app.fs * 2
        //            color: apps.fontColor
        //            horizontalAlignment: Text.AlignHCenter
        //            anchors.horizontalCenter: parent.horizontalCenter
        //        }

        Text {
            id: txt1
            width: r.width - app.fs
            wrapMode: Text.WordWrap

            // Usamos una función separada o lógica más limpia
            text: {
                try {
                    if (!apps.currentWeek) {
                        return "Semana: No asignada (vacía)"
                    }

                    let date = new Date(apps.currentWeek)
                    if (isNaN(date.getTime())) {
                        return "Semana: Fecha inválida (" + apps.currentWeek + ")"
                    }

                    // Normalizamos al Lunes de esa semana usando tu función toMonday
                    let d = r.toMonday(date)

                    // 1. Cálculo del número de semana del año (ISO-8601)
                    let target = new Date(d.valueOf())
                    let dayNr = (d.getDay() + 6) % 7
                    target.setDate(target.getDate() - dayNr + 3)
                    let firstThursday = new Date(target.getFullYear(), 0, 4)
                    let firstDayNr = (firstThursday.getDay() + 6) % 7
                    firstThursday.setDate(firstThursday.getDate() - firstDayNr + 3)
                    let weekOfYear = Math.floor(1 + Math.round((target.getTime() - firstThursday.getTime()) / 86400000) / 7)

                    // 2. Cálculo de la semana del mes (de 1 a 4)
                    let dayOfMonth = d.getDate()
                    let weekOfMonth = Math.min(4, Math.ceil(dayOfMonth / 7))

                    return "Semana " + weekOfYear + " del año — Semana " + weekOfMonth + " del mes"
                } catch (e) {
                    console.log("Error calculando la semana:", e)
                    return "Semana: Error de cálculo"
                }
            }

            font.pixelSize: app.fs * 2
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
                            // Obtener fecha actual o usar la fecha de hoy si apps.currentWeek está vacía
                            let currentDate = apps.currentWeek ? new Date(apps.currentWeek) : new Date()
                            if (isNaN(currentDate.getTime())) {
                                currentDate = new Date()
                            }

                            // Asegurar que partimos desde el Lunes actual
                            currentDate = r.toMonday(currentDate)

                            if (delta > 0) {
                                // Deslizamiento hacia la DERECHA -> Lunes de la semana anterior (-7 días)
                                currentDate.setDate(currentDate.getDate() - 7)
                            } else {
                                // Deslizamiento hacia la IZQUIERDA -> Lunes de la semana siguiente (+7 días)
                                currentDate.setDate(currentDate.getDate() + 7)
                            }

                            // Actualizar la propiedad en la ventana principal con el nuevo Lunes
                            apps.currentWeek = currentDate
                        }
                    }
    }
}
