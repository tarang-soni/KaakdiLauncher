import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import com.uimanager 1.1

Window {
    id: root
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Hello World")
    property string gameDataPath: ""
    property string oldImageUrl: "qrc:/Images/super-mario-3d-world-logo.jpg"
    property string currImageUrl: "qrc:/Images/super-mario-3d-world-logo.jpg"
    property string gameName: "None"
    Timer {
        id: bgUpdateTimer
        interval: 200
        repeat: false

        onTriggered: {
            var gameObj = UIManager.currentGamesList[gameCarousel.currentIndex];

            if (gameObj) {
                oldImageUrl = currImageUrl;
                currImageUrl = "file:///" + UIManager.basePath + "/" + gameObj.bg;
                gameDataPath = UIManager.basePath + "/" + gameObj.rom_path
                crossFadeAnim.start();

                gameName = gameObj.title;
            }
        }
    }

    ListModel {
        id: scrollModel

    }
    Component {
        id: scrollDelegate
        Item {
            id: delegateRoot
            property string gameLogo: "file:///" + UIManager.basePath + "/" + modelData.logo
            property bool isSelected: ListView.isCurrentItem

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

            Image {
                anchors.fill: parent
                source: gameLogo
                asynchronous: true
                sourceSize.width: 150
                sourceSize.height: 150
                layer.enabled: true
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
                onClicked: {
                    gameCarousel.currentIndex = index;
                }
            }
        }
    }

    Item {
        anchors.fill: parent

        Image {
            id: bgBotom
            anchors.fill: parent
            source: oldImageUrl
            sourceSize.width: 1920
            sourceSize.height: 1080
        }
        Image {
            id: bgTop
            anchors.fill: parent
            source: currImageUrl
            sourceSize.width: 1920
            sourceSize.height: 1080
        }
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            gradient: Gradient {
                GradientStop {
                    color: "#77000000"
                    position: 0.3
                }
                GradientStop {
                    color: "#00000000"
                    position: 0.7
                }
                GradientStop {
                    color: "#77000000"
                    position: 1
                }
            }
        }

        NumberAnimation {
            id: crossFadeAnim
            target: bgTop
            property: "opacity"
            from: 0.0
            to: 1.0
            duration: 300
        }

        ColumnLayout {
            anchors.fill: parent
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                RowLayout {

                    Layout.preferredHeight: 100
                    spacing: 20
                    Button {
                        Layout.preferredWidth: 50
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            color: "red"
                        }
                    }
                    Button {
                        Layout.preferredWidth: 50
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            color: "red"
                        }
                    }
                    Button {
                        Layout.preferredWidth: 50
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            color: "red"
                        }
                    }
                }
                Item {
                    Layout.fillWidth: true
                }

                RowLayout {

                    Layout.preferredHeight: 100
                    spacing: 20
                    layoutDirection: Qt.RightToLeft
                    Button {
                        Layout.preferredWidth: 50
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            color: "red"
                        }
                    }
                    Button {
                        Layout.preferredWidth: 50
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            color: "red"
                        }
                    }
                    Button {
                        Layout.preferredWidth: 50
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            color: "red"
                        }
                    }
                }
            }
            ListView {
                id: gameCarousel
                orientation: Qt.Horizontal
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                delegate: scrollDelegate
                model: UIManager.currentGamesList
                spacing: 20
                snapMode: ListView.SnapOneItem
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: 100 + 50
                preferredHighlightEnd: 100 + 100
                highlightMoveVelocity: -1
                highlightMoveDuration: 300
                onCurrentIndexChanged: {
                    bgUpdateTimer.restart();
                }
            }
            Label {
                text: gameName
                color: "#fff"
                font.bold: true
                font.pointSize: 25
                Layout.leftMargin: 125
                Layout.topMargin: 200
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#999"
                    blurMax: 16
                }
            }

            Rectangle {
                Layout.preferredWidth: 300
                Layout.preferredHeight: 80
                Layout.leftMargin: 100
                Layout.topMargin: 20
                radius: 40
                color: "#77ffffff"
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#000"
                    blurMax: 16
                }
                Label {
                    // anchors.centerIn: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Play Game"
                    color: "#fff"
                    font.bold: true
                    font.pointSize: 25
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        UIManager.playGame(gameDataPath);
                    }
                }
            }
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
