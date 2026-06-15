import QtQuick

import com.uimanager 1.1

ListView {
    id: gameCarousel
    signal gameSelected(var gameObj)
    orientation: Qt.Horizontal

    spacing: 20
    snapMode: ListView.SnapOneItem
    highlightRangeMode: ListView.StrictlyEnforceRange
    preferredHighlightBegin: 100 + 50
    preferredHighlightEnd: 100 + 100
    highlightMoveVelocity: -1
    highlightMoveDuration: 300
    delegate: CarouselDelegate {
        implicitWidth: isSelected ? 150 : 100
        implicitHeight: isSelected ? 150 : 100

        Behavior on implicitWidth {
            NumberAnimation {
                duration: 200
                easing.type:Easing.OutBack
            }
        }
        Behavior on implicitHeight {
            NumberAnimation {
                duration: 200
                easing.type:Easing.OutBack
            }
        }
        isSelected: ListView.isCurrentItem
        gameLogo: "file:///" + UIManager.basePath + "/" + modelData.logo
        onClicked: gameCarousel.currentIndex = index
    }

    onCurrentIndexChanged: {
        var gameObj = gameCarousel.model[currentIndex];
        //console.log("index:"+currentIndex);
        //console.log("game name from carousel:"+gameObj.title);
        if (gameObj) {
            gameCarousel.gameSelected(gameObj);
        }

        //bgUpdateTimer.restart();
    }
}
