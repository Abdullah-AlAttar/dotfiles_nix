
# abdullah_nix — Project Reference

## What this is

A NixOS system configuration managed as a **flake**, structured using **flake-parts** and **import-tree**. It configures multiple machines (`mainPC`, `t580`) with a full desktop environment and a Home Manager user environment for `ab_dullah`.

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
│   │       │   ├── default.nix   # KDE aggregator module; composes sibling KDE feature modules
│   │       │   ├── system.nix    # KDE system integration (SDDM, PipeWire, xkb, plasma-manager enablement)
│   │       │   ├── workspace.nix # Plasma workspace look-and-feel, theme, wallpaper, cursor
│   │       │   ├── fonts.nix     # Plasma font preferences
│   │       │   ├── kwin.nix      # KWin effects and night-light behavior
│   │       │   ├── shortcuts.nix # Plasma shortcuts and hotkeys
│   │       │   └── panels.nix    # Plasma top bar + bottom dock panel layout
│   │       └── niri/
│   │           ├── default.nix   # Niri wayland compositor module
│   │           ├── niri.nix.dep  # Niri wrapper-modules configuration (keybinds, layout, etc.)
│   │           ├── noctalia.nix  # Noctalia bar package definition
│   │           └── noctalia.json # Noctalia bar settings
│   │
│   ├── home/
│   │   ├── default.nix        # nixosModule that wires Home Manager into NixOS (no user hardcoded)
│   │   ├── standalone.nix     # flake.homeConfigurations.ab_dullah — standalone HM output
│   │   ├── base.nix           # flake.modules.homeManager.{base, nixosExtras}
│   │   └── profiles/
│   │       ├── shell.nix      # flake.modules.homeManager.shell
│   │       ├── dev.nix        # flake.modules.homeManager.dev
│   │       └── gui.nix        # flake.modules.homeManager.gui
│   │
│   ├── flake/
│   │   └── flake-parts.nix    # Enables flake.modules.* typed registry
│   │
│   └── hosts/
│       ├── mainPC/
│       │   ├── default.nix                 # Declares `nixosConfigurations.mainPC`
│       │   ├── configuration.nix           # Main system config — imports modules, sets users, packages
│       │   ├── home.nix                    # flake.modules.homeManager.mainPC — mainPC HM composition
│       │   ├── hardware-configuration.nix  # Auto-generated hardware config
│       │   └── taskfile.yml               # Host-specific tasks (included by root taskfile under `mainpc:` namespace)
│       └── t580/
│           ├── default.nix                 # Declares `nixosConfigurations.t580`
│           ├── configuration.nix           # ThinkPad T580 system config (Intel Kaby Lake, systemd-boot)
│           ├── home.nix                    # flake.modules.homeManager.t580 — t580 HM composition
│           ├── hardware-configuration.nix  # T580 hardware — Intel Kaby Lake GPU params, VAAPI, TRIM
│           └── taskfile.yml               # Host-specific tasks (included by root taskfile under `t580:` namespace)
│
└── home/                      # Home Manager program configs (plain HM modules, not flake-parts)
    ├── common.nix             # Shared packages, stateVersion, sessionPath for all users
    ├── nix_home.nix           # NixOS-only tweaks (SSH_ASKPASS, etc.) — imported by base.nix
    ├── taskfile.yml           # Standalone HM tasks (included under `home:` namespace)
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

That means `modules/` is reserved for **real flake-parts modules**. Do not place helper/data-only `.nix` files there unless they themselves expose `flake.*` or `perSystem.*`. If a file under `modules/` is not a real module, `import-tree` will still try to evaluate it as one and the flake can fail to build.

### The Dendritic Pattern

Every `.nix` file under `modules/` is a **flake-parts module** — a function that receives `{ self, inputs, ... }` and contributes to the flake outputs by adding keys to `flake.*` or `perSystem.*`. The tree of files is the structure; there is no single registry file.

```
import-tree ./modules
    │
    ├── parts.nix                    → config.systems = [...]
    ├── flake/flake-parts.nix        → enables flake.modules.* registry
    ├── features/theme.nix           → flake.theme, flake.themeNoHash
    ├── features/desktop/gnome/      → flake.nixosModules.gnome
    ├── features/desktop/niri/       → flake.nixosModules.niri
    ├── home/default.nix             → flake.nixosModules.homeManager
    ├── home/standalone.nix          → flake.homeConfigurations.ab_dullah
    ├── home/base.nix                → flake.modules.homeManager.{base, nixosExtras}
    ├── home/profiles/shell.nix      → flake.modules.homeManager.shell
    ├── home/profiles/dev.nix        → flake.modules.homeManager.dev
    ├── home/profiles/gui.nix        → flake.modules.homeManager.gui
    ├── hosts/mainPC/default.nix     → flake.nixosConfigurations.mainPC
    ├── hosts/mainPC/configuration.nix → flake.nixosModules.mainPCConfiguration
    ├── hosts/mainPC/home.nix        → flake.modules.homeManager.mainPC
    ├── hosts/t580/default.nix       → flake.nixosConfigurations.t580
    ├── hosts/t580/configuration.nix → flake.nixosModules.t580Configuration
    └── hosts/t580/home.nix          → flake.modules.homeManager.t580
```

