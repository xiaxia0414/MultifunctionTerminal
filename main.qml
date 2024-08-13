import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "qrc:/Global/"
ApplicationWindow  {
    width: 800
    height: 480
    visible: true
    title: qsTr("Hello World")
    StackSwith
    {
        id:stack_swith
        anchors.fill: parent
        Component.onCompleted:
        {
            Theme.setlightTheme();
        }
        SuspendRoundToolbar
        {
            id:suspend_bar
            stackSwith:stack_swith
            foreColor: Theme.accentColor
        }

    }
    // WeatherLines
    // {
    //     anchors.fill: parent
    // }

}
