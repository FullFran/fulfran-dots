return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "tokyonight"
      opts.options.globalstatus = true
      opts.options.component_separators = ""
      opts.options.section_separators = ""

      -- Intentamos cargar el tema con seguridad
      local status, tokyonight = pcall(require, "lualine.themes.tokyonight")
      if status and tokyonight then
        -- Aplicar transparencia a todas las secciones de todos los modos
        local modes = { "normal", "insert", "visual", "replace", "command", "inactive" }
        for _, mode in ipairs(modes) do
          if tokyonight[mode] then
            for _, section in ipairs({ "a", "b", "c", "x", "y", "z" }) do
              if tokyonight[mode][section] then
                tokyonight[mode][section].bg = "none"
              end
            end
          end
        end
        opts.options.theme = tokyonight
      end
    end,
  },
}
