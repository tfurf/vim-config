-- =============================================================================
-- init.lua  —  Neovim configuration
-- Replaces init.vim + coc-settings.json.
-- Package manager: lazy.nvim (replaces vim-plug)
-- LSP/completion: nvim-lspconfig + mason + nvim-cmp (replaces coc.nvim)
-- Note: coc-settings.json is kept on disk but is no longer used.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. OPTIONS & GLOBALS
-- -----------------------------------------------------------------------------
vim.opt.encoding      = "utf-8"
vim.opt.hidden        = true
vim.opt.number        = true
vim.opt.expandtab     = true
vim.opt.shiftwidth    = 4
vim.opt.tabstop       = 4
vim.opt.smarttab      = true
vim.opt.smartcase     = true
vim.opt.ignorecase    = true
vim.opt.wrap          = false
vim.opt.wildmode      = { "list", "longest" }
vim.opt.laststatus    = 2
vim.opt.sessionoptions = { "blank", "buffers", "globals", "help", "localoptions", "options", "resize" }

-- Disable cursor shape changes (preserves terminal cursor)
vim.opt.guicursor = ""

-- Neovim's built-in 'compatible' mode is always off — no need to set nocp.
-- vim-sensible is also redundant for Neovim, so it is not included.

-- Python provider: use whatever python3 is on PATH rather than a hardcoded path
local py3 = vim.fn.exepath("python3")
if py3 ~= "" then
  vim.g.python3_host_prog = py3
end

-- Disable netrw in favour of nvim-tree
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- -----------------------------------------------------------------------------
-- 2. LAZY.NVIM BOOTSTRAP
-- -----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- -----------------------------------------------------------------------------
-- 3. LSP ON_ATTACH  (defined before plugins so specs can reference it)
-- -----------------------------------------------------------------------------
---@param _client table
---@param bufnr integer
_G.lsp_on_attach = function(_client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  -- Navigation
  map("n", "gd",          vim.lsp.buf.definition,      "Go to definition")
  map("n", "gy",          vim.lsp.buf.type_definition,  "Go to type definition")
  map("n", "gi",          vim.lsp.buf.implementation,   "Go to implementation")
  map("n", "gr",          vim.lsp.buf.references,       "List references")

  -- Refactor
  map("n", "<leader>rn",  vim.lsp.buf.rename,           "Rename symbol")
  map("n", "<leader>qf",  vim.lsp.buf.code_action,      "Code action / quick fix")
  map("n", "<leader>cl",  vim.lsp.codelens.run,         "Run code lens")

  -- Format (normal + visual)
  map("n", "<leader>f",   function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
  map("x", "<leader>f",   function() vim.lsp.buf.format({ async = true }) end, "Format selection")

  -- Hover / signature
  map("n", "K",           vim.lsp.buf.hover,            "Hover docs")
  map("n", "<C-k>",       vim.lsp.buf.signature_help,   "Signature help")
end

-- Apply on_attach to every server globally (Neovim 0.11 native API)
vim.lsp.config('*', { on_attach = _G.lsp_on_attach })

-- -----------------------------------------------------------------------------
-- 4. FORMAT-ON-SAVE AUTOCMD
-- -----------------------------------------------------------------------------
local fmt_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })

local fmt_filetypes = { "*.py", "*.json", "*.c", "*.cpp", "*.h", "*.md" }
for _, pat in ipairs(fmt_filetypes) do
  vim.api.nvim_create_autocmd("BufWritePre", {
    group   = fmt_group,
    pattern = pat,
    callback = function()
      vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
    end,
  })
end

