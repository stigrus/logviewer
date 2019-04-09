import QtQuick 2.9
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3

import Novos.Tools 1.0

ApplicationWindow {
    visible: true
    width: 1600
    height: 800
    title: qsTr("Scroll")

    DropArea {
        id: dropArea;
        anchors.fill: parent;
        onEntered: {
        }
        onDropped: {
            if(drop.hasUrls) {
                logModel.load(drop.urls[0])
            }
        }
        onExited: {
        }
    }

    FileDialog {
        id: fileDialog
        title: "Open log file"
        //folder: shortcuts.home
        onAccepted: {
            logModel.load(fileDialog.fileUrls[0])
        }
    }

    LogModel {
        id: logModel
    }

    menuBar: MenuBar {
        Menu {
            title: "File"
            MenuItem {
                text: "Open..."
                onClicked: fileDialog.open()
            }
            MenuItem {
                text: "Exit"
                onClicked: Qt.quit()
            }
        }
        Menu {
            id: filerMenu
            title: "Filter"
            Repeater
            {
                model: logModel.types

                delegate: CheckBox {
                    checked: true
                    text: modelData

                    onCheckedChanged: {
                       logModel.setType(modelData, checked);
                    }
                }
            }
        }
    }

    /*header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("Open")
                //onClicked: stack.pop()
            }
            GroupBox {
                //title: qsTr("Filter")
                RowLayout {
                    CheckBox {
                        text: "Trace"
                    }
                    CheckBox {
                        text: "Debug"
                    }
                    CheckBox {
                        text: "Warn"
                    }
                    CheckBox {
                        text: "Info"
                    }
                    CheckBox {
                        text: "Error"
                    }
                    CheckBox {
                        text: "Fatal"
                    }
                }
            }

            Label {
                text: "Title"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                text: qsTr("⋮")
                onClicked: menu.open()
            }
        }
    }*/

    LogView
    {
        id: logView
        anchors.fill: parent

        model: logModel
    }
}
