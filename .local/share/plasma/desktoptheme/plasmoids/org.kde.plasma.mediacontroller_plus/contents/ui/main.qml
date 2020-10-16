/***************************************************************************
 *   Copyright 2013 Sebastian Kügler <sebas@kde.org>                       *
 *   Copyright 2014 Kai Uwe Broulik <kde@privat.broulik.de>                *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Library General Public License as       *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU Library General Public License for more details.                  *
 *                                                                         *
 *   You should have received a copy of the GNU Library General Public     *
 *   License along with this program; if not, write to the                 *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore


Item {
    id: root

    property var currentMetadata: mpris2Source.currentData ? mpris2Source.currentData.Metadata : undefined
    property string track: {
        if (!currentMetadata) {
            return ""
        }
        var xesamTitle = currentMetadata["xesam:title"]
        if (xesamTitle) {
            return xesamTitle
        }
        // if no track title is given, print out the file name
        var xesamUrl = currentMetadata["xesam:url"] ? currentMetadata["xesam:url"].toString() : ""
        if (!xesamUrl) {
            return ""
        }
        var lastSlashPos = xesamUrl.lastIndexOf('/')
        if (lastSlashPos < 0) {
            return ""
        }
        var lastUrlPart = xesamUrl.substring(lastSlashPos + 1)
        return decodeURIComponent(lastUrlPart)
    }
    property string artist: currentMetadata ? currentMetadata["xesam:artist"] || "" : ""
    property string albumArt: currentMetadata ? currentMetadata["mpris:artUrl"] || "" : ""

    readonly property string identity: !root.noPlayer ? mpris2Source.currentData.Identity || mpris2Source.current : ""

    property bool noPlayer: mpris2Source.sources.length <= 1

    property var mprisSourcesModel: []

    readonly property bool canControl: (!root.noPlayer && mpris2Source.currentData.CanControl) || false
    readonly property bool canGoPrevious: (canControl && mpris2Source.currentData.CanGoPrevious) || false
    readonly property bool canGoNext: (canControl && mpris2Source.currentData.CanGoNext) || false
    readonly property bool canPlay: (canControl && mpris2Source.currentData.CanPlay) || false
    readonly property bool canPause: (canControl && mpris2Source.currentData.CanPause) || false
    readonly property bool canSeek: mpris2Source.currentData.CanSeek || false

    readonly property double mprisPosition: mpris2Source.currentData.Position || 0
    readonly property real rate: mpris2Source.currentData.Rate || 1
    readonly property double length: currentMetadata ? currentMetadata["mpris:length"] || 0 : 0

    property double position : mprisPosition


    Plasmoid.switchWidth: units.gridUnit * 10
    Plasmoid.switchHeight: units.gridUnit * 8
    Plasmoid.icon: albumArt ? albumArt : "media-playback-playing"
    Plasmoid.toolTipMainText: i18n("No media playing")
    Plasmoid.toolTipSubText: identity
    Plasmoid.toolTipTextFormat: Text.PlainText
    Plasmoid.status: PlasmaCore.Types.PassiveStatus

    Plasmoid.backgroundHints: PlasmaCore.Types.StandardBackground | PlasmaCore.Types.ConfigurableBackground

    Plasmoid.onContextualActionsAboutToShow: {
        plasmoid.clearActions()

        if (root.noPlayer) {
            return
        }

        plasmoid.setActionSeparator("playerList")

        if (mpris2Source.currentData.CanRaise) {
            var icon = mpris2Source.currentData["Desktop Icon Name"] || ""
            plasmoid.setAction("open", i18nc("Open player window or bring it to the front if already open", "Open"), icon)
        }

        if (canControl) {
            plasmoid.setAction("previous", i18nc("Play previous track", "Previous Track"),
                               Qt.application.layoutDirection === Qt.RightToLeft ? "media-skip-forward" : "media-skip-backward");
            plasmoid.action("previous").enabled = Qt.binding(function() {
                return root.canGoPrevious
            })

            // if CanPause, toggle the menu entry between Play & Pause, otherwise always use Play
            if (root.state == "playing" && root.canPause) {
                plasmoid.setAction("pause", i18nc("Pause playback", "Pause"), "media-playback-pause")
                plasmoid.action("pause").enabled = Qt.binding(function() {
                    return root.state === "playing" && root.canPause;
                });
            } else {
                plasmoid.setAction("play", i18nc("Start playback", "Play"), "media-playback-start")
                plasmoid.action("play").enabled = Qt.binding(function() {
                    return root.state !== "playing" && root.canPlay;
                });
            }

            plasmoid.setAction("next", i18nc("Play next track", "Next Track"),
                               Qt.application.layoutDirection === Qt.RightToLeft ? "media-skip-backward" : "media-skip-forward")
            plasmoid.action("next").enabled = Qt.binding(function() {
                return root.canGoNext
            })

            plasmoid.setAction("stop", i18nc("Stop playback", "Stop"), "media-playback-stop")
            plasmoid.action("stop").enabled = Qt.binding(function() {
                return root.state === "playing" || root.state === "paused";
            })
        }

        if (mpris2Source.currentData.CanQuit) {
            plasmoid.setActionSeparator("quitseparator");
            plasmoid.setAction("quit", i18nc("Quit player", "Quit"), "application-exit")
        }

        plasmoid.setActionSeparator("playerActionsSeparator")
    }

    onMprisPositionChanged: {
        position = mprisPosition
    }

    // Reset position on track changes and retrieve again
    // Best option for players not retrieving the current position (Spotify)
    onTrackChanged: {
        position = 0
        retrievePosition()
    }


    // HACK Some players like Amarok take quite a while to load the next track
    // this avoids having the plasmoid jump between popup and panel
    onStateChanged: {
        if (state != "") {
            plasmoid.status = PlasmaCore.Types.ActiveStatus
        } else {
            updatePlasmoidStatusTimer.restart()
        }
    }

    Timer {
        id: updatePlasmoidStatusTimer
        interval: 3000
        onTriggered: {
            if (state != "") {
                plasmoid.status = PlasmaCore.Types.ActiveStatus
            } else {
                plasmoid.status = PlasmaCore.Types.PassiveStatus
            }
        }
    }

    Timer {
        id: updateProgressTimer

        interval: 1000 / rate
        repeat: true
        running: root.state === "playing"

        onTriggered: {
            // some players don't continuously update the seek slider position via mpris
            // add one second; value in microseconds
            position += 1000000
            root.retrievePosition()
        }
    }


    Plasmoid.fullRepresentation: ExpandedRepresentation {}

    Plasmoid.compactRepresentation: CompactRepresentation {}

    PlasmaCore.DataSource {
        id: mpris2Source

        readonly property string multiplexSource: "@multiplex"
        property string current: multiplexSource

        readonly property var currentData: data[current]

        engine: "mpris2"
        connectedSources: sources

        onSourceAdded: {
            updateMprisSourcesModel()
        }

        onSourceRemoved: {
            // if player is closed, reset to multiplex source
            if (source === current) {
                current = multiplexSource
            }
            updateMprisSourcesModel()
        }
    }

    Component.onCompleted: {
        mpris2Source.serviceForSource("@multiplex").enableGlobalShortcuts();
        updateMprisSourcesModel()
    }

    function togglePlaying() {
        if (root.state === "playing") {
            if (root.canPause) {
                root.action_pause();
            }
        } else {
            if (root.canPlay) {
                root.action_play();
            }
        }
    }

    function action_open() {
        serviceOp(mpris2Source.current, "Raise");
    }
    function action_quit() {
        serviceOp(mpris2Source.current, "Quit");
    }

    function action_play() {
        serviceOp(mpris2Source.current, "Play");
    }

    function action_pause() {
        serviceOp(mpris2Source.current, "Pause");
    }

    function action_playPause() {
        serviceOp(mpris2Source.current, "PlayPause");
    }

    function action_previous() {
        serviceOp(mpris2Source.current, "Previous");
    }

    function action_next() {
        serviceOp(mpris2Source.current, "Next");
    }

    function action_stop() {
        serviceOp(mpris2Source.current, "Stop");
    }

    function retrievePosition() {
        serviceOp(mpris2Source.current, "GetPostion");
    }

    function serviceOp(src, op) {
        var service = mpris2Source.serviceForSource(src);
        var operation = service.operationDescription(op);
        return service.startOperationCall(operation);
    }

    function updateMprisSourcesModel () {

        var model = [{
            'text': i18n("Choose player automatically"),
            'icon': 'emblem-favorite',
            'source': mpris2Source.multiplexSource
        }]

        var sources = mpris2Source.sources
        for (var i = 0, length = sources.length; i < length; ++i) {
            var source = sources[i]
            if (source === mpris2Source.multiplexSource) {
                continue
            }

            model.push({
                'text': mpris2Source.data[source]["Identity"],
                'icon': mpris2Source.data[source]["Desktop Icon Name"] || mpris2Source.data[source]["Desktop Entry"] || source,
                'source': source
            });
        }

        root.mprisSourcesModel = model;
    }


/*    Menu {
        id: mprisSourcesMenu

        Instantiator {
            model: mprisSourcesModel
            onObjectAdded: mprisSourcesMenu.insertItem( index, object )
            onObjectRemoved: mprisSourcesMenu.removeItem( object )
            delegate: MenuItem {
                text: text
                icon: icon
                onTriggered: {
                    mpris2Source.current = source;
                }
            }
        }
    }
*/

    states: [
        State {
            name: "playing"
            when: !root.noPlayer && mpris2Source.currentData.PlaybackStatus === "Playing"

            PropertyChanges {
                target: plasmoid
                icon: albumArt ? albumArt : "media-playback-playing"
                toolTipMainText: track
                toolTipSubText: artist ? i18nc("by Artist (player name)", "by %1 (%2)", artist, identity) : identity
            }
        },
        State {
            name: "paused"
            when: !root.noPlayer && mpris2Source.currentData.PlaybackStatus === "Paused"

            PropertyChanges {
                target: plasmoid
                icon: albumArt ? albumArt : "media-playback-paused"
                toolTipMainText: track
                toolTipSubText: artist ? i18nc("by Artist (paused, player name)", "by %1 (paused, %2)", artist, identity) : i18nc("Paused (player name)", "Paused (%1)", identity)
            }
        }
    ]
}
