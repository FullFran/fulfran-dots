return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window = opts.window or {}
      opts.window.position = "right"
      opts.filesystem = opts.filesystem or {}
      -- Hacer que Neo-tree sea transparente
      opts.window.mappings = opts.window.mappings or {}
      opts.filesystem.filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { ".git" },
      }
      opts.filesystem.window = opts.filesystem.window or {}
      opts.filesystem.window.position = "right"
      opts.buffers = opts.buffers or {}
      opts.buffers.window = opts.buffers.window or {}
      opts.buffers.window.position = "right"
      opts.git_status = opts.git_status or {}
      opts.git_status.window = opts.git_status.window or {}
      opts.git_status.window.position = "right"
    end,
  },
}
