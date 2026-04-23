

-- Set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>fp", vim.cmd.Ex)

-- General keymaps
keymap.set("n", "<leader>wq", ":wq<CR>") -- save and quit
keymap.set("n", "<leader>qq", ":q!<CR>") -- quit without saving
keymap.set("n", "<leader>ww", ":w<CR>") -- save
keymap.set("n", "gx", ":!open <c-r><c-a><CR>") -- open URL under cursor

-- Diff keymaps
keymap.set("n", "<leader>cc", ":diffput<CR>") -- put diff from current to other during diff
keymap.set("n", "<leader>cj", ":diffget 1<CR>") -- get diff from left (local) during merge
keymap.set("n", "<leader>ck", ":diffget 3<CR>") -- get diff from right (remote) during merge
keymap.set("n", "<leader>cn", "]c") -- next diff hunk
keymap.set("n", "<leader>cp", "[c") -- previous diff hunk

-- Quickfix keymaps
keymap.set("n", "<leader>qo", ":copen<CR>") -- open quickfix list
keymap.set("n", "<leader>qf", ":cfirst<CR>") -- jump to first quickfix list item
keymap.set("n", "<leader>qn", ":cnext<CR>") -- jump to next quickfix list item
keymap.set("n", "<leader>qp", ":cprev<CR>") -- jump to prev quickfix list item
keymap.set("n", "<leader>ql", ":clast<CR>") -- jump to last quickfix list item
keymap.set("n", "<leader>qc", ":cclose<CR>") -- close quickfix list

-- Telescope
keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, {}) -- fuzzy find files in project
keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {}) -- grep file contents in project
keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {}) -- fuzzy find open buffers
keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, {}) -- fuzzy find help tags
keymap.set('n', '<leader>fs', require('telescope.builtin').current_buffer_fuzzy_find, {}) -- fuzzy find in current file buffer
keymap.set('n', '<leader>fo', require('telescope.builtin').lsp_document_symbols, {}) -- fuzzy find LSP/class symbols
keymap.set('n', '<leader>fi', require('telescope.builtin').lsp_incoming_calls, {}) -- fuzzy find LSP/incoming calls
-- keymap.set('n', '<leader>fm', function() require('telescope.builtin').treesitter({default_text=":method:"}) end) -- fuzzy find methods in current class
keymap.set('n', '<leader>fm', function() require('telescope.builtin').treesitter({symbols={'function', 'method'}}) end) -- fuzzy find methods in current class
keymap.set('n', '<leader>ft', function() -- grep file contents in current nvim-tree node
  local success, node = pcall(function() return require('nvim-tree.lib').get_node_at_cursor() end)
  if not success or not node then return end;
  require('telescope.builtin').live_grep({search_dirs = {node.absolute_path}})
end)

-- Harpoon
keymap.set("n", "<leader>ha", require("harpoon.mark").add_file) -- mark files
keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu) -- toggle file
keymap.set("n", "<leader>h1", function() require("harpoon.ui").nav_file(1) end)
keymap.set("n", "<leader>h2", function() require("harpoon.ui").nav_file(2) end)
keymap.set("n", "<leader>h3", function() require("harpoon.ui").nav_file(3) end)
keymap.set("n", "<leader>h4", function() require("harpoon.ui").nav_file(4) end)
keymap.set("n", "<leader>h5", function() require("harpoon.ui").nav_file(5) end)
keymap.set("n", "<leader>h6", function() require("harpoon.ui").nav_file(6) end)
keymap.set("n", "<leader>h7", function() require("harpoon.ui").nav_file(7) end)
keymap.set("n", "<leader>h8", function() require("harpoon.ui").nav_file(8) end)
keymap.set("n", "<leader>h9", function() require("harpoon.ui").nav_file(9) end)

-- Basic visual and movement keymaps
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move visual block down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move visual block up
vim.keymap.set("n", "J", "mzJ`z") -- join line with below and keep cursor in place
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- half-page down and center
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- half-page up and center
vim.keymap.set("n", "n", "nzzzv") -- next match and center
vim.keymap.set("n", "N", "Nzzzv") -- previous match and center
vim.keymap.set("n", "=ap", "ma=ap'a") -- format paragraph and return to position

-- Escape insert mode
vim.keymap.set("i", "jj", "<Esc>")

-- Location list navigation (used for linter/diagnostic)
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz") -- next item in location list
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz") -- prev item in location list

  -- Keymap to run Python code and handle input()
vim.keymap.set("n", "<leader>rr", function()

  -- Open terminal in a floating window
  local cmd = "python3 " .. vim.fn.expand("%")  -- Command to run the Python file
  vim.cmd("belowright new | terminal " .. cmd)

  -- Switch to insert mode immediately after opening the terminal
  vim.api.nvim_feedkeys("i", "n", true)
end, { noremap = true, silent = true })  -- This is closing the function properly
-- end)


vim.keymap.set('n', '<leader>tt', '<Cmd>!pytest %<CR>', { noremap = true, silent = true })
