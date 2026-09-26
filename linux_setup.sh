#!/usr/bin/env sh

for package in fd-find npm pipx ripgrep; do
    # shellcheck disable=SC2016
    [ "$(dpkg-query -W -f='${db:Status-Status}' "$package" 2>/dev/null)" = installed ] || set -- "$@" "$package"
done

[ "$#" -eq 0 ] || sudo apt-get install -y "$@"
