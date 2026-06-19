import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts

Popup  {
    id:root
    property color popupColor:Qt.rgba(1, 1, 1, 0.22)
    property string gameBgPath:""
    property string gameCoverPath:""
    property int boxRadius:40
    width:parent.width*.8
    height:parent.height*.8
    anchors.centerIn: parent
    padding:0
    modal: true
    enter:Transition{
        NumberAnimation {
            properties: "opacity,scale"
            duration: 200
            from:0
            to:1
            easing.type: Easing.OutCubic
        }
    }
    exit:Transition{
        NumberAnimation {
            properties: "opacity,scale"
            duration: 200
            from:1
            to:0
            easing.type: Easing.InCubic
        }
    }
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
            radius:boxRadius
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
                radius:boxRadius
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
                radius:boxRadius
            }

        }
        Rectangle {
            id:upperRect
            anchors{
                top:parent.top
                left:parent.left
                right:parent.right
            }
            height:parent.height*.3
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
            color: popupColor

            layer.enabled: true
            layer.effect: MultiEffect{
                maskEnabled: true
                maskSource: bgMaskBottom
            }
        }
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            radius: boxRadius
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.3)
        }
    }

    RowLayout{
        id:topSection
        anchors{
            top:parent.top
            left:parent.left
            right:parent.right
            leftMargin:40
            rightMargin:40

        }
        height:upperRect.height

        spacing:30
        //game cover
        CarouselDelegate{
            radius:boxRadius
            boxCol:popupColor
            implicitWidth: 170
            implicitHeight: 170
            Layout.alignment: Qt.AlignVCenter
            gameLogo:gameCoverPath
        }
        //text and button details
        ColumnLayout{
            //Layout.fillWidth: true
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
                Layout.preferredWidth: 200
                Layout.preferredHeight: 56
                radius:height/2
                color:popupColor
                border.width: 1
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
        Item{
            Layout.fillWidth: true
        }
        ColumnLayout{
            // Layout.fillWidth: true
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            spacing:5
            Text{
                Layout.fillWidth: true
                text:"Rating:"
                color:Qt.rgba(1,1,1,0.6)
                font.pixelSize: 16
                font.capitalization: Font.AllUppercase
                horizontalAlignment: Text.AlignRight
                font.letterSpacing: 1.5
            }
            Text{
                Layout.fillWidth: true
                text:"9/10"
                color:"white"
                font.pixelSize: 42
                horizontalAlignment: Text.AlignRight
                font.bold: true
                Layout.bottomMargin: 15

            }
        }
    }
    Item{
        id:bottomSection
        anchors{
            top:topSection.bottom
            bottom:parent.bottom
            left:parent.left
            right:parent.right
        }

        Flickable{
            id:descArea
            anchors.fill: parent
            contentWidth: width
            contentHeight: contentColumn.implicitHeight
            clip: true
                boundsBehavior: Flickable.StopAtBounds
            ColumnLayout{
                id: contentColumn
                width: descArea.width

                Text{
                    text:"Developer: Tarang Soni"
                    color:"white"
                    topPadding: 20
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                }
                Text{
                    text:"Publisher: Zerorez"
                    color:"white"
                    topPadding: 20
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                }
                Text{
                    text:"Released Date: 20020225T000000"
                    color:"white"
                    topPadding: 20
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                }
                Text{
                    text:"Players: 3"
                    color:"white"
                    topPadding: 20
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                }
                Text{
                    color:"white"
                    text:"Genre:"
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                }
                ListView{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    model:4
                    clip: true
                    delegate:Rectangle{
                        width:90
                        height:50
                        color:Qt.rgba(1,1,1,0.5)
                        radius: 5
                    }
                    spacing:20
                    orientation:ListView.Horizontal
                }
                Text{
                    color:"white"
                    text:"Description:"
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                }
                Text{
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                    color:"white"
                    text:"Tired of endlessly doing battle with meddling bandicoots, the nefarious Dr. Neo Cortex shrinks the entire Earth, and Crash and Coco along with it, to the size of a wumpa fruit. Luckily, Coco invents a machine to reverse the effects, but she needs crystals from around the world to power it. Crash must retrieve the crystals to help return the entire planet to its natural state. Experience Crash's biggest adventure yet, with gameplay modes ranging from side-scrolling to 3D chase levels to aerial dogfight combat sequences. Battle your way through over 20 huge levels and six unique locations to defeat Cortex and save the world."
                }
                Item { height: 20 }

            }
        }
    }



}
