// Version 1

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

RowLayout {
	id: configTextFormat

	property alias boldConfigKey: configBold.configKey
	property alias italicConfigKey: configItalic.configKey
	property alias underlineConfigKey: configUnderline.configKey
	property alias alignConfigKey: configTextAlign.configKey

	Button {
		id: configBold
		property string configKey: ''
		visible: configKey
		iconName: 'format-text-bold-symbolic'
		checkable: true
		checked: configKey ? plasmoid.configuration[configKey] : false
		onClicked: plasmoid.configuration[configKey] = checked
	}

	Button {
		id: configItalic
		property string configKey: ''
		visible: configKey
		iconName: 'format-text-italic-symbolic'
		checkable: true
		checked: configKey ? plasmoid.configuration[configKey] : false
		onClicked: plasmoid.configuration[configKey] = checked
	}

	Button {
		id: configUnderline
		property string configKey: ''
		visible: configKey
		iconName: 'format-text-underline-symbolic'
		checkable: true
		checked: configKey ? plasmoid.configuration[configKey] : false
		onClicked: plasmoid.configuration[configKey] = checked
	}

	Item {
		Layout.preferredWidth: units.smallSpacing
		readonly property bool groupBeforeVisible: configBold.visible || configItalic.visible || configUnderline.visible
		readonly property bool groupAfterVisible: configTextAlign.visible
		visible: groupBeforeVisible && groupAfterVisible
	}

	ConfigTextAlign {
		id: configTextAlign
		visible: configKey
	}
}
