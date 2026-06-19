cmake_minimum_required(VERSION 3.16)

project(KaakdiLauncher VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
find_package(Qt6 REQUIRED COMPONENTS Quick Xml)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appKaakdiLauncher
    src/main.cpp
)

qt_add_qml_module(appKaakdiLauncher
    URI KaakdiLauncher
    QML_FILES
        qml/Main.qml
        RESOURCES Resources.qrc
        SOURCES src/uimanager.h src/uimanager.cpp
        SOURCES src/librarymanager.h src/librarymanager.cpp
        SOURCES src/GameFileObj.h
        SOURCES src/appcore.h src/appcore.cpp
        QML_FILES qml/ArcadeFrame.qml
        QML_FILES qml/SplashScreen.qml
        QML_FILES qml/CarouselDelegate.qml
        QML_FILES qml/GameCarousel.qml
        QML_FILES qml/TopNavBar.qml
        QML_FILES qml/NavButtonDelegate.qml
        QML_FILES qml/GridFrame.qml
        QML_FILES qml/InfoPopup.qml
        QML_FILES qml/SearchPopup.qml
        SOURCES src/Config.h src/Config.cpp
        QML_FILES qml/GlassPopup.qml
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
