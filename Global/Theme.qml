pragma Singleton
import QtQuick 2.15
Item {
    id:theme
    property color backgroundColor: "#F5F7FB"
    property color accentColor:"#167CF8"
    property color shadowColor:"#c4c4c4"
    property color cardColor:"#FFFFFF"
    property color normalColor:"#7F7F7F"
    property color textColor: "#3C485C"
    property color redColor: "#DD568D"
    property color blueColor: "#206DC0"
    property color itemPressedColor: "#EBEBEB"
    property var themeState: theme.state
    function setBlackTheme()
    {
        theme.state = "blackTheme"
        //console.log(backgroundColor)
        themeChanged(theme.state)
    }
    function setlightTheme()
    {
        theme.state = "lightTheme"
        themeChanged(theme.state)
    }

    signal themeChanged(var state);

    states: [
        State {
            name: "lightTheme"
            PropertyChanges {
                target: theme
                backgroundColor:"#F5F7FB"
                itemPressedColor:"#3C485C"
            }
            PropertyChanges {
                target: theme
                shadowColor:"#c4c4c4"
            }

            PropertyChanges {
                target: theme
                cardColor:"#FFFFFF"
            }
            PropertyChanges {
                target: theme
                textColor:"#3C485C"
            }

        }
        ,
        State {
            name: "blackTheme"
            PropertyChanges {
                target: theme
                backgroundColor:"#121212"
                itemPressedColor:"#121212"
            }
            PropertyChanges {
                target: theme
                shadowColor:"black"
            }
            PropertyChanges {
                target: theme
                cardColor:"#383838"
            }
            PropertyChanges {
                target: theme
                textColor:"white"
            }
        }
    ]

    transitions: [
                Transition {
                from: "*"; to: "*"
                    PropertyAnimation { target: theme; properties: "backgroundColor"; duration: 500 }
                    PropertyAnimation { target: theme; properties: "shadowColor"; duration: 500 }
                    PropertyAnimation { target: theme; properties: "cardColor"; duration: 500 }
                    PropertyAnimation { target: theme; properties: "textColor"; duration: 500 }
                    PropertyAnimation { target: theme; properties: "itemPressedColor"; duration: 500 }
            }
        ]

}


