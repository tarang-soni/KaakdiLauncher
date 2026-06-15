import QtQuick
import QtQuick.Controls.Basic
Button {
    id:root

    property string iconPath:""
    property bool isGroupButton:true
    width:50
    height:50
    hoverEnabled: false
    checkable: isGroupButton

    signal menuSelected()
    contentItem:Image{
        source:iconPath
        fillMode: Image.PreserveAspectFit
    }
    background:Rectangle{
        color:"transparent"
    }
    scale:checked?1.2:1
    onCheckedChanged:{
        if(isGroupButton && checked){
            menuSelected();
        }
    }
    onClicked:{
        if(!isGroupButton)
        {
            animateButton()
            menuSelected();
        }
    }
    SequentialAnimation{
        id:pressAnim
        NumberAnimation{
            target:root
            property:"scale"
            to:1.2
            from:1
            duration:100
            easing.type:Easing.OutQuad
        }
        NumberAnimation{
            target:root
            property:"scale"
            to:1
            from:1.2
            duration:100
            easing.type:Easing.OutQuad
        }
    }

    function animateButton()
    {
        if(!isGroupButton)
        {
            pressAnim.start()
        }
    }
}
