import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
Item{
    id:root
    anchors.fill: parent
    visible:false
    state: "closed"
    property color bgColor:Qt.rgba(0,0,0,.8)
    property color searchColor:Qt.rgba(0.3,0.3,0.3,0.65)
    property int boxWidth:500
    function open(){
        root.visible=true
        state = "open"
    }
    function close()
    {
        state="closed"
    }

    Rectangle{
        id:bg
        anchors.fill: parent
        color:bgColor
        MouseArea{
            anchors.fill: parent
            onClicked:{
                root.close();
            }
        }

    }
    ColumnLayout{
        anchors.fill: parent
        anchors.topMargin: 60
        spacing: 20

        TextField{
            id:searchBar
            Layout.preferredWidth:boxWidth
            Layout.preferredHeight: 60
            Layout.alignment:Qt.AlignHCenter
            placeholderText:qsTr("Enter game name")
            horizontalAlignment:TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            font.pixelSize: 20
            background:Rectangle{
                color:searchColor
                radius:10
            }
        }
        Rectangle{
            id:resultArea
            Layout.preferredWidth: boxWidth
            Layout.preferredHeight :parent.height*.6
            Layout.alignment:Qt.AlignHCenter
            color:searchColor
            radius:10
            MouseArea{
                anchors.fill: parent
                onClicked:{

                }
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
    states:[
        State{
            name:"closed"
            PropertyChanges {
                target: searchBar
                Layout.preferredWidth: 0
                opacity:0
            }
            PropertyChanges {
                target: bg
                opacity:0
            }
            PropertyChanges {
                target: resultArea
                Layout.preferredWidth: 0
                opacity:0
            }
        },
        State{
            name:"open"
            PropertyChanges {
                target: searchBar
                Layout.preferredWidth: boxWidth
                opacity:1
            }
            PropertyChanges {
                target: bg
                opacity:1
            }
            PropertyChanges {
                target: resultArea
                Layout.preferredWidth: boxWidth
                opacity:1
            }
        }

    ]
    transitions:[
        Transition{
            from:"*"
            to:"open"
            ParallelAnimation{

                NumberAnimation{
                    properties:"Layout.preferredWidth,opacity"
                    duration:200
                    easing.type: Easing.OutCirc
                }
            }
        },
        Transition{
            from:"*"
            to:"closed"
            SequentialAnimation {
                NumberAnimation{
                    properties:"Layout.preferredWidth,opacity"
                    duration:300
                    easing.type: Easing.OutCirc
                }
                ScriptAction {
                    script: root.visible = false   // ← runs after animation
                }
            }
        }

    ]
}
