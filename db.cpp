#include "db.h"
#include <QSqlError>
#include <QDebug>

bool DbManager::connect()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName("127.0.0.1");
    db.setPort(5432);
    db.setDatabaseName("postgres");
    db.setUserName("postgres");
    db.setPassword("12345");

    if (!db.open()) {
        qCritical() << db.lastError().text();
        return false;
    }

    qDebug() << "Database connected";
    return true;
}
