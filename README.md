# dotfiles_nix

Personal NixOS + Home Manager configuration — declarative, modular, multi-machine.

## Quick Start

### NixOS (mainPC / t580)

```bash
# Build and switch
sudo nixos-rebuild switch --flake '.#mainPC'
sudo nixos-rebuild switch --flake '.#t580'

# Or use the task runner
task mainpc:switch
task t580:switch
```

### Standalone Home Manager (Ubuntu / WSL)

Use these on any non‑NixOS Linux system that has Nix installed with flakes enabled.

```bash
# First time: install Home Manager and apply configuration
nix run nixpkgs#home-manager -- switch --flake '.#ubuntu'

# On WSL
nix run nixpkgs#home-manager -- switch --flake '.#wsl'

# Subsequent updates
home-manager switch --flake '.#ubuntu'
```

The standalone configurations include CLI tools, dev toolchains, and system utilities — but no GUI applications. If you need GUI apps on a standalone system, edit `modules/home/standalone.nix` and add `../../home/apps/default.nix` to the `baseModules` list.

### Prerequisites

- **Nix** with [flakes enabled](https://nixos.wiki/wiki/Flakes#Enable_flakes)
- On NixOS: add `nix.settings.experimental-features = ["nix-command" "flakes"];` to your configuration
- On other Linux: add `experimental-features = nix-command flakes` to `~/.config/nix/nix.conf`

## Repository Structure

```
dotfiles_nix/
├── flake.nix              # Entry point — flake inputs and outputs
├── taskfile.yml           # Task runner (task mainpc:switch, task nix:check, …)
│
├── modules/               # flake‑parts modules (auto‑discovered by import‑tree)
│   ├── features/          # Reusable NixOS modules: KDE, GNOME, Niri, NVIDIA, gaming…
│   ├── home/              # Home Manager bridge + flake integration
│   │   ├── default.nix    # NixOS HM bridge (useGlobalPkgs, extraSpecialArgs, …)
│   │   ├── default-hm-imports.nix  # Shared HM module import list (single source of truth)
│   │   ├── modules.nix    # Exposes flake.homeModules (common, cli, dev, apps, system)
│   │   └── standalone.nix # flake.homeConfigurations for Ubuntu and WSL
│   └── hosts/             # Per‑machine definitions
│       ├── mainPC/        # Desktop workstation (NVIDIA GPU, KDE, gaming)
│       └── t580/          # ThinkPad T580 laptop (Intel GPU, KDE)
│
└── home/                  # Home Manager modules (NOT flake‑parts modules)
    ├── common.nix         # Base: stateVersion, git, ripgrep, bat, jq, nixfmt…
    ├── cli/               # Terminal tools: zsh, starship, neovim, helix, yazi…
    ├── dev/               # Dev toolchains: Go, Python, Node, Kubernetes, direnv…
    ├── apps/              # GUI apps: Ghostty, Discord, Obsidian, Zed, Telegram…
    └── system/            # Session vars, network tools, misc utilities
```

## How It Works

### Per‑host module selection

All NixOS hosts share a canonical Home Manager module list defined in `modules/home/default-hm-imports.nix`. Each host's `configuration.nix` imports `self.nixosModules.defaultHomeManager` to get the shared baseline. Per-host overrides (extra packages, session variables) live in `modules/hosts/<host>/home-manager.nix`.

To customise per machine, edit `modules/home/default-hm-imports.nix` to change the shared list, or add/remove packages in the host's `home-manager.nix`.

### Adding a new package

| Type | Where to put it |
|---|---|
| CLI tool (all hosts) | `home/cli/default.nix` → add to `home.packages` |
| Dev tool | `home/dev/default.nix` → add to `home.packages` |
| GUI app (NixOS only) | Create `home/apps/<name>/default.nix`, add `./<name>` to `home/apps/default.nix` |
| System service / kernel module | `modules/features/<name>.nix` (new NixOS module) |

### Adding a new machine

1. Create `modules/hosts/<name>/` with `configuration.nix`, `hardware-configuration.nix`, `home-manager.nix`, and `taskfile.yml`
2. Add an `includes` entry in `taskfile.yml`

## Secrets Management (sops-nix)

API keys and tokens are managed with [sops-nix](https://github.com/Mic92/sops-nix). Secrets are encrypted in the repo and decrypted at build time using your **age** key.

- **Encrypted file**: `secrets/secrets.yaml`
- **Configuration**: `.sops.yaml` (which keys can encrypt), `home/system/sops.nix` (HM module)
- **Decrypted at**: `~/.config/sops-nix/secrets/<key>`

```bash
sops secrets/secrets.yaml    # Edit secrets
sops -d secrets/secrets.yaml # View decrypted
task mainpc:switch            # Rebuild with new secrets
```

sops is **opt-in per host** — only hosts that import `self.homeModules.sops` in their `home-manager.nix` get secrets. Currently enabled on `mainPC`.

Full reference: **[docs/sops-nix.md](docs/sops-nix.md)**

## Common Tasks

```bash
task --list              # List all available tasks
task nix:check           # Evaluate the flake for errors
task nix:format          # Format all .nix files with alejandra
task nix:update          # Update all flake inputs
task nix:gc              # Remove old system generations
```

## Updating Standalone (Ubuntu/WSL)

```bash
# Pull latest changes, then:
nix run nixpkgs#home-manager -- switch --flake '.#ubuntu'

# Or if home-manager is already in PATH:
home-manager switch --flake '.#ubuntu'
```

The standalone config lives in `modules/home/standalone.nix`. It imports `home/common.nix`, `home/cli/`, `home/dev/`, and `home/system/` — but NOT `home/apps/` (GUI apps are typically NixOS‑only). Edit `baseModules` there if you want different module sets for Ubuntu vs WSL.
