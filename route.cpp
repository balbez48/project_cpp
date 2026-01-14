#include "route.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
RouteModel::RouteModel(QObject *parent) : QObject(parent) {}

QVariantList RouteModel::getAll()
{
    QVariantList list;

    QSqlQuery q(R"(
        SELECT id_route,
               point_otbit,
               point_pribit,
               default_price,
               status_route
        FROM list_routes
    )");

    while (q.next()) {
        QVariantMap row;
        row["id"] = q.value(0);
        row["from"] = q.value(1);
        row["to"] = q.value(2);
        row["price"] = q.value(3);
        row["status"] = q.value(4);
        list.append(row);
    }

    return list;
}



bool RouteModel::add(const QString &from,
                     const QString &to,
                     const QString &status,
                     double price)
{
    QSqlQuery q;

    // 1️⃣ Генерируем ID маршрута
    q.exec("SELECT COALESCE(MAX(id_route), 0) + 1 FROM list_routes");
    q.next();
    int newId = q.value(0).toInt();

    // 2️⃣ INSERT
    q.prepare(R"(
        INSERT INTO list_routes
        (id_route, point_otbit, point_pribit, status_route, default_price)
        VALUES (?, ?, ?, ?, ?)
    )");

    q.addBindValue(newId);
    q.addBindValue(from);
    q.addBindValue(to);
    q.addBindValue(status);
    q.addBindValue(price);

    return q.exec();
}



bool RouteModel::remove(int id)
{
    QSqlQuery q;
    q.prepare("DELETE FROM list_routes WHERE id_route=?");
    q.addBindValue(id);
    return q.exec();
}

