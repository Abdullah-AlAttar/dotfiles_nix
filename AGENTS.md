# dotfiles_nix — Project Reference

## What this is

A NixOS system configuration managed as a **flake**, structured using **flake-parts** and **import-tree**. It configures multiple machines (`mainPC`, `t580`) with a full desktop environment and a Home Manager user environment for `ab_dullah`.

---

## Project Structure

```
dotfiles_nix/
├── flake.nix                  # Entry point — wires inputs and delegates to modules/
├── taskfile.yml               # Task runner shortcuts
├── .sops.yaml                 # SOPS encryption config — which age keys can encrypt secrets
│
├── docs/                      # Reference documentation
│   └── sops-nix.md            # Secrets management guide
│
├── secrets/                   # Encrypted secrets (safe to commit)
│   └── secrets.yaml           # API keys, tokens — edit with `sops secrets/secrets.yaml`
│
├── modules/                   # All flake-parts modules (auto-imported via import-tree)
│   ├── parts.nix              # Declares supported systems (x86_64-linux, etc.)
│   │
│   ├── features/              # Reusable nixosModules (desktops, hardware, etc.)
│   │   ├── sops.nix           # sops-nix NixOS module (system-level secrets)
│   │   ├── gaming.nix         # Steam / gaming packages
│   │   ├── nvidia.nix         # Nvidia drivers / CUDA
│   │   ├── displaylink.nix    # DisplayLink dock support
│   │   ├── scanner.nix        # Scanner drivers
│   │   ├── teamviewer.nix     # TeamViewer remote desktop
│   │   ├── weylus.nix         # Weylus screen drawing
│   │   └── desktop/
│   │       ├── cosmic/
│   │       │   ├── default.nix   # COSMIC desktop aggregator module
│   │       │   └── system.nix    # COSMIC system integration (DE enablement, xkb, fonts)
│   │       ├── gnome/
│   │       │   └── default.nix   # GNOME desktop module
│   │       └── kde/
│   │           ├── default.nix   # KDE aggregator module; composes sibling KDE feature modules
│   │           ├── system.nix    # KDE system integration (SDDM, PipeWire, xkb, plasma-manager enablement)
│   │           ├── workspace.nix # Plasma workspace look-and-feel, theme, wallpaper, cursor
│   │           ├── fonts.nix     # Plasma font preferences
│   │           ├── kwin.nix      # KWin effects and night-light behavior
│   │           ├── shortcuts.nix # Plasma shortcuts and hotkeys
│   │           └── panels.nix    # Plasma top bar + bottom dock panel layout
│   │
│   ├── home/
│   │   ├── default.nix               # NixOS HM bridge — sets up home-manager NixOS module
│   │   ├── default-hm-imports.nix     # Shared HM module import list (single source of truth for all hosts)
│   │   ├── modules.nix               # Exposes flake.homeModules (common, cli, dev, apps, system, sops)
│   │   └── standalone.nix            # flake.homeConfigurations for non-NixOS (Ubuntu, WSL)
│   │
│   └── hosts/
│       ├── mainPC/
│       │   ├── configuration.nix           # Declares nixosConfigurations.mainPC + system config (imports features, desktop, HM)
│       │   ├── home-manager.nix            # Host-specific HM overrides (packages, session vars)
│       │   ├── hardware-configuration.nix  # Auto-generated hardware config
│       │   ├── taskfile.yml               # Host-specific tasks (included by root taskfile under `mainpc:` namespace)
│       │   └── certs/
│       │       └── cert_ca.crt            # Custom CA certificate
│       └── t580/
│           ├── configuration.nix           # Declares nixosConfigurations.t580 + system config (Intel Kaby Lake, systemd-boot)
│           ├── home-manager.nix            # Host-specific HM overrides (session vars)
│           ├── hardware-configuration.nix  # T580 hardware — Intel Kaby Lake GPU params, VAAPI, TRIM
│           └── taskfile.yml               # Host-specific tasks (included by root taskfile under `t580:` namespace)
│
└── home/                      # Home Manager modules (plain HM modules, NOT flake-parts modules)
    ├── common.nix             # Base config: stateVersion + essential packages (git, ripgrep, etc.)
    │
    ├── cli/                   # Terminal / CLI tools
    │   ├── default.nix        # Aggregator — imports all CLI modules below
    │   ├── zsh/               # Zsh + oh-my-zsh + plugins
    │   ├── starship/          # Starship prompt
    │   ├── atuin/             # Atuin shell history
    │   ├── zellij/            # Terminal multiplexer
    │   ├── helix/             # Helix editor
    │   ├── neovim/            # NixVim-based Neovim config
    │   │   ├── default.nix
    │   │   ├── options.nix, keymappings.nix, ...
    │   │   └── plugins/       # One file per plugin
    │   ├── bash/              # Bash shell config
    │   ├── yazi.nix           # File manager
    │   ├── eza.nix            # ls replacement
    │   ├── fzf.nix            # Fuzzy finder
    │   ├── zoxide.nix         # Smarter cd
    │   ├── fastfetch.nix      # System info
    │   └── bottom.nix         # System monitor
    │
    ├── dev/                   # Development tools
    │   ├── default.nix        # Aggregator — imports all dev modules + language toolchains
    │   ├── go/                # Go toolchain
    │   ├── kubernetes.nix     # kubectl + plugins
    │   ├── direnv/            # Direnv + nix-direnv
    │   └── k9s/               # K9s TUI + skins + plugins
    │
    ├── apps/                  # GUI applications (NixOS / native Linux only)
    │   ├── default.nix        # Aggregator — imports all GUI app modules
    │   ├── ghostty/           # Ghostty terminal
    │   ├── discord/           # Discord
    │   ├── obsidian/          # Obsidian note-taking
    │   ├── telegram/          # Telegram desktop
    │   ├── obs/               # OBS Studio
    │   ├── microsoft-edge/    # Edge browser
    │   ├── zed/               # Zed editor
    │   ├── alacrity/          # Alacritty terminal
    │   ├── bruno/             # Bruno API client
    │   ├── remmina/           # RDP client
    │   ├── teams/             # Teams for Linux
    │   ├── vlc/               # VLC media player
    │   └── fonts/             # Font packages
    │
    └── system/                # System integration
        ├── default.nix        # Aggregator — session vars, network tools, misc
        └── sops.nix           # sops-nix HM module — opt-in per host (API keys, tokens)
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
    ├── parts.nix           → config.systems = [...]
    ├── features/sops.nix                     → flake.nixosModules.sops
    ├── features/desktop/gnome/default.nix → flake.nixosModules.gnome
    ├── features/desktop/cosmic/default.nix → flake.nixosModules.cosmic
    ├── features/desktop/kde/default.nix   → flake.nixosModules.kde
    ├── modules/home/default.nix           → flake.nixosModules.homeManager
    ├── modules/home/modules.nix           → flake.homeModules (common, cli, dev, apps, system, sops)
    ├── modules/home/standalone.nix        → flake.homeConfigurations (ubuntu, wsl)
    ├── modules/hosts/mainPC/
    │   ├── default.nix           → flake.nixosConfigurations.mainPC
    │   ├── configuration.nix     → flake.nixosModules.mainPCConfiguration
    │   └── home-manager.nix      → flake.nixosModules.mainPCHomeManager
    └── modules/hosts/t580/
        ├── default.nix           → flake.nixosConfigurations.t580
        ├── configuration.nix     → flake.nixosModules.t580Configuration
        └── home-manager.nix      → flake.nixosModules.t580HomeManager
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

Home Manager runs as a **NixOS module**. The bridge is `modules/home/default.nix`:

```nix
flake.nixosModules.homeManager = { pkgs, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs; isNixOS = true; };
    # Per-host module selection is set in each host's home-manager.nix
  };
};
```

HM modules live in `home/` at the repo root. `modules/home/modules.nix` exposes them as `flake.homeModules`:

```nix
flake.homeModules = {
  common = import ../../home/common.nix;
  cli    = import ../../home/cli/default.nix;
  dev    = import ../../home/dev/default.nix;
  apps   = import ../../home/apps/default.nix;
  system = import ../../home/system/default.nix;
};
```

The canonical set of Home Manager modules for all NixOS hosts is defined in `modules/home/default-hm-imports.nix`:

```nix
{ self, ... }: {
  flake.nixosModules.defaultHomeManager = { username, ... }: {
    home-manager.users.${username}.imports = [
      self.homeModules.common
      self.homeModules.cli
      self.homeModules.dev
      self.homeModules.apps
      self.homeModules.system
    ];
  };
}
```

Each host imports `self.nixosModules.defaultHomeManager` in its `configuration.nix` to get the shared baseline. Its `home-manager.nix` only adds **host-specific overrides** (extra packages, session variables):

```nix
{ inputs, ... }: {
  flake.nixosModules.mainPCHomeManager = { pkgs, username, ... }: {
    # Host-specific Home Manager overrides.
    # The shared home module import list lives in
    # flake.nixosModules.defaultHomeManager (modules/home/default-hm-imports.nix).
    home-manager.users.${username} = {
      home.sessionVariables = { SSH_ASKPASS = ""; };
      home.packages = with pkgs; [ scrcpy libreoffice-qt6-fresh ];
    };
  };
}
```

Then in `configuration.nix`, add both `self.nixosModules.defaultHomeManager` and `self.nixosModules.mainPCHomeManager` to the imports list.

Standalone (non-NixOS) configurations for Ubuntu/WSL are in `modules/home/standalone.nix`:
```bash
nix run nixpkgs#home-manager -- switch --flake .#ubuntu
nix run nixpkgs#home-manager -- switch --flake .#wsl
```

```
NixOS system build (mainPC)
    └── mainPCConfiguration
          ├── mainPCHardware
          ├── kde
          ├── nvidia
          ├── gaming
          ├── defaultHomeManager
          │     └── home-manager.users.ab_dullah.imports = [
          │           self.homeModules.common   → home/common.nix (base packages)
          │           self.homeModules.cli      → home/cli/default.nix (zsh, neovim, ...)
          │           self.homeModules.dev      → home/dev/default.nix (go, k8s, ...)
          │           self.homeModules.apps     → home/apps/default.nix (ghostty, discord, ...)
          │           self.homeModules.system   → home/system/default.nix (session vars, ...)
          │         ]
          │     (sops is OPT-IN — imported per-host, not in defaultHomeManager)
          └── mainPCHomeManager
                └── host-specific overrides (packages, session vars)
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
| Switching desktops | Change the import in `configuration.nix`: `self.nixosModules.kde` ↔ `self.nixosModules.gnome` ↔ `self.nixosModules.cosmic` |
| Large feature layout | Prefer an aggregator module plus sibling modules with single ownership, instead of one huge file or ad-hoc helper snippets |
| Adding a program | Create `home/<category>/<name>.nix` (or `<name>/default.nix`), add it to the category `default.nix` imports |
| Adding a feature | Create `modules/features/<name>.nix` exposing `flake.nixosModules.<name>`, import it in the relevant host `configuration.nix` |
| Adding a new host | Create `modules/hosts/<name>/` with `configuration.nix`, `hardware-configuration.nix`, `home-manager.nix`, and `taskfile.yml`; add an `includes` entry to root `taskfile.yml` |
| Adding a GUI app | Create `home/apps/<name>/default.nix`, add `./<name>` to `home/apps/default.nix` imports |
| Selecting HM modules | All hosts share `defaultHomeManager` (in `modules/home/default-hm-imports.nix`). Each host's `home-manager.nix` adds only host-specific overrides |
| sops-nix (Secrets) | API keys stored in `secrets/secrets.yaml` (encrypted). Each host opts in by importing `self.homeModules.sops` in its `home-manager.nix`. Edit with `sops secrets/secrets.yaml`. Full guide: `docs/sops-nix.md` |

