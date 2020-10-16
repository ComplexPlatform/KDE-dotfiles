// Version 1

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.kirigami 2.3 as Kirigami

RowLayout {
	id: configWeatherStationPicker
	Kirigami.FormData.label: i18ndc("plasma_applet_org.kde.plasma.weather", "@label", "Location:")
	property var configKey: 'source'

	property var stationPicker: WeatherStationPickerDialog {
		id: stationPicker

		onAccepted: {
			plasmoid.configuration[configKey] = source
		}
	}

	Label {
		id: locationDisplay
		Layout.fillWidth: true
		elide: Text.ElideRight

		text: {
			var sourceDetails = plasmoid.configuration[configKey].split('|')
			if (sourceDetails.length > 2) {
				return i18ndc("plasma_applet_org.kde.plasma.weather",
					"A weather station location and the weather service it comes from", "%1 (%2)",
					sourceDetails[2], sourceDetails[0])
			}
			return i18ndc("plasma_applet_org.kde.plasma.weather", "no weather station", "-")
		}
	}
	Button {
		id: selectButton
		iconName: "edit-find"
		text: i18ndc("plasma_applet_org.kde.plasma.weather", "@action:button", "Select")
		onClicked: stationPicker.visible = true
	}
}
