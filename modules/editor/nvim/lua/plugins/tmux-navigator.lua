-- vim-tmux-navigator: Seamless navigation between tmux panes and Neovim windows
-- https://github.com/christoomey/vim-tmux-navigator
return {
  "christoomey/vim-tmux-navigator",
  enabled = true,
  lazy = false, -- Load immediately for seamless integration

  -- Configuración para que funcione con Ctrl+h/j/k/l
  init = function()
    -- Deshabilitar los keymaps de LazyVim que podrían interferir
    -- El plugin maneja la navegación cross-editor

    -- Mapping para navegar sin prefix de tmux
    vim.g.tmux_navigator_no_mappings = 1

    -- Keymaps que funcionan en cualquier contexto (Neovim o Terminal)
    vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate left" })
    vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate down" })
    vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate up" })
    vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate right" })

    -- Opcional: preserve window cuando hay un solo buffer
    vim.g.tmux_navigator_preserve_zoom = 1
  end,
}