#ifndef LOGMODEL_H
#define LOGMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QDateTime>
#include <QDebug>

class LogLine
{
public:
    LogLine();
    LogLine(QDateTime _datetime, int _id, QString _type, QString _file, QString _function, int _line, QString _message)
        : datetime(_datetime)
        , id(_id)
        , type(_type)
        , file(_file)
        , function(_function)
        , line(_line)
        , message(_message)
    {
    }

    QDateTime   datetime;
    int         id;
    QString     type;
    QString     file;
    QString     function;
    int         line;
    QString     message;
};

class LogModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QStringList types READ types NOTIFY typesChanged)
public:
    explicit LogModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE bool load(const QString &filename);

    Q_INVOKABLE QString date(const int idx) const;

    QStringList types() const;
    Q_INVOKABLE void setType(const QString &type, bool enabled);

signals:

    void typesChanged(QStringList types);


private:
    enum LogModelRoles
    {
        DateTimeRole = Qt::UserRole + 1,
        IdRole,
        TypeRole,
        FileRole,
        FunctionRole,
        LineRole,
        MessageRole
    };

    QDateTime toDateTime(const QString &datetime);
    void updateFiltered();

    QHash<int, QByteArray> m_roleNames;
    QList<LogLine> m_data;
    QList<LogLine> m_dataFiltered;
    QStringList m_types;
    QStringList m_activeTypes;
};

Q_DECLARE_METATYPE( LogModel* )

#endif // LOGMODEL_H
