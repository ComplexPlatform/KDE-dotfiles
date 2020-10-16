// Version 1

/*
 * Copyright 2018  Friedrich W. H. Kossebau <kossebau@kde.org>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9

import QtQuick.Window 2.2
import QtQuick.Controls 1.4 as QtControls
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore


Window {
	id: dialog

	LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
	LayoutMirroring.childrenInherit: true

	flags: Qt.Dialog
	modality: Qt.WindowModal

	minimumWidth: mainColumn.Layout.minimumWidth
	minimumHeight: mainColumn.Layout.minimumHeight

	title: i18ndc("plasma_applet_org.kde.plasma.weather", "@title:window", "Select Weather Station")
	color: syspal.window

	property alias selectedServices : stationPicker.selectedServices
	property alias source: stationPicker.source

	signal accepted

	function close() {
		dialog.visible = false;
	}


	SystemPalette {
		id: syspal
	}

	QtControls.Action {
		id: acceptAction

		shortcut: "Return"
		enabled: !!source && !stationPicker.handlesEnterKey
		onTriggered: {
			accepted();
			dialog.close();
		}
	}

	QtControls.Action {
		id: cancelAction

		shortcut: "Escape"
		onTriggered: {
			dialog.close();
		}
	}

	ColumnLayout {
		id: mainColumn
		anchors {
			fill: parent
			margins: mainColumn.spacing * units.devicePixelRatio //margins are hardcoded in QStyle we should match that here
		}
		// TODO: not yet perfect
		Layout.minimumWidth: Math.max(stationPicker.Layout.minimumWidth, buttonsRow.implicitWidth) + 2*anchors.margins
		Layout.minimumHeight: stationPicker.Layout.minimumHeight + buttonsRow.implicitHeight + 2*anchors.margins

		WeatherStationPicker {
			id: stationPicker

			Layout.fillWidth: true
			Layout.fillHeight: true
		}

		RowLayout {
			id: buttonsRow

			Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

			QtControls.Button {
				enabled: !!source
				iconName: "dialog-ok"
				text: i18ndc("plasma_applet_org.kde.plasma.weather", "@action:button", "Select")
				onClicked: {
					acceptAction.trigger();
				}
			}
			QtControls.Button {
				iconName: "dialog-cancel"
				text: i18ndc("plasma_applet_org.kde.plasma.weather", "@action:button", "Cancel")
				onClicked: {
					cancelAction.trigger();
				}
			}
		}
	}
}
