import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtGraphicalEffects 1.15
import FluentUI 1.0
Rectangle
{
    Shape {
        id:shape
        property int sx: 0;
        property int sy: 0;
        x:sx;
        y:sy;
            ShapePath {
                fillColor: "blue"
                PathLine { x: 120; y: 200 }
                PathLine { x: -120; y: 200 }
               // PathLine { x: 10; y: 190 }
            }
        }
    Canvas {
            id: circle
            property int cx: parent.width/2;
            property int cy: parent.height/2 ;
            anchors.centerIn: parent
            x:cx;
            y:cy;
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                ctx.beginPath();
                ctx.arc(width / 2, height / 2, 100, 0, 2 * Math.PI);
                ctx.fillStyle = "red";
                ctx.fill();
            }
    }
    SequentialAnimation{

                id:anim
                loops:Animation.Infinite
               NumberAnimation{
                   target: shape
                   properties: "x"
                   to:700
                   duration: 8000
               }
               NumberAnimation{
                   target: shape
                   properties: "x"
                   to:100
                   duration: 8000
               }
           }
    Component.onCompleted:
    {
        anim.start()
    }
}
