------------------------------------------------------------
-- Plugins
------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("lua.plugins.plugins")) -- Instalar plugins

------------------------------------------------------------
-- Opciones generales
------------------------------------------------------------
if vim.fn.has("win32") == 1 then  -- windows -> powershell ; linux -> bash
	vim.opt.shell = "powershell"
else
	vim.opt.shell = "/bin/bash"
end

-- vim.o.winborder = "rounded"
vim.o.winborder = "solid"
vim.o.winblend = 0 
vim.opt.clipboard = "unnamedplus"
vim.cmd("syntax on")
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.cmd("filetype on")
vim.opt.ruler = true
vim.opt.mouse = "a"
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.encoding = "UTF-8"
vim.cmd("filetype plugin indent on")
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.foldcolumn = "2"
vim.opt.wrap = false  -- no hacer salto de linea al llegar al final de la pantalla
vim.opt.listchars = {
  trail = " ",  -- Espacios al final de línea
  tab = "> ",  -- tabs
}

------------------------------------------------------------
-- Funciones
------------------------------------------------------------
-- Ejecutar archivo actual según su extensión
function _G.RunFile()
  vim.cmd("w")
  local file = vim.fn.expand("%:p")
  local ext = vim.fn.expand("%:e")
  local cmd = nil

  if ext == "py" then
    cmd = "python " .. file
  elseif ext == "sh" then
    cmd = "bash " .. file
  else
    print("Tipo de archivo no soportado: " .. ext)
    return
  end
  vim.cmd("terminal " .. cmd)
end

vim.api.nvim_create_user_command("RunFile", RunFile, {})

-- Alternar Copilot
vim.g.copilot_no_tab_map = true
vim.g.copilot_enabled = 0 -- empieza deshabilitado
function _G.CopilotToggle()
  if vim.g.copilot_enabled == 1 then
    vim.cmd("Copilot disable")
    vim.g.copilot_enabled = 0
    print("Copilot desactivado")
  else
    vim.cmd("Copilot enable")
    vim.g.copilot_enabled = 1
    print("Copilot activado")
  end
end

------------------------------------------------------------
-- Keymaps
------------------------------------------------------------
vim.g.mapleader = " " -- espacio tecla líder
local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Cerrar sin guardar
map("n", "<leader>q", ":q!<CR>", opts)
-- Guardar
map("n", "<leader>w", ":silent w<CR>", opts)

-- Scroll
map("n", "<C-k>", "3<C-y>", opts)
map("n", "<C-j>", "3<C-e>", opts)

-- Enviar cursor al centro
map("n", "<leader>z", ":call cursor(line('w0') + (winheight(0)/2), col('.'))<CR>", { silent = true })

-- Final de linea en insertar
map('i', '<S-Tab>', '<Esc>A')

-- Mover líneas
map("n", "<A-j>", ":m .+1<CR>==", { silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { silent = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- Cambiar buffer
map("n", "<leader>n", ":bnext<CR>", opts)
map("n", "<leader>p", ":bprevious<CR>", opts)
map("n", "<leader>x", ":bdelete<CR>", opts)

-- Oil
map("n", "-", "<CMD>Oil<CR>")  -- (buffer de los archivos, para crear, borrar, cambiar nombre...)

-- Ejecutar archivo actual
map("n", "<leader>r", ":RunFile<CR>", opts)

-- Copilot
map("n", "<leader>i", ":lua CopilotToggle()<CR>", opts)

vim.api.nvim_set_keymap( "i", "<C-l>", 'copilot#Accept("<CR>")', { expr = true, silent = true })  -- Aceptar sugerencia con Ctrl+l

-- Scroll horizontal
map("n", "<C-ScrollWheelUp>", "8zh")
map("n", "<C-ScrollWheelDown>", "8zl")

------------------------------------------------------------
-- Tema y colores
------------------------------------------------------------
vim.opt.termguicolors = true

vim.g.molokai_original = 0

vim.cmd("source $HOME/.config/nvim/colors/theme.vim")  -- Tema (se cambia desde script)

-- Colores Blink	:Inspect para ver los highlights de lo seleccionado
-- vim.cmd([[ 
-- 	"hi Normal guibg=NONE ctermbg=NONE
--
-- 	hi! link BlinkCmpKindFunction @function
-- 	hi! link BlinkCmpKindConstructor @constructor
-- 	hi! link BlinkCmpKindVariable @module
-- 	hi! link BlinkCmpKindFolder @module
-- 	hi! link BlinkCmpKindClass @type
-- 	hi! link BlinkCmpKindOperator @operator
-- 	hi! link BlinkCmpKindText @string
--
-- 	hi! link LineNr Normal
-- 	hi EndOfBuffer guifg=bg guibg=bg
-- 	hi! link BufferLineFill Normal
-- 	"hi FoldColumn guibg=bg
-- 	hi! link FoldColumn Normal
-- 	hi! link SignColumn Normal
-- 	hi VertSplit guibg=#302d38 guifg=#302d38
-- ]])

require("lua.plugins.plugins-conf") -- Configuración de plugins
