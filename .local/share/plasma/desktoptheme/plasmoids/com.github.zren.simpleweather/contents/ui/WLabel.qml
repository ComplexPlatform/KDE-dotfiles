import QtQuick 2.7
import org.kde.plasma.components 3.0 as PlasmaComponents

PlasmaComponents.Label {
	font.pointSize: -1
	font.pixelSize: 12 * units.devicePixelRatio
	font.family: forecastLayout.fontFamily
	font.weight: forecastLayout.fontBold
	color: forecastLayout.textColor
	style: forecastLayout.showOutline ? Text.Outline : Text.Normal
	styleColor: forecastLayout.outlineColor
}
