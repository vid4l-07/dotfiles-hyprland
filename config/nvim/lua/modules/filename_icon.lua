local M = {}

-- Función para lualine
M.filename_icon = function()
  local filename = vim.fn.expand("%:t")       -- nombre del archivo
  if filename == "" then return "" end         -- sin archivo activo

  local ext = vim.fn.expand("%:e")             -- extensión
  local icon, icon_highlight = require('nvim-web-devicons').get_icon(filename, ext, { default = true })

  return icon .. " " .. filename
end

return M
