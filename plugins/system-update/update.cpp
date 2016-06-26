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

#include "update.h"

#include <apt-pkg/debversion.h>

namespace UpdatePlugin
{
Update::Update(QObject *parent)
    : QObject(parent)
    , m_anonDownloadUrl("")
    , m_binaryFilesize(0)
    , m_changelog("")
    , m_channel("")
    , m_content("")
    , m_department()
    , m_downloadSha512("")
    , m_downloadUrl("")
    , m_iconUrl("")
    , m_name("")
    , m_origin("")
    , m_packageName("")
    , m_revision(0)
    , m_status("")
    , m_title("")
    , m_localVersion("")
    , m_remoteVersion("")
    , m_token("")
    , m_command("")
    , m_automatic(false)
{
}

Update::~Update()
{
}

QString Update::anonDownloadUrl() const
{
    return m_anonDownloadUrl;
}

uint Update::binaryFilesize() const
{
    return m_binaryFilesize;
}

QString Update::changelog() const
{
    return m_changelog;
}

QString Update::channel() const
{
    return m_channel;
}

QString Update::content() const
{
    return m_content;
}

QStringList Update::department() const
{
    return m_department;
}

QString Update::downloadSha512() const
{
    return m_downloadSha512;
}

QString Update::downloadUrl() const
{
    return m_downloadUrl;
}

QString Update::iconUrl() const
{
    return m_iconUrl;
}

QString Update::name() const
{
    return m_name;
}

QString Update::origin() const
{
    return m_origin;
}

QString Update::packageName() const
{
    return m_packageName;
}

int Update::revision() const
{
    return m_revision;
}

QString Update::status() const
{
    return m_status;
}

QString Update::title() const
{
    return m_title;
}

QString Update::remoteVersion() const
{
    return m_remoteVersion;
}

QString Update::localVersion() const
{
    return m_localVersion;
}

QString Update::token() const
{
    return m_token;
}

QStringList Update::command() const
{
    return m_command;
}

void Update::setAnonDownloadUrl(const QString &anonDownloadUrl)
{
    if (m_anonDownloadUrl != anonDownloadUrl) {
        m_anonDownloadUrl = anonDownloadUrl;
        Q_EMIT anonDownloadUrlChanged();
    }
}

void Update::setBinaryFilesize(const uint &binaryFilesize)
{
    if (m_binaryFilesize != binaryFilesize) {
        m_binaryFilesize = binaryFilesize;
        Q_EMIT binaryFilesizeChanged();
    }
}

void Update::setChangelog(const QString &changelog)
{
    if (m_changelog != changelog) {
        m_changelog = changelog;
        Q_EMIT changelogChanged();
    }
}

void Update::setChannel(const QString &channel)
{
    if (m_channel != channel) {
        m_channel = channel;
        Q_EMIT channelChanged();
    }
}

void Update::setContent(const QString &content)
{
    if (m_content != content) {
        m_content = content;
        Q_EMIT contentChanged();
    }
}

void Update::setDepartment(const QStringList &department)
{
    if (m_department != department) {
        m_department = department;
        Q_EMIT departmentChanged();
    }
}

void Update::setDownloadSha512(const QString &downloadSha512)
{
    if (m_downloadSha512 != downloadSha512) {
        m_downloadSha512 = downloadSha512;
        Q_EMIT downloadSha512Changed();
    }
}

void Update::setDownloadUrl(const QString &downloadUrl)
{
    if (m_downloadUrl != downloadUrl) {
        m_downloadUrl = downloadUrl;
        Q_EMIT downloadUrlChanged();
    }
}

void Update::setIconUrl(const QString &iconUrl)
{
    if (m_iconUrl != iconUrl) {
        m_iconUrl = iconUrl;
        Q_EMIT iconUrlChanged();
    }
}

void Update::setName(const QString &name)
{
    if (m_name != name) {
        m_name = name;
        Q_EMIT nameChanged();
    }
}

void Update::setOrigin(const QString &origin)
{
    if (m_origin != origin) {
        m_origin = origin;
        Q_EMIT originChanged();
    }
}

void Update::setPackageName(const QString &packageName)
{
    if (m_packageName != packageName) {
        m_packageName = packageName;
        Q_EMIT packageNameChanged();
    }
}

void Update::setRevision(const int &revision)
{
    if (m_revision != revision) {
        m_revision = revision;
        Q_EMIT revisionChanged();
    }
}

void Update::setStatus(const QString &status)
{
    if (m_status != status) {
        m_status = status;
        Q_EMIT statusChanged();
    }
}

void Update::setTitle(const QString &title)
{
    if (m_title != title) {
        m_title = title;
        Q_EMIT titleChanged();
    }
}

void Update::setRemoteVersion(const QString &version)
{
    if (m_remoteVersion != version) {
        m_remoteVersion = version;
        Q_EMIT remoteVersionChanged();
    }
}

void Update::setLocalVersion(const QString &version)
{
    if (m_localVersion != version) {
        m_localVersion = version;
        Q_EMIT localVersionChanged();
    }
}

void Update::setToken(const QString &token)
{
    if (m_token != token) {
        m_token = token;
        Q_EMIT tokenChanged();
    }
}

void Update::setCommand(const QStringList &command)
{
    if (m_command != command) {
        m_command = command;
        Q_EMIT commandChanged();
    }
}

bool Update::automatic() const
{
    return m_automatic;
}

void Update::setAutomatic(const bool automatic)
{
    if (m_automatic != automatic) {
        m_automatic = automatic;
        Q_EMIT automaticChanged();
    }
}

bool Update::isUpdateRequired()
{
    int result = debVS.CmpVersion(m_localVersion.toUtf8().data(),
            m_remoteVersion.toUtf8().data());
    return result < 0;
}

// void Update::tokenRequestSslFailed(const QList<QSslError> &errors)
// {

// }

// void Update::tokenRequestFailed(const QNetworkReply::NetworkError &code)
// {

// }

// void Update::tokenRequestSucceeded(const QNetworkReply* reply)
// {

// }

// signals:
//     void signedDownloadUrlChanged();
//     void tokenChanged();

//     void anonDownloadUrlChanged();
//     void binaryFilesizeChanged();
//     void changelogChanged();
//     void channelChanged();
//     void contentChanged();
//     void departmentChanged();
//     void downloadSha512Changed();
//     void downloadUrlChanged();
//     void iconUrlChanged();
//     void nameChanged();
//     void originChanged();
//     void packageNameChanged();
//     void revisionChanged();
//     void sequenceChanged();
//     void statusChanged();
//     void titleChanged();
//     void remoteVersionChanged();
//     void localVersionChanged();

//     void downloadUrlSignFailure();

} // UpdatePlugin
