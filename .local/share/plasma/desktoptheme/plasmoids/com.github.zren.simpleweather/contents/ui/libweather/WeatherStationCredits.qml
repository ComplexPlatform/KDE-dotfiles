// Version 1

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.kirigami 2.3 as Kirigami

Rectangle {
	id: weatherStationCredits
	Layout.fillWidth: true
	property int horzPadding: 4 * Kirigami.Units.devicePixelRatio
	property int vertPadding: 2 * Kirigami.Units.devicePixelRatio
	implicitWidth: horzPadding + weatherStationCreditsLabel.implicitWidth + horzPadding
	implicitHeight: vertPadding + weatherStationCreditsLabel.implicitHeight + vertPadding

	visible: creditsText

	color: {
		var c = Kirigami.Theme.textColor
		return Qt.rgba(c.r, c.g, c.b, 0.1)
	}
	border.color: {
		var c = Kirigami.Theme.textColor
		return Qt.rgba(c.r, c.g, c.b, 0.2)
	}
	border.width: 1 * Kirigami.Units.devicePixelRatio
	radius: 4 * Kirigami.Units.devicePixelRatio

	readonly property string creditsText: weatherDataSource.getData('Credit')
	readonly property string creditsUrl: weatherDataSource.getData('Credit Url')

	PlasmaCore.DataSource {
		id: weatherDataSource
		engine: "weather"
		readonly property string weatherSource: plasmoid.configuration.source
		connectedSources: weatherSource
		interval: 1000 * 60 * 60 * 24
		readonly property var currentData: data[weatherSource]

		function getData(key) {
			if (!currentData) {
				return ''
			}
			if (typeof currentData[key] === "undefined") {
				return ''
			}
			return currentData[key]
		}
	}

	Label {
		id: weatherStationCreditsLabel
		anchors.left: parent.left
		anchors.leftMargin: parent.horzPadding
		anchors.top: parent.top
		anchors.topMargin: parent.vertPadding

		text: {
			var str = ''
			if (weatherStationCredits.creditsText) {
				str = weatherStationCredits.creditsText
				if (weatherStationCredits.creditsUrl) {
					str = '<a href="' + weatherStationCredits.creditsUrl + '">' + str + '</a>'
				}
			}
			return str
		}
		onLinkActivated: Qt.openUrlExternally(link)
		MouseArea {
			anchors.fill: parent
			acceptedButtons: Qt.NoButton // we don't want to eat clicks on the Text
			cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
		}
	}
}
