vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.opt.scrolloff = 999
    vim.opt.sidescrolloff = 5

    vim.schedule(function()
      local function open_tree_right()
        local ok, command = pcall(require, "neo-tree.command")
        if not ok then
          vim.cmd("Neotree position=right toggle")
          return
        end

        local state = require("neo-tree.sources.manager").get_state("filesystem")
        if state and state.winid and vim.api.nvim_win_is_valid(state.winid) then
          if vim.api.nvim_get_current_win() == state.winid then
            command.execute({ action = "close" })
          else
            command.execute({ action = "focus", position = "right", source = "filesystem" })
          end
          return
        end

        command.execute({ action = "show", position = "right", source = "filesystem" })
        command.execute({ action = "focus", position = "right", source = "filesystem" })
      end

      vim.keymap.set("n", "<leader>e", open_tree_right, { desc = "NeoTree (right)" })

      vim.api.nvim_create_user_command("NeoTreeRight", open_tree_right, {})
      vim.cmd("cabbrev tr NeoTreeRight")

      local function open_ide_layout()
        local current_win = vim.api.nvim_get_current_win()

        open_tree_right()

        local ok, opencode = pcall(require, "opencode")
        if ok then
          if not vim.g.opencode_layout_opened then
            opencode.toggle()
            vim.g.opencode_layout_opened = true
          end
        end

        if vim.api.nvim_win_is_valid(current_win) then
          vim.api.nvim_set_current_win(current_win)
        end
      end

      vim.api.nvim_create_user_command("IdeLayout", open_ide_layout, {})
      vim.keymap.set("n", "<leader>ul", open_ide_layout, { desc = "Open IDE layout" })
    end)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local ft = vim.bo.filetype
    if ft == "gitcommit" or ft == "gitrebase" then
      return
    end

    vim.schedule(function()
      pcall(vim.cmd, "IdeLayout")
    end)
  end,
})
