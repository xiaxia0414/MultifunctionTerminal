import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "qrc:/Global/"
Window {
    width: 800
    height: 480
    visible: true
    title: qsTr("Hello World")
    StackSwith
    {
        anchors.fill: parent
        Component.onCompleted:
        {
            Theme.setlightTheme();
        }
        Button
        {
            id:themeSwithBtn
            anchors.bottom: parent.bottom
            onClicked:
            {
                if(Theme.state == "lightTheme")
                {Theme.setBlackTheme()}
                else
                {
                Theme.setlightTheme();
                }
            }

        }
    }

    // WeatherLines
    // {
    //     anchors.fill: parent
    // }

}
