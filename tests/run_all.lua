-- Run all test specs in-process (same Neovim session as minimal_init).
-- This avoids the subprocess spawning issue in PlenaryBustedDirectory where
-- each child process re-sources init.lua in a different environment.
--
-- Usage (after lazy.nvim + plenary are installed):
--   nvim -u tests/minimal_init.lua --headless \
--     -c "luafile tests/run_all.lua" \
--     -c "qa"
--
-- Or from within Neovim:
--   :luafile tests/run_all.lua

local specs = vim.fn.glob(vim.fn.expand("~/.vim/tests/") .. "*_spec.lua", false, true)
table.sort(specs)

local ok, busted = pcall(require, "plenary.busted")
if not ok then
  error("plenary.nvim not loaded. Run nvim once to install plugins, then retry.")
end

for _, f in ipairs(specs) do
  busted.run(f)
end
