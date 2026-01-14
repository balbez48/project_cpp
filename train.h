#ifndef TRAIN_H
#define TRAIN_H

#include <QObject>
#include <QVariantList>

class TrainModel : public QObject
{
    Q_OBJECT
public:
    explicit TrainModel(QObject *parent = nullptr);

    Q_INVOKABLE QVariantList getAll();
    Q_INVOKABLE bool add(const QString &name, const QString &status);
    Q_INVOKABLE bool update(int id, const QString &name, const QString &status);
    Q_INVOKABLE bool remove(int id);


};

#endif // TRAIN_H
