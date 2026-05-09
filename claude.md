# abdullah_nix — Project Reference

## What this is

A NixOS system configuration managed as a **flake**, structured using **flake-parts** and **import-tree**. It configures one machine (`myMachine`) with a full desktop environment and a Home Manager user environment for `ab_dullah`.

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
│   │   └── desktop/
│   │       ├── gnome/
│   │       │   └── default.nix   # GNOME desktop module (active)
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
│       └── myMachine/
│           ├── default.nix           # Declares `nixosConfigurations.myMachine`
│           ├── configuration.nix     # Main system config — imports modules, sets users, packages
│           └── hardware-configuration.nix  # Auto-generated hardware config
│
└── home/                      # Home Manager user configuration (not a flake module)
    ├── ab_dullah.nix          # Root home config — imports all programs
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
        ├── ghostty/           # Ghostty terminal
        ├── yazi/              # File manager
        ├── bottom.nix         # System monitor
        ├── eza.nix            # ls replacement
        ├── fastfetch.nix      # System info
        ├── fzf.nix            # Fuzzy finder
        └── zoxide.nix         # Smarter cd
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
    └── modules/hosts/myMachine/
            ├── default.nix        → flake.nixosConfigurations.myMachine
            └── configuration.nix  → flake.nixosModules.myMachineConfiguration
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
    users.ab_dullah = import ../../home/ab_dullah.nix;
  };
};
```

This module is then imported by `myMachineConfiguration`. The `home/` directory is **not** in `modules/` — it is plain Home Manager configuration, imported by the bridge above. It does **not** use the flake-parts / import-tree machinery. Instead, `ab_dullah.nix` manually lists its program imports.

```
NixOS system build
  └── myMachineConfiguration
        ├── myMachineHardware   (hardware)
        ├── gnome               (or niri)
        └── homeManager         ← injects home-manager module
              └── ab_dullah.nix
                    └── programs/* (zsh, neovim, ghostty, ...)
```

---

## Key Conventions

| Convention | Details |
|---|---|
| Module naming | Derived from the `flake.nixosModules.<name>` key declared inside each file, **not** from the file path |
| Switching desktops | Change the import in `configuration.nix`: `self.nixosModules.gnome` ↔ `self.nixosModules.niri` |
| Theme access | `self.theme.base0X` (with `#`), `self.themeNoHash.base0X` (without) — used inside niri binds, colors, etc. |
| Adding a program | Create `home/programs/<name>.nix` (or `<name>/default.nix`), add it to the `imports` list in `ab_dullah.nix` |
| Adding a feature | Create `modules/features/<name>.nix` exposing `flake.nixosModules.<name>`, import it in `configuration.nix` |

---

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#myMachine
```
