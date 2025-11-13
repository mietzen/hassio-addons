## **Status: Stable ✓**

# Home Assistant Add-on: Visual Studio Code Remote SSH Server

Enables you to connect to Home Assistant via Visual Studio Code Remote SSH.

## About

This add-on lets you use Visual Studio Code Remote SSH to edit your Home Assistant config.

## Installation

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** -> **Add-on Store** and add this URL as an additional repository: `https://github.com/mietzen/hassio-addons`
2. Refresh your browser.
3. Find the "Visual Studio Code Remote SSH Server" add-on and click the "INSTALL" button.
4. Configure the add-on and click on "START".

## Configuration

_Example configuration_:

Addon:
```yaml
ssh_keys: ["ssh-rsa yourverylongsshkey", "ssh-ed25519 andanotherone"]

# Optional:
persist_ssh_host_keys: true
```
_The `persist_ssh_host_keys` option, when `true`, also stores the SSH host keys in the persistent `/data` directory. This maintains a stable host identity, which is standard practice for SSH servers and prevents `known_hosts` errors on the client._

VS-Code ssh config ($HOME/.ssh/config):
```
Host home-assistant-vscode-ssh
   HostName <YOUR-HOME-ASSISTANT_IP>
   Port 22000
   User root
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_
