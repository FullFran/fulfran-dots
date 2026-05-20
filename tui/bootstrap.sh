#!/usr/bin/env sh
# fulfran-dots bootstrap TUI
# Scaffolds a private home-manager flake from the fulfran-dots template.
#
# Steps:
#   1. If no flake.nix in cwd, run nix flake init from template
#   2. Prompt for preset (minimal / full / dev-only / terminal-only)
#   3. Prompt for config mode (safe / full / custom)
#   4. If custom, ask per toggle
#   5. Prompt for hostname (sanitized) and username, write hosts/<host>.nix

set -eu

FULFRAN_FLAKE_URL="${FULFRAN_FLAKE_URL:-github:FullFran/fulfran-dots}"

# ── 0. Helper detection ────────────────────────────────────────────────────

have() { command -v "$1" >/dev/null 2>&1; }

# POSIX-portable in-place sed (GNU vs BSD compat).
_sed_inplace() {
  if sed --version >/dev/null 2>&1; then
    # GNU sed
    sed -i "$@"
  else
    # BSD sed (macOS)
    sed -i '' "$@"
  fi
}

ui_select() {
  # ui_select <prompt> <opt1> <opt2> ...
  prompt="$1"; shift
  if have gum; then
    printf '%s\n' "$@" | gum choose --header="$prompt"
  elif have whiptail; then
    args=""
    for o in "$@"; do args="$args $o $o"; done
    # shellcheck disable=SC2086
    whiptail --title "fulfran-dots" --menu "$prompt" 20 60 12 $args 3>&1 1>&2 2>&3
  else
    printf '%s\n' "$prompt" >&2
    i=1
    for o in "$@"; do
      printf '  %d) %s\n' "$i" "$o" >&2
      i=$((i + 1))
    done
    printf 'choice (number): ' >&2
    read -r c
    i=1
    for o in "$@"; do
      if [ "$i" = "$c" ]; then printf '%s' "$o"; return; fi
      i=$((i + 1))
    done
    printf '%s' "$1"  # default to first option
  fi
}

ui_input() {
  # ui_input <prompt> <default>
  prompt="$1"; def="${2:-}"
  if have gum; then
    gum input --prompt "$prompt: " --value "$def"
  elif have whiptail; then
    whiptail --title "fulfran-dots" --inputbox "$prompt" 10 60 "$def" 3>&1 1>&2 2>&3
  else
    printf '%s [%s]: ' "$prompt" "$def" >&2
    read -r v
    printf '%s' "${v:-$def}"
  fi
}

ui_confirm() {
  # ui_confirm <prompt>  -- returns 0 for yes, 1 for no
  prompt="$1"
  if have gum; then
    gum confirm "$prompt"
  elif have whiptail; then
    whiptail --yesno "$prompt" 10 60
  else
    printf '%s [y/N]: ' "$prompt" >&2
    read -r r
    case "$r" in
      y|Y) return 0 ;;
      *)   return 1 ;;
    esac
  fi
}

ui_yesno() {
  # ui_yesno <prompt> <default: y|n>  -- prints "y" or "n" to stdout
  prompt="$1"; default="${2:-n}"
  if have gum; then
    if gum confirm "$prompt"; then
      printf 'y'
    else
      printf 'n'
    fi
  elif have whiptail; then
    if whiptail --yesno "$prompt" 10 60; then
      printf 'y'
    else
      printf 'n'
    fi
  else
    if [ "$default" = "y" ]; then
      printf '%s [Y/n]: ' "$prompt" >&2
    else
      printf '%s [y/N]: ' "$prompt" >&2
    fi
    read -r ans
    case "$ans" in
      y|Y) printf 'y' ;;
      n|N) printf 'n' ;;
      '')  printf '%s' "$default" ;;
      *)   printf '%s' "$default" ;;
    esac
  fi
}

# ── 1. Prerequisites ────────────────────────────────────────────────────────

have nix || { printf 'nix not found. Install via https://install.determinate.systems\n' >&2; exit 1; }

# ── 2. Detect current platform ──────────────────────────────────────────────

_detect_nix_system() {
  uname_s=$(uname -s)
  uname_m=$(uname -m)
  case "$uname_s" in
    Darwin)
      case "$uname_m" in
        arm64) printf 'aarch64-darwin' ;;
        *)     printf 'x86_64-darwin'  ;;
      esac
      ;;
    *)
      case "$uname_m" in
        aarch64|arm64) printf 'aarch64-linux' ;;
        *)             printf 'x86_64-linux'  ;;
      esac
      ;;
  esac
}

_detect_home_dir() {
  # Returns the platform-appropriate home directory path for a given user.
  # $1 = username
  uname_s=$(uname -s)
  case "$uname_s" in
    Darwin) printf '/Users/%s' "$1" ;;
    *)      printf '/home/%s'  "$1" ;;
  esac
}

