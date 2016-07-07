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

#ifndef CLICK_TOKEN_DOWNLOADER_IMPL_H
#define CLICK_TOKEN_DOWNLOADER_IMPL_H

#include "tokendownloader.h"
#include "client.h"

namespace UpdatePlugin
{
namespace Click
{
class TokenDownloaderImpl : public TokenDownloader
{
    Q_OBJECT
public:
    explicit TokenDownloaderImpl(Client *client,
                                 QSharedPointer<Update> update,
                                 QObject *parent = 0);
    virtual ~TokenDownloaderImpl();
    virtual void download() override;
    virtual void setAuthToken(const UbuntuOne::Token &authToken) override;

public slots:
    virtual void cancel() override;

protected slots:
    void handleSuccess(const QString &token);
    void handleFailure();

private:
    void init();
    Client *m_client;
};
} // Click
} // UpdatePlugin

#endif // CLICK_TOKEN_DOWNLOADER_IMPL_H
