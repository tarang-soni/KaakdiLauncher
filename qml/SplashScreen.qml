import QtQuick

Rectangle{
    id:splashBG
    anchors.fill: parent
    color:"white"
    Image{
        id:splashLogo
        anchors.centerIn: parent
        sourceSize.height: 350
        source:"qrc:/assets/Images/logo.png"
        rotation:0

        SequentialAnimation on rotation{
            loops:Animation.Infinite
            NumberAnimation{
                to:360
                duration:1000
            }
        }
    }
    z:999

}
