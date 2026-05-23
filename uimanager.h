#ifndef UIMANAGER_H
#define UIMANAGER_H
#include<QProcess>
#include <QDir>
#include <QObject>
#include <QDebug>
#include <QQmlEngine>
#include<QJsonDocument>
class UIManager : public QObject
{
    Q_OBJECT
public:
    explicit UIManager(QObject *parent = nullptr);
    Q_INVOKABLE void print();
    Q_INVOKABLE void playGame(QString data);
    static void registerClass();
    Q_PROPERTY(QString basePath READ basePath WRITE setBasePath NOTIFY basePathChanged FINAL);
    Q_PROPERTY(QVariantList currentGamesList READ currentGamesList WRITE setcurrentGamesList NOTIFY currentGamesListChanged FINAL)
    static QObject* singletonProvider(QQmlEngine *, QJSEngine *);
    QString basePath() const;
    void setBasePath(const QString &newBasePath);
    static UIManager* getInstance();
    QVariantList currentGamesList() const;
    void setcurrentGamesList(const QVariantList &newCurrentGamesList);

signals:

    void basePathChanged();
    void currentGamesListChanged();

public slots:
    void initCarousel(QJsonDocument doc);
private:
    const QString retroarchPath = "C:\\RetroArch-Win64\\retroarch.exe";


    QString m_basePath;
    QVariantList m_currentGamesList;
};

#endif // UIMANAGER_H
