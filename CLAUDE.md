# abdullah_nix — Project Reference

## What this is

A NixOS system configuration managed as a **flake**, structured using **flake-parts** and **import-tree**. It configures one machine (`mainPC`) with a full desktop environment and a Home Manager user environment for `ab_dullah`.

---

## Project Structure

```
abdullah_nix/
├── flake.nix                  # Entry point — wires inputs and delegates to modules/
├── taskfile.yml               # Task runner shortcuts
│
├── modules/                   # All flake-parts modules (auto-imported via import-tree)
│   ├── parts.nix              # Declares supported systems (x86_64-linux, etc.)
│   │
│   ├── features/              # Reusable nixosModules (desktop, theme, etc.)
│   │   ├── theme.nix          # Base16 color theme exposed on `self.theme` / `self.themeNoHash`
│   │   ├── wallpaper.png      # Wallpaper asset
│   │   ├── gaming.nix         # Steam / gaming packages
│   │   ├── nvidia.nix         # Nvidia drivers / CUDA
│   │   └── desktop/
│   │       ├── gnome/
│   │       │   └── default.nix   # GNOME desktop module
│   │       ├── kde/
│   │       │   └── default.nix   # KDE Plasma module (currently active)
│   │       └── niri/
│   │           ├── default.nix   # Niri wayland compositor module
│   │           ├── niri.nix.dep  # Niri wrapper-modules configuration (keybinds, layout, etc.)
│   │           ├── noctalia.nix  # Noctalia bar package definition
│   │           └── noctalia.json # Noctalia bar settings
│   │
│   ├── home/
│   │   └── default.nix        # nixosModule that wires Home Manager into NixOS
│   │
│   └── hosts/
│       └── mainPC/
│           ├── default.nix           # Declares `nixosConfigurations.mainPC`
│           ├── configuration.nix     # Main system config — imports modules, sets users, packages
│           └── hardware-configuration.nix  # Auto-generated hardware config
│
└── home_man/                  # Git submodule — Home Manager user configuration (not a flake module)
    ├── home.nix               # Standalone HM entry (non-NixOS)
    ├── common.nix             # Shared config imported by both home.nix and NixOS HM bridge
    │                          #   └── home.packages: CLI tools, dev deps, cross-platform packages
    └── programs/
        ├── zsh/               # Zsh + oh-my-zsh + plugins
        ├── starship/          # Starship prompt
        ├── zellij/            # Terminal multiplexer
        ├── neovim/            # NixVim-based Neovim config
        │   ├── default.nix
        │   ├── options.nix
        │   ├── keymappings.nix
        │   ├── autocommands.nix
        │   ├── completion.nix
        │   ├── extraConfigLua.lua
        │   └── plugins/       # One file per plugin
        ├── yazi/              # File manager
        ├── bottom.nix         # System monitor
        ├── eza.nix            # ls replacement
        ├── fastfetch.nix      # System info
        ├── fzf.nix            # Fuzzy finder
        ├── zoxide.nix         # Smarter cd
        └── system-specific/   # Platform-conditional config
            ├── default.nix    # Defines enableNativeLinux / enableGuiApps options
            └── linux/
                ├── default.nix       # Imports all linux-specific modules
                ├── ghostty/          # Ghostty terminal
                ├── obsidian/         # Obsidian note-taking (GUI)
                ├── telegram/         # Telegram desktop (GUI)
                ├── obs/              # OBS Studio (GUI)
                ├── microsoft-edge/   # Edge browser (GUI)
                ├── zed/              # Zed editor (GUI)
                ├── alacrity/         # Alacritty terminal (GUI)
                └── fonts/            # Font packages
```

---

## How it Works

### Entry Point — `flake.nix`

```nix
outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
```

`flake-parts` structures the flake as composable **parts** (modules for the flake itself, not NixOS). `import-tree` recursively discovers and merges every `.nix` file under `./modules/` — no manual import lists needed.

### The Dendritic Pattern

Every `.nix` file under `modules/` is a **flake-parts module** — a function that receives `{ self, inputs, ... }` and contributes to the flake outputs by adding keys to `flake.*` or `perSystem.*`. The tree of files is the structure; there is no single registry file.

```
import-tree ./modules
    │
    ├── parts.nix           → config.systems = [...]
    ├── features/theme.nix  → flake.theme, flake.themeNoHash
    ├── features/desktop/gnome/default.nix → flake.nixosModules.gnome
    ├── features/desktop/niri/default.nix  → flake.nixosModules.niri
    ├── features/desktop/niri/noctalia.nix → perSystem.packages.myNoctalia
    ├── modules/home/default.nix           → flake.nixosModules.homeManager
        └── modules/hosts/mainPC/
          ├── default.nix        → flake.nixosConfigurations.mainPC
          └── configuration.nix  → flake.nixosModules.mainPCConfiguration
```