-- -----------------------------------------------------------------------------
-- 5. PLUGINS
-- -----------------------------------------------------------------------------
require("lazy").setup({

  -- -------------------------------------------------------------------------
  -- Colorschemes
  -- -------------------------------------------------------------------------
  {
    "rebelot/kanagawa.nvim",
    lazy     = false,
    priority = 1000,
    config   = function()
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  { "chriskempson/base16-vim",       lazy = true },
  { "NLKNguyen/papercolor-theme",    lazy = true },
  { "sainnhe/gruvbox-material",      lazy = true },
  { "uloco/bluloco.nvim",            lazy = true, dependencies = { "rktjmp/lush.nvim" } },

  -- Commented-out colorschemes (uncomment to enable):
  -- { "altercation/vim-colors-solarized" },
  -- { "chriskempson/vim-tomorrow-theme" },
  -- { "sainnhe/everforest",
  --   config = function()
  --     vim.opt.background = "light"
  --     vim.g.everforest_background = "medium"
  --     vim.g.everforest_better_performance = 1
  --     vim.cmd.colorscheme("everforest")
  --   end,
  -- },

  -- -------------------------------------------------------------------------
  -- UI: statusline, icons, file tree, git signs
  -- -------------------------------------------------------------------------
  {
    -- Replaces vim-airline + vim-airline-themes
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme                = "papercolor_light",
        globalstatus         = true,
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
      },
      extensions = { "nvim-tree", "fugitive", "fzf", "lazy" },
      sections = {
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
      },
      tabline = {
        lualine_a = { "buffers" },
        lualine_z = { "tabs" },
      },
    },
  },

  {
    -- Replaces vim-devicons (also used by lualine, nvim-tree, fzf)
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<Leader>e", "<cmd>NvimTreeFocus<cr>", desc = "Focus file tree" },
    },
    opts = {},
  },

  {
    -- Replaces vim-gitgutter
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      -- Preserve original clear of SignColumn highlight
      vim.cmd("highlight clear SignColumn")
    end,
  },

  -- -------------------------------------------------------------------------
  -- Fuzzy finder
  -- -------------------------------------------------------------------------
  {
    "junegunn/fzf",
    build = function() vim.fn["fzf#install"]() end,
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    keys = {
      { "<Leader>t",   "<cmd>Files<cr>",   desc = "FZF: files" },
      { "<Leader>g",   "<cmd>GFiles<cr>",  desc = "FZF: git files" },
      { "<Leader>b",   "<cmd>Buffers<cr>", desc = "FZF: buffers" },
      { "<Leader>a",   "<cmd>Ag<cr>",      desc = "FZF: ag search" },
      { "<C-x><C-k>",  "<plug>(fzf-complete-word)", mode = "i", desc = "FZF: complete word" },
      { "<C-x><C-f>",  "<plug>(fzf-complete-path)", mode = "i", desc = "FZF: complete path" },
      { "<C-x><C-j>",  "<plug>(fzf-complete-file)", mode = "i", desc = "FZF: complete file" },
      { "<C-x><C-l>",  "<plug>(fzf-complete-line)", mode = "i", desc = "FZF: complete line" },
    },
    config = function()
      vim.g.fzf_layout         = { down = "~40%" }
      vim.g.fzf_preview_window = { "down:40%" }
    end,
  },

  -- -------------------------------------------------------------------------
  -- Editing utilities
  -- -------------------------------------------------------------------------
  {
    -- Replaces vim-commentary
    "numToStr/Comment.nvim",
    keys = { { "gc", mode = { "n", "v" } }, { "gcc", mode = "n" } },
    opts = {},
  },

  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = "x", desc = "Easy align (visual)" },
      { "ga", "<Plug>(EasyAlign)", mode = "n", desc = "Easy align (normal)" },
    },
  },

  { "tpope/vim-surround",    event = "VeryLazy" },
  { "tpope/vim-unimpaired",  event = "VeryLazy" },
  { "tpope/vim-repeat",      event = "VeryLazy" },
  { "tpope/vim-abolish",     event = "VeryLazy" },
  { "tpope/vim-dispatch",    cmd   = { "Dispatch", "Make", "Focus", "Start" } },
  { "tpope/vim-fugitive",    event = "VeryLazy" },

  {
    "chrisbra/vim-diff-enhanced",
    cond = vim.fn.has("nvim") == 1,
    config = function()
      if vim.opt.diff:get() then
        vim.opt.diffexpr = 'EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
      end
    end,
  },

  -- -------------------------------------------------------------------------
  -- Language-specific
  -- -------------------------------------------------------------------------
  {
    "lervag/vimtex",
    ft = "tex",
    -- texlab (Mason) provides LSP; vimtex provides compile/view/navigation
  },

  {
    "plasticboy/vim-markdown",
    ft = "markdown",
  },

  -- Commented-out plugins (preserved for reference):
  -- { "psf/black",             branch = "stable", ft = "python" },  -- use ruff (LSP) instead
  -- { "nvie/vim-flake8" },                                           -- use pyright/ruff LSP instead
  -- { "rdnetto/YCM-Generator", branch = "stable" },                  -- YCM removed
  -- { "Valloric/YouCompleteMe" },                                     -- replaced by native LSP
  -- { "SirVer/ultisnips" },                                          -- replaced by LuaSnip
  -- { "honza/vim-snippets" },
  -- { "beloglazov/vim-online-thesaurus" },
  -- { "derekwyatt/vim-fswitch" },
  -- { "derekwyatt/vim-protodef" },

  -- -------------------------------------------------------------------------
  -- AI / coding assistant
  -- -------------------------------------------------------------------------
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
  },

  -- -------------------------------------------------------------------------
  -- LSP: mason + mason-lspconfig + nvim-lspconfig
  -- -------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts  = {},
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        -- Automatically install these LSP servers via Mason on first launch.
        -- Requires: node/npm (install via nvm) for the npm-based servers.
        -- coc extension → Mason server mapping:
        --   coc-pyright        → pyright         (npm)
        --   coc-json           → jsonls           (npm)
        --   coc-tsserver       → ts_ls            (npm)
        --   coc-yaml           → yamlls           (npm)
        --   coc-clangd         → clangd           (pre-built binary)
        --   coc-vimtex         → texlab           (pre-built binary)
        --
        -- NOT managed by Mason (installed via uv — see section 6 below):
        --   coc-pyright fmt    → ruff             (uv tool install ruff)
        --   coc-cmake          → cmake-language-server (uv tool install cmake-language-server)
        ensure_installed = {
          "pyright",
          "jsonls",
          "ts_ls",
          "yamlls",
          "clangd",
          "texlab",
        },
        -- Use vim.lsp.enable() per server (Neovim 0.11 native API).
        -- on_attach and capabilities are set globally via vim.lsp.config('*', ...).
        handlers = {
          function(server_name)
            vim.lsp.enable(server_name)
          end,
        },
      })

      -- clangd: extra compiler analysis flags
      vim.lsp.config('clangd', {
        cmd = { "clangd", "--clang-tidy", "--background-index", "--suggest-missing-includes" },
      })

      -- ruff and cmake-language-server are NOT in ensure_installed because
      -- they are installed via `uv tool` (not Mason/npm/pip).
      -- Install: uv tool install ruff && uv tool install cmake-language-server
      if vim.fn.executable("ruff") == 1 then
        vim.lsp.config('ruff', {
          on_attach = function(client, bufnr)
            -- pyright handles hover; ruff is lint/format only
            client.server_capabilities.hoverProvider = false
            _G.lsp_on_attach(client, bufnr)
          end,
        })
        vim.lsp.enable('ruff')
      end
      if vim.fn.executable("cmake-language-server") == 1 then
        vim.lsp.enable('cmake')
      end
    end,
  },

  -- none-ls: bridges markdownlint-cli2 (coc-markdownlint equivalent) into LSP
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        on_attach = _G.lsp_on_attach,
        sources = {
          -- coc-markdownlint equivalent
          null_ls.builtins.diagnostics.markdownlint_cli2,
        },
      })
    end,
  },

  -- -------------------------------------------------------------------------
  -- Completion: nvim-cmp + sources + LuaSnip
  -- -------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          -- TAB: cycle through completions (mirrors old coc TAB behaviour)
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- CR: confirm selection (mirrors old coc CR behaviour)
          ["<CR>"] = cmp.mapping.confirm({ select = false }),

          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip"  },
        }, {
          { name = "buffer" },
          { name = "path"   },
        }),
      })

      -- Advertise nvim-cmp completion capabilities to every LSP server
      vim.lsp.config('*', {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
    end,
  },

  -- -------------------------------------------------------------------------
  -- Testing infrastructure (plenary — also used by several plugins)
  -- -------------------------------------------------------------------------
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

}, {
  -- lazy.nvim global options
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      -- Remove built-in plugins superseded by the config above
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})

