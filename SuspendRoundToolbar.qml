import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "qrc:/Global/"
Rectangle {
    id:root
    property var size: 35
    property color foreColor :"green"
    property color textColor
    property color shadowColor:Theme.shadowColor
    property color toolBoxColor: Theme.cardColor
    property color pressedColor: (Theme.themeState === "lightTheme") ? "#EBEBEB" : "#121212"
    property var stackSwith: value

    width: size+5
    height: size+5
    color:"transparent"
    Rectangle
    {
        id:tool_btn
        z:10
        color:foreColor
        width:size
        height: size
        anchors.margins: 5
        radius: tool_btn.width/2
        MouseArea
        {
            id:tool_btn_mouseArea
            anchors.fill: parent
             drag.target: root
            onClicked: {
                if(root.state == "closeState" )
                {
                    root.state = "expendState"
                }
                else
                {
                   root.state = "closeState"
                }
            }
            onDoubleClicked:
            {
                console.log("doubleClicked")
            }
        }
        Text {
            id: tool_btn_icon
            anchors.centerIn: parent
            anchors.topMargin: -5
            font.family:"iconfont"
            color:"white"
            font.pointSize: 15
            text: root.state == "closeState"? "\ue648":"\ue665"
        }
    }
    Rectangle
    {
        id:tool_box
        width: size
        height: size
        clip: true
        color:toolBoxColor
        //border.color: "black"
        //border.width: 1
        anchors.top: tool_btn.top
        anchors.horizontalCenter: tool_btn.horizontalCenter
        radius: tool_box.width/2
            Button
            {
                id:btn_1
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 0
                width: size-4
                height: size-4
                background: Rectangle
                {
                    id:rect
                    color: btn_1.pressed ?  pressedColor :"transparent"
                    anchors.fill:parent
                    radius:rect.width/2
                }
                onClicked:
                {
                    stackSwith.popPage()
                }
                Text {
                    id: btn_1_icon
                    anchors.centerIn: parent
                    anchors.topMargin: -5
                    font.family:"iconfont"
                    color:Theme.accentColor
                    font.pointSize: size/2
                    text:"\ue666"
                }
            }
            Button
            {
                id:btn_2
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: parent.height/3
                width: size-4
                height: size-4
                background: Rectangle
                {
                    id:rect2
                    color:btn_2.pressed ?  pressedColor :"transparent"
                    anchors.fill:parent
                    radius:rect.width/2
                }
                onClicked:
                {

                        if(Theme.state == "lightTheme")
                        {
                            Theme.setBlackTheme()
                        }
                        else
                        {
                            Theme.setlightTheme()
                        }

                }
                Text {
                    id: btn_2_icon
                    anchors.centerIn: parent
                    anchors.topMargin: -5
                    font.family:"iconfont"
                    color:Theme.accentColor
                    font.pointSize: size/2
                    text:"\ue632"
                }
            }

    }
    layer.enabled: true
    layer.effect:DropShadow
    {
        id:shadow
        //transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 0
        radius:8
        color:shadowColor 		//argb
    }
    states: [
                State {
                    name: "closeState"
                    PropertyChanges {
                        target:tool_box
                        height:size
                    }
                    PropertyChanges {
                        target:root
                        height:size
                    }
                    PropertyChanges {
                        target:tool_box
                        width:size
                    }
                    PropertyChanges {
                        target:btn_1
                        visible:false
                    }
                    PropertyChanges {
                        target:btn_2
                        visible:false
                    }

                },
                State {
                    name: "expendState"
                    PropertyChanges {
                        target:tool_box
                        height:size*3
                    }
                    PropertyChanges {
                        target:tool_box
                        width:size
                    }
                    PropertyChanges {
                        target:root
                        height:size*3
                    }
                    PropertyChanges {
                        target:btn_1
                        visible:true
                    }
                    PropertyChanges {
                        target:btn_2
                        visible:true
                    }

                }
            ]
    transitions: [
                Transition {
                from: "*"; to: "*"
                    PropertyAnimation { target: tool_box; properties: "height"; duration: 200 ;easing.type: Easing.InOutQuad}
                    PropertyAnimation { target: tool_box; properties: "width"; duration: 200;easing.type: Easing.InOutQuad }
                    PropertyAnimation { target: root; properties: "height"; duration: 200 ;easing.type: Easing.InOutQuad}
                    PropertyAnimation { target: btn_1; properties: "visible"; duration: 100;easing.type: Easing.InOutQuad }
                    PropertyAnimation { target: btn_2; properties: "visible"; duration: 100;easing.type: Easing.InOutQuad }
            }
        ]
    Component.onCompleted:
    {
        root.state = "closeState"
    }
}
