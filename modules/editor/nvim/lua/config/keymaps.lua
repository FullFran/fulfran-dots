local map = vim.keymap.set

-- General
map("n", "<Space>", "<cmd>nohlsearch<CR>")
map({ "n", "i" }, "<C-s>", "<cmd>w<CR>")
map("i", "jk", "<Esc>")

-- Split navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- =============================================================================
-- S.A.N.D. Philosophy
-- =============================================================================

-- [S]earch
map("n", "<leader>sf", function()
  if pcall(require, "snacks") then
    require("snacks").picker.files()
  elseif pcall(require, "telescope.builtin") then
    require("telescope.builtin").find_files()
  end
end, { desc = "Search Files" })

map("n", "<leader>sg", function()
  if pcall(require, "snacks") then
    require("snacks").picker.grep()
  elseif pcall(require, "telescope.builtin") then
    require("telescope.builtin").live_grep()
  end
end, { desc = "Search Grep" })

map("n", "<leader>sb", function()
  if pcall(require, "snacks") then
    require("snacks").picker.buffers()
  elseif pcall(require, "telescope.builtin") then
    require("telescope.builtin").buffers()
  end
end, { desc = "Search Buffers" })

-- [A]ctions (OpenCode / IA)
map("n", "<leader>aa", function()
  require("opencode").toggle()
end, { desc = "AI Toggle" })

map({ "n", "x" }, "<leader>as", function()
  require("opencode").select({ submit = true })
end, { desc = "AI Select" })

map({ "n", "x" }, "<leader>aq", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    require("opencode").ask("", { submit = true })
  else
    require("opencode").ask("@file " .. file .. " ", { submit = true })
  end
end, { desc = "AI Ask File" })

map({ "n", "x" }, "<leader>ai", function()
  require("opencode").ask("@this: ", { submit = true })
end, { desc = "AI Ask This" })

map({ "n", "x" }, "<leader>ap", function()
  require("opencode").prompt("@this", { submit = true })
end, { desc = "AI Prompt" })

-- [N]avigation
map("n", "<leader>ne", "<cmd>Neotree toggle<CR>", { desc = "Nav Explorer" })
map("n", "<leader>nz", ":Zi<CR>", { desc = "Nav Zoxide" })

-- [D]iagnostics & Git
map("n", "<leader>dx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics List" })
map("n", "<leader>db", "<cmd>Gitsigns blame_line<CR>", { desc = "Git Blame" })
map("n", "<leader>dp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Git Preview Hunk" })

-- =============================================================================

-- Git (Lazygit)
map("n", "<leader>gg", function()
  local snacks = pcall(require, "snacks")
  if snacks then
    require("snacks").lazygit.open()
  else
    vim.fn.jobstart("lazygit", { detach = true })
  end
end, { desc = "Open Lazygit" })

-- Legacy / Helpers (kept for muscle memory)
map("n", "<leader>ff", "<leader>sf", { remap = true })
map("n", "<leader>fg", "<leader>sg", { remap = true })
map("n", "<leader>fb", "<leader>sb", { remap = true })
map("n", "<leader>z",  "<leader>nz", { remap = true })
map("n", "<leader>e",  "<leader>ne", { remap = true })

-- Markdown Preview
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>")

-- Command aliases
vim.api.nvim_create_user_command("OpenCodeToggle", function()
  require("opencode").toggle()
end, {})
vim.api.nvim_create_user_command("OpenCodeAsk", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    require("opencode").ask("", { submit = true })
  else
    require("opencode").ask("@file " .. file .. " ", { submit = true })
  end
end, {})
vim.cmd("cabbrev aa OpenCodeToggle")
vim.cmd("cabbrev aq OpenCodeAsk")
