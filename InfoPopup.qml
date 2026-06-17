import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
Popup  {
    property color bgColor:Qt.rgba(0,0,0,.8)
    property color popupColor:Qt.rgba(0.3,0.3,0.3,0.65)
    property string gameBgPath:""
    property string gameCoverPath:""
    width:parent.width*.8
    height:parent.height*.8
    anchors.centerIn: parent
    modal: true
    background: Rectangle {
        id:popupRoot

        color: popupColor
        radius:20
    }
    Item {
        id: popupBgMask
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        layer.enabled: true
        visible: false
        height: parent.height / 4
        Rectangle {
            anchors.fill: parent
            radius: 20
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 20
        }
    }

    Image{
        id:topGameDisplayImg
        anchors{
            top:parent.top
            left:parent.left
            right:parent.right
        }
        source:gameBgPath
        sourceClipRect: Qt.rect(100, -250, 1300, 1300)
        height:parent.height/4
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: popupBgMask
        }
        fillMode: Image.PreserveAspectCrop

        Rectangle{
            anchors.fill: parent
            gradient: Gradient{
                orientation :Gradient.Horizontal
                GradientStop{
                    position:0
                    color:Qt.rgba(0,0,0,0.9)
                }
                GradientStop{
                    position:1
                    color:Qt.rgba(0,0,0,0)
                }
            }
        }
        RowLayout{
            anchors.fill: parent
            anchors.leftMargin: 40
            anchors.rightMargin: 40
            spacing:30
            //game cover
            CarouselDelegate{
                implicitWidth: 150
                implicitHeight: 150
                Layout.alignment: Qt.AlignVCenter
                gameLogo:gameCoverPath
            }
            //text and button details
            ColumnLayout{
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing:5
                Text{
                    Layout.fillWidth: true
                    text:"Game Name:"
                    color:Qt.rgba(1,1,1,0.6)
                    font.pixelSize: 16
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 1.5
                }
                Text{
                    Layout.fillWidth: true
                    text:"Mario Kart"
                    color:"white"
                    font.pixelSize: 42
                    font.bold: true
                    Layout.bottomMargin: 15

                }
                Rectangle{
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 45
                    radius:height/2
                    color:Qt.rgba(1,1,1,0.6)
                    border.width: 2
                    border.color: Qt.rgba(1, 1, 1, 0.5)
                    Text {
                        anchors.centerIn: parent
                        text: "PLAY"
                        color: "white"
                        font.pixelSize: 18
                        font.bold: true
                        font.letterSpacing: 2
                    }
                }
            }
        }
    }
    Overlay.modal: Rectangle {
        color: bgColor
    }
}
