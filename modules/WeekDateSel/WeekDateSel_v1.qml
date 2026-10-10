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
        Text {
            id: txt0
            text: "Desliza hacia la izquierda o derecha"
            font.pixelSize: app.fs
            color: apps.fontColor
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

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

            text: {
                try {
                    if (!apps.currentWeek) {
                        return "Semana: No asignada"
                    }

                    let date = new Date(apps.currentWeek)
                    if (isNaN(date.getTime())) {
                        return "Semana: Fecha inválida"
                    }

                    // Normalizamos al Lunes de esa semana usando tu función toMonday
                    let monday = r.toMonday(date)
                    let year = monday.getFullYear()
                    let month = monday.getMonth() // 0 = Enero, 9 = Octubre

                    // --- 1. Encontrar el primer Lunes del mes actual ---
                    let firstDayOfMonth = new Date(year, month, 1)
                    let dayOfWeek = firstDayOfMonth.getDay() // 0: Dom, 1: Lun, ..., 6: Sáb

                    // Días que faltan para llegar al primer lunes
                    let offsetToFirstMonday = (dayOfWeek === 1) ? 0 : (dayOfWeek === 0 ? 1 : (9 - dayOfWeek))
                    let firstMondayOfMonth = new Date(year, month, 1 + offsetToFirstMonday)

                    // --- 2. Calcular la semana del mes basada en el primer lunes ---
                    // Diferencia en milisegundos entre el lunes actual y el primer lunes del mes
                    let diffTime = monday.getTime() - firstMondayOfMonth.getTime()
                    let diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24))

                    let weekOfMonth = 1
                    if (diffDays >= 0) {
                        // Cada bloque de 7 días suma una semana
                        weekOfMonth = Math.floor(diffDays / 7) + 1
                    } else {
                        // Si el lunes está antes del primer lunes del mes (pertenece al cierre del mes anterior)
                        weekOfMonth = 1 // O puedes manejarlo como semana previa
                    }

                    // --- 3. Semana del año a partir del primer lunes del año ---
                    let firstDayOfYear = new Date(year, 0, 1)
                    let yearDayOfWeek = firstDayOfYear.getDay()
                    let offsetYearMonday = (yearDayOfWeek === 1) ? 0 : (yearDayOfWeek === 0 ? 1 : (9 - yearDayOfWeek))
                    let firstMondayOfYear = new Date(year, 0, 1 + offsetYearMonday)

                    let diffYearTime = monday.getTime() - firstMondayOfYear.getTime()
                    let diffYearDays = Math.floor(diffYearTime / (1000 * 60 * 60 * 24))
                    let weekOfYear = Math.max(1, Math.floor(diffYearDays / 7) + 1)

                    return "Semana " + weekOfYear + " del año — Semana " + weekOfMonth + " del mes"
                } catch (e) {
                    console.log("Error en cálculo de semanas:", e)
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
