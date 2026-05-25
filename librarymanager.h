#ifndef LIBRARYMANAGER_H
#define LIBRARYMANAGER_H
#include <QObject>
#include<QMap>
#include<QList>
#include<QFile>
#include "GameFileObj.h"
#include<QJsonDocument>
class LibraryManager : public QObject
{
    Q_OBJECT
public:
    explicit LibraryManager(QObject *parent = nullptr);
    void scan();
signals:
    void filesReady(QJsonDocument doc);
private:
    void initCores(QMap<QString, QList<GameFileObj>>&dict,const QString& path);
    void populateGames(QMap<QString, QList<GameFileObj>>&dict,const QString& path);
    void parseGamesList(const QString& xmlPath,QList<GameFileObj>&games,const QString& emuName);
    void createJson(QMap<QString, QList<GameFileObj>>&dict,const QString& path);

    bool jsonExists() const;
    QJsonDocument getGameListJson() const;

private:
    QString basePath;
};

#endif // LIBRARYMANAGER_H
