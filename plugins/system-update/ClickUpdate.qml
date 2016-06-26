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
 */

import QtQuick 2.4
import Ubuntu.DownloadManager 1.2
import Ubuntu.SystemSettings.Update 1.0

Update {
    id: update
    // property string packageName
    // property int revision
    // property var command
    // property string downloadUrl
    // property string downloadSha512
    property string downloadId

    updateState: SystemUpdate.StateAvailable
    kind: SystemUpdate.KindApp

    // onRetry: retryUpdate(update.packageName)
    // onPause: download.pause()
    // onResume: download.resume()
    // onInstall:
    // onDownload: install()

    // signal retryUpdate(string name)

    onProgressChanged: {
        console.warn('onProgressChanged (qml)', progress);
    }

    states: [
        State {
            name: "failed"
            when: update.updateState === SystemUpdate.StateFailed
            StateChangeScript {
                script: update.setError(
                    i18n.tr("Update failed"),
                    i18n.tr("Something went wrong.")
                )
            }
        }
    ]

    // Makes the progress bar indeterminate when waiting
    Binding {
        target: update
        property: "progress"
        value: -1
        when: {
            var queued = updateState === SystemUpdate.StateQueuedForDownload;
            var installing = updateState === SystemUpdate.StateInstalling;
            return queued || installing;
        }
    }
}
