This is largely a fork of [derekwyatt's vim-config](https://github.com/derekwyatt/vim-config).

## Installation

Clone the repo and symlink it so Neovim finds it:

```bash
cd ~
git clone https://github.com/tfurf/vim-config .vim
cd .vim
bash install.bash
```

`install.bash` creates `~/.config/nvim → ~/.vim`.

On first launch, [lazy.nvim](https://github.com/folke/lazy.nvim) will bootstrap itself and install all plugins. [mason.nvim](https://github.com/williamboman/mason.nvim) will then install LSP servers in the background.

### Prerequisites

| Requirement | Used for |
|---|---|
| Neovim ≥ 0.11 | native `vim.lsp.config` API |
| Node / npm (via [nvm](https://github.com/nvm-sh/nvm)) | pyright, json-lsp, ts_ls, yaml-lsp |
| [uv](https://github.com/astral-sh/uv) | ruff, cmake-language-server |
| git | lazy.nvim, plugin updates |

Install Python LSP tools:
```bash
uv tool install ruff
uv tool install cmake-language-server
```

## Running tests

The config ships with a [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) busted test suite:

```bash
nvim --headless \
  -c "PlenaryBustedDirectory tests/ {minimal_init='tests/minimal_init.lua',sequential=true}" \
  -c "qa"
```

Expected: 67 tests across 4 spec files, 0 failures.

---

## 2025–26 migration: `init.vim` → `init.lua`

The original `init.vim` (kept as `init.vim.bak`) was rewritten in Lua with the following modernisations:

### Package manager

| Before | After |
|---|---|
| [vim-plug](https://github.com/junegunn/vim-plug) | [lazy.nvim](https://github.com/folke/lazy.nvim) |

Plugins are now declared with lazy-loading specs (`keys`, `event`, `ft`, `cmd`). lazy.nvim bootstraps itself from git on first launch.

### LSP & completion

| Before | After |
|---|---|
| coc.nvim + 8 coc extensions | nvim-lspconfig + mason.nvim + nvim-cmp |
| coc-settings.json | `vim.lsp.config` / `vim.lsp.enable` (Neovim 0.11 native API) |

coc extension → server mapping:

| coc extension | Mason / uv server |
|---|---|
| coc-pyright | pyright (Mason/npm) |
| coc-pyright fmt | ruff (`uv tool install ruff`) |
| coc-json | json-lsp (Mason/npm) |
| coc-tsserver | typescript-language-server (Mason/npm) |
| coc-yaml | yaml-language-server (Mason/npm) |
| coc-clangd | clangd (Mason/binary) |
| coc-cmake | cmake-language-server (`uv tool install cmake-language-server`) |
| coc-vimtex | texlab (Mason/binary) |
| coc-markdownlint | markdownlint-cli2 via none-ls.nvim |

### UI plugins

| Before | After |
|---|---|
| vim-airline + vim-airline-themes | lualine.nvim |
| vim-gitgutter | gitsigns.nvim |
| vim-devicons | nvim-web-devicons |
| vim-commentary | Comment.nvim |
| vim-clang-format | clangd LSP format-on-save |
| neoformat | LSP `BufWritePre` format-on-save |

As per usual, it's provided without any express guarantee of anything.
