#!/bin/bash
set -e

local_scan=$(cat /data/options.json | jq -r '.local_scan // empty')
options=$(cat /data/options.json | jq -r 'if .options then [.options[] | "-o "+.name+"="+.value ] | join(" ") else "" end')
config="/var/lib/mopidy/.config/mopidy/mopidy.conf"

export local_scan
export options
export config

mkdir -p /data/icecast2/logs
touch /data/icecast2/logs/error.log
touch /data/icecast2/logs/access.log
chmod -R a+rwX /data/
printenv

/usr/bin/supervisord -c /etc/supervisord.conf