nix_system=$(_detect_nix_system)

# ── 3. Scaffold if no flake.nix ─────────────────────────────────────────────

if [ ! -f flake.nix ]; then
  printf 'No flake.nix in cwd — initializing from template...\n' >&2
  nix flake init -t "$FULFRAN_FLAKE_URL"
else
  printf 'flake.nix already exists — skipping template init.\n' >&2
fi

# ── 4. Preset selection ─────────────────────────────────────────────────────

preset=$(ui_select "Pick a preset" minimal full dev-only terminal-only)
preset="${preset:-full}"

# ── 5. Config mode selection ─────────────────────────────────────────────────
#
# safe   — disable all config overwrites; install packages only
# full   — enable all configs (replaces today's commented-out defaults)
# custom — ask per toggle

printf '\n' >&2
printf 'Config mode:\n' >&2
printf '  safe   = install packages only; do NOT overwrite your existing dotfiles (recommended for new users)\n' >&2
printf '  full   = ship all configs (recommended for fresh installs or if you want everything)\n' >&2
printf '  custom = choose per config\n' >&2
printf '\n' >&2

config_mode=$(ui_select "Pick a config mode" safe full custom)
config_mode="${config_mode:-safe}"

# ── 5a. Per-toggle resolution ────────────────────────────────────────────────
#
# Resolve each toggle to "true" or "false" based on the chosen config_mode.
# core.enable is always true; dev.enableJdk defaults to false in all modes.

_resolve_toggles() {
  # mode: safe, full, or custom
  mode="$1"

  case "$mode" in
    safe)
      tog_enableBash="false"
      tog_enableZsh="false"
      tog_tmux="false"
      tog_ghostty="false"
      tog_nvim="false"
      tog_lazygit="false"
      tog_btop="false"
      tog_gitHelpers="true"
      tog_jdk="false"
      ;;
    full)
      tog_enableBash="true"
      tog_enableZsh="true"
      tog_tmux="true"
      tog_ghostty="true"
      tog_nvim="true"
      tog_lazygit="true"
      tog_btop="true"
      tog_gitHelpers="true"
      tog_jdk="false"
      ;;
    custom)
      printf '\nAnswer yes/no for each config. Hit Enter to accept the default shown.\n\n' >&2

      tog_enableBash=$(ui_yesno \
        "[shell.enableBash] Ship bash modular config? (would overwrite ~/.bashrc and ~/.config/bash/)" n)
      tog_enableZsh=$(ui_yesno \
        "[shell.enableZsh] Ship zsh modular config? (would overwrite ~/.zshrc and ~/.config/zsh/)" n)
      tog_tmux=$(ui_yesno \
        "[tmux] Use fulfran-dots' tmux.conf? (would overwrite ~/.tmux.conf and ~/.config/tmux/tmux.conf)" n)
      tog_ghostty=$(ui_yesno \
        "[ghostty] Use fulfran-dots' ghostty config? (would overwrite ~/.config/ghostty/config)" n)
      tog_nvim=$(ui_yesno \
        "[nvim] Use fulfran-dots' LazyVim config? (would overwrite ~/.config/nvim/)" n)
      tog_lazygit=$(ui_yesno \
        "[lazygit] Use fulfran-dots' lazygit config? (would overwrite ~/.config/lazygit/config.yml)" n)
      tog_btop=$(ui_yesno \
        "[btop] Use fulfran-dots' btop config? (would overwrite ~/.config/btop/btop.conf)" n)
      tog_gitHelpers=$(ui_yesno \
        "[dev.enableGitHelpers] Install gwt() git worktree helpers? (adds a small function to your shell, no file overwrite)" y)
      tog_jdk=$(ui_yesno \
        "[dev.enableJdk] Install JDK 21? (heavy download, opt-in)" n)
      ;;
    *)
      # Fallback to safe
      tog_enableBash="false"
      tog_enableZsh="false"
      tog_tmux="false"
      tog_ghostty="false"
      tog_nvim="false"
      tog_lazygit="false"
      tog_btop="false"
      tog_gitHelpers="true"
      tog_jdk="false"
      ;;
  esac
}

_resolve_toggles "$config_mode"

# Convert y/n to true/false for custom mode results
_yn_to_bool() {
  case "$1" in
    y) printf 'true'  ;;
    *) printf 'false' ;;
  esac
}

