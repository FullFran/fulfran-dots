return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    },
    config = function(_, opts)
      require("persistence").setup(opts)

      vim.api.nvim_create_user_command("SessionLast", function()
        require("persistence").load({ last = true })
      end, {})
    end,
  },
}
