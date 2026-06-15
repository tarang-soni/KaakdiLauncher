#ifndef GAMEFILEOBJ_H
#define GAMEFILEOBJ_H
#include<QString>
#include<QStringList>
#include <QObject>
struct GameFileObj{
    GameFileObj():isGridBtn(false){}
    bool isGridBtn;
    QString name;
    QString logoPath;
    QString bgPath;
    QString romPath;
    QString desc;
    QStringList genre;
    QString playerCount;
    QString developerName;
    QString pubName;
    float rating;
};
Q_DECLARE_METATYPE(GameFileObj)
#endif // GAMEFILEOBJ_H
