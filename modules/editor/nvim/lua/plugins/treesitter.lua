return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.auto_install = vim.fn.executable("tree-sitter") == 1

      opts.ensure_installed = opts.ensure_installed or {}
      local has_latex = false
      if type(opts.ensure_installed) == "table" then
        for _, lang in ipairs(opts.ensure_installed) do
          if lang == "latex" then
            has_latex = true
            break
          end
        end
        if not has_latex then
          table.insert(opts.ensure_installed, "latex")
        end
      end
    end,
  },
}
