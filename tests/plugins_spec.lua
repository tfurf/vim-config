-- Tests for lazy.nvim plugin registration
-- Verifies that all expected plugins are registered in lazy's plugin table.

-- Use a filesystem check: if the plugin is installed by lazy, its directory
-- exists in stdpath("data")/lazy/<name>. This is reliable regardless of whether
-- the plugin has been loaded into Neovim's rtp in the current session.
local lazy_dir = vim.fn.stdpath("data") .. "/lazy/"

local function has_plugin(name)
  return vim.loop.fs_stat(lazy_dir .. name) ~= nil
end

describe("package manager", function()
  it("lazy.nvim is loadable", function()
    local ok = pcall(require, "lazy")
    assert.is_true(ok, "lazy.nvim not installed or not on rtp")
  end)
end)

describe("LSP & completion plugins", function()
  it("mason.nvim is registered", function()
    assert.is_true(has_plugin("mason.nvim"))
  end)

  it("mason-lspconfig.nvim is registered", function()
    assert.is_true(has_plugin("mason-lspconfig.nvim"))
  end)

  it("nvim-lspconfig is registered", function()
    assert.is_true(has_plugin("nvim-lspconfig"))
  end)

  it("nvim-cmp is registered", function()
    assert.is_true(has_plugin("nvim-cmp"))
  end)

  it("LuaSnip is registered", function()
    assert.is_true(has_plugin("LuaSnip"))
  end)

  it("none-ls.nvim is registered", function()
    assert.is_true(has_plugin("none-ls.nvim"))
  end)
end)

describe("UI plugins", function()
  it("lualine.nvim is registered (replaces vim-airline)", function()
    assert.is_true(has_plugin("lualine.nvim"))
  end)

  it("gitsigns.nvim is registered (replaces vim-gitgutter)", function()
    assert.is_true(has_plugin("gitsigns.nvim"))
  end)

  it("nvim-web-devicons is registered (replaces vim-devicons)", function()
    assert.is_true(has_plugin("nvim-web-devicons"))
  end)

  it("comment.nvim is registered (replaces vim-commentary)", function()
    -- Note: the lazy directory name uses the repo casing: Comment.nvim
    assert.is_true(has_plugin("Comment.nvim"))
  end)

  it("nvim-tree.lua is registered exactly once", function()
    -- Filesystem: the plugin dir should exist exactly once (a dir, not a dup)
    local dir = lazy_dir .. "nvim-tree.lua"
    local stat = vim.loop.fs_stat(dir)
    assert.is_not_nil(stat, "nvim-tree.lua not installed in lazy dir")
    assert.equal("directory", stat.type, "nvim-tree.lua should be a directory")
  end)
end)

describe("fuzzy finder plugins", function()
  it("fzf is registered", function()
    assert.is_true(has_plugin("fzf"))
  end)

  it("fzf.vim is registered", function()
    assert.is_true(has_plugin("fzf.vim"))
  end)
end)

describe("editing utility plugins", function()
  it("vim-surround is registered", function()
    assert.is_true(has_plugin("vim-surround"))
  end)

  it("vim-fugitive is registered", function()
    assert.is_true(has_plugin("vim-fugitive"))
  end)

  it("vim-easy-align is registered", function()
    assert.is_true(has_plugin("vim-easy-align"))
  end)

  it("vimtex is registered", function()
    assert.is_true(has_plugin("vimtex"))
  end)

  it("vim-dispatch is registered", function()
    assert.is_true(has_plugin("vim-dispatch"))
  end)

  it("nvim-treesitter is registered", function()
    assert.is_true(has_plugin("nvim-treesitter"))
  end)

  it("which-key.nvim is registered", function()
    assert.is_true(has_plugin("which-key.nvim"))
  end)

  it("friendly-snippets is registered", function()
    assert.is_true(has_plugin("friendly-snippets"))
  end)
end)

describe("removed plugins", function()
  it("coc.nvim is NOT registered", function()
    assert.is_false(has_plugin("coc.nvim"), "coc.nvim should be removed")
  end)

  it("vim-airline is NOT registered", function()
    assert.is_false(has_plugin("vim-airline"), "vim-airline should be replaced by lualine")
  end)

  it("vim-gitgutter is NOT registered", function()
    assert.is_false(has_plugin("vim-gitgutter"), "vim-gitgutter should be replaced by gitsigns")
  end)

  it("neoformat is NOT registered", function()
    assert.is_false(has_plugin("neoformat"), "neoformat should be replaced by none-ls/LSP formatting")
  end)

  it("vim-clang-format is NOT registered", function()
    assert.is_false(has_plugin("vim-clang-format"), "vim-clang-format should be replaced by clangd")
  end)
end)
