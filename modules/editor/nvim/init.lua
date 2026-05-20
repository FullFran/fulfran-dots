vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.env.PATH = vim.fn.expand("~/.cargo/bin") .. ":" .. vim.env.PATH

vim.api.nvim_create_user_command("SessionLast", function()
  if package.loaded["persistence"] then
    require("persistence").load({ last = true })
    return
  end

  local ok, lazy = pcall(require, "lazy")
  if ok then
    lazy.load({ plugins = { "persistence.nvim" } })
  end

  vim.defer_fn(function()
    if package.loaded["persistence"] then
      require("persistence").load({ last = true })
    end
  end, 50)
end, {})

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
