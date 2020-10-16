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
import QtQuick.Layouts 1.2
import org.kde.plasma.extras 2.0 as PlasmaExtras


GridLayout {
    id: trackInfo

    property alias textAlignment: songText.horizontalAlignment
    property bool showAlbumLine: true
    property bool horizontal: false
    property string album: { getAlbum() }

    function getAlbum() {
        var metadata = root.currentMetadata

        if (!metadata) {
            return ""
        }
        var xesamAlbum = metadata["xesam:album"]
        if (xesamAlbum) {
            return xesamAlbum
        }

        // if we play a local file without title and artist, show its containing folder instead
        if (metadata["xesam:title"] || root.artist) {
            return ""
        }

        var xesamUrl = (metadata["xesam:url"] || "").toString()
        if (xesamUrl.indexOf("file:///") !== 0) { // "!startsWith()"
            return ""
        }

        var urlParts = xesamUrl.split("/")
        if (urlParts.length < 3) {
            return ""
        }

        var lastFolderPath = urlParts[urlParts.length - 2] // last would be filename
        if (lastFolderPath) {
            return lastFolderPath
        }

        return ""
    }

    PlasmaExtras.Heading {
        id: songText
        Layout.fillWidth: true
        level: 4
        horizontalAlignment: Text.AlignHCenter

        maximumLineCount: 1
        elide: Text.ElideRight
        text: {
            if (!root.track) {
                return i18n("No media playing")
            }
            return (showAlbumLine && album && root.artist) ? i18nc("artist – track", "%1 – %2", root.artist, root.track) : root.track
        }
        textFormat: Text.PlainText
    }

    PlasmaExtras.Heading {
        id: albumText
        Layout.fillWidth: true
        Layout.row: horizontal ? 0 : 1
        Layout.column: horizontal ? 1 : 0

        level: 5
        opacity: 0.6
        horizontalAlignment: textAlignment
        wrapMode: Text.NoWrap
        elide: Text.ElideRight
        visible: text !== ""
        text: (showAlbumLine && album)? album : root.artist || ""
        textFormat: Text.PlainText
    }
}