Each node adds exactly what it owns. Cross-references are done via `self.nixosModules.*` (e.g. `configuration.nix` imports `self.nixosModules.gnome`).

For multi-file features, prefer an **aggregator module + sibling feature modules** pattern:

```nix
{ self, ... }:
{
  flake.nixosModules.kde = {
    imports = [
      self.nixosModules.kdeSystem
      self.nixosModules.kdeWorkspace
      self.nixosModules.kdeFonts
      self.nixosModules.kdeKwin
      self.nixosModules.kdeShortcuts
      self.nixosModules.kdePanels
    ];
  };
}
```

In this pattern, each sibling file under `modules/features/desktop/kde/` is still a top-level flake-parts module that owns one concern. This is more aligned with the dendritic pattern than using a raw helper file imported from inside `modules/`.

**Adding a new desktop or feature** = drop a new `.nix` file anywhere under `modules/` that contributes a `flake.nixosModules.<name>`, then reference it by name in `configuration.nix`.

### Home Manager Integration

HM uses a **named module registry** via `flake.modules.homeManager.*`, enabled by `modules/flake/flake-parts.nix`. Each concern lives in its own flake-parts module:

```
modules/home/base.nix         → flake.modules.homeManager.base        (packages, stateVersion)
                                flake.modules.homeManager.nixosExtras  (SSH_ASKPASS, NixOS tweaks)
modules/home/profiles/
  shell.nix                   → flake.modules.homeManager.shell        (zsh, starship, atuin, ...)
  dev.nix                     → flake.modules.homeManager.dev          (neovim, helix, go, k9s, ...)
  gui.nix                     → flake.modules.homeManager.gui          (system-specific GUI apps)
modules/hosts/mainPC/home.nix → flake.modules.homeManager.mainPC       (composes all + scrcpy/opencode)
modules/hosts/t580/home.nix   → flake.modules.homeManager.t580         (composes base+shell+dev)
```

Each host's `home.nix` composes by **name**, not by path:

```nix
# modules/hosts/mainPC/home.nix
{ config, inputs, ... }: {
  flake.modules.homeManager.mainPC = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      base nixosExtras shell dev gui
    ];
    home.packages = [ pkgs.scrcpy ] ++ [ inputs.llm-agents... ];
  };
}
```

The NixOS bridge (`modules/home/default.nix`) is infrastructure-only — it wires `home-manager` into NixOS without hardcoding any user. Each host's `configuration.nix` captures its named HM module in a `let` and passes it:

```nix
# modules/hosts/mainPC/configuration.nix
{ config, ... }: let
  hmMainPC = config.flake.modules.homeManager.mainPC;
in {
  flake.nixosModules.mainPCConfiguration = { ... }: {
    home-manager.users.ab_dullah = hmMainPC;
  };
}
```

The standalone output is in `modules/home/standalone.nix` — it composes the same named modules without `nixosExtras`:

```nix
flake.homeConfigurations.ab_dullah = inputs.home-manager.lib.homeManagerConfiguration {
  modules = with config.flake.modules.homeManager; [ base shell dev gui ] ++ [ { ... } ];
};
```

```
NixOS system build (mainPC)
    └── mainPCConfiguration
          ├── mainPCHardware   (hardware — GRUB, Nvidia GPU)
          ├── kde                 (or gnome / niri)
          ├── nvidia
          ├── gaming
          └── homeManager         ← bridge (NixOS infra only)
                └── users.ab_dullah = flake.modules.homeManager.mainPC
                      = base + nixosExtras + shell + dev + gui + scrcpy/opencode

NixOS system build (t580 — ThinkPad T580)
    └── t580Configuration
          ├── t580Hardware     (hardware — systemd-boot, Intel Kaby Lake GPU, VAAPI, TRIM)
          ├── kde                 (or gnome / niri)
          └── homeManager
                └── users.ab_dullah = flake.modules.homeManager.t580
                      = base + nixosExtras + shell + dev

Standalone Home Manager (non-NixOS)
    └── homeConfigurations.ab_dullah  ← modules/home/standalone.nix
          = base + shell + dev + gui
```

---

## Using the `nix` (mcp) helper for package and docs lookups

When you need to find a package, option, or documentation reference, prefer
using the `nix` mcp helper. It queries live Nix resources (NixOS, Home Manager,
NixHub, nix.dev, Noogle, FlakeHub, the NixOS wiki, etc.) and returns structured
results. Examples:

