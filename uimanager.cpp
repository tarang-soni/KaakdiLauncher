#include "uimanager.h"
#include<QCoreApplication>
#include "Config.h"
static UIManager* m_object = nullptr;
UIManager::UIManager(QObject *parent)
    : QObject{parent}
{
    m_basePath = QCoreApplication::applicationDirPath();
}

void UIManager::print()
{
    qInfo()<<"Hello World";
}

void UIManager::playGame(QString data)
{
    QString basePath = QCoreApplication::applicationDirPath();
    QFileInfo fileInfo(data);
    QString folderName = fileInfo.dir().dirName();

    QString corePath = QDir(basePath).filePath("Cores/" + folderName);

    QDir coreDir(corePath);

    QStringList filters;
    #if defined(Q_OS_LINUX)
        filters<<"*.so";
    #elif defined(Q_OS_WIN)
        filters << "*.dll";
    #endif
    coreDir.setNameFilters(filters);
    coreDir.setFilter(QDir::Files);

    QStringList dllFiles = coreDir.entryList();
    QString fullCorePath = "";

    if(!dllFiles.isEmpty())
    {
        QString coreFileName = dllFiles.first();
        fullCorePath = coreDir.filePath(coreFileName);
    }
    else {
        qWarning() << "Could not find a .dll file in" << corePath;
        return;
    }

    qDebug() << "Launching Core:" << fullCorePath;

    QString gamePath = data;
    qDebug() << "Launching Game:" << gamePath;

    QStringList arguments;
    arguments << "-f"                     // Fullscreen
              << "-L" << fullCorePath     // Load Core
              << gamePath;                // Load Game
    QString path = Config::instance()["retroarch_path"].toString();
    QProcess::startDetached(path, arguments);
}

void UIManager::registerClass()
{
    qmlRegisterSingletonType<UIManager>("com.uimanager",1,1,"UIManager",singletonProvider);
}
QObject *UIManager::singletonProvider(QQmlEngine *, QJSEngine *)
{
    return getInstance();
}
QString UIManager::basePath() const
{
    return m_basePath;
}

void UIManager::setBasePath(const QString &newBasePath)
{
    if (m_basePath == newBasePath)
        return;
    m_basePath = newBasePath;
    emit basePathChanged();
}

UIManager * UIManager::getInstance()
{
    if(m_object == nullptr) {
        m_object = new UIManager();
    }
    return m_object;
}

void UIManager::initCarousel(QJsonDocument doc)
{
    QVariantMap rootMap = doc.toVariant().toMap();
    QVariantList systemsList = rootMap["systems"].toList();
    if(systemsList.isEmpty())
    {
        qWarning() << "No systems found in the JSON!";
        return;
    }
    //QVariantList gamesList = firstSystemMap["games"].toList();

    QVariantList gamesList;
    QVariantMap firstSystemMap = systemsList.first().toMap();
    for (int i = 0; i < systemsList.count(); ++i) {
        QVariantMap qMap = systemsList.at(i).toMap();
        gamesList.append(qMap["games"].toList());
    }



    setcurrentGamesList(gamesList);
    qInfo() << "Successfully loaded" << gamesList.count() << "games into the carousel!";
}

QVariantList UIManager::currentGamesList() const
{
    return m_currentGamesList;
}

void UIManager::setcurrentGamesList(const QVariantList &newCurrentGamesList)
{
    if (m_currentGamesList == newCurrentGamesList)
        return;
    m_currentGamesList = newCurrentGamesList;
    emit currentGamesListChanged();
}
