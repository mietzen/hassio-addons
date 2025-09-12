# Home Assistant Add-on: Visual Studio Code Remote SSH Server

Enables you to connect to Home Assistant via Visual Studio Code Remote SSH.

## Configuration Options

### Option: `ssh_keys`

List of ssh keys that are allowed to connect

### Option: `persist_ssh_host_keys` (Optional)

If set to `true`, the add-on will store the SSH host keys in a persistent location (`/data`). This prevents the host key from changing after an add-on update or restart, avoiding "REMOTE HOST IDENTIFICATION HAS CHANGED" errors on the client. Defaults to `false`.