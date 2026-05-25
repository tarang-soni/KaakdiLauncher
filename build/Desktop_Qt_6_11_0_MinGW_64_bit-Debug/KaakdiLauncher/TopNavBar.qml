import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
RowLayout {
    id:menuRoot
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