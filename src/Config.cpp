#include "Config.h"
#include <QFile>
#include<QDebug>
Config& Config::instance()
{
    static Config inst;
    return inst;
}

Config::Config()
{
    QFile file = QFile(m_path);

    if(!file.open(QIODevice::ReadOnly))
    {
        qWarning()<<"Failed to open file:"+m_path;
        return;
    }
    QByteArray bytes = file.readAll();
    QJsonParseError err;
    m_configDoc = QJsonDocument::fromJson(bytes,&err);
    if(m_configDoc.isNull())
    {
        qWarning()<<err.errorString();
        return;
    }

}

