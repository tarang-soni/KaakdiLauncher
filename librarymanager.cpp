#include "librarymanager.h"
#include<QCoreApplication>
#include<QDir>
#include<QDirIterator>
#include<QDebug>
#include <QJsonObject>
#include<QJsonArray>
#include<QJsonDocument>
#include<QtXml/QDomDocument>
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
    QString mediaPath = QDir(path).filePath("media");
    QDirIterator gameDirIterator(gamePath,QDir::Dirs|QDir::NoDotAndDotDot,QDirIterator::NoIteratorFlags);//get games
    QStringList filters;
    QString filterPath = QDir(path).filePath("Games\\filters.txt");
    QFile filterFile(filterPath);
    if(!filterFile.open(QIODevice::ReadOnly))
    {
        qWarning() << "Failed to open file";
        return;
    }
    QByteArray filterData = filterFile.readAll();
    filters = QString::fromUtf8(filterData).split('\n',Qt::SkipEmptyParts);
    QStringList xmlPaths;
    while(gameDirIterator.hasNext())
    {
        QString emu = gameDirIterator.next();
        QString emuPath = QDir(gamePath).filePath(emu);
        QDir emuDir(emuPath);

        emuDir.setNameFilters(filters);
        QString emuName = emuPath.section('/',-1);
        QString xmlPath = QDir(gamePath).filePath(emuName+"/gamelist.xml");
        if(dict.contains(emuName))
        {
            QList<GameFileObj> gameList;
            dict[emuName]=gameList;
            parseGamesList(xmlPath,dict[emuName],emuName);

        }

    }

}

void LibraryManager::parseGamesList(const QString &xmlPath, QList<GameFileObj> &games,const QString& emuName)
{
    QDomDocument doc;
    QFile file(xmlPath);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qWarning() << "Could not open gamelist.xml at:" << xmlPath;
        return;
    }
    if(!doc.setContent(&file))
    {
        qWarning() << "Failed to parse XML content.";
        file.close();
        return;
    }
    file.close();

    QDomNodeList gameNodes = doc.elementsByTagName("game");
    for (int i = 0; i < gameNodes.count(); ++i) {
        QDomNode gameNode = gameNodes.at(i);
        if(gameNode.isElement())
        {
            GameFileObj gameObj;
            QDomNode childNode = gameNode.firstChild();
            while(!childNode.isNull())
            {
                if(childNode.isElement())
                {
                    QDomElement element = childNode.toElement();
                    QString tagName = element.tagName();
                    QString textData = element.text();
                    if(textData.startsWith("./"))
                    {
                        textData.replace(0,2,"Games/"+emuName+"/");
                    }
                    if(tagName == "path")
                    {
                        gameObj.romPath = textData;
                    }
                    else if(tagName == "name")
                    {
                        gameObj.name = textData;
                    }
                    else if(tagName == "desc")
                    {
                        gameObj.desc = textData;
                    }
                    else if(tagName == "rating")
                    {
                        gameObj.rating = textData.toFloat();
                    }
                    else if(tagName == "developer")
                    {
                        gameObj.developerName = textData;
                    }
                    else if(tagName == "publisher")
                    {
                        gameObj.pubName = textData;
                    }
                    else if(tagName == "genre")
                    {
                        QStringList a = textData.split("-");
                        gameObj.genre = a;
                    }
                    else if(tagName == "players")
                    {
                        gameObj.playerCount = textData;
                    }
                    else if(tagName == "image")
                    {
                        gameObj.bgPath = textData;
                    }
                    else if(tagName == "thumbnail")
                    {
                        gameObj.logoPath = textData;
                    }
                }
                childNode = childNode.nextSibling();
            }
            games.append(gameObj);

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
