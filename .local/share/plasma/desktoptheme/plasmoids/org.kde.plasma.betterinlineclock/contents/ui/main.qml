/*
 * Copyright 2013  Heena Mahour <heena393@gmail.com>
 * Copyright 2013 Sebastian Kügler <sebas@kde.org>
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
import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.private.digitalclock 1.0
import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.calendar 2.0 as PlasmaCalendar

Item {
    id: root

    width: units.gridUnit * 10
    height: units.gridUnit * 4
    property string dateFormatString: setDateFormatString()
    property date tzDate: {
        // get the time for the given timezone from the dataengine
        var now = dataSource.data[plasmoid.configuration.lastSelectedTimezone]["DateTime"];
        // get current UTC time
        var msUTC = now.getTime() + (now.getTimezoneOffset() * 60000);
        // add the dataengine TZ offset to it
        return new Date(msUTC + (dataSource.data[plasmoid.configuration.lastSelectedTimezone]["Offset"] * 1000));
    }

    function initTimezones() {
        var tz  = Array()
        if (plasmoid.configuration.selectedTimeZones.indexOf("Local") === -1) {
            tz.push("Local");
        }
        root.allTimezones = tz.concat(plasmoid.configuration.selectedTimeZones);
    }

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: DigitalClock { }
    Plasmoid.fullRepresentation: CalendarView { }

    Plasmoid.toolTipItem: Loader {
        id: tooltipLoader

        Layout.minimumWidth: item ? item.width : 0
        Layout.maximumWidth: item ? item.width : 0
        Layout.minimumHeight: item ? item.height : 0
        Layout.maximumHeight: item ? item.height : 0

        source: "Tooltip.qml"
    }

    //We need Local to be *always* present, even if not disaplayed as
    //it's used for formatting in ToolTip.dateTimeChanged()
    property var allTimezones
    Connections {
        target: plasmoid.configuration
        onSelectedTimeZonesChanged: root.initTimezones();
    }

    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: allTimezones
        interval: plasmoid.configuration.showSeconds ? 1000 : 60000
        intervalAlignment: plasmoid.configuration.showSeconds ? PlasmaCore.Types.NoAlignment : PlasmaCore.Types.AlignToMinute
    }

    function setDateFormatString() {
        // remove "dddd" from the locale format string
        // /all/ locales in LongFormat have "dddd" either
        // at the beginning or at the end. so we just
        // remove it + the delimiter and space
        var format = Qt.locale().dateFormat(Locale.LongFormat);
        format = format.replace(/(^dddd.?\s)|(,?\sdddd$)/, "");
        return format;
    }

    function action_clockkcm() {
        KCMShell.open("clock");
    }

    function action_formatskcm() {
        KCMShell.open("formats");
    }

    Component.onCompleted: {
        plasmoid.setAction("clipboard", i18n("Copy to Clipboard"), "edit-copy");
        ClipboardMenu.setupMenu(plasmoid.action("clipboard"));

        root.initTimezones();
        if (KCMShell.authorize("clock.desktop").length > 0) {
            plasmoid.setAction("clockkcm", i18n("Adjust Date and Time..."), "preferences-system-time");
        }
        if (KCMShell.authorize("formats.desktop").length > 0) {
            plasmoid.setAction("formatskcm", i18n("Set Time Format..."));
        }

        // Set the list of enabled plugins from config
        // to the manager
        PlasmaCalendar.EventPluginsManager.enabledPlugins = plasmoid.configuration.enabledCalendarPlugins;
    }
}
