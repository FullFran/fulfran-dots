-- Preview mermaid diagrams as ASCII in a floating window
-- <leader>mm — renderiza el bloque mermaid bajo el cursor
return {
  "nvim-lua/plenary.nvim",
  lazy = true,
  keys = {
    {
      "<leader>mm",
      function()
        local mmaid = vim.fn.expand("~/.local/bin/mmaid")
        if vim.fn.executable(mmaid) == 0 then
          vim.notify("mmaid no encontrado en ~/.local/bin/mmaid", vim.log.levels.ERROR)
          return
        end

        -- Extraer bloque mermaid bajo el cursor
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local cursor = vim.api.nvim_win_get_cursor(0)[1]
        local start_line, end_line

        -- Buscar el bloque mermaid que contiene el cursor
        for i = cursor, 1, -1 do
          if lines[i] and lines[i]:match("^```mermaid") then
            start_line = i + 1
            break
          end
        end
        for i = (start_line or cursor), #lines do
          if lines[i] and lines[i]:match("^```$") then
            end_line = i - 1
            break
          end
        end

        if not start_line or not end_line then
          vim.notify("No hay bloque mermaid bajo el cursor", vim.log.levels.WARN)
          return
        end

        local diagram = table.concat(vim.list_slice(lines, start_line, end_line), "\n")
        local result = vim.fn.systemlist(mmaid .. " -f -", diagram)

        -- Mostrar en floating window
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
        local width = math.min(120, vim.o.columns - 4)
        local height = math.min(#result + 2, vim.o.lines - 4)
        vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          col = math.floor((vim.o.columns - width) / 2),
          row = math.floor((vim.o.lines - height) / 2),
          style = "minimal",
          border = "rounded",
          title = " Mermaid Preview ",
          title_pos = "center",
        })
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
        vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
      end,
      desc = "Preview mermaid diagram as ASCII",
    },
  },
}
