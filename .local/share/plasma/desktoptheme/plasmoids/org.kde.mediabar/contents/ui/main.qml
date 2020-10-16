/*
 *   Copyright 2019-2020 Panagiotis Panagiotopoulos <panagiotopoulos.git@gmail.com>
 *
 * 	  This file is part of MediaBar.
 *
 *    MediaBar is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    MediaBar is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with MediaBar.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.12
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
	id: root

	readonly property int iconSize: units.iconSizes.medium
	readonly property string playIcon: "stock_media-play"
	readonly property string pauseIcon: "stock_media-pause"
	property bool seekingWheel: plasmoid.configuration.useWheelForSeeking
	property int minWidth: plasmoid.configuration.minimumWidth
	property int maxWidth: plasmoid.configuration.maximumWidth
	property int currentWidth: -1
	property bool inPanel: (plasmoid.location === PlasmaCore.Types.TopEdge || plasmoid.location === PlasmaCore.Types.RightEdge || plasmoid.location === PlasmaCore.Types.BottomEdge || plasmoid.location === PlasmaCore.Types.LeftEdge)
	property bool isExpanded: plasmoid.expanded

    onIsExpandedChanged: {
		if (plasmoid.expanded) {
			updatePosition();
		}
    }

	Plasmoid.compactRepresentation: CompactRepresentation {
	}
	Plasmoid.fullRepresentation: ExpandedRepresentation {
		spacing: units.smallSpacing*2
		Layout.minimumWidth: currentWidth
		Layout.maximumWidth: currentWidth
		Layout.preferredWidth: currentWidth
	}
	Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
	Plasmoid.icon: mediaSource.albumArt ? mediaSource.albumArt : ""
	Plasmoid.toolTipMainText: mediaSource.track ? mediaSource.track : ""
	Plasmoid.toolTipSubText: mediaSource.artist ? (mediaSource.artist + " - " + mediaSource.album) : ""
	Plasmoid.toolTipTextFormat: Text.PlainText
	Plasmoid.status: PlasmaCore.Types.Hidden

	Plasmoid.onContextualActionsAboutToShow: {
		plasmoid.clearActions();
		if(mediaSource.canRaise){
			plasmoid.setAction("open", i18nc("Open player window or bring it to the front if already open", "Open "+mediaSource.playerName), mediaSource.playerIcon);
		}
	}

	PlasmaCore.DataSource {
		id: mediaSource
		engine: "mpris2"
		connectedSources: sources

		property string currentSource: plasmoid.configuration.preferredSource
		property var currentData: data[currentSource]
		property var currentMetadata: currentData ? currentData.Metadata : {}

        property bool loaded: hasLoaded()
		property bool canRaise: (loaded && currentData.CanRaise)
		property bool canControl: (loaded && currentData.CanControl)
		property bool canGoNext: (canControl && currentData.CanGoNext)
		property bool canGoPrevious: (canControl && currentData.CanGoPrevious)
		property bool canPlay: (canControl && currentData.CanPlay)
		property bool canPause: (canControl && currentData.CanPause)
		property bool canSeek: (canControl && currentData.CanSeek)

		property string playerIcon: loaded ? currentData["Desktop Icon Name"] : ""
		property string playerName: loaded ? currentData.Identity : ""
		property string playbackStatus: loaded ? currentData.PlaybackStatus : ""
		property string track: currentMetadata ? currentMetadata["xesam:title"] || "" : ""
		property string artist: currentMetadata ? currentMetadata["xesam:artist"] || "" : ""
		property string album: currentMetadata ? currentMetadata["xesam:album"] || "" : ""
		property string albumArt: currentMetadata ? currentMetadata["mpris:artUrl"] || "" : ""
		property double length: currentMetadata ? currentMetadata["mpris:length"] || 0 : 0
		property double position: loaded ? currentData.Position || 0 : 0

		function hasLoaded() {
			if (typeof currentData === "undefined" || typeof currentMetadata === "undefined") {
				return false;
			} else {
				return true;
			}
		}

		onSourceRemoved: {
			if(source === currentSource){
				currentSource = "@multiplex";
			}
		}
	}

	function formatTrackTime(s) {
		var hours   = Math.floor(s / 3600);
		var minutes = Math.floor((s - (hours * 3600)) / 60);
		var seconds = Math.ceil(s - (hours * 3600) - (minutes * 60));
		minutes = (minutes < 10) ? "0"+minutes : minutes;
		seconds = (seconds < 10) ? "0"+seconds : seconds;
		var time = minutes+":"+seconds;
		return time;
	}
	function action_open() {
		serviceOp("Raise");
	}
	function mediaPlay() {
		serviceOp("Play");
	}
	function mediaPause() {
		serviceOp("Pause");
	}
	function mediaToggle() {
		serviceOp("PlayPause");
	}
	function mediaPrev() {
		serviceOp("Previous");
	}
	function mediaNext() {
		serviceOp("Next");
	}
	function mediaStop() {
		serviceOp("Stop");
	}
	function updatePosition() {
		serviceOp("GetPosition");
	}
	function setPosition(s) {
		serviceOp("SetPosition", s);
	}
	function mediaSeek(s) {
		serviceOp("Seek", s);
	}
	function serviceOp(op,n) {
		var service = mediaSource.serviceForSource(mediaSource.currentSource);
		var operation = service.operationDescription(op);
		if (typeof n === "number") {
			operation.microseconds = n;
		}
		service.startOperationCall(operation);
	}

	Timer {
		interval: 500
		running: true
		repeat: true
		onTriggered: {
			updatePosition();
		}
	}

	Component.onCompleted: {
        mediaSource.serviceForSource("@multiplex").enableGlobalShortcuts();
    }
}
