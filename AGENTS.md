# Agent instructions for tfurf/vim-config

This file tells AI coding agents how to work safely and effectively in this repository.

## What this repo is

A Neovim configuration written in Lua. The entry point is `init.lua`; `init.vim.bak` is the old vimscript config kept for reference only. The directory is symlinked as `~/.config/nvim`.

## Test-driven workflow

**Always run the test suite before and after making changes.**

```bash
cd ~/.vim
nvim --headless \
  -c "PlenaryBustedDirectory tests/ {minimal_init='tests/minimal_init.lua',sequential=true}" \
  -c "qa"
```

Expected output: 67 tests, 0 failures, 0 errors across 4 spec files.

The specs live in `tests/`:

| File | What it covers |
|---|---|
| `options_spec.lua` | `vim.opt.*` settings |
| `keymaps_spec.lua` | Key bindings (fzf, nvim-tree, easy-align, LSP, etc.) |
| `plugins_spec.lua` | lazy.nvim plugin registration; removed plugins absent |
| `lsp_spec.lua` | LSP server configs present; `_G.lsp_on_attach` behaviour |

`tests/minimal_init.lua` is the test bootstrap. It calls `vim.loader.enable()` before loading `init.lua` — this is required because plenary's `PlenaryBustedDirectory` passes `--noplugin` to its subprocess, which prevents lazy.nvim's module cache from initialising otherwise.

## Key design decisions (do not undo silently)

- **lazy.nvim** is the package manager. Plugins live under `~/.local/share/nvim/lazy/`.
- **LSP uses Neovim 0.11 native API** (`vim.lsp.config`, `vim.lsp.enable`) — do *not* revert to `require("lspconfig").server.setup()`, which is deprecated.
- **`_G.lsp_on_attach`** is a global function so tests can call it directly.
- **`vim.lsp.config('*', { on_attach = ..., capabilities = ... })`** applies shared LSP settings globally; individual servers only need overrides.
- **ruff and cmake-language-server** are installed via `uv tool`, not Mason. They are guarded with `vim.fn.executable()` checks and enabled with `vim.lsp.enable()`.
- **Keymaps for fzf / nvim-tree / easy-align** are registered with both `lazy keys:` (for lazy-loading) and explicit `vim.keymap.set()` calls (for testability with `--noplugin`).

## When editing `init.lua`

1. Run tests before your change to establish a baseline.
2. Make the change.
3. Run tests again and confirm the same or better counts.
4. If a test for the changed behaviour doesn't exist, add one.

## Gotchas

- `PlenaryBustedDirectory` spawns a subprocess with `--noplugin`. This means `vim.loader` is not active and lazy's internal module cache does not populate `config.plugins`. Do not rely on `lazy.core.config.plugins` in tests — use filesystem checks (`vim.loop.fs_stat`) or `vim.fn.maparg` instead.
- `init.lua` and `init.vim` must not coexist in `~/.config/nvim` — Neovim raises E5422. The old config is `init.vim.bak`.
- `~/.config/nvim` is a symlink to `~/.vim`. Recreate with `ln -s ~/.vim ~/.config/nvim` if missing.
- Mason servers require external runtimes: npm (via nvm) for JS-based servers; the `uv` Python tool manager for ruff/cmake.

## LSP servers

| Server | Manager | Filetype |
|---|---|---|
| pyright | Mason (npm) | Python |
| ruff | uv | Python |
| json-lsp | Mason (npm) | JSON |
| typescript-language-server | Mason (npm) | JS/TS |
| yaml-language-server | Mason (npm) | YAML |
| clangd | Mason (binary) | C/C++ |
| texlab | Mason (binary) | LaTeX |
| cmake-language-server | uv | CMake |
| harper-ls | `vim.lsp.enable` | prose/markdown |

## General Workflows

- Don't add any helper scripts when a oneliner in README is sufficient.
- Be concise with everything - less verbage is better.
- Maintain work items in `TODO` section of `README.md`