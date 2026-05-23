#include "librarymanager.h"
#include<QCoreApplication>
#include<QDir>
#include<QDirIterator>
#include<QDebug>
#include <QJsonObject>
#include<QJsonArray>
#include<QJsonDocument>

LibraryManager::LibraryManager(QObject *parent)
    : QObject{parent}
{
    basePath = QCoreApplication::applicationDirPath();



}
void LibraryManager::scan()
{

    QMap<QString, QList<GameFileObj>> dict;
    if(!jsonExists()){
        initCores(dict,basePath);
        populateGames(dict,basePath);
        qInfo()<<"Scanning for games...";
        createJson(dict,basePath);
    }
    QJsonDocument json =getGameListJson();
    emit filesReady(json);

}

void LibraryManager::initCores(QMap<QString, QList<GameFileObj> > &dict, const QString& path)
{
    QString corePath = QDir(path).filePath("Cores");

    QDirIterator coreDirIterator(corePath,QDir::Dirs|QDir::NoDotAndDotDot,QDirIterator::NoIteratorFlags);//get cores
    while(coreDirIterator.hasNext())
    {
        coreDirIterator.next();
        QString emuName = coreDirIterator.filePath().section('/',-1);
        if(!dict.contains(emuName))
        {
            dict[emuName] = QList<GameFileObj>();
        }
    }
}

void LibraryManager::populateGames(QMap<QString, QList<GameFileObj> > &dict, const QString& path)
{
    QString gamePath = QDir(path).filePath("Games");
    QDirIterator gameDirIterator(gamePath,QDir::Dirs|QDir::NoDotAndDotDot,QDirIterator::NoIteratorFlags);//get games

    QDir baseDir(path);
    while(gameDirIterator.hasNext())
    {
        gameDirIterator.next();
        QString emuPath = gameDirIterator.filePath();

        QString emuName = emuPath.section('/',-1);
        if(dict.contains(emuName))
        {
            QList<GameFileObj>& refList = dict[emuName];
            QDirIterator gamedirs(emuPath,QDir::Dirs|QDir::NoDotAndDotDot,QDirIterator::NoIteratorFlags);//populate map list

            while(gamedirs.hasNext())
            {
                QDir gameDir(gamedirs.next());
                GameFileObj obj = GameFileObj();
                QString targetBaseName = "bg";
                obj.name=gameDir.dirName();
                for(QFileInfo& file:gameDir.entryInfoList(QDir::Files))
                {
                    if(file.baseName() == "bg")
                    {
                        obj.bgPath =baseDir.relativeFilePath( file.filePath());
                    }
                    else if(file.baseName() == "logo")
                    {
                        obj.logoPath =baseDir.relativeFilePath( file.filePath());
                    }
                    else if(file.baseName() == "rom")
                    {
                        obj.romPath = baseDir.relativeFilePath( file.filePath());
                    }
                }
                refList.append(obj);
                qInfo()<<gamedirs.filePath().section('/',-1);
            }
        }
        else{
            qWarning()<<"Emulator not found: "+emuName;
            continue;
        }

    }
}

void LibraryManager::createJson(QMap<QString, QList<GameFileObj> > &dict, const QString& path)
{
    QString gamePath = QDir(path).filePath("Games");
    QJsonObject root;

    QMap<QString, QList<GameFileObj>>::iterator i = dict.begin();
    QJsonArray emuArray;
    while(i!=dict.end())
    {
        QJsonObject emuObj;
        emuObj.insert("id",i.key());
        QJsonArray gameArray;
        for(auto& game:i.value())
        {
            QJsonObject gameObj;
            gameObj.insert("title",game.name);
            gameObj.insert("rom_path",game.romPath);
            gameObj.insert("logo",game.logoPath);
            gameObj.insert("bg",game.bgPath);
            gameArray.append(gameObj);
        }
        emuObj.insert("games",gameArray);
        emuArray.append(emuObj);
        ++i;

    }
    root.insert("systems",emuArray);

    QJsonDocument doc;
    doc.setObject(root);
    QString jsonPath = QDir(gamePath).filePath("gamelist.json");
    QFile jsonFile(jsonPath);
    if(!jsonFile.open(QIODevice::WriteOnly))
    {
        qDebug() << "Could not open file for writing:" << jsonFile.errorString();
        return;
    }
    QByteArray jsonData = doc.toJson(QJsonDocument::Indented);
    jsonFile.write(jsonData);
    jsonFile.close();
    qDebug() << "JSON written to" << jsonPath;
}

bool LibraryManager::jsonExists() const
{
    QString gamePath = QDir(basePath).filePath("Games/gamelist.json");
    QFile jsonFile(gamePath);
    return jsonFile.exists();
}

QJsonDocument LibraryManager::getGameListJson() const
{
    QString gamePath = QDir(basePath).filePath("Games/gamelist.json");
    QFile jsonFile(gamePath);
    QJsonDocument json;
    if (!jsonFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file";
        return json;
    }
    QByteArray jsonData =jsonFile.readAll();
    jsonFile.close();
    QJsonParseError parseError;
    json = QJsonDocument::fromJson(jsonData, &parseError);
    if(json.isNull())
    {
        qDebug() << "Failed to parse JSON:" << parseError.errorString();
    }
    return json;
}
