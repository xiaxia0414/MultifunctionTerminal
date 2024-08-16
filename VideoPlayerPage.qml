import QtQuick 2.15
import QtQuick.Controls 2.15
import VideoOutput 1.0
import "qrc:/Global/"
Rectangle
{
    id:root
    color: Theme.backgroundColor
    VideoOutput
    {
        id:video_outPut
        anchors.fill: parent
    }
    Button
    {
        text: "开始播放"
        onClicked:
        {
            video_outPut.playVideo();
        }
    }

}
