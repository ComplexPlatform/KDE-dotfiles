// Version 2

/*
 * Copyright 2016,2018  Friedrich W. H. Kossebau <kossebau@kde.org>
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

import QtQuick.Controls 1.4 as QtControls
import QtQuick.Layouts 1.3

import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.weather 1.0


ColumnLayout {
	id: root

	property alias selectedServices: serviceListModel.selectedServices
	property string source
	readonly property bool canSearch: !!searchStringEdit.text && selectedServices.length
	readonly property bool handlesEnterKey: canSearch && searchStringEdit.activeFocus

	function searchLocation() {
		if (!canSearch) {
			return;
		}

		// avoid automatic selection once model is refilled
		locationListView.currentRow = -1;
		locationListView.selection.clear();
		noSearchResultReport.visible = false;
		source = "";
		locationListView.forceActiveFocus();

		locationListModel.searchLocations(searchStringEdit.text, selectedServices);
	}

	function handleLocationSearchDone(success, searchString) {
		if (!success) {
			noSearchResultReport.text = i18ndc("plasma_applet_org.kde.plasma.weather", "@info", "No weather stations found for '%1'", searchString);
			noSearchResultReport.visible = true;
		}
	}

	LocationListModel {
		id: locationListModel
		onLocationSearchDone: handleLocationSearchDone(success, searchString);
	}

	ServiceListModel {
		id: serviceListModel
	}

	QtControls.Menu {
		id: serviceSelectionMenu

		Instantiator {
			model: serviceListModel
			delegate: QtControls.MenuItem {
				text: model.display
				checkable: true
				checked: model.checked

				onToggled: {
					model.checked = checked;
					checked = Qt.binding(function() { return model.checked; });
					// weatherStationConfigPage.configurationChanged();
				}
			}
			onObjectAdded: serviceSelectionMenu.insertItem(index, object)
			onObjectRemoved: serviceSelectionMenu.removeItem(object)
		}

	}

	ColumnLayout {
		RowLayout {
			Layout.fillWidth: true

			QtControls.TextField {
				id: searchStringEdit

				Layout.fillWidth: true
				Layout.minimumWidth: implicitWidth
				placeholderText: i18ndc("plasma_applet_org.kde.plasma.weather", "@info:placeholder", "Enter location")
				onAccepted: {
					searchLocation();
				}
			}

			QtControls.Button {
				id: serviceSelectionButton

				iconName: "services"
				tooltip: i18ndc("plasma_applet_org.kde.plasma.weather", "@info:tooltip", "Select weather services providers")
				menu: serviceSelectionMenu
			}

			Item {
				Layout.preferredHeight: Math.max(searchButton.height, searchStringEdit.height)
				Layout.preferredWidth: Layout.preferredHeight

				PlasmaComponents.BusyIndicator {
					id: busy

					anchors.fill: parent
					visible: locationListModel.validatingInput
				}
			}

			QtControls.Button {
				id: searchButton

				iconName: "edit-find"
				text: i18ndc("plasma_applet_org.kde.plasma.weather", "@action:button", "Search")
				enabled: canSearch

				onClicked: {
					searchLocation();
				}
			}
		}

		QtControls.TableView {
			id: locationListView

			Layout.minimumWidth: implicitWidth
			Layout.minimumHeight: implicitHeight
			Layout.fillWidth: true
			Layout.fillHeight: true

			headerVisible: false
			model: locationListModel

			onActivated: {
				if (row !== -1 && rowCount) {
					source = locationListModel.valueForListIndex(row);
				}
			}

			QtControls.TableViewColumn {
				id: locationListViewStationColumn

				movable: false
				resizable: false
				role: "display"
			}

			QtControls.Label {
				id: noSearchResultReport

				anchors.centerIn: parent
				visible: false
			}
		}
	}

	Component.onCompleted: {
		searchStringEdit.forceActiveFocus();
	}
}
