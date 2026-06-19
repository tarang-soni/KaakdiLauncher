import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
    id: menuRoot
    signal homeButton();
    signal gridMenuButton();
    signal settingsButton();
    signal searchButton();
    ButtonGroup{
        id:navGroup
    }

    RowLayout {

        Layout.preferredHeight: 100
        spacing: 20
        NavButtonDelegate {
            id:homeBtn
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            onMenuSelected:homeButton()
            ButtonGroup.group: navGroup
            checked:true
            iconPath:"qrc:/assets/Images/icons8-home-page-64.png"
        }
        NavButtonDelegate {
            id:gridBtn
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            ButtonGroup.group: navGroup
            onMenuSelected:gridMenuButton()
            iconPath:"qrc:/assets/Images/icons8-grid-90.png"
        }
        NavButtonDelegate {
            id:searchBtn
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            onMenuSelected: searchButton()
            isGroupButton: false
            iconPath:"qrc:/assets/Images/icons8-search-64.png"
        }
    }
    Item {
        Layout.fillWidth: true
    }

    RowLayout {

        Layout.preferredHeight: 100
        spacing: 20
        layoutDirection: Qt.RightToLeft

        NavButtonDelegate {
            id:powerBtn
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            ButtonGroup.group: navGroup
            iconPath:"qrc:/assets/Images/icons8-power-off-button-64.png"
        }
        NavButtonDelegate {
            id:settingsBtn
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            ButtonGroup.group: navGroup
            isGroupButton: false
            iconPath:"qrc:/assets/Images/icons8-settings-64.png"
            onMenuSelected:settingsButton()
        }

    }
}
