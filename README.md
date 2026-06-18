# NixOS-Config

My personal configurations for all Nix-based systems (NixOS, Linux distributions with multi-user `nix` installed and `nix-darwin`).

## Nix-Darwin

Quick start:

1. Install `nix`:
   ```sh
   sh <(curl -L https://nixos.org/nix/install)
   ```
2. Install `homebrew`:
   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. Clone the repository:
   ```sh
   git clone https://github.com/Fr4nk1inCs/nixos-config.git ~/nixos-config
   ```
4. Build the system with `darwin-rebuild`:
   ```sh
   nix run --extra-experimental-features "nix-command flakes" nix-darwin -- switch --flake ~/nixos-config#fr4nk1in-macbook-air
   ```
5. Reboot the system and enjoy!
