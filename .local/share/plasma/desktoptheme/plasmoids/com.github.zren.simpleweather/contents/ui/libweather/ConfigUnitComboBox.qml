// Version 1

import QtQuick 2.5
import QtQuick.Controls 2.5 as QtControls

QtControls.ComboBox {
	property string configKey

	textRole: "display"

	property bool populated: false

	// Bug: Switching from ConfigUnits to another page will set
	// WeatherPlugin.TemperatureUnitListModel to null. The
	// default weather widget segfaults.
	enabled: populated

	onCurrentIndexChanged: {
		// console.log('currentIndex', currentIndex, populated)
		if (configKey && model && model.unitIdForListIndex && populated) {
			var nextValue = model.unitIdForListIndex(currentIndex)
			serializeWith(nextValue)
		}
	}

	// Note that this function is overloaded to call
	// DisplayUnits.set____UnitId(nextValue) which will
	// serialize 0 if nextValue is the locale default.
	function serializeWith(nextValue) {
		// console.log('UrlComboBox.serializeWith', nextValue)
		if (plasmoid.configuration[configKey] === nextValue) {
			return
		}
		plasmoid.configuration[configKey] = nextValue
	}

	function populateWith(unitId) {
		// console.log('populateWith', unitId, model, model && model.unitIdForListIndex)
		if (model && model.unitIdForListIndex) {
			currentIndex = model.listIndexForUnitId(unitId)
			populated = true
		}
	}
}
