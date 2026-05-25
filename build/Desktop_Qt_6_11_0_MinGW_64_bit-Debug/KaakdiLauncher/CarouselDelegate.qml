import QtQuick
import QtQuick.Effects

Item {
    id: delegateRoot
    property string gameLogo: ""
    property bool isSelected: ListView.isCurrentItem
    signal clicked()
    implicitWidth: isSelected ? 150 : 100
    implicitHeight: isSelected ? 150 : 100

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
        }
    }
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
        }
    }
    Rectangle {
        id: maskShape
        anchors.fill: parent
        radius: 20
        visible: false
        layer.enabled: true
    }
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(1,1,1,0.4)
        radius: 20
    }
    Image {
        anchors.fill: parent
        source: gameLogo
        asynchronous: true
        sourceSize.width: 150
        sourceSize.height: 150
        layer.enabled: true
        fillMode: Image.PreserveAspectFit
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: maskShape
        }
    }
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: 3
        border.color: "#ced4da"
        radius: 20
        scale: 1.09
        opacity: delegateRoot.isSelected ? 1.0 : 0.0
        Behavior on opacity {
            //here
            NumberAnimation {
                duration: 200
            }
        }
    }
    // onIsSelectedChanged: {
    //     if (isSelected) {
    //             oldImageUrl = currImageUrl;
    //             currImageUrl = gameBg;
    //             crossFadeAnim.start();

    //             gameName = gameTitle;
    //             gameDataPath = gameRomPath;
    //         }
    // }

    MouseArea {
        anchors.fill: parent
        // onClicked: {
        //     gameCarousel.currentIndex = index;
        // }
        onClicked: delegateRoot.clicked()
    }
}
