import QtQuick 1.0

Image {
    id: screen
    width: 480
    height: 800
    source: "backgrounds/music.jpg"
    fillMode: Image.PreserveAspectCrop

    state: Xbmc.state

    VisualItemModel {
        id: itemModel

//        Item {
//            property string label: "Library"
//            width: view.width; height: view.height
//            LibraryView {
//                id: libraryView
//                visible: true
//            }

//            Component.onDestruction: print("destroyed 1")
//        }
        Item {
            id: musicBrowser
            width: view.width; height: view.height
            Browser {
                id: fileBrowser
                visible: true
                onGoBack: homeMenu.state = "open"
            }
            LibraryView {
                id: libraryView
//                library: AudioLibrary
                visible: false
                onGoBack: homeMenu.state = "open"
            }

            states: [
                State { name: "files"
                    PropertyChanges {target:  fileBrowser; visible: true }
                    PropertyChanges {target:  libraryView; visible: false }
                },
                State { name: "library"
                    PropertyChanges {target:  fileBrowser; visible: false }
                    PropertyChanges {target:  libraryView; visible: true }
                }

            ]

        }

        Item {
            property string label: "Now Playing"
            width: view.width; height: view.height
            NowPlaying {
                anchors.fill: parent
            }

        }
    }

    ListView {
        id: view
        anchors.fill: parent
        model: itemModel
        preferredHighlightBegin: 0; preferredHighlightEnd: 0
        highlightRangeMode: ListView.StrictlyEnforceRange
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem; flickDeceleration: 300
        highlightMoveSpeed: 1200
        cacheBuffer: 200
    }

    Rectangle {
        id: notConnectedPopup
        anchors.centerIn: parent
        height: 200
        width: 400
        color: "black"
        border.color: "white"
        radius: 10
        opacity: 0
        scale: 0.5

        Image {
            anchors.fill: parent
            source: "images/GlassOverlay.png"
        }

        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Could not connect to Xbmc. Please check your network connection and settings."
            wrapMode: Text.WordWrap
            color: "white"
            font.pixelSize: 28
        }
    }


    MouseArea {
        id: cancelArea
        anchors.fill: screen
        enabled: false
        onClicked: {
            homeMenu.state = "closed"
        }
        states: State {
            name: "homeMenuOpen"; when: homeMenu.state == "open"
            PropertyChanges { target: cancelArea; enabled: true }
        }
    }
    HomeMenu {
        id: homeMenu

    }

    states: [
    State {
            name: "notConnected"; when: !Xbmc.connected
            PropertyChanges { target: notConnectedPopup; opacity: 0.8; scale: 1 }
            PropertyChanges { target: view; opacity: 0; }
        },
        State {
            name: "connected"; when: Xbmc.connected
            PropertyChanges { target: notConnectedPopup; opacity: 0; scale: 0.5 }
            PropertyChanges { target: view; opacity: 1; }
        }
    ]

    transitions: [
        Transition {
            from: "*"; to: "notConnected"
            NumberAnimation {properties: "opacity"; duration:  300; easing.type: Easing.InCirc}
            NumberAnimation {properties: "scale"; duration:  500; easing.type: Easing.OutBack}
        },
        Transition {
            from: "notConnected"
            to: "*"
            NumberAnimation {properties: "opacity"; duration:  200; easing.type: Easing.OutCirc}
            NumberAnimation {properties: "scale"; duration:  300; easing.type: Easing.Linear}
        }
    ]


}
