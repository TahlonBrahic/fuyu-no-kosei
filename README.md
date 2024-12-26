<div>
  <img alt="NixOS Logo" src="https://github.com/NixOS/nixos-artwork/blob/master/logo/nix-snowflake-colours.svg" width="120px"/>
  <h1>❖ Winter Composition ❖</h1>
  <img alt="Static Badge" src="https://img.shields.io/badge/%E5%86%AC%E3%81%AE%E6%A7%8B%E6%88%90-a5e8e9">
  <img src="https://img.shields.io/github/last-commit/TahlonBrahic/fuyu-no-kosei/?style=for-the-badge&labelColor=1B2330&color=23a5e8e9" alt="GitHub last commit"/>
  <img src="https://img.shields.io/github/languages/code-size/TahlonBrahic/fuyu-no-kosei?style=for-the-badge&logoSize=auto&label=REPO%20SIZE&color=%23a5e8e9" alt="GitHub repo size"/>
  <a href="https://nixos.org" target="_blank">
    <img src="https://img.shields.io/badge/NixOS-stable-blue.svg?style=for-the-badge&labelColor=1B2330&logo=NixOS&logoColor=white&color=ef65ea" alt="NixOS Stable"/>
  </a>
</div>

This repository contains a modular NixOS configuration designed to support multiple machines with profile support distributed across those machines.

## Directory Structure

- **`docs`**: Learn about the flake's API.
- **`checks`**: Integrates Nix defined checks and formatters.
- **`flake.nix`**: The main entry point for the NixOS configurations.
- **`installer`**: Extracts and builds custom ISOs' from the modules.
- **`lib`**: Custom library of Nix functions.
- **`modules`**: Contains reusable modules for both nixos and home-manager.
- **`templates`**: Pre-built to quickly start using this flake.
- **`overlays`**: Extensions of nixpkgs.
- **`LICENSE`**: A standard MIT License for ease of distribution and modification.
- **`README.md`**: This file, which provides an overview of the repository.

## Getting Started

1. Choose your template:

```bash
$ nix --extra-experimental-features [ "nix-command flakes" ] flake init -t github:TahlonBrahic/fuyu-no-kosei 
```

2. Define your own configuration in outputs or choose a pre-defined configuration:

Read through all files under the outputs directory and 
follow the comments to customize it to your liking.

3. Rebuild your system:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

Replace `hostname` with the appropriate hostname configured in ./outputs/architecture/system/hostname/hostname.nix

## References

The following websites and/or content creators were the most influential in the help of the developement of this NixOS repository and my understanding of both NixOS and its language:

### Websites:

[nix.dev](https://nix.dev/tutorials/nix-language)

### Repositories

[librephoenix](https://github.com/librephoenix/nixos-config)
[Misterio77](https://github.com/Misterio77/nix-config)
[ryan4yin](https://github.com/ryan4yin/nix-config)
[EmergentMind](https://github.com/EmergentMind/nix-config)
