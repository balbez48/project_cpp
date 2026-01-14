#ifndef ROUTE_H
#define ROUTE_H

#include <QObject>
#include <QVariantList>

class RouteModel : public QObject
{
    Q_OBJECT
public:
    explicit RouteModel(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getAll();

    Q_INVOKABLE bool add(const QString &from,
                         const QString &to,
                         const QString &status,
                         double price);


    Q_INVOKABLE bool remove(int id);
};

#endif // ROUTE_H
