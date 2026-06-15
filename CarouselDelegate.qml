import QtQuick
import QtQuick.Effects

Item {
    id: delegateRoot
    property string gameLogo: ""
    property bool isSelected
    signal clicked()
    implicitWidth: 100
    implicitHeight: 100

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

    MouseArea {
        anchors.fill: parent
        onClicked: delegateRoot.clicked()
    }
}
