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
import org.kde.plasma.components 3.0 as PlasmaComponents

ColumnLayout {
	id: expandedView
	enabled: (mediaSource.loaded && mediaSource.track)
	focus: true

    Keys.onReleased: {
        if (!event.modifiers) {
            event.accepted = true;
            if (event.key === Qt.Key_Space || event.key === Qt.Key_K) {
                // K is YouTube's key for "play/pause" :)
                root.mediaToggle();
            } else if (event.key === Qt.Key_P) {
                root.mediaPrev();
            } else if (event.key === Qt.Key_N) {
                root.mediaNext();
            } else if (event.key === Qt.Key_Left || event.key === Qt.Key_J) {
                // seek back 5s
               root.mediaSeek(-5000000);
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_L) {
                // seek forward 5s
                root.mediaSeek(5000000);
            } else if (event.key === Qt.Key_Home ||  event.key === Qt.Key_0) {
                root.setPosition(0);
            } else if (event.key > Qt.Key_0 && event.key <= Qt.Key_9) {
                // jump to percentage, ie. 0 = beginning, 1 = 10% of total length etc
                root.setPosition(mediaSource.length / 10 * (event.key - Qt.Key_0));
            } else {
                event.accepted = false;
            }
        }
    }

	Image {
		id: albumArt
		source: plasmoid.icon
		asynchronous: true
		sourceSize.width: root.currentWidth
		Layout.fillWidth: true
		fillMode: Image.PreserveAspectFit
		visible: status === Image.Ready
	}

    RowLayout {
		spacing: units.smallSpacing*2
        TextMetrics {
            id: durationTextMetrics
            text: i18nc("This is used to preserve a fixed width for the duration text.", "00:00")
            font: theme.smallestFont
        }

        PlasmaComponents.Label {
            Layout.preferredWidth: durationTextMetrics.width
            horizontalAlignment: Text.AlignRight
            text: root.formatTrackTime(progressBar.value)
            opacity: 0.9
            font: theme.smallestFont
        }

        ProgressBar {
            id: progressBar
			to: Math.ceil(mediaSource.length / 1000000)
            value: Math.ceil(mediaSource.position / 1000000)
            visible: mediaSource.canSeek
			Layout.fillWidth: true
        }

        PlasmaComponents.Label {
            Layout.preferredWidth: durationTextMetrics.width
            horizontalAlignment: Text.AlignLeft
            text: root.formatTrackTime(progressBar.to)
            opacity: 0.9
            font: theme.smallestFont
        }
    }

    PlasmaComponents.Label {
        Layout.fillWidth: true
        visible: text !== ""
		horizontalAlignment: Text.AlignHCenter
        text: plasmoid.toolTipMainText
        wrapMode: Text.WordWrap
        font.pointSize: subLabel.font.pointSize*1.2
		minimumPointSize: theme.smallestFont.pointSize
    }

    PlasmaComponents.Label {
		id: subLabel
		visible: text !== ""
		Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        text: plasmoid.toolTipSubText
        wrapMode: Text.WordWrap
		fontSizeMode: Text.Fit
		minimumPointSize: theme.smallestFont.pointSize
		opacity: 0.6
    }
}
