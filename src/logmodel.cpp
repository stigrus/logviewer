#include "logmodel.h"
#include <QFile>
#include <QRegularExpression>

LogModel::LogModel(QObject *parent) : QAbstractListModel(parent)
{
    m_roleNames[DateTimeRole] = "datetime";
    m_roleNames[IdRole] = "idx";
    m_roleNames[TypeRole] = "type";
    m_roleNames[FileRole] = "file";
    m_roleNames[FunctionRole] = "func";
    m_roleNames[LineRole] = "line";
    m_roleNames[MessageRole] = "message";

    m_types << "Trace"
            << "Debug"
            << "Warn"
            << "Info"
            << "Error"
            << "Fatal";

    m_activeTypes = m_types;
}

int LogModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_dataFiltered.count();
}

QVariant LogModel::data(const QModelIndex &index, int role) const
{

    int idx = index.row();
    if(idx >= m_dataFiltered.count())
    {
        return QVariant();
    }

    QVariant value;
    switch(role)
    {
    case DateTimeRole:
        value = m_dataFiltered.at(idx).datetime;
        break;
    case IdRole:
        value = m_dataFiltered.at(idx).id;
        break;
    case TypeRole:
        value = m_dataFiltered.at(idx).type;
        break;
    case FileRole:
        value = m_dataFiltered.at(idx).file;
        break;
    case FunctionRole:
        value = m_dataFiltered.at(idx).function;
        break;
    case LineRole:
        value = m_dataFiltered.at(idx).line;
        break;
    case MessageRole:
        value = m_dataFiltered.at(idx).message;
        break;
    }

    return value;
}

QVariant LogModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    Q_UNUSED(section)
    Q_UNUSED(orientation)
    QVariant value;
    switch(role)
    {
    case DateTimeRole:
        value = "Time";
        break;
    case IdRole:
        value = "ID";
        break;
    case TypeRole:
        value = "Type";
        break;
    case FileRole:
        value = "File";
        break;
    case FunctionRole:
        value = "Function";
        break;
    case LineRole:
        value = "Line";
        break;
    case MessageRole:
        value = "Message";
        break;
    }
    return value;
}

QHash<int, QByteArray> LogModel::roleNames() const
{
    return m_roleNames;
}

bool LogModel::load(const QString &filename)
{
    QString fn = filename;
    if(filename.startsWith("file:///"))
    {
        fn = filename.right(filename.count() - 8);
    }
    qCritical() << "File" << fn;

    QFile file(fn);
    if(!file.exists())
    {
        qCritical() << "File" << fn << "does not exist";
        return false;
    }

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qCritical() << "Open File Failed";
        return false;
    }

    QString data = QString(file.readAll());
    file.close();

    //Process data
    QRegularExpression exp("(?<datetime>[0-9]+/[0-9]+/[0-9]+ [0-9]+:[0-9]+:[0-9]+:[0-9]+) \\[(?<id>[0-9]+)\\] (?<type>[A-Z]+)[ -]+File: (?<file>.*?). Function: (?<function>.*?). Line: (?<line>[0-9]+). (?<message>.*?)(?=\n[0-9]+/[0-9]+/[0-9]+ [0-9]+:[0-9]+:[0-9]+:[0-9]+|$)");
    exp.setPatternOptions(QRegularExpression::DotMatchesEverythingOption);
    QRegularExpressionMatchIterator i = exp.globalMatch(data);

    m_data.clear();

    while (i.hasNext()) {
        QRegularExpressionMatch match = i.next();

        QString datetime = match.captured("datetime");
        int id = match.captured("id").toInt();
        QString type = match.captured("type");
        QString file = match.captured("file").trimmed();
        QString function = match.captured("function").trimmed();
        int line = match.captured("line").toInt();
        QString message = match.captured("message").trimmed();

        m_data.append(LogLine(toDateTime(datetime), id, type, file, function, line, message));
    }

    updateFiltered();

    return true;
}

QString LogModel::date(const int idx) const
{
    foreach(const LogLine &line, m_data)
    {
        if(line.id == idx)
        {
            return line.datetime.toString("MMM dd yyyy");
        }
    }
    return QString("No date");
}

QStringList LogModel::types() const
{
    return m_types;
}

void LogModel::setType(const QString &type, bool enabled)
{
    if( enabled )
    {
        if(!m_activeTypes.contains(type))
        {
            m_activeTypes.append(type);
        }
    }
    else
    {
        m_activeTypes.removeAll(type);
    }

    updateFiltered();
}

QDateTime LogModel::toDateTime(const QString &datetime)
{
    QString datetimestring = datetime;
    datetimestring.insert(6, "20");

    return QDateTime::fromString(datetimestring, "MM/dd/yyyy hh:mm:ss:zzz");
}

void LogModel::updateFiltered()
{
    beginResetModel();
    m_dataFiltered.clear();
    foreach (const LogLine &line, m_data) {
        if(m_activeTypes.contains(line.type, Qt::CaseInsensitive))
        {
            m_dataFiltered.append(line);
        }
    }
    endResetModel();
}
