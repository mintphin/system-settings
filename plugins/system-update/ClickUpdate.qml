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
    property string packageName
    property int revision
    property var downloadId: null
    property var download: null
    property string command
    property string clickToken
    property string downloadUrl
    property string downloadSha512
    property string headers

    onDownloadIdChanged: {
        if (downloadId === null) {
            var metadata = {
                "command": update.command.split(" "),
                "title": update.name,
                "showInIndicator": false,
                // "downloadUrl": download_url,
            };
            var hdrs = {
                "X-Click-Token": update.clickToken
            };
            var metadataObj = mdt.createObject(update, metadata);
            var singleDownloadObj = sdl.createObject(update, {
                "url": update.downloadUrl,
                "autoStart": false,
                "hash": update.downloadSha512,
                "algorithm": "sha512",
                "headers": hdrs,
                "metadata": metadataObj
            });
            singleDownloadObj.download(update.downloadUrl);
            download = singleDownloadObj;
        }
    }

    updateState: UpdateManager.StateAvailable
    kind: UpdateManager.KindApp

    onRetry: UpdateManager.retryClickPackage(update.packageName, update.revision)
    onPause: download.pause()
    onResume: download.resume()
    onInstall: download.download(update.downloadUrl)
    onDownload: download.download(update.downloadUrl)

    Connections {
        target: download
        onErrorChanged: {
            update.setError(
                i18n.tr("Download failed"), download.errorMessage
            )
            updateState = UpdateManager.StateFailed;
        }
        onFinished: {
            updateState = UpdateManager.StateInstalled;
        }
        onProgressChanged: {
            update.progress = download.progress;
            updateState = UpdateManager.StateDownloading;
        }
        onPaused: {
            updateState = UpdateManager.StateDownloadPaused;
        }
        onResumed: {
            updateState = UpdateManager.StateDownloading;
        }
        onStarted: {
            updateState = UpdateManager.StateQueuedForDownload;
        }
        onProcessing: {
            updateState = UpdateManager.StateInstalling;
        }
    }

    Component { id: sdl; SingleDownload { property string url; } }
    Component { id: mdt; Metadata {} }

    // Makes the progress bar indeterminate when waiting
    Binding {
        target: update
        property: "progress"
        value: -1
        when: {
            var queued = updateState === UpdateManager.StateQueuedForDownload;
            var installing = updateState === UpdateManager.StateInstalling;
            return queued || installing;
        }
    }
}
