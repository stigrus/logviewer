#ifndef TABBARMODEL_H
#define TABBARMODEL_H

#include <QAbstractListModel>
#include <QMap>
#include "logmodel.h"

class TabBarModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit TabBarModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

private:
    enum LogModelRoles
    {
        NameRole = Qt::UserRole + 1,
        ModelRole
    };

    QHash<int, QByteArray> m_roleNames;
    QMap<QString, LogModel> m_data;
};

Q_DECLARE_METATYPE( TabBarModel* )

#endif // TABBARMODEL_H
