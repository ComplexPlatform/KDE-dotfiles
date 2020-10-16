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
import org.kde.plasma.configuration 2.0

ConfigModel {
	ConfigCategory {
		name: i18n("General")
		icon: "preferences-desktop"
		source: "GeneralConfig.qml"
	}
}
