import QtQuick 2.15
import QtQuick.Controls 2.15
Rectangle
{
   // property bool isHomePage: stack_view.depth == 1 ? true:false
    StackView
    {
        id:stack_view
        anchors.fill: parent
        initialItem:HomeFlow
        {
            id:home_flow
        }
        property int duration: 500
        pushEnter:Transition {
                     PropertyAnimation {
                         property: "width"
                         from: 0
                         to:parent.width
                         duration: duration
                        easing.type: Easing.OutCirc
                     }

                     PropertyAnimation {
                         property: "height"
                         from: 0
                         to:parent.height
                         duration: duration
                         easing.type:Easing.OutCirc
                     }
                     PropertyAnimation {
                         property: "x"
                         from: parent.width/2
                         to:0
                         duration: duration
                         easing.type:Easing.OutCirc
                     }
                     PropertyAnimation {
                         property: "y"
                         from: parent.height/2
                         to:0
                         duration: duration
                         easing.type:Easing.OutCirc
                     }
                      PropertyAnimation {
                          properties:"radius"
                          from :100
                          to:0
                      }
                }
        popExit: Transition {
            PropertyAnimation {
                property: "width"
                from: parent.width
                to:0
                duration: duration
               easing.type:Easing.OutCirc
            }

            PropertyAnimation {
                property: "height"
                from: parent.height
                to:0
                duration: duration
                easing.type: Easing.OutCirc
            }
            PropertyAnimation {
                property: "x"
                from:0
                to:parent.width/2
                duration: duration
                easing.type: Easing.OutCirc
            }
            PropertyAnimation {
                property: "y"
                from: 0
                to:parent.height/2
                duration: duration
                easing.type:Easing.OutCirc
            }
            PropertyAnimation {
                properties:"radius"
                from :0
                to:100
            }
        }
        popEnter: Transition {}
        pushExit: Transition {
            PropertyAnimation {
                property: "width"
                from: parent.width
                to:parent.width
                duration: duration
            }

            PropertyAnimation {
                property: "height"
                from: parent.height
                to:parent.height
                duration: duration
            }
        }

    }

    Button
    {
        id:back_btn
        visible: stack_view.depth>1
        enabled: stack_view.depth>1
        anchors.top: parent.top
        anchors.left: parent.left
        onClicked:
        {
            stack_view.pop()
        }
        width: 40
        height: 40
        background: Rectangle{color: "transparent"}
         Text {
            id: back_btn_icon
            font.family:"iconfont"
            font.pixelSize: 30
            text:"\ue733"
            color: "gray"
        }
    }
    Connections
    {
        target: home_flow
        function onPageBtnClicked(s)
        {
           stack_view.push(s)
        }
    }

}
