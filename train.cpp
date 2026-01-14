#include "train.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

TrainModel::TrainModel(QObject *parent) : QObject(parent) {}

QVariantList TrainModel::getAll()
{
    QVariantList list;
    QSqlQuery q("SELECT id_train, name_train, status_train FROM train");

    while (q.next()) {
        QVariantMap row;
        row["id"] = q.value(0);
        row["name"] = q.value(1);
        row["status"] = q.value(2);
        list.append(row);
    }
    return list;
}

bool TrainModel::add(const QString &name, const QString &status)
{
    if (name.isEmpty())
        return false;

    QSqlQuery q;

    // 1️⃣ Получаем следующий ID
    q.exec("SELECT COALESCE(MAX(id_train), 0) + 1 FROM train");
    q.next();
    int newId = q.value(0).toInt();

    // 2️⃣ Вставляем
    q.prepare(
        "INSERT INTO train (id_train, name_train, status_train) "
        "VALUES (?, ?, ?)"
    );
    q.addBindValue(newId);
    q.addBindValue(name);
    q.addBindValue(status);

    return q.exec();
}


bool TrainModel::update(int id, const QString &name, const QString &status)
{
    QSqlQuery q;
    q.prepare(R"(
        UPDATE train
        SET name_train = ?, status_train = ?
        WHERE id_train = ?
    )");
    q.addBindValue(name);
    q.addBindValue(status);
    q.addBindValue(id);
    return q.exec();
}

bool TrainModel::remove(int id)
{
    QSqlQuery q;
    q.prepare("DELETE FROM train WHERE id_train=?");
    q.addBindValue(id);
    return q.exec();
}



