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
opt.foldmethod = "expr"         -- Use expression-based folding
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use Treesitter for folding

-- Scrolling
vim.opt.scrolloff = 8           -- Keep 8 lines visible above/below cursor

-- Cursor
vim.opt.guicursor = ""          -- Keep block cursor in all modes


