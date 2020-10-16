import QtQuick 2.7
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.weather 1.0 as WeatherPlugin

import "./libweather"

Item {
	id: widget

	WeatherData {
		id: weatherData
	}

	Plasmoid.icon: weatherData.currentConditionIconName
	Plasmoid.toolTipMainText: weatherData.currentConditions

	Plasmoid.fullRepresentation: Item {
		readonly property bool isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating
		Plasmoid.backgroundHints: isDesktopContainment && !plasmoid.configuration.showBackground ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground

		property Item contentItem: weatherData.needsConfiguring ? configureButton : forecastLayout
		Layout.preferredWidth: 200 * units.devicePixelRatio
		Layout.preferredHeight: 150 * units.devicePixelRatio
		width: Layout.preferredWidth
		height: Layout.preferredHeight

		PlasmaComponents.Button {
			id: configureButton
			anchors.centerIn: parent
			visible: weatherData.needsConfiguring
			text: i18ndc("plasma_applet_org.kde.plasma.weather", "@action:button", "Configure...")
			onClicked: plasmoid.action("configure").trigger()
		}

		ForecastLayout {
			id: forecastLayout
			anchors.fill: parent
			visible: !weatherData.needsConfiguring
		}

	}

	function action_refresh() {
		weatherData.refresh()
	}

	Component.onCompleted: {
		plasmoid.setAction("refresh", i18n("Refresh"), "view-refresh")

		// plasmoid.action("configure").trigger()
	}
}
