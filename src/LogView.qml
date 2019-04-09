import QtQuick 2.12
import QtQuick.Controls 2.12
import Novos.Tools 1.0

Item {
    id: root

    Item {
        id: _private_
        property string font: "Adobe Song Std L"
        property string sectionFont: "Cambria"
        property int fontSize: 10
        property int sectionFontSize: 10

        property int datetimeWidth: 86

        property color traceColor: "#33FFFFFF"
        property color debugColor: "#33999999"
        property color warningColor: "#33FFFF00"
        property color infoColor: "#3300FF00"
        property color errorColor: "#33990000"
        property color fatalColor: "#55FF0000"
    }

    property var model: null

    Component {
        id: sectionDelegate

        Rectangle
        {
            anchors.left: parent.left
            anchors.right: parent.right

            height: 20
            color: "#770000FF"

            Item {
                id: datetimeItem
                height: 20
                width: _private_.datetimeWidth
                anchors.left: parent.left

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.margins: 6
                    text: model.date(section)
                    font.family: _private_.sectionFont
                    font.pointSize: _private_.sectionFontSize
                }
            }
            Item {
                id: typeItem
                height: 20
                width: 60
                anchors.left: datetimeItem.right

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.margins: 6
                    text: "Type"
                    font.family: _private_.sectionFont
                    font.pointSize: _private_.sectionFontSize
                }
            }
            Item {
                id: fileItem
                height: 20
                width: 160
                anchors.left: typeItem.right

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.margins: 6
                    text: "File"
                    font.family: _private_.sectionFont
                    font.pointSize: _private_.sectionFontSize
                }
            }
            Item {
                id: lineItem
                height: 20
                width: 40
                anchors.left: fileItem.right

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.margins: 6
                    text: "Line"
                    font.family: _private_.sectionFont
                    font.pointSize: _private_.sectionFontSize
                }
            }
            Item {
                id: functionItem
                height: 20
                width: 600
                anchors.left: lineItem.right

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.margins: 6
                    text: "Function"
                    font.family: _private_.sectionFont
                    font.pointSize: _private_.sectionFontSize
                }
            }
            Item {
                anchors.left: functionItem.right
                anchors.right: parent.right
                height: 20

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.margins: 6
                    text: "Message"
                    font.family: _private_.sectionFont
                    font.pointSize: _private_.sectionFontSize
                }
            }
        }

    }

    Component {
        id: loglineDelegate

        Rectangle
        {
            id: backgroundRectangle
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.max(functionItem.height, Math.max(20, messageItem.height))

            border.width: listView.currentIndex == index ? 1 : 0
            border.color: "black"

            state: type

            states: [
                State {
                    name: "TRACE"
                    PropertyChanges { target: backgroundRectangle; color: _private_.traceColor }
                },
                State {
                    name: "DEBUG"
                    PropertyChanges { target: backgroundRectangle; color: _private_.debugColor }
                },
                State {
                    name: "WARN"
                    PropertyChanges { target: backgroundRectangle; color: _private_.warningColor }
                },
                State {
                    name: "INFO"
                    PropertyChanges { target: backgroundRectangle; color: _private_.infoColor }
                },
                State {
                    name: "ERROR"
                    PropertyChanges { target: backgroundRectangle; color: _private_.errorColor }
                },
                State {
                    name: "FATAL"
                    PropertyChanges { target: backgroundRectangle; color: _private_.fatalColor }
                }
            ]

            MouseArea {
                anchors.fill: parent
                onClicked: listView.currentIndex = index
            }

            Item {
                id: datetimeItem
                height: 20
                width: _private_.datetimeWidth
                anchors.left: parent.left

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.margins: 6
                    text: Qt.formatDateTime(datetime, "hh:mm:ss.zzz");
                    font.family: _private_.font
                    font.pointSize: _private_.fontSize
                }
            }
            Item {
                id: typeItem
                height: 20
                width: 60
                anchors.left: datetimeItem.right

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.margins: 6
                    text: type
                    font.family: _private_.font
                    font.pointSize: _private_.fontSize
                }
            }
            Item {
                id: fileItem
                height: 20
                width: 160
                anchors.left: typeItem.right

                Text {
                    id: fileText
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.margins: 6
                    text: file
                    font.family: _private_.font
                    font.pointSize: _private_.fontSize
                    elide: Text.ElideLeft
                }
            }
            Item {
                id: lineItem
                height: 20
                width: 40
                anchors.left: fileItem.right

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    anchors.margins: 6
                    text: line
                    font.family: _private_.font
                    font.pointSize: _private_.fontSize
                }
            }
            Item {
                id: functionItem
                height: functionText.contentHeight
                width: 600
                anchors.left: lineItem.right
                anchors.margins: 2

                Text {
                    id: functionText
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.margins: 6
                    text: func
                    font.family: _private_.font
                    font.pointSize: _private_.fontSize
                    wrapMode: Text.WordWrap
                }
            }
            Item {
                id: messageItem
                anchors.left: functionItem.right
                anchors.right: parent.right
                anchors.margins: 2
                height: messageText.contentHeight

                Text {
                    id: messageText
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.margins: 6
                    text: message
                    font.family: _private_.font
                    font.pointSize: _private_.fontSize
                    wrapMode: Text.WordWrap
                }
            }
        }
    }

    ListView {
        id: listView
        anchors.fill: parent

        delegate: loglineDelegate

        section.property: "idx"
        section.criteria: ViewSection.FullString
        section.delegate: sectionDelegate

        model: root.model

        focus: true

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AlwaysOn
        }
    }
}
