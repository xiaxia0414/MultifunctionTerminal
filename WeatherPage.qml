import QtQuick 2.15
import QtGraphicalEffects 1.15
import WeatherServer 1.0
import QtCharts 2.15
import "qrc:/Global/"
Rectangle {
    id:root
    color:Theme.backgroundColor
    clip: true
    property var jsonObj
    property var weatherMap : {
        "晴": "qrc:/image/WeatherImg/rijiantianqi-qing.png",
        "多云": "qrc:/image/WeatherImg/tianqi-duoyun.png",
        "阴":"qrc:/image/WeatherImg/tianqi-yintian.png",
        "小雨": "qrc:/image/WeatherImg/tianqi-xiaoyu.png",
        "中雨": "qrc:/image/WeatherImg/tianqi-zhongyu.png",
        "大雨": "qrc:/image/WeatherImg/tianqi-dayu.png",
        "暴雨":"qrc:/image/WeatherImg/tianqi-baoyu.png",
    }

    function loadWeatherViewModel()
    {
        for (var i = 0; i < jsonObj.data.forecast.length; i++) {
            weather_all_model.append({date:jsonObj.data.forecast[i].ymd,
                                    week:jsonObj.data.forecast[i].week,
                                    high:jsonObj.data.forecast[i].high.slice(2),
                                    low:jsonObj.data.forecast[i].low.slice(2),
                                    type:jsonObj.data.forecast[i].type
                                     });
        }
    }


        Rectangle
        {
            id:weatherToday_card
            width: 200
            height: 200
            x:20
            y:20
            color:Theme.cardColor
            radius: 20
            clip: true
            layer.enabled: true
            Image {
                id:weather_image
                source: weatherMap[jsonObj.data.forecast[0].type]
                width: 120
                height: 120
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 0
            }
            Text {
                id: city_name
                anchors.top:weather_image.bottom
                anchors.topMargin: -10
                anchors.left: parent.left
                anchors.leftMargin: 15
                text: jsonObj.cityInfo.city
                font.pixelSize: 20
                font.family: "微软雅黑"
                color: Theme.textColor
            }
            Text {
                id: city_tmp
                font.pixelSize: 20
                anchors.left: city_name.right
                anchors.leftMargin: 5
                anchors.top: city_name.top
                color:Theme.textColor
                text: jsonObj.data.wendu + "℃"
            }
            Text {
                id: city_weather_type
                font.pixelSize: 20
                anchors.left: city_tmp.right
                anchors.leftMargin: 5
                anchors.top: city_name.top
                color:Theme.textColor
                 font.family: "微软雅黑"
                text: jsonObj.data.forecast[0].type;
            }
            Text {
                id: city_extra_info
                font.pixelSize: 15
                anchors.left: city_name.left
                anchors.leftMargin: -5
                anchors.top: city_name.bottom
                color:Theme.textColor
                font.family: "微软雅黑"
                text:jsonObj.data.forecast[0].week+" "+jsonObj.data.forecast[0].high.slice(2)+"/"+jsonObj.data.forecast[0].low.slice(2)+" 空气:"+jsonObj.data.quality;
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
            anchors.top:  weatherToday_card.top
            anchors.left: weatherToday_card.right
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            width: parent.width-weatherToday_card.width-20
            height: weatherToday_card.height
            color:Theme.cardColor
            radius: 20

            ListView {
                id:weather_all_veiw
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                orientation: ListView.Horizontal
                spacing: 10
                clip: true
                Component {
                    id: contactsDelegate
                    Rectangle {
                        id: wrapper
                        width: 50
                        height: weather_all_veiw.height
                        color: "transparent"
                        Text {
                            id: contactInfo_date
                            anchors.top: parent.top
                             anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 10
                            text: date.slice(5)
                            color: Theme.textColor
                            font.pixelSize: 15
                        }
                        Text {
                            id: contactInfo_week
                            anchors.top: contactInfo_date.bottom
                             anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 5
                            text: week
                            color: Theme.textColor
                            font.pixelSize: 13
                        }

                        Text {
                            id: contactInfo_type
                            anchors.top: contactInfo_week.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 5
                            text: type
                            color: Theme.textColor
                            font.pixelSize: 20
                        }
                        Image {
                            id:  contactInfo_type_image
                            width: parent.width
                            height: parent.width
                            anchors.top: contactInfo_type.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 5
                            source: weatherMap[type]
                        }
                        Text {
                            id: contactInfo_high
                            anchors.top: contactInfo_type_image.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.topMargin: 5
                            horizontalAlignment: Text.AlignHCenter  // 水平居中
                            verticalAlignment: Text.AlignVCenter    // 垂直居中
                            text: high+"\n~\n"+low
                            color: Theme.textColor
                            font.pixelSize: 15
                        }

                    }
                }

                model: ListModel
                {
                    id:weather_all_model
                }
                delegate: contactsDelegate
                focus: true
            }

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
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            width: parent.width
            height:parent.height - weatherToday_card.height -20
            color:Theme.cardColor
            radius: 20
            clip: true
            WeatherLines
            {
                anchors.fill: parent
                weatherData: weather_all_model
            }

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
            loadWeatherViewModel();
        }


}
