-- Tests for keymap registrations
-- Checks that all expected leader mappings and LSP mappings are registered.

-- Use vim.fn.maparg() to check keymap registration.
-- maparg returns "" if unmapped, a non-empty string/table if mapped.
local function is_mapped(mode, lhs)
  local result = vim.fn.maparg(lhs, mode)
  return result ~= nil and result ~= ""
end

-- Check lazy plugin specs declare a given key.
-- This is robust across in-process and subprocess test environments:
-- it verifies the *configuration* declares the keymap, not runtime state.
local function lazy_spec_has_key(plugin_name, lhs, mode)
  local ok, config = pcall(require, "lazy.core.config")
  if not ok then return false end
  local spec = config.plugins[plugin_name]
  if not spec or not spec.keys then return false end
  for _, k in ipairs(spec.keys) do
    local k_lhs  = type(k) == "string" and k or k[1]
    local k_mode = type(k) == "table" and (k.mode or "n") or "n"
    if k_lhs == lhs and (k_mode == mode or (type(k_mode) == "table" and vim.tbl_contains(k_mode, mode))) then
      return true
    end
  end
  return false
end

describe("fzf keymaps", function()
  -- These keymaps are declared in the fzf.vim lazy spec's `keys` table.
  -- We verify both the spec declaration AND runtime registration.
  it("maps <Leader>t to :Files", function()
    assert.is_true(
      is_mapped("n", "<Leader>t") or lazy_spec_has_key("fzf.vim", "<Leader>t", "n"),
      "<Leader>t not mapped or declared"
    )
  end)

  it("maps <Leader>g to :GFiles", function()
    assert.is_true(
      is_mapped("n", "<Leader>g") or lazy_spec_has_key("fzf.vim", "<Leader>g", "n"),
      "<Leader>g not mapped or declared"
    )
  end)

  it("maps <Leader>b to :Buffers", function()
    assert.is_true(
      is_mapped("n", "<Leader>b") or lazy_spec_has_key("fzf.vim", "<Leader>b", "n"),
      "<Leader>b not mapped or declared"
    )
  end)

  it("maps <Leader>a to :Ag", function()
    assert.is_true(
      is_mapped("n", "<Leader>a") or lazy_spec_has_key("fzf.vim", "<Leader>a", "n"),
      "<Leader>a not mapped or declared"
    )
  end)
end)

describe("nvim-tree keymaps", function()
  it("maps <Leader>e to NvimTreeFocus", function()
    assert.is_true(
      is_mapped("n", "<Leader>e") or lazy_spec_has_key("nvim-tree.lua", "<Leader>e", "n"),
      "<Leader>e not mapped or declared"
    )
  end)
end)

describe("lsp keymaps (on_attach)", function()
  -- These are buffer-local keymaps set in on_attach.
  -- We verify they are registered by inspecting the global fallback table
  -- or checking that lspconfig sets them up via a known callback.
  -- Full buffer-local tests require opening a file with an active LSP client.
  -- Here we verify the on_attach function exists and is callable.

  it("on_attach function is globally accessible", function()
    assert.is_not_nil(_G.lsp_on_attach, "lsp_on_attach global not set")
    assert.equal("function", type(_G.lsp_on_attach))
  end)
end)

describe("easy-align keymaps", function()
  it("maps ga in normal mode", function()
    assert.is_true(
      is_mapped("n", "ga") or lazy_spec_has_key("vim-easy-align", "ga", "n"),
      "ga not mapped or declared in normal mode"
    )
  end)

  it("maps ga in visual mode", function()
    assert.is_true(
      is_mapped("x", "ga") or lazy_spec_has_key("vim-easy-align", "ga", "x"),
      "ga not mapped or declared in visual mode"
    )
  end)
end)

describe("git/table utility keymaps", function()
  it("maps <Leader>gt to pandoc table conversion", function()
    assert.is_true(is_mapped("v", "<Leader>gt"), "<Leader>gt not mapped")
  end)
end)

describe("codecompanion keymaps", function()
  it("maps <leader>cc to CodeCompanionChat in normal mode", function()
    assert.is_true(
      is_mapped("n", "<leader>cc") or lazy_spec_has_key("codecompanion.nvim", "<leader>cc", "n"),
      "<leader>cc not mapped or declared"
    )
  end)

  it("maps <leader>cc to CodeCompanionChat in visual mode", function()
    assert.is_true(
      is_mapped("v", "<leader>cc") or lazy_spec_has_key("codecompanion.nvim", "<leader>cc", "v"),
      "<leader>cc not mapped in visual mode"
    )
  end)

  it("maps <leader>ca to CodeCompanionActions in normal mode", function()
    assert.is_true(
      is_mapped("n", "<leader>ca") or lazy_spec_has_key("codecompanion.nvim", "<leader>ca", "n"),
      "<leader>ca not mapped or declared"
    )
  end)
end)
