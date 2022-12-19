![Diagram](doc/logo.png)

[![Rails](https://github.com/siegy22/synchronist/actions/workflows/rails.yml/badge.svg)](https://github.com/siegy22/synchronist/actions/workflows/rails.yml)

Synchronist is mirroring/sync tool which allows to send increments without having an active connection between them.

## Installation

Right now the only way to easily install synchronist would be using [docker](https://www.docker.com/). You can howevery deploy it from source if you want to. However instructions for that are not covered here.


Before you start, make sure you have docker (or podman) set up with [docker-compose](https://docs.docker.com/compose/). See https://docs.docker.com/get-docker/

### Choose location

We'll use `/opt/synchronist` in this example:

```
$ mkdir /opt/synchronist
$ cd /opt/synchronist
```

### Install script

Run the install script (or download it, for inspection and run it manually):

```
$ sh -c "$(curl https://raw.githubusercontent.com/siegy22/synchronist/main/setup-deployment.sh)"
```

You'll need to specify the folders that should be exposed to synchronist, use comma-separated values to have multiple values.

### Further configuration

The installation script prepared a `docker-compose.yml` in the current working directory. With the values pre-filled.
If you want to change those at any point, feel free! The script is only here to have a quick start.

You also might wanna put this behind a reverse proxy to support https, I recommend using [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy)

### Starting up!

```bash
$ systemctl start synchronist

# Or if you want to have it always running also after rebooting:
$ systemctl enable --now synchronist
```

### Acess the web interface

Visit your server name with your configured port in a web browser and configure the application!

## FAQ

### How?

- Using a so-called payload, the receiver generates the current state of the storage that it currently holds.
- The payload then needs to be sent to the sender (not covered by synchronist)
- The payload is parsed by the **sender** which will diff their current state with the payload
- The sender puts the increment into a configurable folder
- The increment then needs to be put into the receive folder on the receiver's end.
- The receiver will put all the received data into the storage folder.

