-- Tests for vim options and globals
-- Run via: :PlenaryBustedDirectory tests/
-- or: nvim --headless -c "PlenaryBustedDirectory tests/ {minimal_init='tests/minimal_init.lua'}" -c "qa"

local eq = assert.are.equal

describe("editor options", function()
  it("uses spaces for indentation", function()
    eq(true, vim.opt.expandtab:get())
  end)

  it("uses 4-space indent", function()
    eq(4, vim.opt.shiftwidth:get())
    eq(4, vim.opt.tabstop:get())
  end)

  it("enables line numbers", function()
    eq(true, vim.opt.number:get())
  end)

  it("enables smart case search", function()
    eq(true, vim.opt.ignorecase:get())
    eq(true, vim.opt.smartcase:get())
  end)

  it("disables line wrap", function()
    eq(false, vim.opt.wrap:get())
  end)

  it("uses utf-8 encoding", function()
    eq("utf-8", vim.opt.encoding:get())
  end)

  it("uses longest wildmode completion", function()
    local wm = vim.opt.wildmode:get()
    assert.is_true(vim.tbl_contains(wm, "longest") or type(wm) == "string" and wm:find("longest") ~= nil)
  end)

  it("disables cursor style change (nvim)", function()
    -- guicursor should be empty/unset to prevent cursor shape changes.
    -- Neovim 0.11+ returns {} (empty table) for an empty opt value.
    local gc = vim.opt.guicursor:get()
    local is_empty = (type(gc) == "string" and gc == "")
                  or (type(gc) == "table"  and #gc == 0)
    assert.is_true(is_empty, "guicursor should be empty, got: " .. vim.inspect(gc))
  end)

  it("enables hidden buffers", function()
    eq(true, vim.opt.hidden:get())
  end)

  it("enables smart indentation", function()
    eq(true, vim.opt.smarttab:get())
  end)

  it("shows statusline always", function()
    eq(2, vim.opt.laststatus:get())
  end)

  it("includes useful session options", function()
    local so = vim.opt.sessionoptions:get()
    local required = { "blank", "buffers", "globals", "help", "localoptions", "options", "resize" }
    for _, v in ipairs(required) do
      assert.is_true(vim.tbl_contains(so, v), "sessionoptions missing: " .. v)
    end
  end)
end)
