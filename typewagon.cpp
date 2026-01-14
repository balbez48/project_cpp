#include "typewagon.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

TypeWagonModel::TypeWagonModel(QObject *parent) : QObject(parent) {}

QVariantList TypeWagonModel::getAll()
{
    QVariantList list;
    QSqlQuery q("SELECT id_type_wagon, name_wagon, capacity_wagon FROM type_wagon");

    while (q.next()) {
        QVariantMap row;
        row["id"] = q.value(0);
        row["name"] = q.value(1);
        row["capacity"] = q.value(2);
        list.append(row);
    }
    return list;
}

bool TypeWagonModel::add(const QString &name, int capacity)
{
    QSqlQuery q;

    // 1. Получаем новый ID
    if (!q.exec("SELECT COALESCE(MAX(id_type_wagon), 0) + 1 FROM type_wagon")) {
        qDebug() << "Ошибка получения id:" << q.lastError();
        return false;
    }

    q.next();
    int newId = q.value(0).toInt();

    // 2. Вставляем запись
    q.prepare(R"(
        INSERT INTO type_wagon (id_type_wagon, name_wagon, capacity_wagon)
        VALUES (?, ?, ?)
    )");

    q.addBindValue(newId);
    q.addBindValue(name);
    q.addBindValue(capacity);

    if (!q.exec()) {
        qDebug() << "Ошибка добавления вагона:" << q.lastError();
        return false;
    }

    return true;
}



bool TypeWagonModel::update(int id, const QString &name, int capacity)
{
    QSqlQuery q;
    q.prepare("UPDATE type_wagon SET name_wagon=?, capacity_wagon=? WHERE id_type_wagon=?");
    q.addBindValue(name);
    q.addBindValue(capacity);
    q.addBindValue(id);
    return q.exec();
}

bool TypeWagonModel::remove(int id)
{
    QSqlQuery q;
    q.prepare("DELETE FROM type_wagon WHERE id_type_wagon=?");
    q.addBindValue(id);
    return q.exec();
}
