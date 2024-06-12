#!/bin/bash
set -eo pipefail

if [[ -n "$USER_UID" ]] && [[ -n "$USER_GID" ]]; then
    # Create group and user only if they don't exist
    [[ ! $(getent group builder) ]] && groupadd -r --gid "$USER_GID" builder
    if [[ ! $(getent passwd builder) ]]; then
        useradd --create-home --home-dir /home/builder --uid "$USER_UID" --gid "$USER_GID" --system --shell /bin/bash builder
        usermod -aG wheel builder
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
