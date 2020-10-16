/***************************************************************************
 *   Copyright 2013 Sebastian Kügler <sebas@kde.org>                       *
 *   Copyright 2014, 2016 Kai Uwe Broulik <kde@privat.broulik.de>          *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Library General Public License as       *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU Library General Public License for more details.                  *
 *                                                                         *
 *   You should have received a copy of the GNU Library General Public     *
 *   License along with this program; if not, write to the                 *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.4
import org.kde.plasma.core 2.0 as PlasmaCore


Item {

    property alias artSize: albumArt.sourceSize

    PlasmaCore.IconItem {
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        height: Math.min(parent.height, Math.max(units.iconSizes.large, Math.round(parent.height / 2)))
        width: height

        source: mpris2Source.currentData["Desktop Icon Name"]
        visible: !albumArt.visible

        usesPlasmaTheme: false
    }

    Image {
        id: albumArt
        anchors {
            fill: parent
        }

        source: root.albumArt
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(height, height)
        visible: !!root.track && status === Image.Ready
    }
}