### Where to put a new package

```
Need system integration (services, kernel, PAM)?
  └── YES → modules/features/<name>.nix  (new nixosModule) or configuration.nix directly
  └── NO → Is it a GUI app (Linux desktop only)?
        └── YES → home/apps/<name>/default.nix
        └── NO  → Appropriate category: home/cli, home/dev, or home/system
```

### KDE Module Pattern

KDE is the reference example for a split dendritic desktop feature:

- `default.nix` is only the aggregator.
- `system.nix` owns system-level KDE integration.
- `workspace.nix`, `fonts.nix`, `kwin.nix`, `shortcuts.nix`, and `panels.nix` each own one Plasma configuration slice.
- If a KDE concern is only used once and corresponds to a real option subtree, prefer a sibling module over a separate helper file.

### GUI App Module Pattern

All GUI apps under `home/apps/` follow a simple pattern — no conditional flags; module selection is at the per-host level.

**Prefer `programs.<name>.enable`** when Home Manager has a module for the program. This gives declarative settings, shell integrations, and proper HM integration:

```nix
{ ... }: {
  programs.zed-editor = {
    enable = true;
    extensions = ["catppuccin-icons" "html" "sql"];
  };
}
```

For programs **without** a Home Manager module, fall back to `home.packages`:

```nix
{ pkgs, ... }: {
  home.packages = [ pkgs.discord ];
}
```

