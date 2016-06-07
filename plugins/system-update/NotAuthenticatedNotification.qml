/*
 * This file is part of system-settings
 *
 * Copyright (C) 2016 Canonical Ltd.
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 3, as published
 * by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranties of
 * MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
 * PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems

Column {
    id: credentialsNotification
    objectName: "credentialsNotification"

    signal requestAuthentication()

    spacing: units.gu(2)
    anchors {
        left: parent.left
        right: parent.right
    }

    Label {
        text: i18n.tr("Sign in to Ubuntu One to receive updates for apps.")
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
        anchors {
            left: parent.left
            leftMargin: units.gu(10)
            right: parent.right
            rightMargin: units.gu(10)
        }
    }
    Button {
        objectName: "updateRequestAuthButton"
        text: i18n.tr("Sign In…")
        anchors.horizontalCenter: parent.horizontalCenter
        // onClicked: uoaConfig.exec()
        onClicked: credentialsNotification.requestAuthentication()
    }
}
