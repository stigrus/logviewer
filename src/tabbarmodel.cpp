#include "tabbarmodel.h"

TabBarModel::TabBarModel(QObject *parent)
    : QAbstractListModel(parent)
{
    m_roleNames[NameRole] = "name";
    m_roleNames[ModelRole] = "themodel";
}

int TabBarModel::rowCount(const QModelIndex &parent) const
{
    return m_data.count();
}

QVariant TabBarModel::data(const QModelIndex &index, int role) const
{
    int idx = index.row();
    if(idx >= m_data.count())
    {
        return QVariant();
    }

    QVariant value;
    switch(role)
    {
    case NameRole:
        value = m_data.keys().at(idx);
        break;
    case ModelRole:
        value = QVariant::fromValue(m_data.values().at(idx));
        break;
    }

    return value;
}

QHash<int, QByteArray> TabBarModel::roleNames() const
{
    return m_roleNames;
}
