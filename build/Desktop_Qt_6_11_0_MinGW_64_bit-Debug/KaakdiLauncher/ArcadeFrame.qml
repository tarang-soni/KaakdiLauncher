import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
ColumnLayout {
    id:arcadeFrameRoot
    property var gameModel:null
    property string gameName:""
    signal updateTimer(var gameObj)
    signal requestPlayGame()

    GameCarousel{
        Layout.fillWidth: true
        Layout.preferredHeight: 300
        model:gameModel
        onGameSelected:(gameObj)=>{
            updateTimer(gameObj)
        }
    }

    Label {
        text: arcadeFrameRoot.gameName
        color: "#fff"
        font.bold: true
        font.pointSize: 25
        Layout.leftMargin: 125
        Layout.topMargin: 200
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#999"
            blurMax: 16
        }
    }

    Rectangle {
        Layout.preferredWidth: 300
        Layout.preferredHeight: 80
        Layout.leftMargin: 100
        Layout.topMargin: 20
        radius: 40
        color: "#77ffffff"
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#000"
            blurMax: 16
        }
        Label {
            // anchors.centerIn: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "Play Game"
            color: "#fff"
            font.bold: true
            font.pointSize: 25
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                arcadeFrameRoot.requestPlayGame();
            }
        }
    }
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }
}
