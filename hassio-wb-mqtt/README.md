# Hass.io Add-on: HASSIO-WB-MQTT

This add-on provides a way to integrate and configure [Wirenboard][wirenboard-site] devices using [wb-mqtt-serial] deamon. Also can be used as Modbus to MQTT bridge.

## About

The addon provides the following features:
 1. [wb-mqtt-serial] service that acts as a bridge between [Wirenboard][wirenboard-site] devices (use Modbus protocol) and  [Home Assistant][home-assistant] (uses MQTT protocol).
 1. Web interface that allows to edit the [wb-mqtt-serial] config file.
 

Although [wb-mqtt-serial] was designed to work with [Wirenboard][wirenboard-site] devices based on their template system, you can use it with any Modbus device by configuring its channels right in the config file. 

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Hass.io add-on.

1. [Add my Hass.io add-ons repository][repository] to your Hass.io instance.
1. Install the "hassio-wb-mqtt" add-on.
1. Start the "hassio-wb-mqtt" add-on.
1. Check the logs of the "hassio-wb-mqtt" add-on to see if everything went well.

Please read the rest of this document further instructions.

## Configuration

On the first run, this add-on creates the default configuration file
for you. You can modify the configuration using the web interface right from the addon. For documentation on configuring, please refer
to the [wb-mqtt-serial] repository. Also please check out their [Config Sample][wb-mqtt-serial-sample] and [Existing Templates][wb-mqtt-serial-templates] to get more details.
The add-on has a configuration possibilities as well.

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```json
{
    "root_path": "/",
    "path_to_config_file": "/data/wb-mqtt-serial.conf",
    "path_to_history_folder": "/data/history",
    "path_to_config_schema": "/app/wb-mqtt/wb-mqtt-serial.schema.json",
    "mqtt_host": "core-mosquitto",
    "mqtt_port": "1883",
    "mqtt_user": "your_mqtt_user",
    "mqtt_password": "your_mqtt_password"
}
```

### Option: `root_path`

The `root_path` option controls the path to root folder for the script. You do not need to change it for hassio installation.

### Option: `path_to_config_file`

The path to the the configuration file that is used by [wb-mqtt-serial] daemon.

### Option: `path_to_history_folder`

Each time when you save changes for the configuration file, the previous version is saved to the history folder. Using this parameter, you can controls the path to this folder.

### Option: `path_to_config_schema`

This parameter is not used fully yet, but it will be used to validate the configuration file against its schema.

### Option: `mqtt_host`

Hostname of your MQTT broker. *core-mosquitto* or *192.168.10.1* for example.

### Option: `mqtt_port`

Port that should be used to connect to the mosquitto broker.

### Options: `mqtt_user` and `mqtt_password`

Credentials to your MQTT broker.

## Known issues and limitations

- For now can use only **/dev/ttyUSB0** port to work with Modbus adapter.
- You need to restart the addon manually after you change the configuration.
- Sometimes when you edit the configuration file using the web interface, you will see some glitches or 'undo' operations after you edit the file.

## Real-world example

[WBIO-DO-R10A-8] is connected to [WB-MIO], [WB-MIO] is connected to a Raspberry PI  3 through [Cheap USB to RS485 converter][USB to RS485] and UTP-5. The converter is mounted under **/dev/ttyUSB0** port.
Raspberry PI has Hass.io with **hassio-wb-mqtt** and mosquitto addons running.

### The [wb-mqtt-serial] configuration is the following:
```json
{
    "debug": true,
    "ports": [
        {
            "path": "/dev/ttyUSB0",
            "baud_rate": 9600,
            "parity": "N",
            "data_bits": 8,
            "stop_bits": 2,
            "poll_interval": 100,
            "enabled": true,
            "devices": [
                {
                    "device_type": "WBIO-DO-R10A-8",
                    "name": "WBIO-DO-R10A-8",
                    "enabled": true,
                    "slave_id": "31:1"
                }
            ]
        }
    ]
}
```
**Note**: _slave_id value is combined, because [WBIO-DO-R10A-8] is the first connected device for [WB-MIO] with address '31', so '31' + 'the first' becomes '31:1'. In case of an ordinary device, an address could be '0x12', '12' etc._

### The [Home Assistant][home-assistant] configuration is the following:

```yaml
#switches
- platform: mqtt
  name: "Kitchen Light"
  state_topic: "/devices/wb-mio-gpio_31:1/controls/K1"
  command_topic: "/devices/wb-mio-gpio_31:1/controls/K1/on"
  payload_on: "1"
  payload_off: "0"
```

So [wb-mqtt-serial] polls the registers every 100ms (`poll_interval` setting) and publish a new MQTT message to topic `/devices/wb-mio-gpio_31:1/controls/K1` once they get a new value. And vice-versa, once you change the state of the switch, the daemon reacts to the `/devices/wb-mio-gpio_31:1/controls/K1/on` topic and writes the new value to the modbus register.

## Credits

A big shout out to the following people, without them this add-on was not
possible:

- The team & community of [Home Assistant][home-assistant] for developing such
  an excellent home automation toolkit
- [Franck Nijhof][frenck] for inspiration
- [Wirenboard][wirenboard-site] team for great devices

Thank you all!



[frenck]: https://github.com/frenck
[home-assistant]: https://home-assistant.io
[license-shield]: https://img.shields.io/github/license/hassio-addons/addon-homebridge.svg
[repository]: https://github.com/egor-romanko/hassio-addons
[semver]: http://semver.org/spec/v2.0.0.htm
[wirenboard-site]: https://wirenboard.com/
[wb-mqtt-serial]: https://github.com/contactless/wb-mqtt-serial
[wb-mqtt-serial-sample]: https://github.com/contactless/wb-mqtt-serial/blob/master/config.sample.json
[wb-mqtt-serial-templates]: https://github.com/contactless/wb-mqtt-serial/tree/master/wb-mqtt-serial-templates
[WBIO-DO-R10A-8]: https://wirenboard.com/en/product/WBIO-DO-R10A-8/
[WB-MIO]: https://wirenboard.com/en/product/WB-MIO/
[USB to RS485]: https://www.aliexpress.com/item/32428596578.html