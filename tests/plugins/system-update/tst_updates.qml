/*
 * This file is part of system-settings
 *
 * Copyright (C) 2016 Canonical Ltd.
 *
 * Contact: Jonas G. Drange <jonas.drange@canonical.com>
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
 * Here we test the Updates component, which constitutes the main Updates
 * screen as seen in [1].
 *
 * [1] https://wiki.ubuntu.com/SoftwareUpdates#Phone
 */
import QtQuick 2.4
import QtTest 1.0
import Ubuntu.Components 1.3
import Ubuntu.SystemSettings.Update 1.0
import Ubuntu.Test 0.1

import Source 1.0

Item {
    id: testRoot
    width: units.gu(50)
    height: units.gu(90)

    Component {
        id: updates

        Updates {
            anchors.fill: parent
        }
    }

    ListModel {
        id: mockClickUpdatesModel
        dynamicRoles: true
    }

    UbuntuTestCase {
        name: "UpdatesTest"
        when: windowShown

        property var cUpdts: null

        function init() {
            cUpdts = updates.createObject(testRoot, {
                systemImageBackend: UpdateManager.systemImageBackend
            });
        }

        function cleanup () {
            cUpdts.destroy();
            cUpdts = null;
            mockClickUpdatesModel.clear();
        }

        function getGlobal() {
            return findChild(cUpdts, "updatesGlobal");
        }

        function getSystemUpdate() {
            return findChild(cUpdts, "updatesSystemUpdate");
        }

        function getClickUpdates() {
            return findChild(cUpdts, "updatesClickUpdates");
        }

        function getNoAuthNotif() {
            return findChild(cUpdts, "updatesNoAuthNotif");
        }

        function getFullscreenMessage() {
            return findChild(cUpdts, "updatesFullscreenMessage");
        }

        function getFullscreenMessageText() {
            return findChild(cUpdts, "updatesFullscreenMessageText");
        }

        function generateClickUpdates(count) {
            for (var i = 0; i < count; i++) {
                mockClickUpdatesModel.append({
                    "app_id": "app" + i,
                    "revision": i,
                    "command": "click test --foo",
                    "udm_download_id": null,
                    "click_token": "as54d",
                    "download_url": "http://example.org/c.click",
                    "download_sha512": "6a5sd4a6s",
                    "remote_version": i,
                    "size": 500,
                    "title": "Click Update #" + i,
                    "icon_url": "",
                    "changelog": "Changes"
                });
            }
        }

        function test_visibility_data() {
            var connectText = i18n.tr("Connect to the Internet to check for updates.");
            var uptodateText = i18n.tr("Software is up to date");
            var notrespondingText = i18n.tr("The update server is not responding. Try again later.");
            return [
                {
                    tag: "check in progress (offline, no auth)",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.CheckingAllUpdates,
                    online: false,
                    authenticated: false,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: connectText }
                },
                {
                    tag: "check in progress (offline, auth)",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.CheckingAllUpdates,
                    online: false,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: connectText }
                },
                {
                    tag: "check in progress (online, no auth)",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.CheckingAllUpdates,
                    online: true,
                    authenticated: false,
                    // Here be target values:
                    global: { hidden: false },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: true },
                    fullscreenmessage: { visible: false }
                },
                {
                    tag: "check in progress (online, auth)",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.CheckingAllUpdates,
                    online: true,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: false },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: false }
                },
                {
                    tag: "no updates (offline, no auth)",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.Idle,
                    online: false,
                    authenticated: false,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: connectText }
                },
                {
                    tag: "no updates (offline, auth)",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.Idle,
                    online: false,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: connectText }
                },
                {
                    tag: "no updates (online, auth)",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.Idle,
                    online: true,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: uptodateText }
                },
                {
                    tag: "no updates (online, no auth)",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.Idle,
                    online: true,
                    authenticated: false,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: true },
                    fullscreenmessage: { visible: false }
                },
                {
                    tag: "offline (auth)",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.Idle,
                    online: false,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: connectText }
                },,
                {
                    tag: "offline (no auth)",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.Idle,
                    online: false,
                    authenticated: false,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: connectText }
                },
                {
                    tag: "server error",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.ServerError,
                    online: true,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: notrespondingText }
                },
                {
                    tag: "network error",
                    haveSystemUpdate: false,
                    updatesCount: 0,
                    managerStatus: UpdateManager.NetworkError,
                    online: true,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: notrespondingText }
                },
                {
                    tag: "system update (online, no auth)",
                    haveSystemUpdate: true,
                    updatesCount: 1,
                    managerStatus: UpdateManager.Idle,
                    online: true,
                    authenticated: false,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: true },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: true },
                    fullscreenmessage: { visible: false }
                },
                {
                    tag: "system update (online, auth)",
                    haveSystemUpdate: true,
                    updatesCount: 1,
                    managerStatus: UpdateManager.Idle,
                    online: true,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: true },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: false }
                },
                {
                    tag: "system update (offline, auth)",
                    haveSystemUpdate: true,
                    updatesCount: 1,
                    managerStatus: UpdateManager.Idle,
                    online: false,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: connectText }
                },
                {
                    tag: "system update (network error)",
                    haveSystemUpdate: true,
                    updatesCount: 1,
                    managerStatus: UpdateManager.NetworkError,
                    online: true,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: notrespondingText }
                },
                {
                    tag: "system update (server error)",
                    haveSystemUpdate: true,
                    updatesCount: 1,
                    managerStatus: UpdateManager.ServerError,
                    online: true,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: notrespondingText }
                },
                {
                    tag: "click updates (offline, no system update)",
                    haveSystemUpdate: false,
                    updatesCount: 2,
                    managerStatus: UpdateManager.Idle,
                    online: false,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: true },
                    systemupdate: { visible: false },
                    clickupdates: { visible: false },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: true, text: connectText }
                },
                {
                    tag: "click updates (online, no system update)",
                    haveSystemUpdate: false,
                    updatesCount: 2,
                    managerStatus: UpdateManager.Idle,
                    online: true,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: false },
                    systemupdate: { visible: false },
                    clickupdates: { visible: true },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: false }
                },
                {
                    tag: "click updates (online, system update)",
                    haveSystemUpdate: true,
                    updatesCount: 3,
                    managerStatus: UpdateManager.Idle,
                    online: true,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: false },
                    systemupdate: { visible: true },
                    clickupdates: { visible: true },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: false }
                },
                {
                    tag: "many click updates (online, system update)",
                    haveSystemUpdate: true,
                    updatesCount: 50,
                    managerStatus: UpdateManager.Idle,
                    online: true,
                    authenticated: true,
                    // Here be target values:
                    global: { hidden: false },
                    systemupdate: { visible: true },
                    clickupdates: { visible: true },
                    noauthnotification: { visible: false },
                    fullscreenmessage: { visible: false }
                }
            ]
        }

        function test_visibility(data) {
            cUpdts.haveSystemUpdate = data.haveSystemUpdate;
            cUpdts.updatesCount = data.updatesCount;
            cUpdts.managerStatus = data.managerStatus;
            cUpdts.online = data.online;
            cUpdts.authenticated = data.authenticated;
            cUpdts.clickUpdatesModel = mockClickUpdatesModel;

            // If updatesCount is sufficient, create some dummy click updates.
            // We don't test the individual click updates here.
            if (data.updatesCount > 0) {
                var offset = data.haveSystemUpdate ? 1 : 0
                generateClickUpdates(data.updatesCount - offset);
            }

            compare(getGlobal().hidden, data.global.hidden, "global had wrong visibility");
            compare(getSystemUpdate().visible, data.systemupdate.visible, "system update had wrong visibility");
            compare(getClickUpdates().visible, data.clickupdates.visible, "click updates had wrong visibility");
            compare(getNoAuthNotif().visible, data.noauthnotification.visible, "no auth notification had wrong visibility");
            compare(getFullscreenMessage().visible, data.fullscreenmessage.visible, "fullscreen message had wrong visibility");
            if (data.fullscreenmessage.text) {
                compare(getFullscreenMessageText().text, data.fullscreenmessage.text, "fullscreen message had wrong text");
            }
        }
    }
}
