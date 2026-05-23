#include "appcore.h"
#include"uimanager.h"

AppCore::AppCore(QObject *parent)
    : QObject{parent}
{
    UIManager::registerClass();
    m_libraryManager = QSharedPointer<LibraryManager>::create();
    connect(m_libraryManager.data(),&LibraryManager::filesReady,UIManager::getInstance(),&UIManager::initCarousel);
    m_libraryManager->scan();
}