```js
# Search NixOS packages
nix(action="search", query="firefox", source="nixos", type="packages")

# Get package info
nix(action="info", query="firefox", source="nixos", type="package")

# Search Home Manager options
nix(action="search", query="git", source="home-manager")

# Browse darwin options
nix(action="options", source="darwin", query="system.defaults")

# Search Nixvim options
nix(action="search", query="telescope", source="nixvim")

# Get Nixvim option info
nix(action="info", query="plugins.telescope.enable", source="nixvim")

# Search FlakeHub
nix(action="search", query="nixpkgs", source="flakehub")

# Get FlakeHub flake info
nix(action="info", query="NixOS/nixpkgs", source="flakehub")

# Search Noogle for Nix functions
nix(action="search", query="mapAttrs", source="noogle")

# Get Noogle function info
nix(action="info", query="lib.attrsets.mapAttrs", source="noogle")

# Browse Noogle function categories
nix(action="options", source="noogle", query="lib.strings")

# Search NixOS Wiki
nix(action="search", query="nvidia", source="wiki")

# Get Wiki page info
nix(action="info", query="Flakes", source="wiki")

# Search nix.dev documentation
nix(action="search", query="packaging tutorial", source="nix-dev")

# Search NixHub for package metadata
nix(action="search", query="nodejs", source="nixhub")

# Get detailed package info from NixHub (license, homepage, store paths)
nix(action="info", query="python", source="nixhub")

# Check binary cache status
nix(action="cache", query="hello")

# Check cache for specific version
nix(action="cache", query="python", version="3.12.0")

# Check cache for specific system
nix(action="cache", query="firefox", system="x86_64-linux")

# Get stats
nix(action="stats", source="nixos", channel="stable")

# List local flake inputs (requires Nix)
nix(action="flake-inputs", type="list")

# Browse files in a flake input
nix(action="flake-inputs", type="ls", query="nixpkgs:pkgs/by-name")

# Read a file from a flake input
nix(action="flake-inputs", type="read", query="nixpkgs:flake.nix")
```

## Key Conventions

| Convention | Details |
|---|---|
| Module naming | Derived from the `flake.nixosModules.<name>` key declared inside each file, **not** from the file path |
| `modules/` contents | Every `.nix` file under `modules/` must be a real flake-parts module. Put plain helper/data files outside `modules/`, or better, refactor them into sibling modules when they represent a real concern |
| Switching desktops | Change the import in `configuration.nix`: `self.nixosModules.kde` ↔ `self.nixosModules.gnome` ↔ `self.nixosModules.niri` |
| Large feature layout | Prefer an aggregator module plus sibling modules with single ownership, instead of one huge file or ad-hoc helper snippets |
| Theme access | `self.theme.base0X` (with `#`), `self.themeNoHash.base0X` (without) — used inside niri binds, colors, etc. |
| Adding a program | Create `home/programs/<name>.nix` (or `<name>/default.nix`), then add it to the relevant profile in `modules/home/profiles/` |
| Adding a feature | Create `modules/features/<name>.nix` exposing `flake.nixosModules.<name>`, import it in the relevant host `configuration.nix` |
| Adding a new host | Create `modules/hosts/<name>/` with `default.nix`, `configuration.nix`, `home.nix`, `hardware-configuration.nix`, and `taskfile.yml`; add an `includes` entry to root `taskfile.yml` |
| Adding a GUI app | Create `home/programs/system-specific/linux/<name>/default.nix`, add it to `linux/default.nix` imports (see below) |
| System-level packages | Only put packages in `configuration.nix` (`environment.systemPackages` or `users.users.ab_dullah.packages`) if they need system-level integration. Everything else belongs in Home Manager |
| Docker | Enabled via `virtualisation.docker.enable = true` in `configuration.nix`; user added to `"docker"` extraGroup |

### Where to put a new package

```
Need system integration (services, kernel, PAM)?
  └── YES → modules/features/<name>.nix  (new nixosModule) or configuration.nix directly
  └── NO → Is it a GUI app only used on NixOS native Linux?
        └── YES → home/programs/system-specific/linux/<name>/default.nix
        └── NO  → home/common.nix  home.packages (CLI tools, cross-platform dev deps)
```

### KDE Module Pattern

KDE is the reference example for a split dendritic desktop feature:

- `default.nix` is only the aggregator.
- `system.nix` owns system-level KDE integration.
- `workspace.nix`, `fonts.nix`, `kwin.nix`, `shortcuts.nix`, and `panels.nix` each own one Plasma configuration slice.
- If a KDE concern is only used once and corresponds to a real option subtree, prefer a sibling module over a separate helper file.

### GUI App Module Pattern

All GUI apps under `home/programs/system-specific/linux/` **must** follow this pattern (see `telegram/default.nix` as the reference):

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

After creating the file, add `./\<name\>` to the `imports` list in `home/programs/system-specific/linux/default.nix`.

---

## Rebuild

Host-specific tasks live in each host's `taskfile.yml` and are included in the root taskfile under their namespace:

```bash
task mainpc:switch   # build and switch mainPC
task t580:switch     # build and switch t580
task t580:boot       # build and set boot entry (use before first reboot on t580)
task home:switch     # standalone home-manager switch
```

Or call directly:

```bash
sudo nixos-rebuild switch --flake '.#mainPC'
sudo nixos-rebuild switch --flake '.#t580'
home-manager switch --flake '.#ab_dullah'
```