if [ "$config_mode" = "custom" ]; then
  tog_enableBash=$(_yn_to_bool "$tog_enableBash")
  tog_enableZsh=$(_yn_to_bool "$tog_enableZsh")
  tog_tmux=$(_yn_to_bool "$tog_tmux")
  tog_ghostty=$(_yn_to_bool "$tog_ghostty")
  tog_nvim=$(_yn_to_bool "$tog_nvim")
  tog_lazygit=$(_yn_to_bool "$tog_lazygit")
  tog_btop=$(_yn_to_bool "$tog_btop")
  tog_gitHelpers=$(_yn_to_bool "$tog_gitHelpers")
  tog_jdk=$(_yn_to_bool "$tog_jdk")
fi

# ── 6. Hostname + sanitization ──────────────────────────────────────────────

raw_host=$(ui_input "Hostname" "$(uname -n 2>/dev/null || printf 'my-host')")
host=$(printf '%s' "$raw_host" \
  | tr '[:upper:] ' '[:lower:]-' \
  | sed -E 's/[^a-z0-9-]+/-/g; s/-+/-/g; s/^-//; s/-$//')

[ -n "$host" ] || { printf 'Invalid hostname after sanitization.\n' >&2; exit 1; }

# ── 7. Username ─────────────────────────────────────────────────────────────

user=$(ui_input "Username" "${USER:-user}")
[ -n "$user" ] || { printf 'Username cannot be empty.\n' >&2; exit 1; }

home_dir=$(_detect_home_dir "$user")

# ── 8. Write hosts/<host>.nix ───────────────────────────────────────────────

mkdir -p hosts
cat > "hosts/${host}.nix" <<EOF
# Generated by fulfran-dots TUI on $(date -Iseconds 2>/dev/null || date)
# Config mode: ${config_mode}
{ pkgs, lib, ... }:
{
  home.username = "${user}";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${user}"
    else "/home/${user}";

  home.stateVersion = "25.05";

  # Generated by the TUI based on your "${config_mode}" choice.
  # Edit any value here to customize after the initial setup.
  programs.fulfran = {
    core.enable = true;
    shell.enableBash = ${tog_enableBash};
    shell.enableZsh = ${tog_enableZsh};
    tmux.enableConfig = ${tog_tmux};
    ghostty.enableConfig = ${tog_ghostty};
    nvim.enableConfig = ${tog_nvim};
    lazygit.enableConfig = ${tog_lazygit};
    btop.enableConfig = ${tog_btop};
    dev.enableGitHelpers = ${tog_gitHelpers};
    dev.enableJdk = ${tog_jdk};
  };
}
EOF

printf 'Wrote hosts/%s.nix\n' "$host" >&2

# ── 9. Patch flake.nix at the marker ────────────────────────────────────────

if [ ! -f flake.nix ]; then
  printf 'flake.nix not found — cannot patch.\n' >&2
  exit 1
fi

if ! grep -q '# FULFRAN_TUI_INSERT_HERE' flake.nix; then
  printf 'Warning: marker # FULFRAN_TUI_INSERT_HERE not found in flake.nix.\n' >&2
  printf 'Add the entry for "%s@%s" manually.\n' "$user" "$host" >&2
else
  # Try Python3 first for clean string substitution, fall back to sed
  _patch_with_python() {
    python3 - "$1" "$2" "$3" "$4" <<'PY'
import sys, pathlib
u, h, preset, nix_system = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]
p = pathlib.Path("flake.nix")
src = p.read_text()
entry = (
    f'        "{u}@{h}" = home-manager.lib.homeManagerConfiguration {{\n'
    f'          pkgs = pkgsFor "{nix_system}";\n'
    f'          modules = [ fulfran-dots.homeManagerModules.{preset} ./hosts/{h}.nix ];\n'
    f'        }};\n'
    f'        # FULFRAN_TUI_INSERT_HERE'
)
new = src.replace("# FULFRAN_TUI_INSERT_HERE", entry)
p.write_text(new)
PY
  }

  _patch_with_sed() {
    # sed fallback — BSD and GNU compatible via _sed_inplace
    _sed_inplace "s|# FULFRAN_TUI_INSERT_HERE|        \"${user}@${host}\" = home-manager.lib.homeManagerConfiguration {\n          pkgs = pkgsFor \"${nix_system}\";\n          modules = [ fulfran-dots.homeManagerModules.${preset} .\/hosts\/${host}.nix ];\n        };\n        # FULFRAN_TUI_INSERT_HERE|" flake.nix
  }

  if have python3; then
    _patch_with_python "$user" "$host" "$preset" "$nix_system" || _patch_with_sed
  else
    _patch_with_sed
  fi
  printf 'Registered %s@%s in flake.nix\n' "$user" "$host" >&2
fi

# ── 10. Optional home-manager switch ─────────────────────────────────────────

if ui_confirm "Run home-manager switch --flake .#${user}@${host} -b backup now?"; then
  nix run nixpkgs#home-manager -- switch --flake ".#${user}@${host}" -b backup
fi

printf 'Done. Edit hosts/%s.nix to customize.\n' "$host" >&2
