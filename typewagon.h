#pragma once
#include <QObject>
#include <QVariantList>

class TypeWagonModel : public QObject
{
    Q_OBJECT
public:
    explicit TypeWagonModel(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getAll();
    Q_INVOKABLE bool add(const QString &name, int capacity);
    Q_INVOKABLE bool update(int id, const QString &name, int capacity);
    Q_INVOKABLE bool remove(int id);
};
