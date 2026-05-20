return {
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      show_dirname = false,
      show_basename = true,
      show_modified = true,
      exclude_filetypes = { "neo-tree", "help", "terminal", "lazy" },
    },
  },
}
