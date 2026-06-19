import QtQuick
import QtQuick.Controls
import QtQuick.Effects
Popup {
    id:root
    width:parent.width*.7
    height:parent.height*0.7
    anchors.centerIn: parent
    modal:true
    background:Item{
        ShaderEffectSource{
            id:behindCapture
            anchors.fill: parent
            sourceItem:root.parent
            sourceRect:Qt.rect(root.x,root.y,root.width,root.height)
            live:true
            hideSource:false
            visible: false
        }
        MultiEffect {
            anchors.fill: parent
            source: behindCapture

            // Blur Properties
            blurEnabled: true
            blur: 1
            blurMax: 48
            blurMultiplier: 0.7
            saturation: 0.1
            autoPaddingEnabled: false
            // Mask Properties
            maskEnabled: true
            maskSource: cornerMask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0

        }

        Rectangle{
            id:cornerMask
            anchors.fill: parent
            radius:20
            layer.enabled: true
            visible:false
            layer.smooth: true
        }


        Item
        {
            id:bgMask
            layer.enabled:true
            visible:false
            anchors{
                top:parent.top
                left:parent.left
                right:parent.right
            }
            height:parent.height*.4
            Rectangle{
                anchors.fill: parent
                radius:20
            }
            Rectangle{
                anchors{
                    bottom:parent.bottom
                    left:parent.left
                    right:parent.right
                }
                height:20
            }
        }
        Item
        {
            id:bgMaskBottom
            layer.enabled:true
            visible:false
            anchors{
                top:bgMask.bottom
                bottom:parent.bottom
                left:parent.left
                right:parent.right
            }
            Rectangle{
                anchors{
                    top:parent.top
                    left:parent.left
                    right:parent.right
                }
                height:20
            }
            Rectangle{
                anchors.fill: parent
                radius:20
            }

        }
        Rectangle {
            id:upperRect
            anchors{
                top:parent.top
                left:parent.left
                right:parent.right
            }
            height:parent.height*.4
            //radius: 20
            color: Qt.rgba(1, 1, 1, 0.0)



            layer.enabled: true
            layer.effect: MultiEffect{
                maskEnabled: true
                maskSource: bgMask
            }
        }
        Rectangle {
            anchors{
                top:upperRect.bottom
                bottom:parent.bottom
                left:parent.left
                right:parent.right
            }
            height:parent.height*.4
            //radius: 20
            color: Qt.rgba(1, 1, 1, 0.22)

            layer.enabled: true
            layer.effect: MultiEffect{
                maskEnabled: true
                maskSource: bgMaskBottom
            }
        }
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            radius: 20
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.3)
        }

    }

}
