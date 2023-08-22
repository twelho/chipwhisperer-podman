# chipwhisperer-podman

A container image with ChipWhisperer and JupyterHub optimized for user-mode (non-root) Podman. USB-attached ChipWhisperer hardware is supported out of the box after installing the [udev rule](90-newae.rules).

## Usage

```sh
sudo groupadd -r chipwhisperer
sudo usermod -aG chipwhisperer "$(whoami)"
sudo cp 90-newae.rules /etc/udev/rules.d/
./build.sh && ./run.sh [workdir]
```

## Authors

- Dennis Marttinen ([@twelho](https://github.com/twelho))

## License

[MIT](https://opensource.org/license/mit/) ([LICENSE](LICENSE))
