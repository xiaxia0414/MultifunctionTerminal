import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
Rectangle
{
        property int size: 40
        property color timeColor: "#5781F3"

        height: size*2
        width: size*4

        property string currentDateString: Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss ddd")
        property var s: []
        id:clock
        function currentDateTime(){
               return Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss ddd");
        }
        color: "transparent"
       // anchors.fill: parent
        Label {
            id: time
            text:s[1]
            anchors.top: parent.top
            font.pixelSize: size
            color: timeColor
        }
        Label {
            id: ymd
            text:s[0]
            anchors.top: time.bottom
            anchors.left: time.left
            font.pixelSize: size/2
            color: timeColor
        }
        Label {
            id: week
            text:s[2]
            anchors.top: time.bottom
            anchors.right:time.right
            font.pixelSize: size/2
            color: timeColor
        }
        layer.enabled: true
        layer.effect:DropShadow
        {
            id:shadow
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 0
            radius: 5
            color: "#5781F3"		//argb
        }
        Timer{
                id: timer
                interval: 1000 //间隔(单位毫秒):1000毫秒=1秒
                repeat: true //重复
                onTriggered:{
                    currentDateString = currentDateTime();
                    s = currentDateString.split(" ")
                   // console.log(s)
                }
            }
        Component.onCompleted:
        {
            timer.start()
             s = currentDateString.split(" ")
        }

    }


