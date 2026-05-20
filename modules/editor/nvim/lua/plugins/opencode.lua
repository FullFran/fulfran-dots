return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      {
        "folke/snacks.nvim",
        opts = {
          input = {},
          picker = {},
          terminal = {},
        },
      },
    },
    config = function()
      vim.g.opencode_opts = {
        provider = {
          snacks = {
            win = { 
              position = "right", -- Lo muevo a la derecha para que no choque con Neo-tree
              width = 0.3,
              style = "minimal",
              border = "none",
            },
          },
        },
      }
      vim.o.autoread = true
    end,
  },
}
