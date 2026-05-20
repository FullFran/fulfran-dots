# Sandbox Regression — Phase 12 Verification

Date: 2026-05-20

## Configuration

- Public flake: `.local/fulfran-dots/` (path input)
- Private consumer: `.local/dotfiles-private/` (`fulfran-dots.url = "path:../fulfran-dots"`)
- Sandbox home: `/tmp/fulfran-dots-sandbox-home` (via `FULFRAN_SANDBOX_HOME` env)

## Results

| Check | Command | Result |
|-------|---------|--------|
| T12.1 | Confirm `path:` input in dotfiles-private/flake.nix | PASS |
| T12.2 | `nix flake metadata --no-write-lock-file` (dotfiles-private) | PASS — resolved all inputs |
| T12.3 | `nix eval sandbox@sandbox.config.home.homeDirectory` | PASS — `"/tmp/fulfran-dots-sandbox-home"` |
| T12.4 | `nix build sandbox@sandbox.activationPackage --no-link` | PASS — 17 derivations built, 133 paths fetched |
| T12.5 | `nix flake check --no-write-lock-file` (fulfran-dots) | PASS — exit 0 |

## Fix applied during Phase 12

`modules/dev/packages.nix`: renamed `poppler_utils` to `poppler-utils` (upstream nixpkgs rename).
This was caught by the sandbox build (T12.4).
