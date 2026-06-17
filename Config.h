#ifndef CONFIG_H
#define CONFIG_H
#include <QString>
#include<QJsonDocument>
#include <QJsonValue>

class Config
{
public:


    static Config& instance();
    Config(const Config&) = delete;
    void operator=(const Config&) = delete;
    QJsonValue operator[](const QString& id) const
    {
        return m_configDoc[id];

    }
private:
    Config();
    ~Config(){}
private:
    const QString m_path = "config/config.json";
    QJsonDocument m_configDoc;

};

#endif // CONFIG_H
