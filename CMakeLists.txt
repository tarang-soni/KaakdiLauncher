cmake_minimum_required(VERSION 3.16)

project(KaakdiLauncher VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
find_package(Qt6 REQUIRED COMPONENTS Quick Xml)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appKaakdiLauncher
    main.cpp
)

qt_add_qml_module(appKaakdiLauncher
    URI KaakdiLauncher
    QML_FILES
        Main.qml
        RESOURCES Resources.qrc
        SOURCES uimanager.h uimanager.cpp
        SOURCES librarymanager.h librarymanager.cpp
        SOURCES GameFileObj.h
        SOURCES appcore.h appcore.cpp
        QML_FILES ArcadeFrame.qml
        QML_FILES SplashScreen.qml
        QML_FILES CarouselDelegate.qml
        QML_FILES GameCarousel.qml
        QML_FILES TopNavBar.qml
        QML_FILES NavButtonDelegate.qml
        QML_FILES GridFrame.qml
        QML_FILES InfoPopup.qml
        QML_FILES SearchPopup.qml
        SOURCES Config.h Config.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appKaakdiLauncher PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appKaakdiLauncher
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appKaakdiLauncher
    PRIVATE Qt6::Quick Qt6::Xml
)
file(COPY "config/config.json" DESTINATION "config")
install(TARGETS appKaakdiLauncher
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
