import QtQuick 2.15
import QtGraphicalEffects 1.15
import WeatherServer 1.0
import "qrc:/Global/"
Rectangle {
    id:root
    color:Theme.backgroundColor
    clip: true
    property var jsonObj
    Grid
    {
        columns: 2
        anchors.fill:parent
        spacing: 20
        anchors.margins: 20
        Rectangle
        {
            id:weatherToday_card
            width: 200
            height: 200
            color:Theme.cardColor
            radius: 20
            clip: true
            layer.enabled: true
            Text {
                id: city_name
                text: jsonObj.cityInfo.city
                width: parent.width/2
                height: parent.height/2
                font.pixelSize: 40
                color: Theme.accentColor
            }
            layer.effect:DropShadow
            {
                horizontalOffset: 0
                verticalOffset: 4
                radius:8
                color: Theme.shadowColor
            }
        }
        Rectangle
        {
            id:weather_all
            anchors.left: weatherToday_card.right
            anchors.leftMargin: 20
            width: parent.width-weatherToday_card.width-20
            height: weatherToday_card.height
            color:Theme.cardColor
            radius: 20
            clip: true
            layer.enabled: true
            layer.effect:DropShadow
            {
                horizontalOffset: 0
                verticalOffset: 4
                radius:8
                color: Theme.shadowColor
            }
        }
        Rectangle
        {
            id:weather_crve
            anchors.top: weatherToday_card.bottom
            anchors.topMargin: 20
            width: parent.width
            height:parent.height - weatherToday_card.height -20
            color:Theme.cardColor
            radius: 20
            clip: true
            layer.enabled: true
            layer.effect:DropShadow
            {
                horizontalOffset: 0
                verticalOffset: 4
                radius:8
                color: Theme.shadowColor
            }
        }
        Component.onCompleted: {
            var s = WeatherServer.getWeatherJson();
           jsonObj = JSON.parse(s);
        }

    }

}
