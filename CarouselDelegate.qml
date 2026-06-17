import QtQuick
import QtQuick.Effects

Item {
    id: delegateRoot
    property string gameLogo: ""
    property bool isSelected
    property color boxCol:Qt.rgba(1,1,1,.4)
    signal clicked()
    implicitWidth: 100
    implicitHeight: 100
    property int radius:20
    Rectangle {
        id: maskShape
        anchors.fill: parent
        radius: delegateRoot.radius
        visible: false
        layer.enabled: true
    }
    Rectangle {
        anchors.fill: parent
        color: boxCol
        radius: delegateRoot.radius
        border.width: 1
        border.color:Qt.rgba(1,1,1,.5)
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
        radius: delegateRoot.radius
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
