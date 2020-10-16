/**
    Copyright 2016 Bill Binder <dxtwjb@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.5 as QQC2

Item {
    id: compactViewConfig

    property alias cfg_minimumWidthUnits: widthSlider.proxyFirstValue
    property alias cfg_maximumWidthUnits: widthSlider.proxySecondValue
    property alias cfg_showProgressBar: showProgressBar.checked
    property alias cfg_hideDisabledControls: hideDisabledControls.checked

    GridLayout {
        columns: 2
        rowSpacing: units.smallSpacing
        Layout.fillWidth: true

        QQC2.Label {
            text: i18n("Width Range:")
            Layout.alignment: Qt.AlignRight
            Layout.bottomMargin: units.largeSpacing
        }

        RowLayout {
            spacing: units.smallSpacing
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            Layout.bottomMargin: units.largeSpacing

            QQC2.Label {
                id: lbl_minWidth
                text: Math.round(widthSlider.proxyFirstValue * units.gridUnit) + "px"
                Layout.preferredWidth: 50
                horizontalAlignment: Text.AlignRight
            }

            QQC2.RangeSlider {
                id: widthSlider
                Layout.fillWidth: true
                from: 1
                to: 101
                stepSize: 1
                snapMode: QQC2.RangeSlider.SnapAlways
                first.value: 18
                second.value: to

                //On QT 2.5 `RangeSlider` values are not allowed as an alias
                property int proxySecondValue: 0
                property int proxyFirstValue: 1

                first.onValueChanged: proxyFirstValue = first.value
                second.onValueChanged: proxySecondValue = (second.position == 1.0) ? 0 : second.value
                onProxyFirstValueChanged: first.value = proxyFirstValue
                onProxySecondValueChanged: second.value = proxySecondValue ? proxySecondValue : to
            }

            QQC2.Label {
                id: lbl_maximumWidth
                text: (widthSlider.second.position == 1.0) ? i18n("No limit")
                                                           : Math.round(widthSlider.proxySecondValue * units.gridUnit) + "px"
                Layout.preferredWidth: 50
                horizontalAlignment: Text.AlignLeft
            }
        }

        QQC2.Label {
            text: i18n("Display:")
            Layout.alignment: Qt.AlignRight
        }

        QQC2.CheckBox {
            id: showProgressBar
            text: i18n("Show progress bar")
        }

        QQC2.Label {}

        QQC2.CheckBox {
            id: hideDisabledControls
            text: i18n("Hide controls when not available")
        }
    }
}
