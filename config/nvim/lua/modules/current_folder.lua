local M = {}

M.folder_name = function()
  local path = vim.fn.expand("%:p:h")
  if path == "" then return "" end

  -- Extraer solo el nombre de la carpeta
  local folder = vim.fn.fnamemodify(path, ":t")
  return " " .. folder  -- icono opcional
end

return M
