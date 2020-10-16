/*
 * Copyright 2015 Martin Klapetek <mklapetek@kde.org>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 2.0
import QtQuick.Controls 2.4 as QtControls
import QtQuick.Layouts 1.0 as QtLayouts
import org.kde.plasma.calendar 2.0 as PlasmaCalendar
import org.kde.kirigami 2.5 as Kirigami

Item {
    id: calendarPage
    width: childrenRect.width
    height: childrenRect.height

    signal configurationChanged

    property alias cfg_showWeekNumbers: showWeekNumbers.checked

    function saveConfig()
    {
        plasmoid.configuration.enabledCalendarPlugins = PlasmaCalendar.EventPluginsManager.enabledPlugins;
    }

    Kirigami.FormLayout {
        anchors {
            left: parent.left
            right: parent.right
        }

        QtControls.CheckBox {
            id: showWeekNumbers
            Kirigami.FormData.label: i18n("General:")
            text: i18n("Show week numbers")
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QtControls.CheckBox {
            id: showBorders
            Kirigami.FormData.label: i18n("Visuals:")
            text: i18n("Show borders")
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QtLayouts.ColumnLayout {
            Kirigami.FormData.label: i18n("Available Plugins:")
            Kirigami.FormData.buddyFor: children[1] // 0 is the Repeater

            Repeater {
                id: calendarPluginsRepeater
                model: PlasmaCalendar.EventPluginsManager.model
                delegate: QtLayouts.RowLayout {
                    QtControls.CheckBox {
                        text: model.display
                        checked: model.checked
                        onClicked: {
                            //needed for model's setData to be called
                            model.checked = checked;
                            calendarPage.configurationChanged();
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        PlasmaCalendar.EventPluginsManager.populateEnabledPluginsList(plasmoid.configuration.enabledCalendarPlugins);
    }
}

