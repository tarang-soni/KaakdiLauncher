#ifndef GAMEFILEOBJ_H
#define GAMEFILEOBJ_H
#include<QString>
#include<QStringList>
struct GameFileObj{
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
#endif // GAMEFILEOBJ_H
