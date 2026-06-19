import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import com.uimanager 1.1

Window {
    id: root
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Hello World")
    property string gameDataPath: ""
    property string oldImageUrl: "qrc:/assets/Images/wallpaperflare.com_wallpaper.jpg"
    property string currImageUrl: "qrc:/assets/Images/wallpaperflare.com_wallpaper.jpg"
    property string gameName: "None"
    property var currGameObj
    SplashScreen{
        id:splashBG
    }
    NumberAnimation {
        id: splashFadeAnim
        target: splashBG
        property: "opacity"
        from: 1.0
        to: 0.0
        duration: 600
        onStarted:{
            menuPanel.visible=true
        }

        onFinished:{
            splashBG.visible=false

        }
    }
    Timer{
        id:fadeTimer
        running:true
        interval:2500
        repeat:false
        onTriggered: {
            splashFadeAnim.start();
        }
    }

    Timer {
        id: bgUpdateTimer
        interval: 200
        repeat: false
        property var pendingGameObj
        onTriggered: {
            if (pendingGameObj) {
                oldImageUrl = currImageUrl;
                currImageUrl = "file:///" + UIManager.basePath + "/" + pendingGameObj.bg;
                gameDataPath = UIManager.basePath + "/" + pendingGameObj.rom_path
                console.log(pendingGameObj.rom_path);
                crossFadeAnim.start();

                gameName = pendingGameObj.title;
            }
        }
    }

    Item {
        id:menuPanel
        anchors.fill: parent
        visible:false
        Image {
            id: bgBotom
            anchors.fill: parent
            source: oldImageUrl
            sourceSize.width: 1920
            sourceSize.height: 1080
        }
        Image {
            id: bgTop
            anchors.fill: parent
            source: currImageUrl
            sourceSize.width: 1920
            sourceSize.height: 1080
        }
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            gradient: Gradient {
                GradientStop {
                    color: "#77000000"
                    position: 0.3
                }
                GradientStop {
                    color: "#00000000"
                    position: 0.7
                }
                GradientStop {
                    color: "#77000000"
                    position: 1
                }
            }
        }

        NumberAnimation {
            id: crossFadeAnim
            target: bgTop
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 300
        }
        Component{
            id:arcadePanelComponent
            ArcadeFrame{
                gameModel:UIManager.currentGamesList
                gameName:gameName
                onUpdateTimer:(gameObj)=>{

                    bgUpdateTimer.pendingGameObj=gameObj;
                    root.currGameObj = gameObj
                    bgUpdateTimer.restart();
                }
                onRequestPlayGame: ()=>{
                    UIManager.playGame(gameDataPath);
                }
            }
        }
        Component{
            id:gridFrameComponent
            GridFrame{

                onGameSelected:(gameObj)=>{

                                   bgUpdateTimer.pendingGameObj=gameObj;
                                   bgUpdateTimer.restart();
                               }
            }
        }

        InfoPopup{
           id:infoPopup
           gameBgPath: "file:///" + UIManager.basePath + "/" + root.currGameObj.bg;
           gameCoverPath:"file:///" + UIManager.basePath + "/" + root.currGameObj.logo;

        }

        SearchPopup{
            id:searchPopup
            z:10
        }

        ColumnLayout {
            anchors.fill: parent
            TopNavBar{
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                onGridMenuButton: {
                    mainStack.replaceCurrentItem(gridFrameComponent)
                }
                onHomeButton: {
                    mainStack.replaceCurrentItem(arcadePanelComponent)
                }

                onSettingsButton:{
                   infoPopup.open()
                }
                onSearchButton: {
                    searchPopup.open()
                }
            }
            StackView{
                id:mainStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                initialItem: arcadePanelComponent

            }

        }

    }
}
