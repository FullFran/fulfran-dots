return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        colors.bg = "none"
        colors.bg_sidebar = "none"
        colors.bg_float = "none"
        colors.bg_statusline = "none"
      end,
      on_highlights = function(hl, c)
        hl.Normal = { bg = "none" }
        hl.NormalFloat = { bg = "none" }
        hl.NormalNC = { bg = "none" }
        hl.MsgArea = { bg = "none" }
        hl.WinSeparator = { fg = c.border, bg = "none" }
        hl.StatusLine = { bg = "none" }
        hl.StatusLineNC = { bg = "none" }
        hl.EndOfBuffer = { fg = c.bg }
        -- Neo-tree transparency
        hl.NeoTreeNormal = { bg = "none" }
        hl.NeoTreeNormalNC = { bg = "none" }
        hl.NeoTreeWinSeparator = { fg = c.border, bg = "none" }
        -- Snacks transparency (for opencode)
        hl.SnacksBackdrop = { bg = "none" }
        hl.SnacksNormal = { bg = "none" }
      end,
    },
  },
}
