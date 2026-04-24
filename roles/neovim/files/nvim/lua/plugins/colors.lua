-- === Active theme — comment/uncomment to switch ===

-- -- HTB profile (default)
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      show_end_of_buffer = false,
      term_colors = true,
      no_italic = false,
      no_bold = false,
      styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        cmp = true,
        telescope = true,
        harpoon = true,
        mason = true,
      },
    })
    vim.cmd("colorscheme catppuccin-mocha")

    vim.api.nvim_create_autocmd("VimEnter", {
      pattern = "*",
      callback = function()
        vim.api.nvim_set_hl(0, "Normal",        { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NormalNC",      { bg = "NONE" })
        vim.api.nvim_set_hl(0, "SignColumn",    { bg = "NONE" })
        vim.api.nvim_set_hl(0, "EndOfBuffer",   { bg = "NONE" })
        vim.api.nvim_set_hl(0, "CursorLine",    { bg = "NONE" })
        vim.api.nvim_set_hl(0, "CursorLineNr",  { bg = "NONE" })
        vim.api.nvim_set_hl(0, "Comment",       { fg = "#6c7086", bg = "NONE" })
        vim.api.nvim_set_hl(0, "Visual",        { bg = "#2d3f55" })
        vim.api.nvim_set_hl(0, "VisualNOS",     { bg = "#2d3f55" })
      end,
    })
  end,
}

-- -- Investigation profile
-- return {
--   "folke/tokyonight.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("tokyonight").setup({
--       style = "storm",
--       transparent = true,
--       terminal_colors = true,
--       styles = {
--         comments = {},
--         keywords = {},
--         functions = {},
--         variables = {},
--         sidebars = "transparent",
--         floats = "transparent",
--       },
--       on_highlights = function(hl, c)
--         hl.CursorLine   = { bg = "NONE" }
--         hl.CursorLineNr = { bg = "NONE" }
--         hl.Comment      = { fg = c.comment, bg = "NONE" }
--         hl.Folded       = { fg = c.blue, bg = "NONE" }
--       end,
--     })
--     vim.cmd("colorscheme tokyonight-storm")
--   end,
-- }
