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
 * This file represents the UI of the System Updates panel.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems
import Ubuntu.SystemSettings.Update 1.0

Item {
    id: updates
    property bool havePower: false
    property bool haveSystemUpdate: false
    property int managerStatus
    property int updatesCount
    property bool authenticated: false
    property bool online: false
    property alias systemImageBackend: systemUpdate.backend
    property alias clickUpdatesModel: clickUpdatesRepeater.model

    signal requestAuthentication()
    signal stop()
//    signal udmDownloadCreated(string packageName, int revision, int udmId)

    states: [
        State {
            name: "offline"
            PropertyChanges { target: overlay; visible: true }
            PropertyChanges { target: glob; hidden: true }
            PropertyChanges { target: systemUpdate; visible: false }
            PropertyChanges { target: clickUpdates; visible: false }
            when: !online
        },
        State {
            name: "error"
            PropertyChanges { target: overlay; visible: true }
            PropertyChanges { target: glob; hidden: true }
            PropertyChanges { target: systemUpdate; visible: false }
            PropertyChanges { target: clickUpdates; visible: false }
            when: managerStatus === UpdateManager.NetworkError ||
                  managerStatus === UpdateManager.ServerError
        },
        State {
            name: "noAuth"
            when: !authenticated
            PropertyChanges { target: notauthNotification; visible: true }
            PropertyChanges { target: noauthDivider; visible: (haveSystemUpdate || !glob.hidden) }
        },
        State {
            name: "noUpdates"
            PropertyChanges { target: overlay; visible: true }
            when: {
                var idle = managerStatus === UpdateManager.Idle;
                var noUpdates = (updatesCount === 0) && !haveSystemUpdate;
                return idle && noUpdates;
            }
        }
    ]

    Flickable {
        id: scrollWidget
        anchors.fill: parent
        boundsBehavior: (contentHeight > parent.height) ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
        contentHeight: {
            var h = 0;
            h += glob.hidden ? 0 : glob.height;
            h += systemUpdate.visible ? systemUpdate.height : 0;
            h += clickUpdates.visible ? clickUpdates.height : 0;
            h += noauthDivider.visible ? noauthDivider.height : 0;
            h += notauthNotification.visible ? notauthNotification.height : 0;
            return h;
        }
        flickableDirection: Flickable.VerticalFlick

        Global {
            id: glob
            objectName: "updatesGlobal"
            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }

            height: hidden ? 0 : units.gu(6)
            managerStatus: updates.managerStatus
            requireRestart: updates.haveSystemUpdate
            updatesCount: updates.updatesCount
            online: updates.online
            onStop: updates.stop()
        }

        SystemUpdate {
            id: systemUpdate
            objectName: "updatesSystemUpdate"
            visible: updates.haveSystemUpdate
            anchors {
                left: parent.left
                right: parent.right
                top: glob.bottom
            }
        }

        Column {
            id: clickUpdates
            objectName: "updatesClickUpdates"
            visible: !!clickUpdatesRepeater.model && clickUpdatesRepeater.model.count > 0
            anchors {
                left: parent.left
                right: parent.right
                top: updates.haveSystemUpdate ? systemUpdate.bottom : glob.bottom
            }
            height: childrenRect.height

            Repeater {
                id: clickUpdatesRepeater
                height: childrenRect.height
                delegate: ClickUpdate {
                    width: clickUpdates.width
                    command: model.command
                    packageName: app_id
                    revision: model.revision
                    downloadId: udm_download_id
                    clickToken: click_token
                    downloadUrl: download_url
                    downloadSha512: download_sha512
                    version: remote_version
                    size: model.size
                    name: title
                    iconUrl: icon_url
                    changelog: model.changelog
                }
            }
        }

        ListItems.ThinDivider {
            id: noauthDivider
            visible: false
            anchors {
                left: parent.left
                right: parent.left
                top: systemUpdate.visible ? systemUpdate.bottom : glob.bottom
            }
        }

        NotAuthenticatedNotification {
            id: notauthNotification
            objectName: "updatesNoAuthNotif"
            visible: false
            anchors {
                top: {
                    if (noauthDivider.visible)
                        return noauthDivider.bottom
                    else if (systemUpdate.visible)
                        return systemUpdate.bottom
                    else
                        return glob.bottom
                }
                topMargin: units.gu(5)
            }
            onRequestAuthentication: updates.requestAuthentication()
        }
    }

    Rectangle {
        id: overlay
        objectName: "updatesFullscreenMessage"
        visible: false
        color: "white"
        anchors.fill: parent

        Label {
            id: placeholder
            objectName: "updatesFullscreenMessageText"
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: {
                var s = updates.managerStatus;
                if (!updates.online) {
                    return i18n.tr("Connect to the Internet to check for updates.");
                } else if (s === UpdateManager.Idle && UpdateManager.updatesCount === 0) {
                    return i18n.tr("Software is up to date");
                } else if (s === UpdateManager.ServerError || s === UpdateManager.NetworkError) {
                    return i18n.tr("The update server is not responding. Try again later.");
                }
                return "";
            }
        }
    }
}
