import QtQuick 2.7
import QtQuick.Layouts 1.1

ColumnLayout {
	id: forecastLayout

	opacity: weatherData.hasData ? 1 : 0
	Behavior on opacity { NumberAnimation { duration: 1000 } }

	//--- Settings
	spacing: units.smallSpacing

	readonly property color textColor: plasmoid.configuration.textColor || theme.textColor
	readonly property color outlineColor: plasmoid.configuration.outlineColor || theme.backgroundColor

	readonly property bool showOutline: plasmoid.configuration.showOutline

	readonly property string fontFamily: plasmoid.configuration.fontFamily || theme.defaultFont.family
	readonly property var fontBold: plasmoid.configuration.bold ? Font.Bold : Font.Normal

	readonly property real fadedOpacity: 0.7

	//--- Layout
	CurrentWeatherView {
		id: currentWeatherView
		Layout.alignment: Qt.AlignHCenter
	}

	NoticesListView {
		Layout.fillWidth: true
		model: weatherData.watchesModel
		readonly property bool showWatches: plasmoid.configuration.showWarnings
		visible: showWatches && model.length > 0
		state: "Watches"
		horizontalAlignment: Text.AlignHCenter
	}

	NoticesListView {
		Layout.fillWidth: true
		model: weatherData.warningsModel
		readonly property bool showWarnings: plasmoid.configuration.showWarnings
		visible: showWarnings && model.length > 0
		state: "Warnings"
		horizontalAlignment: Text.AlignHCenter
	}
}