-- -----------------------------------------------------------------------------
-- 6. HARPER-LS
-- -----------------------------------------------------------------------------
vim.lsp.enable("harper-ls")

-- -----------------------------------------------------------------------------
-- 7. MISCELLANEOUS KEYMAPS
-- -----------------------------------------------------------------------------
-- Pandoc: convert markdown pipe tables to grid tables (from previous init.lua)
vim.keymap.set(
  "v", "<leader>gt",
  ":!pandoc -f markdown -t markdown-pipe_tables+grid_tables --columns=60<CR>",
  { desc = "Convert markdown table to grid format" }
)

-- FZF keymaps (mirrors lazy keys: entries above; registered here so they are
-- always visible even when lazy's key-handler stubs are not yet installed)
vim.keymap.set("n", "<Leader>t", "<cmd>Files<cr>",   { desc = "FZF: files" })
vim.keymap.set("n", "<Leader>g", "<cmd>GFiles<cr>",  { desc = "FZF: git files" })
vim.keymap.set("n", "<Leader>b", "<cmd>Buffers<cr>", { desc = "FZF: buffers" })
vim.keymap.set("n", "<Leader>a", "<cmd>Ag<cr>",      { desc = "FZF: ag search" })

-- nvim-tree keymap (mirrors lazy keys: entry above)
vim.keymap.set("n", "<Leader>e", "<cmd>NvimTreeFocus<cr>", { desc = "Focus file tree" })

-- vim-easy-align keymaps (mirrors lazy keys: entries above)
vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { desc = "Easy align (visual)" })
vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { desc = "Easy align (normal)" })
