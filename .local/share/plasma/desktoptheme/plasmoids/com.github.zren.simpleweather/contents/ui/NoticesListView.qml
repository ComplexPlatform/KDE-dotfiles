// Version 2

import QtQuick 2.7
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.weather 1.0 as WeatherPlugin

ColumnLayout {
	id: noticesListView
	property alias model: repeater.model

	spacing: units.smallSpacing

	property int horizontalAlignment: Text.AlignLeft
	property color backgroundColor: "#800"
	property color borderColor: "#800"
	property color textColor: "#eee"

	state: "Watches"
	states: [
		// Watches = "warning" yellow/orange
		State {
			name: "Watches"
			PropertyChanges {
				target: noticesListView
				backgroundColor: "#856404"
				borderColor: "#755400"
				textColor: "#fff3cd"
			}
		},
		// Warnings = "danger" red
		State {
			name: "Warnings"
			PropertyChanges {
				target: noticesListView
				backgroundColor: "#721c24"
				borderColor: "#620c14"
				textColor: "#f8d7da"
			}
		}
	]

	Repeater {
		id: repeater
		model: []

		Rectangle {
			id: noticeItem
			Layout.fillWidth: true
			property int horPadding: 4 * units.devicePixelRatio
			property int vertPadding: 2 * units.devicePixelRatio
			implicitHeight: vertPadding + noticeLabel.implicitHeight + vertPadding

			color: getStateColor(noticesListView.backgroundColor)
			border.color: getStateColor(noticesListView.borderColor)
			property color labelColor: getStateColor(noticesListView.textColor)

			function getStateColor(c) {
				return noticeMouseArea.containsMouse ? Qt.lighter(c, 1.1) : c
			}

			border.width: 1 * units.devicePixelRatio
			radius: 3 * units.devicePixelRatio


			MouseArea {
				id: noticeMouseArea
				anchors.fill: parent
				hoverEnabled: true
				cursorShape: Qt.PointingHandCursor
				onClicked: Qt.openUrlExternally(modelData.url)
			}

			PlasmaComponents.Label {
				id: noticeLabel
				text: modelData.description
				color: noticeItem.labelColor
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: noticeItem.horPadding
				anchors.right: parent.right
				anchors.rightMargin: noticeItem.horPadding
				elide: Text.ElideRight
				horizontalAlignment: noticesListView.horizontalAlignment
			}
		}
	}
}
