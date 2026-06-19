#ifndef APPCORE_H
#define APPCORE_H

#include <QObject>
#include <QSharedPointer>
#include"librarymanager.h"
class AppCore : public QObject
{
    Q_OBJECT
public:
    explicit AppCore(QObject *parent = nullptr);

signals:
private:
    QSharedPointer<LibraryManager> m_libraryManager;
};

#endif // APPCORE_H
