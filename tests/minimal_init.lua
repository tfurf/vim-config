-- Minimal init for running plenary tests headlessly.
-- Loads lazy.nvim (which in turn loads all plugins) so that
-- tests can inspect the fully-configured state.
--
-- Usage:
--   nvim --headless -c "PlenaryBustedDirectory tests/ {minimal_init='tests/minimal_init.lua'}" -c "qa"
--
-- IMPORTANT: Plenary sources this file once per test-file in the same Neovim
-- process. The guard below prevents lazy.setup() from being called more than
-- once, which would reset keymap state and corrupt the plugin registry.
if vim.g.minimal_init_done then return end
vim.g.minimal_init_done = true

-- Enable the Neovim bytecode cache loader (normally activated by plugin/netrwPlugin.vim etc).
-- Plenary's PlenaryBustedDirectory passes --noplugin, which skips the normal loader init,
-- causing lazy.nvim's module cache to not populate package.loaded properly.
if vim.loader then
  vim.loader.enable()
end

-- Make sure the vim config root is on the runtimepath
vim.opt.rtp:prepend(vim.fn.expand("~/.vim"))

-- Bootstrap lazy.nvim if needed (same logic as init.lua)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Source the main init to get all plugins + config loaded
local ok, err = pcall(dofile, vim.fn.expand("~/.vim/init.lua"))
if not ok then
  vim.notify("minimal_init: failed to load init.lua: " .. tostring(err), vim.log.levels.ERROR)
end

-- Ensure plenary itself is available for the test runner
local plenary_ok = pcall(require, "plenary")
if not plenary_ok then
  local plenary_path = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
  if vim.loop.fs_stat(plenary_path) then
    vim.opt.rtp:prepend(plenary_path)
  else
    error("plenary.nvim not found. Run nvim once to let lazy.nvim install plugins first.")
  end
end

-- Force-load plugins that tests need to inspect.
-- lazy.load() is not supported in headless mode (it needs the manage subsystem),
-- so we add each plugin's directory to rtp directly instead.
local lazy_data = vim.fn.stdpath("data") .. "/lazy/"
local plugins_to_load = {
  "nvim-lspconfig",
  "mason.nvim",
  "mason-lspconfig.nvim",
  "none-ls.nvim",
  "nvim-cmp",
  "nvim-tree.lua",
  "fzf.vim",
  "vim-easy-align",
  "Comment.nvim",
  "lualine.nvim",
  "gitsigns.nvim",
  "plenary.nvim",
}
for _, name in ipairs(plugins_to_load) do
  local dir = lazy_data .. name
  if vim.loop.fs_stat(dir) then
    vim.opt.rtp:prepend(dir)
  end
end
