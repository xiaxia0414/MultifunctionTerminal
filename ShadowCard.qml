import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import "qrc:/Global/"
Rectangle
{
    width: 200
    height: 200
    color:Theme.cardColor
    radius: 20
    clip: true
    property string imgUrl:""
    property bool isGradient: true
    property string name
    property int imgWidth :300
    property int imgHeight : 200
    property int imgTopMargin : -20
    property int imgLeftMargin: 0
    property var swith
    Rectangle
    {
        id:inner_rect
        color:Theme.cardColor
        anchors.fill: parent;
        anchors.margins: 5
        radius: parent.radius
        clip: true
        Image {
            id: airconditonner_img
            anchors.top: parent.top
            anchors.topMargin: imgTopMargin
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: imgLeftMargin
            width: imgWidth
            height: imgHeight
            source: imgUrl
            LinearGradient {//线性梯度渐变
                    visible: isGradient
                    anchors.fill: parent//填充父类
                    start: Qt.point(parent.width/2,0)//起始点
                    end: Qt.point(0, 0)//结束点
                    gradient: Gradient {//线性渐变
                        GradientStop { position: 0.0; color: Theme.cardColor }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }
        }
        Text {
            id: airconditonner_text
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 10
            text: name
            color:swith.checked? Theme.accentColor:"gray";
            font.family: "微软雅黑"
            font.pixelSize: 20
        }
  }
    layer.enabled: true
    layer.effect:DropShadow
    {
        id:shadow
        //transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 4
        radius:8
        color: Theme.shadowColor		//argb
    }
}
