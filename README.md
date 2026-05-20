# fulfran-dots

A reusable, modular [home-manager](https://github.com/nix-community/home-manager) base
for Linux workstations. Opinionated defaults, composable presets, and per-feature toggles
so any consumer can opt out of individual configs without forking.

---

## Quick-start

```sh
# Scaffold a private flake from the template
nix flake init -t github:FullFran/fulfran-dots

# Or run the interactive bootstrap TUI directly
nix run github:FullFran/fulfran-dots#tui
```

The TUI will prompt for a preset, hostname, and username, write
`hosts/<hostname>.nix`, patch `flake.nix`, and optionally activate.

---

## Modules

| Module | What it installs | Key toggles |
|---|---|---|
| `core` | git, gh, jq, fd, ripgrep, bat, eza, fzf, zoxide, atuin, direnv, wget, curl, fastfetch, tree, btop | `core.enable` |
| `shell` | bash + zsh modular configs, portable aliases | `shell.enableBash`, `shell.enableZsh` |
| `terminal` | tmux (Tokyo Night config), ghostty config, nerd fonts | `tmux.enableConfig`, `ghostty.enableConfig` |
| `editor` | neovim + LazyVim config, lazygit config, btop config, delta | `nvim.enableConfig`, `lazygit.enableConfig`, `btop.enableConfig` |
| `dev` | nodejs, pnpm, bun, go, yazi, lazygit, direnv, delta, git helpers | `dev.enableGitHelpers`, `dev.enableJdk` |

All toggles live under `programs.fulfran.<tool>.*` and default to `true` (except
`dev.enableJdk` which defaults to `false`).

The `editor` module includes `avante.nvim` (AI-optional — disabled by default via
`enabled = false` in the plugin spec) and `opencode.nvim` (public Neovim plugin for
the [opencode](https://github.com/sst/opencode) CLI). Both are safe to leave in place;
neither requires external credentials to have a working Neovim setup.

---

## Presets

| Preset | Included modules |
|---|---|
| `minimal` | core + shell |
| `full` | core + shell + terminal + editor + dev |
| `dev-only` | core + shell + editor + dev |
| `terminal-only` | core + shell + terminal |

Each preset is available as both `presets.<name>` and `homeManagerModules.<name>`.

---

## Override pattern

Import a preset in your host file, then disable any feature you want to replace:

```nix
# hosts/my-laptop.nix
{ ... }:
{
  imports = [ fulfran-dots.presets.full ];

  # Disable the shipped tmux config; bring your own:
  programs.fulfran.tmux.enableConfig = false;

  # Opt in to JDK:
  programs.fulfran.dev.enableJdk = true;
}
```

No `mkForce` needed — a plain assignment overrides the `mkDefault`/`mkEnableOption`
defaults.

---

## License

MIT — see [LICENSE](./LICENSE).
