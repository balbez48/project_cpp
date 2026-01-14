import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 1200
    height: 400
    visible: true
    title: "РЖД-путь"

    property bool tableVisible: false
    property var trainData: []

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        // ===== ВЕРХНЕЕ МЕНЮ =====
        TabBar {
            id: tabBar
            Layout.fillWidth: true

            TabButton { text: "Поезда" }
            TabButton { text: "Типы вагонов" }
            TabButton { text: "Маршруты" }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            // ================== ПОЕЗДА ==================
            Item {
                Column {
                    anchors.fill: parent
                    spacing: 10
                    padding: 10

                    GroupBox {
                        title: "Добавить поезд"
                        width: parent.width

                        Row {
                            spacing: 10

                            TextField {
                                id: nameField
                                placeholderText: "Название поезда"
                                width: 200
                            }

                            ComboBox {
                                id: statusCombo
                                width: 160
                                model: ["Готов", "В пути", "На ремонте"]
                            }

                            Button {
                                text: "Добавить"
                                onClicked: {
                                    if (nameField.text === "")
                                        return

                                    trainModel.add(
                                        nameField.text,
                                        statusCombo.currentText
                                    )

                                    trainData = trainModel.getAll()
                                    nameField.text = ""
                                }
                            }
                        }
                    }

                    Button {
                        text: tableVisible ? "Скрыть поезда" : "Показать поезда"
                        onClicked: {
                            tableVisible = !tableVisible
                            if (tableVisible)
                                trainData = trainModel.getAll()
                        }
                    }

                    TableView {
                        visible: tableVisible
                        model: trainData
                        width: parent.width
                        height: 250

                        delegate: Row {
                            spacing: 10

                            Text { text: modelData.id; width: 50 }
                            Text { text: modelData.name; width: 200 }
                            Text { text: modelData.status; width: 150 }

                            Button {
                                text: "Удалить"
                                onClicked: {
                                    trainModel.remove(modelData.id)
                                    trainData = trainModel.getAll()
                                }
                            }
                        }
                    }
                }
            }

            // ================== ТИПЫ ВАГОНОВ ==================
            Item {
                id: wagonTab

                property bool wagonTableVisible: false
                property var wagonData: []

                Column {
                    anchors.fill: parent
                    spacing: 10
                    padding: 10

                    // ===== ДОБАВЛЕНИЕ =====
                    GroupBox {
                        title: "Добавить тип вагона"
                        width: parent.width

                        Row {
                            spacing: 10

                            TextField {
                                id: wagonNameField
                                placeholderText: "Название"
                                width: 200
                            }

                            TextField {
                                id: capacityField
                                placeholderText: "Вместимость"
                                width: 120
                                inputMethodHints: Qt.ImhDigitsOnly
                            }

                            Button {
                                text: "Добавить"
                                onClicked: {
                                    if (wagonNameField.text === "" || capacityField.text === "")
                                        return

                                    typeWagonModel.add(
                                        wagonNameField.text,
                                        parseInt(capacityField.text)
                                    )

                                    wagonTab.wagonData = typeWagonModel.getAll()
                                    wagonNameField.text = ""
                                    capacityField.text = ""
                                }
                            }
                        }
                    }

                    // ===== ПОКАЗ / СКРЫТИЕ =====
                    Button {
                        text: wagonTab.wagonTableVisible
                              ? "Скрыть типы вагонов"
                              : "Показать типы вагонов"
                        onClicked: {
                            wagonTab.wagonTableVisible = !wagonTab.wagonTableVisible
                            if (wagonTab.wagonTableVisible)
                                wagonTab.wagonData = typeWagonModel.getAll()
                        }
                    }

                    // ===== ТАБЛИЦА =====
                    TableView {
                        visible: wagonTab.wagonTableVisible
                        model: wagonTab.wagonData
                        width: parent.width
                        height: 250

                        delegate: Row {
                            spacing: 10

                            Text { text: modelData.id; width: 50 }
                            Text { text: modelData.name; width: 200 }
                            Text { text: modelData.capacity; width: 120 }

                            Button {
                                text: "Редактировать"
                                onClicked: {
                                    editWagonDialog.editId = modelData.id
                                    editWagonNameField.text = modelData.name
                                    editCapacityField.text = modelData.capacity
                                    editWagonDialog.open()
                                }
                            }

                            Button {
                                text: "Удалить"
                                onClicked: {
                                    typeWagonModel.remove(modelData.id)
                                    wagonTab.wagonData = typeWagonModel.getAll()
                                }
                            }
                        }
                    }
                }

                // ===== DIALOG РЕДАКТИРОВАНИЯ =====
                Dialog {
                    id: editWagonDialog
                    title: "Редактировать тип вагона"
                    modal: true
                    standardButtons: Dialog.Ok | Dialog.Cancel

                    property int editId: -1

                    Column {
                        spacing: 10
                        padding: 10

                        TextField {
                            id: editWagonNameField
                            placeholderText: "Название"
                            width: 200
                        }

                        TextField {
                            id: editCapacityField
                            placeholderText: "Вместимость"
                            width: 200
                            inputMethodHints: Qt.ImhDigitsOnly
                        }
                    }

                    onAccepted: {
                        if (editWagonNameField.text === "" || editCapacityField.text === "")
                            return

                        typeWagonModel.update(
                            editId,
                            editWagonNameField.text,
                            parseInt(editCapacityField.text)
                        )

                        wagonTab.wagonData = typeWagonModel.getAll()
                    }
                }
            }


            // ================== МАРШРУТЫ ==================
            Item {
                id: routeTab

                property bool routeTableVisible: false
                property var routeData: []
                property var trains: []
                property var wagons: []

                Column {
                    anchors.fill: parent
                    spacing: 10
                    padding: 10

                    GroupBox {
                        title: "Добавить маршрут"
                        width: parent.width

                        Row {
                            spacing: 10

                            ComboBox {
                                id: routeTrainCombo
                                width: 160
                                model: routeTab.trains
                                textRole: "name"
                            }

                            ComboBox {
                                id: routeWagonCombo
                                width: 220
                                model: routeTab.wagons
                                textRole: "display"
                            }

                            TextField {
                                id: routeFromField
                                placeholderText: "Откуда"
                                width: 120
                            }

                            TextField {
                                id: routeToField
                                placeholderText: "Куда"
                                width: 120
                            }

                            ComboBox {
                                id: routeStatusCombo
                                width: 150
                                model: ["Запланирован", "В пути", "Завершён", "Отменён"]
                            }

                            TextField {
                                id: routePriceField
                                placeholderText: "Цена"
                                width: 100
                                inputMethodHints: Qt.ImhDigitsOnly
                            }

                            Button {
                                text: "Добавить"
                                onClicked: {
                                    if (routeFromField.text === "" ||
                                        routeToField.text === "" ||
                                        routePriceField.text === "")
                                        return

                                    routeModel.add(
                                        routeFromField.text,
                                        routeToField.text,
                                        routeStatusCombo.currentText,
                                        parseFloat(routePriceField.text)
                                    )

                                    routeTab.routeData = routeModel.getAll()
                                    routeFromField.text = ""
                                    routeToField.text = ""
                                    routePriceField.text = ""
                                }
                            }
                        }
                    }

                    Button {
                        text: routeTab.routeTableVisible
                              ? "Скрыть маршруты"
                              : "Показать маршруты"
                        onClicked: {
                            routeTab.routeTableVisible = !routeTab.routeTableVisible
                            if (routeTab.routeTableVisible) {
                                routeTab.routeData = routeModel.getAll()
                                routeTab.trains = trainModel.getAll()
                                routeTab.wagons = typeWagonModel.getAll().map(w => ({
                                    id: w.id,
                                    display: w.name + " (" + w.capacity + " мест)"
                                }))
                            }
                        }
                    }

                    TableView {
                        visible: routeTab.routeTableVisible
                        model: routeTab.routeData
                        width: parent.width
                        height: 250

                        delegate: Row {
                            spacing: 15

                            Text { text: modelData.id; width: 60 }
                            Text { text: modelData.from + " → " + modelData.to; width: 220 }
                            Text { text: modelData.status; width: 150 }
                            Text { text: modelData.price + " ₽"; width: 100 }

                            Button {
                                text: "Удалить"
                                onClicked: {
                                    routeModel.remove(modelData.id)
                                    routeTab.routeData = routeModel.getAll()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
