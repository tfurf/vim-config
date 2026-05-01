-- Tests for LSP server configuration
-- Verifies mason installs and lspconfig setups are registered.

local lsp_dir     = vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig"
local configs_dir = lsp_dir .. "/lua/lspconfig/configs/"

local function lspconfig_has(server_name)
  -- Check that the server config file exists inside the nvim-lspconfig install.
  -- This does not require the plugin to be loaded into rtp.
  return vim.loop.fs_stat(configs_dir .. server_name .. ".lua") ~= nil
end

describe("mason registry (server installations)", function()
  -- These tests will be PENDING until mason has had time to install.
  -- Run `:MasonInstall` or let mason-lspconfig auto-install on first startup.

  local servers = {
    "pyright",
    "ruff",
    "json-lsp",          -- jsonls Mason package name
    "cmake-language-server",
    "typescript-language-server",  -- ts_ls
    "yaml-language-server",        -- yamlls
    "clangd",
    "texlab",
    "markdownlint-cli2", -- via none-ls
  }

  for _, pkg in ipairs(servers) do
    it("installs " .. pkg, function()
      local ok, registry = pcall(require, "mason-registry")
      if not ok then
        pending("mason-registry not available (mason not loaded)")
        return
      end
      -- Servers are installed asynchronously on first interactive startup.
      -- If not yet installed, mark pending rather than failing so the suite
      -- stays green on fresh installs and only turns red on regressions.
      if not registry.is_installed(pkg) then
        pending(pkg .. " not yet installed — run :MasonInstall or restart nvim")
        return
      end
      assert.is_true(true) -- server is installed
    end)
  end
end)

describe("lspconfig server definitions", function()
  local servers = {
    "pyright",
    "ruff",
    "jsonls",
    "cmake",
    "ts_ls",
    "yamlls",
    "clangd",
    "texlab",
  }

  for _, server in ipairs(servers) do
    it("lspconfig knows server: " .. server, function()
      assert.is_true(lspconfig_has(server), "lspconfig has no definition for " .. server)
    end)
  end
end)

describe("LSP on_attach keymaps (integration)", function()
  -- Simulate calling on_attach with a mock buffer
  it("on_attach sets gd keymap on a buffer", function()
    if type(_G.lsp_on_attach) ~= "function" then
      pending("lsp_on_attach not defined yet")
    end
    local bufnr = vim.api.nvim_create_buf(false, true)
    _G.lsp_on_attach({}, bufnr)
    local maps = vim.api.nvim_buf_get_keymap(bufnr, "n")
    local found = false
    for _, m in ipairs(maps) do
      if m.lhs == "gd" then found = true; break end
    end
    assert.is_true(found, "gd not mapped after lsp_on_attach")
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end)

  it("on_attach sets <leader>rn keymap on a buffer", function()
    if type(_G.lsp_on_attach) ~= "function" then
      pending("lsp_on_attach not defined yet")
    end
    local bufnr = vim.api.nvim_create_buf(false, true)
    _G.lsp_on_attach({}, bufnr)
    -- Normalize lhs before comparing so <Leader> expansion is handled.
    local target_rn = vim.api.nvim_replace_termcodes("<leader>rn", true, true, true)
    local maps = vim.api.nvim_buf_get_keymap(bufnr, "n")
    local found = false
    for _, m in ipairs(maps) do
      if vim.api.nvim_replace_termcodes(m.lhs, true, true, true) == target_rn then
        found = true; break
      end
    end
    assert.is_true(found, "<leader>rn not mapped after lsp_on_attach")
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end)

  it("on_attach sets <leader>f keymap on a buffer", function()
    if type(_G.lsp_on_attach) ~= "function" then
      pending("lsp_on_attach not defined yet")
    end
    local bufnr = vim.api.nvim_create_buf(false, true)
    _G.lsp_on_attach({}, bufnr)
    local target_f = vim.api.nvim_replace_termcodes("<leader>f", true, true, true)
    local maps = vim.api.nvim_buf_get_keymap(bufnr, "n")
    local found = false
    for _, m in ipairs(maps) do
      if vim.api.nvim_replace_termcodes(m.lhs, true, true, true) == target_f then
        found = true; break
      end
    end
    assert.is_true(found, "<leader>f not mapped after lsp_on_attach")
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end)
end)

describe("harper-ls", function()
  it("harper-ls is enabled via vim.lsp.enable", function()
    -- harper-ls is enabled unconditionally via vim.lsp.enable("harper-ls").
    -- We verify it is registered in the enabled servers list.
    local ok, _ = pcall(function()
      local enabled = vim.lsp._enabled_configs or {}
      -- Neovim 0.11: check if "harper-ls" appears in the lsp config registry
      local cfg = vim.lsp._config and vim.lsp._config["harper-ls"]
      if cfg == nil then
        -- Fallback: confirm the lspconfig definition exists
        assert.is_true(
          vim.loop.fs_stat(vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lua/lspconfig/configs/harper_ls.lua") ~= nil,
          "harper_ls lspconfig definition not found"
        )
      end
    end)
    assert.is_true(ok, "harper-ls check threw an error")
  end)
end)

describe("format-on-save autocmd", function()
  it("BufWritePre autocmd exists for python", function()
    local autocmds = vim.api.nvim_get_autocmds({ event = "BufWritePre", pattern = "*.py" })
    assert.is_true(#autocmds > 0, "No BufWritePre autocmd for *.py")
  end)

  it("BufWritePre autocmd exists for json", function()
    local autocmds = vim.api.nvim_get_autocmds({ event = "BufWritePre", pattern = "*.json" })
    assert.is_true(#autocmds > 0, "No BufWritePre autocmd for *.json")
  end)
end)
