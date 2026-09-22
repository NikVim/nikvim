# Changelog

All notable changes to this project are documented here.

## [0.2.0] - 2026-09-22

### Bug Fixes

- Scope luacheck to project files, not vendored luarocks
- Drop gitignored after/ from CI file lists
- *(formatters)* Resolve stylua.toml via buffer path, not cwd
- *(formatters)* Keep override winning after a later LSP attach

### Documentation

- State neovim 0.12+ requirement for lsp module

### Features

- *(indent)* Add consolidated indent module with per-filetype overrides
- *(lsp)* Add lua_ls support with codelens/inlay hint toggles
- *(diagnostic)* Add diagnostic display config and keymaps
- *(keymaps)* Dismiss floats, quickfix/loclist and search highlight on <Esc>
- *(fold)* Add fold configuration
- *(formatters)* Add formatter override
- *(completion)* Add completion configuration
- *(completion)* Auto-show completion docs and signature help

### Miscellaneous Tasks

- Add v0.1.0 changelog
- Add CI workflow for lint, format, and smoke tests
- Wire up indent module in init.lua
- Wire up lsp module in init.lua
- Lint lsp directory in ci
- Wire up diagnostic module in init.lua
- Wire up fold module in init.lua
- Wire up formatters module in init.lua
- Add .luarc.json for vim global
- Wire up completion module in init.lua

### Refactor

- *(options)* Remove indent options, now in indent.lua
- *(keymaps)* Remove indent shift keymaps, now in indent.lua
- *(options)* Remove completion options, now in completion.lua
## [0.1.0] - 2026-09-18

### Documentation

- Add contributing guide
- Add README
- Document release workflow in contributing guide

### Features

- Enable native ui2 message and cmdline UI
- *(options)* Add native editing and UI defaults
- Load options module
- *(keymaps)* Add navigation and editing keymaps
- Load keymaps module
- *(autocmds)* Add quality-of-life autocmds
- Load autocmds module

### Miscellaneous Tasks

- Initial commit
- Add MIT license
- Add commit message skill
- Add gitignore
- Add CLAUDE.md
- Ignore local scratch keymap file
- Add git-cliff changelog configuration
- Add conventional commit-msg hook

