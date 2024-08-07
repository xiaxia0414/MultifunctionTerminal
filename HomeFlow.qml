import QtQuick 2.15
import QtQuick 2.0
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "qrc:/Global/"

Rectangle {

    id: root;
    property ListModel model
    property int itemCount: 5
    property  color backgroundColor: Theme.backgroundColor
    property color accnetColor: Theme.accentColor
    property color normalColor: Theme.normalColor

    signal pageBtnClicked(string pageUrl);
    DynamicClock
    {
        id:clock
        timeColor: Theme.accentColor
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 50
        z:99
    }
    color:backgroundColor
    Component {
        id: rectDelegate;

        Item {
            width: 150;
            height: 150;
            id: wrapper;
            property int shadowR: 6
           //property color shadowC:
            z: PathView.z;
            opacity: PathView.itemAlpha;
            scale: PathView.itemScale
            state: wrapper.PathView.isCurrentItem ?"current" : "nocurrent";
            property  string s : info
            Rectangle {
                id:rect1
                width: 120
                height: 120
                anchors.centerIn: parent
                color: Theme.cardColor
                border.width: 0;
                radius: 10
                clip: true
                //border.color: wrapper.PathView.isCurrentItem ?"black" : "lightgray";
                Text
                {
                    id:icon
                    width: 80
                    height: 80
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 80
                    color: accnetColor
                    font.family:"iconfont"
                    text: url;
                    // Rectangle
                    // {
                    //     anchors.fill: parent
                    //     color:"red"
                    // }

                }


                layer.enabled: true
                layer.effect:DropShadow
                {
                    id:shadow
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 4
                    radius: wrapper.shadowR
                    color: Theme.shadowColor	//argb
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        console.log(index)
                        console.log(pathView.currentIndex)
                        var step = Math.abs(pathView.currentIndex-index);
                        var d = pathView.currentIndex-index;
                        if(step == 0)
                        {
                            pageBtnClicked(pageUrl)
                        }
                        while(step--)
                        {
                            if(d<0)
                            {
                                pathView.incrementCurrentIndex()
                            }
                            else
                            {
                                pathView.decrementCurrentIndex()
                            }
                        }

                    }
                }

            }

            states: [
                        State {
                            name: "current"
                            PropertyChanges {
                                target:rect1;
                                border.color:accnetColor
                            }
                            PropertyChanges {
                                target:wrapper;
                                shadowR: 12
                            }
                            PropertyChanges {
                                target:icon;
                                color:accnetColor
                            }

                        },
                        State {
                            name: "nocurrent"
                            PropertyChanges {
                                target:rect1;
                                border.color:"white"
                            }
                            PropertyChanges {
                                target:wrapper;
                                shadowR: 8
                            }
                            PropertyChanges {
                                target:icon;
                                color:normalColor
                            }
                        }
                    ]
            transitions: [
                        Transition {
                        from: "*"; to: "*"
                            PropertyAnimation { target: rect1; properties: "border.color"; duration: 200 }
                            PropertyAnimation { target: icon; properties: "color"; duration: 200 }
                            PropertyAnimation { target:wrapper ; properties: "shadowR"; duration: 300 }
                    }
                    ]

        }
    }
    PathView {
        id: pathView;
        anchors.fill: parent;
        //interactive: true;
        pathItemCount: itemCount;
        preferredHighlightBegin: 0.5;
        preferredHighlightEnd: 0.5;
        delegate: rectDelegate;
        model: ListModel{
            id:model
            ListElement{url:"\ue73f"
            pageUrl:"qrc:/SmartHomePage.qml"
            info:"智能家居"
            }
            ListElement{url:"\ue740"
            pageUrl:"qrc:/SmartHomePage.qml"
            info:"本机信息"
            }
            ListElement{url:"\ue73c"
            pageUrl:"qrc:/WeatherPage.qml"
            info:"天气"
            }
            ListElement{url:"\ue63b"
            pageUrl:"qrc:/SmartHomePage.qml"
            info:"音乐"}
            ListElement{url:"\ue744"
            pageUrl:"qrc:/SmartHomePage.qml"
            info:"设置"
            }
        }
        path:Path {
            startX: 0;
            startY:pathView.height/2 ;
            PathAttribute { name: "z"; value: 0 }
            PathAttribute { name: "itemAlpha"; value: 1.0 }
            PathAttribute { name: "itemScale"; value: 0.6 }
            PathLine { x: pathView.width/2; y:pathView.height/2; }
            PathAttribute { name: "z"; value: 10 }
            PathAttribute { name: "itemAlpha"; value: 1.0 }
            PathAttribute { name: "itemScale"; value: 1.2 }
            PathLine { x: pathView.width; y: pathView.height/2; }
            PathAttribute { name: "z"; value: 0 }
            PathAttribute { name: "itemAlpha"; value: 1.0 }
            PathAttribute { name: "itemScale"; value: 0.6 }
            PathPercent{value:1.0}
        }
        focus: true;
        Keys.onLeftPressed: decrementCurrentIndex();
        Keys.onRightPressed: incrementCurrentIndex();
        Label {
            id: lable
            y: pathView.height/2+80;
            anchors.left: pathView.currentItem.left;
            anchors.right:  pathView.currentItem.right;
            height: 20
            font.pointSize: 15
            horizontalAlignment: Text.AlignHCenter//(1)
            verticalAlignment: Text.AlignVCenter//(2)
            text: pathView.currentItem.s
            color: accnetColor

        }
    }
    Rectangle
    {
        id:leftRect
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width/3
        color: "transparent"
        LinearGradient {//线性梯度渐变
                anchors.fill: parent//填充父类
                start: Qt.point(0, 0)//起始点
                end: Qt.point(leftRect.width,0)//结束点
                gradient: Gradient {//线性渐变
                    GradientStop { position: 0.0; color: backgroundColor }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        Button
        {
            anchors.left: parent.left;
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 50
            width: 50;
            height: 50;
            onClicked:
            {
                pathView.decrementCurrentIndex();
            }
            background: Rectangle{color: "transparent"}
            Text {
                id: btn1
                font.family:"iconfont"
                text:"\ue733"
                font.pixelSize: 30
            }
        }
    }
    Rectangle
    {
        id:rightRect
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width/3
        color: "transparent"
        LinearGradient {//线性梯度渐变
                anchors.fill: parent//填充父类
                start: Qt.point(rightRect.width,0 )//起始点
                end: Qt.point(0,0)//结束点
                gradient: Gradient {//线性渐变
                    GradientStop { position: 0.0; color: backgroundColor }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        Button
        {
            anchors.right: parent.right;
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 50
            width: 50;
            height: 50;
            onClicked:
            {
                pathView.incrementCurrentIndex();
            }
            background: Rectangle{color: "transparent"}
            Text {
                id: btn2
                font.family:"iconfont"
                text:"\ue734"
                font.pixelSize: 30
            }
        }

    }
}
