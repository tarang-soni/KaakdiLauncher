#include "uimanager.h"
#include<QCoreApplication>

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
    QString corePath = QDir(basePath).filePath("Cores/n64/mupen64plus_next_libretro.dll");
    qDebug()<<corePath;

    QString gamePath = data;
         qDebug()<<gamePath;
    QStringList arguments;
     arguments << "-f"
               << "-L" << corePath
              << gamePath;
    QProcess::startDetached(retroarchPath, arguments);
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
    QVariantMap firstSystemMap = systemsList.first().toMap();
    QVariantList gamesList = firstSystemMap["games"].toList();
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
