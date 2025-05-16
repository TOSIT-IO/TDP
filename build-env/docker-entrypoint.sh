#!/bin/bash
set -eo pipefail

if [[ -n "$BUILDER_UID" ]] && [[ -n "$BUILDER_GID" ]]; then
    # Create group and user only if they don't exist
    [[ ! $(getent group "$BUILDER_GID") ]] && groupadd --gid "$BUILDER_GID" --system builder
    if [[ ! $(getent passwd "$BUILDER_UID") ]]; then
        useradd --uid "$BUILDER_UID" --system --gid "$BUILDER_GID" --home-dir /home/builder builder
        # Avoid useradd warning if home dir already exists by making home dir ourselves.
        # Home dir can exists if mounted via "docker run -v ...:/home/builder/...".
        mkdir -p /home/builder
        chown builder:builder /home/builder
        gosu builder cp -r /etc/skel/. /home/builder
    fi
    # Avoid changing dir if a work dir is specified
    [[ "$PWD" == "/root" ]] && cd /home/builder
    if [[ -z "$@" ]]; then
        exec gosu $BUILDER_UID /bin/bash
    else
        exec gosu $BUILDER_UID "$@"
    fi
fi

exec "$@"