If the HM module doesn't cover all config needs (e.g., custom shaders, non-standard paths), you can mix both — use the module for most settings and `home.file` for the extras.

After creating the file, add `./<name>` to the `imports` list in `home/apps/default.nix`.`,

### AppImage Wrapping Pattern

When a GUI app is only available as an AppImage and not in nixpkgs (or was removed), wrap it using `pkgs.appimageTools.wrapType2`. Create `home/apps/<name>/default.nix`:

```nix
# <Name> — <short description> (AppImage wrap)
# <homepage>
{pkgs, ...}: let
  pname = "<name>";
  version = "<version>";

  src = pkgs.fetchurl {
    url = "https://download.example.com/releases/${pname}-${version}-x86_64.AppImage";
    hash = "sha256-...";
  };

  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
in {
  home.packages = [
    (pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/<app-id>.desktop $out/share/applications/${pname}.desktop
        install -m 444 -D ${appimageContents}/path/to/icon.png $out/share/icons/hicolor/512x512/apps/${pname}.png
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=${pname}' \
          --replace-fail 'Icon=<app-id>' 'Icon=${pname}'
      '';

      meta = {
        description = "...";
        homepage = "https://...";
        license = pkgs.lib.licenses.unfree;
        platforms = ["x86_64-linux"];
        mainProgram = pname;
      };
    })
  ];
};
```

Key steps:
1. **Get the hash** — download the AppImage and run `nix hash file <file>`.
2. **Find desktop + icon paths** — extract locally first: `nix run nixpkgs#appimage-run -- --appimage-extract <AppImage>`, then look in the `squashfs-root/` output for `.desktop` and icon files.
3. **App ID** — the `.desktop` file's `Icon=` value reveals the icon identifier inside the AppImage.
4. **Add the import** — add `./<name>` to `home/apps/default.nix`'s `imports` list.
5. **Run `task mainpc:switch`** (or `t580:switch`) to build and deploy.

This pattern does **not** need `programs.appimage.binfmt` at runtime — `wrapType2` produces a regular FHS binary, not a raw AppImage. It works with any `pkgs.appimageTools.wrapType2` call; the extracted contents provide `.desktop` entries and icons.

---

## Rebuild

Host-specific tasks live in each host's `taskfile.yml` and are included in the root taskfile under their namespace:

```bash
task mainpc:switch   # build and switch mainPC
task t580:switch     # build and switch t580
task t580:boot       # build and set boot entry (use before first reboot on t580)
```

Or call nixos-rebuild directly:

```bash
sudo nixos-rebuild switch --flake '.#mainPC'
sudo nixos-rebuild switch --flake '.#t580'
```
