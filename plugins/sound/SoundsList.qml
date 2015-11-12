import GSettings 1.0
import QtQuick 2.4
import QtMultimedia 5.0
import SystemSettings 1.0
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.SystemSettings.Sound 1.0
import QMenuModel 0.1

import "utilities.js" as Utilities

ItemPage {
    property variant soundDisplayNames:
        Utilities.buildSoundValues(soundFileNames)
    property variant soundFileNames: backendInfo.listSounds(
        [soundsDir, "/custom" + soundsDir])
    property bool showStopButton: false
    property int soundType // 0: ringtone, 1: message
    property string soundsDir

    id: soundsPage
    flickable: scrollWidget

    UbuntuSoundPanel {
        id: backendInfo
        onIncomingCallSoundChanged: {
            if (soundType == 0)
                soundSelector.selectedIndex =
                        Utilities.indexSelectedFile(soundFileNames,
                                                    incomingCallSound)
        }
        onIncomingMessageSoundChanged: {
            if (soundType == 1)
                soundSelector.selectedIndex =
                        Utilities.indexSelectedFile(soundFileNames,
                                                    incomingMessageSound)
        }
    }

    GSettings {
        id: soundSettings
        schema.id: "com.ubuntu.touch.sound"
    }

    QDBusActionGroup {
        id: soundActionGroup
        busType: DBus.SessionBus
        busName: "com.canonical.indicator.sound"
        objectPath: "/com/canonical/indicator/sound"

        Component.onCompleted: start()
    }

    Audio {
        id: soundEffect
        audioRole: MediaPlayer.alert
    }

    Flickable {
        id: scrollWidget
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: contentItem.childrenRect.height + stopItem.height
        boundsBehavior: (contentHeight > height) ?
                            Flickable.DragAndOvershootBounds :
                            Flickable.StopAtBounds
        /* Set the direction to workaround https://bugreports.qt-project.org/browse/QTBUG-31905
           otherwise the UI might end up in a situation where scrolling doesn't work */
        flickableDirection: Flickable.VerticalFlick

        Column {
            anchors.left: parent.left
            anchors.right: parent.right

            ListItem.ItemSelector {
                id: soundSelector
                containerHeight: itemHeight * model.length
                height: containerHeight.height
                expanded: true
                model: soundDisplayNames
                selectedIndex: {
                    if (soundType == 0)
                        soundSelector.selectedIndex =
                                Utilities.indexSelectedFile(soundFileNames,
                                    backendInfo.incomingCallSound)
                    else if (soundType == 1)
                        soundSelector.selectedIndex =
                                Utilities.indexSelectedFile(soundFileNames,
                                    backendInfo.incomingMessageSound)
                }
                onDelegateClicked: {
                    if (soundType == 0) {
                        soundSettings.incomingCallSound = soundFileNames[index]
                        backendInfo.incomingCallSound = soundFileNames[index]
                    } else if (soundType == 1) {
                        soundSettings.incomingMessageSound = soundFileNames[index]
                        backendInfo.incomingMessageSound = soundFileNames[index]
                    }
                    soundEffect.source = soundFileNames[index]
                    soundEffect.play()
                }
            }

            ListItem.Standard {
                id: customRingtone
                text: i18n.tr("Custom Ringtone…")
                onClicked: {
                    // FIXME: open picker dialog here
                }
            }
        }
    }

    ListItem.SingleControl {
        id: stopItem
        anchors.bottom: parent.bottom
        control: Button {
            text: i18n.tr("Stop playing")
            width: parent.width - units.gu(4)
            onClicked:
                soundEffect.stop()
        }
        enabled: soundEffect.playbackState == Audio.PlayingState
        visible: enabled
        Rectangle {
            anchors.fill: parent
            z: parent.z - 1
            color: Theme.palette.normal.background
        }
    }
}
