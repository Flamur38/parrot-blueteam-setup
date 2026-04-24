local opt = vim.opt

-- Line Numbers
opt.relativenumber = true       -- Show relative line numbers
opt.number = true               -- Show absolute line number on the current line

-- Tabs & Indentation
opt.tabstop = 4                 -- Number of spaces for a tab
opt.shiftwidth = 4              -- Number of spaces for autoindent
opt.expandtab = true            -- Convert tabs to spaces
opt.smartindent = true          -- Smart autoindenting on new lines
opt.softtabstop = 4             -- Spaces when pressing tab in insert mode

-- Line Wrapping
opt.wrap = false                -- Disable line wrapping

-- Search Settings
opt.ignorecase = true           -- Ignore case when searching...
opt.smartcase = true            -- ...unless capital letters are used

-- Cursor Line
opt.cursorline = true        -- Highlight the current line (disabled by default)

-- Appearance
opt.termguicolors = true        -- Enable 24-bit RGB colors
opt.background = "dark"         -- Set background for colorschemes
opt.signcolumn = "yes"          -- Always show the sign column
opt.showmode = true             -- Don't show current mode (e.g., -- INSERT --)

-- Backspace
opt.backspace = "indent,eol,start" -- Allow backspace over everything in insert mode

-- Clipboard
opt.clipboard:append("unnamedplus") -- Use system clipboard

-- Consider - as part of a keyword
opt.iskeyword:append("-")        -- So `foo-bar` is treated as one word

-- Disable the mouse while in nvim
opt.mouse = ""                   -- No mouse support

-- Folding
opt.foldlevel = 20              -- Open most folds by default

-- Scrolling
vim.opt.scrolloff = 8           -- Keep 8 lines visible above/below cursor

-- Cursor
vim.opt.guicursor = ""          -- Keep block cursor in all modes



-- Remove background from comments globally
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    local comment = vim.api.nvim_get_hl(0, { name = "Comment" })
    comment.bg = nil
    vim.api.nvim_set_hl(0, "Comment", comment)
    vim.api.nvim_set_hl(0, "SpecialComment", { bg = "NONE" })
  end,
})

-- Force no background on all highlight groups for all themes
local function clear_backgrounds()
  local groups = {
    "CursorLine", "CursorLineNr", "Folded", "Comment",
    "shConditional", "shFunction", "shStatement", "shRepeat",
    "shException", "shOperator", "shOption", "shCommandSub",
    "Statement", "Conditional", "Repeat", "Function",
    "Keyword", "Special", "SpecialChar", "Tag",
  }
  for _, group in ipairs(groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
    if ok and hl then
      hl.bg = nil
      pcall(vim.api.nvim_set_hl, 0, group, hl)
    end
  end
end

vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = clear_backgrounds })
vim.api.nvim_create_autocmd("VimEnter",    { pattern = "*", callback = clear_backgrounds })
