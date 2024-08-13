import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/Global/"
Rectangle
{
    id:root
    color: "transparent"
    property  var maxtmp:100
    property  var mintmp:0
    property var  dayNum: weatherData.count+1
    property var y_pixPerSize: root.height/(maxtmp - mintmp)
    property var x_pixPerSize: root.width/dayNum
    property ListModel weatherData

    function  realXyToPixXy(realx,realy)
    {
        var tmp_y = y_pixPerSize*(realy-mintmp);
        var x = x_pixPerSize*realx;
        return {x:x,y:root.height-tmp_y}
    }

    function loadWeatherData()
    {
        var t_min_tmp = 100
        var t_max_tmp = -100
         for (var i = 0; i < weatherData.count; i++)
         {
            var item = weatherData.get(i)
            var tmp_high =parseFloat(item.high)
            var tmp_low = parseFloat(item.low)
            t_min_tmp = Math.min(tmp_low,t_min_tmp)
            t_max_tmp = Math.max(tmp_high,t_max_tmp)
         }
        root.maxtmp = t_max_tmp +10
        root.mintmp = t_min_tmp -10
    }

    Canvas {
           id: canvas
           anchors.fill: parent
           onPaint: {

               for (var i = 0; i < weatherData.count; i++)
                  {
                    var item = weatherData.get(i)
                    var tmp_high =parseFloat(item.high)
                    var day = i+1;
                    var point = realXyToPixXy(day,tmp_high);
                    var context = getContext("2d");
                    context.fillStyle = Theme.redColor;
                    context.beginPath();
                    context.arc(point.x, point.y, 5, 0, Math.PI * 2); // 绘制圆形作为点
                    context.fill();

                    var textctx = getContext("2d");
                    textctx.font = "bold 15px Arial";
                    textctx.fillStyle = Theme.textColor; // 填充文字的颜色
                    textctx.fillText(tmp_high, point.x-5, point.y-10);
                    var s = weatherData.get(i).date.slice(5);
                    var textctx2 = getContext("2d");
                    textctx2.font = "15px Arial";
                    textctx2.fillStyle = Theme.textColor;
                    textctx2.fillText(s, point.x-15,25)

                   if(i>0)
                   {
                        var item2 = weatherData.get(i-1)
                        var tmp_high_2 =parseFloat(item2.high)
                        var point_start = realXyToPixXy(day-1,tmp_high_2);
                        var ctx = getContext("2d");
                                   ctx.beginPath(); // 开始新路径
                                   ctx.moveTo(point_start.x  ,point_start.y ); // 起点
                                   ctx.lineTo(point.x, point.y); // 终点
                                   ctx.strokeStyle = Theme.redColor; // 线的颜色
                                   ctx.lineWidth = 5; // 线的宽度
                                   ctx.stroke(); // 绘制线条
                   }

               }

               for (var i = 0; i < weatherData.count; i++)
                  {
                    var item = weatherData.get(i)
                    var tmp_high =parseFloat(item.low)
                    var day = i+1;
                    var point = realXyToPixXy(day,tmp_high);
                    var context = getContext("2d");
                    context.fillStyle = Theme.blueColor;
                    context.beginPath();
                    context.arc(point.x, point.y, 5, 0, Math.PI * 2); // 绘制圆形作为点
                    context.fill();

                   var textctx = getContext("2d");
                    textctx.font = "bold 15px Arial";
                    textctx.fillStyle = Theme.textColor; // 填充文字的颜色
                    textctx.fillText(tmp_high, point.x-5, point.y+20);

                   if(i>0)
                   {
                        var item2 = weatherData.get(i-1)
                        var tmp_low_2 =parseFloat(item2.low)
                        var point_start = realXyToPixXy(day-1,tmp_low_2);
                        var ctx = getContext("2d");
                                   ctx.beginPath(); // 开始新路径
                                   ctx.moveTo(point_start.x  ,point_start.y ); // 起点
                                   ctx.lineTo(point.x, point.y); // 终点
                                   ctx.strokeStyle = Theme.blueColor; // 线的颜色
                                   ctx.lineWidth = 5; // 线的宽度
                                   ctx.stroke(); // 绘制线条
                   }

               }
           }
       }
    Component.onCompleted: {
    loadWeatherData()
    }
    Connections
        {
            target: Theme
            onThemeChanged://注意大写
            {
                singleShotTimer.start();
            }
        }
    Timer {
            id: singleShotTimer
            interval: 600 // 延迟时间，单位为毫秒
            running: false
            repeat: false
            onTriggered: {
                canvas.requestPaint()
            }
    }

}
