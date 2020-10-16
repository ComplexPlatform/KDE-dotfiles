/***************************************************************************
 *   Copyright 2013 Sebastian Kügler <sebas@kde.org>                       *
 *   Copyright 2014, 2016 Kai Uwe Broulik <kde@privat.broulik.de>          *
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

import QtQuick 2.5
import QtQuick.Layouts 1.3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.kcoreaddons 1.0 as KCoreAddons


Item {
    id: expandedRepresentation

    Layout.minimumWidth: Layout.minimumHeight * 1.5
    Layout.minimumHeight: units.gridUnit * 7
    Layout.preferredWidth: Layout.preferredHeight * 1.5
    Layout.preferredHeight: units.gridUnit * 22

    readonly property bool verticalView: width / height < 1.8

    // only show hours (the default for KFormat) when track is actually longer than an hour
    readonly property int durationFormattingOptions: root.length >= 60*60*1000*1000 ? 0 : KCoreAddons.FormatTypes.FoldHours

    property bool disablePositionUpdate: false
    property bool keyPressed: false

    Connections {
        target: plasmoid
        onExpandedChanged: {
            if (plasmoid.expanded) {
                root.retrievePosition();
            }
        }
    }

    Keys.onPressed: keyPressed = true

    Keys.onReleased: {
        keyPressed = false

        if (!event.modifiers) {
            event.accepted = true

            if (event.key === Qt.Key_Space || event.key === Qt.Key_K) {
                // K is YouTube's key for "play/pause" :)
                root.togglePlaying()
            } else if (event.key === Qt.Key_P) {
                root.action_previous()
            } else if (event.key === Qt.Key_N) {
                root.action_next()
            } else if (event.key === Qt.Key_S) {
                root.action_stop()
            } else if (event.key === Qt.Key_Left || event.key === Qt.Key_J) { // TODO ltr languages
                // seek back 5s
                seekSlider.value = Math.max(0, seekSlider.value - 5000000) // microseconds
                seekSlider.moved();
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_L) {
                // seek forward 5s
                seekSlider.value = Math.min(seekSlider.to, seekSlider.value + 5000000)
                seekSlider.moved();
            } else if (event.key === Qt.Key_Home) {
                seekSlider.value = 0
                seekSlider.moved();
            } else if (event.key === Qt.Key_End) {
                seekSlider.value = seekSlider.to
                seekSlider.moved();
            } else if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9) {
                // jump to percentage, ie. 0 = beginnign, 1 = 10% of total length etc
                seekSlider.value = seekSlider.to * (event.key - Qt.Key_0) / 10
                seekSlider.moved();
            } else {
                event.accepted = false
            }
        }
    }

    PlasmaComponents3.TabBar {
        id: playerSelector
        width: parent.width
        height: visible ? units.gridUnit * 2 : 0

        anchors {
            top: parent.top
            topMargin: 0
            horizontalCenter: parent.horizontalCenter
        }
        visible: tabButtonInstantiator.model.length > 2 // more than one player, @multiplex is always there

        Instantiator {
            id: tabButtonInstantiator
            model: { root.mprisSourcesModel }

            onObjectAdded: { playerSelector.insertItem(index, object) }
            onObjectRemoved: { playerSelector.removeItem(object) }

            delegate: PlasmaComponents3.TabButton {
                checked: modelData["source"] == mpris2Source.current
                text: modelData["text"]
                contentItem: PlasmaCore.IconItem {
                    source: modelData["icon"]
                    implicitHeight: units.iconSizes.smallMedium
                }
                onClicked: {
                    disablePositionUpdate = true
                    mpris2Source.current = modelData["source"];
                    disablePositionUpdate = false
                }
            }

            onModelChanged: {
                //if model changes, we try to find the current player again
                for (var i = 0, length = model.length; i < length; i++) {
                    if (model[i].source === mpris2Source.current) {
                        playerSelector.currentIndex = i
                        break
                    }
                }
            }
        }
    }


    AlbumArt {
        id: albumArt

        anchors {
            left: parent.left
            top: playerSelector.bottom
            right: verticalView? parent.right : controlCol.left
            bottom: verticalView? controlCol.top: parent.bottom
            margins: units.smallSpacing
        }
    }

    ColumnLayout {
        id: controlCol
        width: verticalView? parent.width: parent.width - albumArt.height
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        spacing: units.smallSpacing

        RowLayout {
            id: progress

            spacing: units.smallSpacing

            // if there's no "mpris:length" in the metadata, we cannot seek, so hide it in that case
            enabled: !root.noPlayer && root.track && root.length > 0 ? true : false
            opacity: enabled ? 1 : 0
            Behavior on opacity {
                NumberAnimation { duration: units.longDuration }
            }

            // ensure the layout doesn't shift as the numbers change and measure roughly the longest text that could occur with the current song
            TextMetrics {
                id: timeMetrics
                text: i18nc("Remaining time for song e.g -5:42", "-%1",
                            KCoreAddons.Format.formatDuration(seekSlider.to / 1000, expandedRepresentation.durationFormattingOptions))
                font: theme.smallestFont
            }

            PlasmaComponents3.Label {
                Layout.preferredWidth: timeMetrics.width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                text: KCoreAddons.Format.formatDuration(seekSlider.value / 1000, expandedRepresentation.durationFormattingOptions)
                opacity: 0.9
                font: theme.smallestFont
            }

            PlasmaComponents3.Slider {
                id: seekSlider
                Layout.fillWidth: true
                z: 999
                value: 0
                visible: root.canSeek

                onMoved: {
                    if (!disablePositionUpdate) {
                        // delay setting the position to avoid race conditions
                        queuedPositionUpdate.restart()
                    }
                }
            }

            PlasmaComponents3.ProgressBar {
                id: progressBar
                Layout.fillWidth: true
                value: root.position
                from: 0
                to: root.length
                visible: !root.canSeek

                onValueChanged: {
                    // we don't want to interrupt the user dragging the slider
                    if (!seekSlider.pressed && !keyPressed) {
                        // we also don't want passive position updates
                        disablePositionUpdate = true
                        seekSlider.value = value
                        disablePositionUpdate = false
                    }
                }

                onToChanged: {
                    disablePositionUpdate = true
                    // When reducing maximumValue, value is clamped to it, however
                    // when increasing it again it gets its old value back.
                    // To keep us from seeking to the end of the track when moving
                    // to a new track, we'll reset the value to zero and ask for the position again
                    seekSlider.value = 0
                    seekSlider.to = to
                    root.retrievePosition()
                    disablePositionUpdate = false
                }
            }

            PlasmaComponents3.Label {
                Layout.preferredWidth: timeMetrics.width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                text: i18nc("Remaining time for song e.g -5:42", "-%1",
                            KCoreAddons.Format.formatDuration((seekSlider.to - seekSlider.value) / 1000, expandedRepresentation.durationFormattingOptions))
                opacity: 0.9
                font: theme.smallestFont
            }
        }

        TrackInfo {
            id: trackInfo
            Layout.fillWidth: true
            textAlignment: Text.AlignHCenter
        }

        Item {
            width: parent.width
            height: playerControls.height
            Layout.fillWidth: true

            PlayerControls {
                id: playerControls
                anchors.horizontalCenter: parent.horizontalCenter
                compactView: false
            }
        }
    }

    Timer {
        id: queuedPositionUpdate
        interval: 100
        onTriggered: {
            if (root.position == seekSlider.value) {
                return;
            }
            var service = mpris2Source.serviceForSource(mpris2Source.current)
            var operation = service.operationDescription("SetPosition")
            operation.microseconds = seekSlider.value
            service.startOperationCall(operation)
        }
    }
}
