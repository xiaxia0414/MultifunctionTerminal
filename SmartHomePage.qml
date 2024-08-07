import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.15
import "qrc:/Global/"
Rectangle {
    id:rect
    color:Theme.backgroundColor
    clip: true
    Material.primary : Material.Red
    Material.accent: Material.Blue
    Flow
    {
        anchors.fill: parent
        spacing: 20
        anchors.margins: 20
        ShadowCard
        {
            id:airconditonner_card
            width: 350
            imgUrl: "qrc:/image/airconditonner.png"
            name:"卧室空调"
            swith: airconditon_swith
            Column
            {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.right: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.margins: 10
                Switch{
                    id:airconditon_swith
                }
                SpinBox{
                width: 150
                from :16
                to:30
                }
            }
        }
        ShadowCard
        {
            id:lite_card
            width: 250
            imgUrl: "qrc:/image/lite.png"
            imgTopMargin: 20
            imgLeftMargin: -10
            imgHeight: 150
            imgWidth: 150
            isGradient: false
            name:"卧室台灯"
            swith: lite_swith
            Column
            {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.right: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.margins: 10
                Switch{
                id:lite_swith
                }
            }
        }
        ShadowCard
        {
            id:curtain_card
            width: 175
            height: 100
            imgHeight: 50
            imgWidth: 50
            isGradient: false
            name:"窗帘"
            swith:curtain_swith
            Column
            {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.right: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.margins: 10
                Switch{
                id:curtain_swith
                }
            }
        }


        ShadowCard
        {
            id:airCleaner_card
            width: 175
            height: 100
            imgHeight: 50
            imgWidth: 50
            isGradient: false
            name:"空气净化器"
            swith:airCleaner_swith
            Column
            {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.right: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.margins: 10
                Switch{
                id:airCleaner_swith
                }
            }
        }
        ShadowCard
        {
            id:humidifier_card
            width: 175
            height: 100
            imgHeight: 50
            imgWidth: 50
            isGradient: false
            name:"加湿器"
            swith:humidifier_swith
            Column
            {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.right: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.margins: 10
                Switch{
                id:humidifier_swith
                }
            }
        }
    }
}
