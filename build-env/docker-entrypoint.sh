#!/bin/bash
set -eo pipefail

if [[ -n "$BUILDER_UID" ]] && [[ -n "$BUILDER_GID" ]]; then
    # Create group and user only if they don't exist
    [[ ! $(getent group builder) ]] && groupadd --gid "$BUILDER_GID" --system builder
    if [[ ! $(getent passwd builder) ]]; then
        useradd --uid "$BUILDER_UID" --system --gid builder --home-dir /home/builder builder
        # Avoid useradd warning if home dir already exists by making home dir ourselves.
        # Home dir can exists if mounted via "docker run -v ...:/home/builder/...".
        mkdir -p /home/builder
        chown builder:builder /home/builder
        gosu builder cp -r /etc/skel/. /home/builder
    fi
    # Avoid changing dir if a work dir is specified
    [[ "$PWD" == "/root" ]] && cd /home/builder
    if [[ -z "$@" ]]; then
        exec gosu builder /bin/bash
    else
        exec gosu builder "$@"
    fi
fi

exec "$@"
