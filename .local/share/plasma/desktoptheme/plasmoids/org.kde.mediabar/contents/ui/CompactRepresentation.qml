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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

Item {
	id: compactView

	Layout.minimumWidth: compactRow.calculatedWidth
	Layout.maximumWidth: compactRow.calculatedWidth
	Layout.preferredWidth: compactRow.calculatedWidth

	RowLayout {
		id: compactRow
		spacing: 0

		property int calculatedWidth: compactTrackInfo.calculatedTextWidth + compactIcon.width
		Layout.minimumWidth: calculatedWidth
		Layout.maximumWidth: calculatedWidth
		Layout.preferredWidth: calculatedWidth

		onCalculatedWidthChanged: {
			root.currentWidth = calculatedWidth;
		}

		PlasmaCore.IconItem {
			id: compactIcon
			Layout.alignment: Qt.AlignVCenter
			Layout.preferredHeight: compactView.height
			source: mediaSource.playbackStatus === "Playing" ? root.pauseIcon : root.playIcon
		}

		Item {
			id: container
			visible: (mediaSource.loaded && mediaSource.track)

			Layout.fillHeight: true;
			Layout.preferredWidth: compactTrackInfo.calculatedTextWidth
			clip: true

			PlasmaComponents.Label {
				id: compactTrackInfo

				property int calculatedTextWidth: Math.max(root.minWidth, Math.min(root.maxWidth, barTextMetrics.width)) + units.gridUnit
				property int widthDifference: calculatedTextWidth - barTextMetrics.width
				property bool scrolling: false

				text: barTextMetrics.text

				anchors {
					top: parent.top
					bottom: parent.bottom
				}

				width: 	calculatedTextWidth
				fontSizeMode: Text.VerticalFit
				verticalAlignment: Text.AlignVCenter
				elide: scrolling ? Text.ElideNone : Text.ElideRight
				maximumLineCount: 1

				onTextChanged: {
					anim.complete();
					run();
				}

				function run() {
					if (calculatedTextWidth  >= barTextMetrics.width || anim.running || scrolling) {
						return;
					}
					anim.start();
					scrolling = true;
				}
			}
		}
	}

	function clickedView(btn) {
		switch (btn) {
		case 1:
			root.mediaToggle();
			break;
		case 8:
			root.mediaPrev();
			break;
		case 16:
			root.mediaNext();
			break;
		default:
			if (!plasmoid.expanded) {
				plasmoid.expanded = true;
			}
		}
	}

	MouseArea {
		anchors.fill: compactRow
		hoverEnabled: true
		acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton
		onClicked: clickedView(mouse.button)
		onWheel: {
			if (root.seekingWheel && mediaSource.canSeek) {
				wheel.angleDelta.y > 0  ? root.mediaSeek(5000000) :  root.mediaSeek(-5000000);
			}
		}
        onEntered: compactTrackInfo.run()
	}

	TextMetrics {
		id: barTextMetrics
		text: (mediaSource.artist ? mediaSource.artist + " - " : "") + (mediaSource.track ? mediaSource.track : "")
		font.pixelSize: compactTrackInfo.font.pixelSize
	}

	SequentialAnimation {
		id: anim
		running: false
		onStopped: compactTrackInfo.scrolling = false;
		PauseAnimation {
			duration: 250
		}
		SmoothedAnimation {
			easing.type: Easing.InSine
			target: compactTrackInfo
			property: "x"
			from: 0
			to: compactTrackInfo.widthDifference
			velocity: 30
		}
		SmoothedAnimation {
			easing.type: Easing.OutSine
			target: compactTrackInfo
			property: "x"
			to: 0
			velocity: 40
		}
	}
}
