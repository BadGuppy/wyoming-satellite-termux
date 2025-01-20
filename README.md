## Wyoming Satellite on Android

This project provides a simple way of setting up Wyoming Satellite and OpenWakeWord on Android.

### Prerequisites

- Install [Termux](https://github.com/termux/termux-app) (open source terminal emulator app)
- Install [Termux:API](https://github.com/termux/termux-api) (necessary to get mic access)
- (Optional) Install [Termux:Boot](https://github.com/termux/termux-boot) and [open it once + disable battery optimization for Termux & Termux:Boot](https://wiki.termux.com/wiki/Termux:Boot) (only required if you want wyoming-satellite to autostart when your device restarts)

### How to install

Open Termux and run:

``` Bash
(command -v wget > /dev/null 2>&1 || (echo "Installing wget..." && pkg install -y wget)) && bash <(wget -qO- https://raw.githubusercontent.com/T-vK/wyoming-satellite-termux/refs/heads/main/install.sh)

```

Or version 2 
```Bash
(command -v wget > /dev/null 2>&1 || (echo "Installing wget..." && pkg install -y wget)) && bash <(wget -qO- https://raw.githubusercontent.com/BadGuppy/wyoming-satellite-termux/refs/heads/main/install_ver2.sh)

```

### How to uninstall

Open Termux and run:

``` Bash
wget -qO- https://raw.githubusercontent.com/T-vK/wyoming-satellite-termux/refs/heads/main/uninstall.sh | bash
```
### Integrate into HomeAssistant

- Open Home Assistant go to Settings → Integrations → Add Integration → Wyoming Protocol
- It should ask you for a host and a port now. Enter the IP address of your Android device into the host-field (if unsure what you IP is, run `ifconfig` in Termux and check the output, it will most likely start with `192.`) and enter 10700 in the port-field.
