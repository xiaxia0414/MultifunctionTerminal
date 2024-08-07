pragma Singleton
import QtQuick 2.15
Item {
    id:theme
    property color backgroundColor: "#F5F7FB"
    property color accentColor:"#167CF8"
    property color shadowColor:"#c4c4c4"
    property color cardColor:"#FFFFFF"
    property color normalColor:"#7F7F7F"
    property color textColor: "#7F7F7F"

    function setBlackTheme()
    {
        theme.state = "blackTheme"
        console.log(backgroundColor)
    }
    function setlightTheme()
    {
        theme.state = "lightTheme"
    }

    states: [
        State {
            name: "lightTheme"
            PropertyChanges {
                target: theme
                backgroundColor:"#F5F7FB"
            }
            PropertyChanges {
                target: theme
                shadowColor:"#c4c4c4"
            }

            PropertyChanges {
                target: theme
                cardColor:"#FFFFFF"
            }
        }
        ,
        State {
            name: "blackTheme"
            PropertyChanges {
                target: theme
                backgroundColor:"#121212"
            }
            PropertyChanges {
                target: theme
                shadowColor:"black"
            }
            PropertyChanges {
                target: theme
                cardColor:"#383838"
            }
        }
    ]

    transitions: [
                Transition {
                from: "*"; to: "*"
                    PropertyAnimation { target: theme; properties: "backgroundColor"; duration: 500 }
                    PropertyAnimation { target: theme; properties: "shadowColor"; duration: 500 }
                    PropertyAnimation { target: theme; properties: "cardColor"; duration: 500 }
            }
        ]

}


