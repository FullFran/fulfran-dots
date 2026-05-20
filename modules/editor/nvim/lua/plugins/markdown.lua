return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.nvim",
    },
    opts = {
      heading = {
        enabled = true,
        sign = true,
        style = "full",
        icons = { "1. ", "2. ", "3. ", "4. ", "5. ", "6. " },
        left_pad = 1,
      },
      bullet = {
        enabled = true,
        icons = { "*", "-", "+", "•" },
        right_pad = 1,
        highlight = "render-markdownBullet",
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
