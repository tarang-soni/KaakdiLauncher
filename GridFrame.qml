import QtQuick
import QtQuick.Layouts
import com.uimanager
Item {
    id:root
        signal gameSelected(var gameObj)

    GridView{
        id:gridView
        anchors.fill:parent
        topMargin: 20
        leftMargin: (width%cellWidth)/2
        rightMargin: leftMargin
        cellWidth:120
        cellHeight:120
        model:UIManager.currentGamesList
        clip:true

        delegate:CarouselDelegate
        {
            gameLogo: "file:///" + UIManager.basePath + "/" + modelData.logo
            isSelected: GridView.isCurrentItem
            onClicked:gridView.currentIndex=index
            scale:isSelected?1.2:1.0
            z: isSelected?10:1
            Behavior on scale{
                NumberAnimation{
                    duration:200
                    easing.type:Easing.OutBack
                    easing.overshoot: 1.5
                }
            }

        }
        onCurrentIndexChanged: {
            var gameObj = gridView.model[currentIndex];
            //console.log("index:"+currentIndex);
            //console.log("game name from carousel:"+gameObj.title);
            if (gameObj) {
                root.gameSelected(gameObj);
            }

            //bgUpdateTimer.restart();
        }

    }
}