Each node adds exactly what it owns. Cross-references are done via `self.nixosModules.*` (e.g. `configuration.nix` imports `self.nixosModules.gnome`).

**Adding a new desktop or feature** = drop a new `.nix` file anywhere under `modules/` that contributes a `flake.nixosModules.<name>`, then reference it by name in `configuration.nix`.

### Home Manager Integration

Home Manager runs as a **NixOS module** (not a standalone flake output). The bridge is `modules/home/default.nix`:

```nix
flake.nixosModules.homeManager = { pkgs, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useGlobalPkgs = true;       # uses system nixpkgs, no separate HM nixpkgs
    useUserPackages = true;     # installs HM packages into the user profile
    users.ab_dullah = import ../../home_man/common.nix;
  };
};
```

This module is then imported by `mainPCConfiguration`. The `home_man/` directory is a **git submodule** — it is plain Home Manager configuration, imported by the bridge above. It does **not** use the flake-parts / import-tree machinery. Instead, `common.nix` manually lists its program imports.

```
NixOS system build
    └── mainPCConfiguration
      ├── mainPCHardware   (hardware)
        ├── kde                 (or gnome / niri)
        ├── nvidia
        ├── gaming
        └── homeManager         ← injects home-manager module
              └── common.nix
                    └── programs/* (zsh, neovim, ghostty, ...)
                          └── system-specific/linux/* (GUI apps, fonts, ...)
```

---

## Key Conventions

| Convention | Details |
|---|---|
| Module naming | Derived from the `flake.nixosModules.<name>` key declared inside each file, **not** from the file path |
| Switching desktops | Change the import in `configuration.nix`: `self.nixosModules.kde` ↔ `self.nixosModules.gnome` ↔ `self.nixosModules.niri` |
| Theme access | `self.theme.base0X` (with `#`), `self.themeNoHash.base0X` (without) — used inside niri binds, colors, etc. |
| Adding a program | Create `home_man/programs/<name>.nix` (or `<name>/default.nix`), add it to the `imports` list in `common.nix` |
| Adding a feature | Create `modules/features/<name>.nix` exposing `flake.nixosModules.<name>`, import it in `configuration.nix` |
| Adding a GUI app | Create `home_man/programs/system-specific/linux/<name>/default.nix`, add it to `linux/default.nix` imports (see below) |
| System-level packages | Only put packages in `configuration.nix` (`environment.systemPackages` or `users.users.ab_dullah.packages`) if they need system-level integration. Everything else belongs in Home Manager |
| Docker | Enabled via `virtualisation.docker.enable = true` in `configuration.nix`; user added to `"docker"` extraGroup |

### Where to put a new package

```
Need system integration (services, kernel, PAM)?
  └── YES → modules/features/<name>.nix  (new nixosModule) or configuration.nix directly
  └── NO → Is it a GUI app only used on NixOS native Linux?
        └── YES → home_man/programs/system-specific/linux/<name>/default.nix
        └── NO  → home_man/common.nix  home.packages (CLI tools, cross-platform dev deps)
```

### GUI App Module Pattern

All GUI apps under `home_man/programs/system-specific/linux/` **must** follow this pattern (see `telegram/default.nix` as the reference):

```nix
{
  config,
  pkgs,
  lib,
  ...
}:

let
  has<Name> = builtins.hasAttr "<pkg-attr-name>" pkgs;
in
{
  config = {
    home.packages = lib.mkIf (config.programs.system-specific.enableGuiApps && has<Name>) [
      pkgs.<pkg-attr-name>
    ];

    warnings =
      lib.optional (config.programs.system-specific.enableGuiApps && !has<Name>)
        "programs.system-specific.<name>: <pkg-attr-name> is not available for this platform; skipping installation.";
  };
}
```

After creating the file, add `./\<name\>` to the `imports` list in `home_man/programs/system-specific/linux/default.nix`.

---

## Rebuild

```bash
sudo nixos-rebuild switch --flake '.?submodules=1#mainPC'
```

`.?submodules=1` means:
- `.` = use the current directory as the flake source.
- `?submodules=1` = include Git submodule contents in that source snapshot.

This repo imports Home Manager files from the `home_man` submodule, so omitting
`submodules=1` can cause evaluation errors for paths inside that submodule.
