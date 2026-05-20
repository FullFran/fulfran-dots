# fulfran-dots

Public, reusable dotfiles base.

This sandbox repo is a local prototype for splitting shared configuration from
private machine/user overrides. It should contain only portable modules,
presets, examples, and future configuration UI code.

## Architecture

```text
fulfran-dots        -> public shared source of truth
dotfiles-private    -> imports fulfran-dots and adds private overrides
```

The public base must not know real usernames, private hostnames, secrets, local
AI credentials, or machine-specific keyboard/device paths.

## Current prototype scope

- Core CLI packages
- Shell defaults
- Terminal tools
- Development tools
- Example Home Manager host

Not included yet:

- Private host profiles
- Claude/OpenCode/Codex/Gemini local wiring
- Kanata laptop-specific config
- Real installer touching `$HOME`
