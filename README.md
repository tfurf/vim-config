This is largely a fork of [derekwyatt's vim-config](https://github.com/derekwyatt/vim-config).

## TODO

### AI / agent integration (codecompanion.nvim)

`codecompanion.nvim` is already registered as a lazy plugin (`event = "VeryLazy"`) but not yet configured.

Goal: wire it up to a self-hosted OpenAI-compatible API server so chat and inline agent workflows are available directly in Neovim.

Steps:
1. Configure an adapter pointing at the local server, e.g.:
   ```lua
   require("codecompanion").setup({
     adapters = {
       my_server = function()
         return require("codecompanion.adapters").extend("openai_compatible", {
           env = { url = "http://localhost:11434" },  -- adjust port/host
           schema = { model = { default = "your-model-name" } },
         })
       end,
     },
     strategies = {
       chat   = { adapter = "my_server" },
       inline = { adapter = "my_server" },
     },
   })
   ```
2. Add keymaps (e.g. `<leader>cc` for chat, `<leader>ca` for inline action).
3. Write tests: at minimum check that the adapter name appears in the codecompanion config and that the keymaps are registered.
4. Verify `:CodeCompanionChat` opens and can reach the server.

Reference: <https://github.com/olimorris/codecompanion.nvim>

---

### Fuzzy finder: evaluate telescope.nvim vs fzf.vim

Currently using `fzf` + `fzf.vim`. [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) is the more common Lua-native choice and has a richer extension ecosystem (LSP pickers, git, diagnostics, etc.).

Evaluation checklist:
- [ ] Install `telescope.nvim` + `telescope-fzf-native.nvim` alongside fzf.vim (not replacing it yet)
- [ ] Compare: file search, live grep, buffer list, LSP references/definitions
- [ ] Check startup-time impact (`--startuptime` before/after)
- [ ] Check whether `fzf-complete-*` insert-mode mappings have telescope equivalents
- [ ] Decide: migrate fully, keep both, or stay with fzf.vim
- [ ] If migrating: update keymaps in `init.lua`, update `keymaps_spec.lua` tests, remove fzf.vim

---

## Installation

Clone the repo and symlink it so Neovim finds it:

```bash
cd ~
git clone https://github.com/tfurf/vim-config .vim
ln -s ~/.vim ~/.config/nvim
```

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
