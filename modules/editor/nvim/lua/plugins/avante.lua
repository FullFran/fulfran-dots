return {
  {
    "yetone/avante.nvim",
    enabled = false,
    build = "make",
    event = "VeryLazy",
    version = false,
    opts = {
      provider = "opencode",
      acp_providers = {
        opencode = {
          command = "opencode",
          args = { "acp" },
        },
      },
      windows = {
        position = "left",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
