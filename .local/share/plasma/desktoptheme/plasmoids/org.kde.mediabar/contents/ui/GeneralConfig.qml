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
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
	id: configRoot

	signal configurationChanged

	property alias cfg_maximumWidth: widthSlider.value
	property alias cfg_minimumWidth: widthSlider.from
	property string cfg_preferredSource
	property alias cfg_useWheelForSeeking: scrollSeekCheckBox.checked

	ColumnLayout {
		spacing: units.smallSpacing*2

		CheckBox {
			id: scrollSeekCheckBox
			text: i18n("Use scroll wheel for seeking")
		}

		Label {
			text: i18n("Maximum width:")
		}

		RowLayout {
			Slider {
				id: widthSlider
				stepSize: 10
				snapMode: Slider.SnapAlways
				from: 200
				to: 1000
			}
			Label {
				text: widthSlider.value + i18n("px")
			}
		}

		Label {
			text:  i18n("Preferred media source:")
		}

		ListModel {
			id: sourcesModel
			Component.onCompleted: {
				var arr = [];
				arr.push({text: cfg_preferredSource});
				var sources = dataSource.sources;
				for (var i = 0, j = sources.length; i < j; ++i) {
					if (sources[i] === cfg_preferredSource) {
						continue
					}
					arr.push({text: sources[i]});
				}
				append(arr);
			}
		}

		ComboBox {
			id: sourcesComboBox
			model: sourcesModel
			focus: true
			currentIndex: 0
			textRole: "text"
			onCurrentIndexChanged: {
				var current = model.get(currentIndex);
				if (current) {
					cfg_preferredSource = current.text;
					configRoot.configurationChanged();
				}
			}
		}
	}

	PlasmaCore.DataSource {
		id: dataSource
		engine: "mpris2"
	}
}
