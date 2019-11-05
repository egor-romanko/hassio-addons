#!/usr/bin/env bashio
set -e

CONFIG_PATH=/data/options.json

ROOT_PATH="$(jq --raw-output '.root_path' $CONFIG_PATH)"
PATH_TO_CONFIG_FILE="$(jq --raw-output '.path_to_config_file' $CONFIG_PATH)"
PATH_TO_HISTORY_FOLDER="$(jq --raw-output '.path_to_history_folder' $CONFIG_PATH)"
PATH_TO_CONFIG_SCHEMA="$(jq --raw-output '.path_to_config_schema' $CONFIG_PATH)"

MQTT_HOST="$(jq --raw-output '.mqtt_host' $CONFIG_PATH)"
MQTT_PORT="$(jq --raw-output '.mqtt_port' $CONFIG_PATH)"
MQTT_USER="$(jq --raw-output '.mqtt_user' $CONFIG_PATH)"
MQTT_PASS="$(jq --raw-output '.mqtt_password' $CONFIG_PATH)"

export ROOT_PATH
export PATH_TO_CONFIG_FILE
export PATH_TO_HISTORY_FOLDER
export PATH_TO_CONFIG_SCHEMA

export MQTT_HOST
export MQTT_PORT
export MQTT_USER
export MQTT_PASS

printenv
cp -n /etc/wb-mqtt-serial.conf $PATH_TO_CONFIG_FILE
/usr/bin/supervisord -c /etc/supervisord.conf