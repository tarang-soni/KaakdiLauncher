import QtQuick
import QtQuick.Controls
Popup  {
    width:parent.width*.7
    height:parent.height*.7
    anchors.centerIn: parent
    modal: true
    Rectangle{
        anchors.fill: parent
        color: Qt.rgba(1, 1, 1, 0.5)
    }
}
