-- === Active theme ===
-- HTB profile      → tokyonight
-- Investigation    → oxocarbon (uncomment below, comment tokyonight)

-- -- HTB profile
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, c)
        hl.CursorLine   = { bg = "NONE" }
        hl.CursorLineNr = { bg = "NONE" }
        hl.SignColumn   = { bg = "NONE" }
      end,
    })
    vim.cmd("colorscheme tokyonight-night")
  end,
}

-- -- Investigation profile
-- return {
--   "nyoom-engineering/oxocarbon.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.opt.background = "dark"
--     vim.cmd("colorscheme oxocarbon")
--     vim.cmd [[
--       highlight Normal         guibg=NONE ctermbg=NONE
--       highlight NormalNC       guibg=NONE ctermbg=NONE
--       highlight SignColumn     guibg=NONE ctermbg=NONE
--       highlight VertSplit      guibg=NONE ctermbg=NONE
--       highlight EndOfBuffer    guibg=NONE ctermbg=NONE
--       highlight CursorLine     guibg=NONE ctermbg=NONE
--       highlight CursorLineNr   guibg=NONE ctermbg=NONE
--     ]]
--   end,
-- }
