// Version 6

import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.kirigami 2.3 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

// ConfigPage's parent is a StackView in:
// https://github.com/KDE/plasma-desktop/blame/master/desktoppackage/contents/configuration/AppletConfiguration.qml
Item {
	id: page
	Layout.fillWidth: true
	default property alias _contentChildren: content.data
	implicitHeight: content.implicitHeight

	// We should probably get ScrollBar.width but this works.
	property int scrollbarWidth: 21
	property int rightPadding: Kirigami.Units.smallSpacing
	property int scrollbarMargin: rightPadding + Math.ceil(scrollbarWidth * units.devicePixelRatio)

	ColumnLayout {
		id: content
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.rightMargin: page.scrollbarMargin
		anchors.top: parent.top

		// Workaround for crash when using default on a Layout.
		// https://bugreports.qt.io/browse/QTBUG-52490
		// Still affecting Qt 5.7.0
		Component.onDestruction: {
			while (children.length > 0) {
				children[children.length - 1].parent = page
			}
		}
	}

	property alias showAppletVersion: appletVersionLoader.active
	Loader {
		id: appletVersionLoader
		active: false
		visible: active
		source: "AppletVersion.qml"
		anchors.right: parent.right
		anchors.rightMargin: page.scrollbarMargin
		anchors.bottom: parent.top
	}
}
