------------------------------------------------------------
--- Instalar Lazy; Los plugins se gestionan con :Lazy
------------------------------------------------------------
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
------------------------------------------------------------
-- Opciones generales
------------------------------------------------------------
-- vim.o.winborder = "rounded"
vim.o.winborder = "solid"
vim.o.winblend = 0 
vim.opt.clipboard = "unnamedplus"
vim.opt.shell = "/bin/zsh"
vim.cmd("syntax on")
vim.opt.tabstop = 4
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

------------------------------------------------------------
-- Airline (barra superior e inferior)
------------------------------------------------------------
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tabline#left_sep"] = " "
vim.g["airline#extensions#tabline#left_alt_sep"] = "|"
vim.g["airline#extensions#whitespace#enabled"] = 0
vim.g["airline#extensions#tabline#buffers_label"] = "" -- quita la palabra buffers
vim.g.airline_section_c = "" -- quitar nombre del archivo
vim.g.airline_section_y = "" -- quitar encoding
vim.g.airline_section_z = "" -- quitar lineas/columnas

------------------------------------------------------------
-- Tema y colores
------------------------------------------------------------
vim.opt.termguicolors = true
-- Fondo transparente
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")

vim.g.indentLine_char = "⏽ "
vim.g.molokai_original = 1

-- vim.cmd("colorscheme nord")
-- vim.cmd("colorscheme kanagawa")
-- vim.cmd("colorscheme onedark")

-- vim.g.airline_theme = 'nord'
-- vim.g.airline_theme = 'base16_atelier_cave'

-- Tema (se cambia desde changetheme)
vim.cmd("source $HOME/.config/nvim/theme.vim")

-- Colores Blink	:Inspect para ver los highlights de lo seleccionado
vim.cmd([[ 
	hi! link @variable Text

    hi! link BlinkCmpScrollBarThumb Normal
	hi! link BlinkCmpScrollBarGutter Normal

	hi! link BlinkCmpMenuSelection Search

	hi! link BlinkCmpDoc Pmenu
	hi! link BlinkCmpDocBorder Pmenu
	hi! link BlinkCmpDocSeparator Pmenu
	hi! link BlinkCmpDocCursorLine Pmenu


	hi! link BlinkCmpKindFunction @function
	hi! link BlinkCmpKindConstructor @constructor
	hi! link BlinkCmpKindVariable @module
	hi! link BlinkCmpKindFolder @module
	hi! link BlinkCmpKindClass @type
	hi! link BlinkCmpKindOperator @operator
	hi! link BlinkCmpKindText @string

	hi! link NormalFloat Pmenu

	hi EndOfBuffer guifg=bg guibg=bg
	hi LineNr guibg=bg
	hi foldcolumn guibg=bg
	hi VertSplit guibg=#302d38 guifg=#302d38
]])

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
    cmd = "python3 " .. file
  elseif ext == "c" then
    cmd = "gcc " .. file .. " -o /tmp/a.out && /tmp/a.out"
  elseif ext == "cpp" then
    cmd = "g++ " .. file .. " -o /tmp/a.out && /tmp/a.out"
  elseif ext == "js" then
    cmd = "node " .. file
  elseif ext == "sh" then
    cmd = "bash " .. file
  elseif ext == "lua" then
    cmd = "lua " .. file
  else
    print("Tipo de archivo no soportado: " .. ext)
    return
  end
  vim.cmd("botright split | term " .. cmd)
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

-- Nueva lina en insertar
map('i', '<S-CR>', '<Esc>o')

-- Final de linea en insertar
map('i', '<S-Tab>', '<Esc>A')

-- Mover líneas
map("n", "<A-j>", ":m .+1<CR>==", { silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { silent = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- NERDTree
map("n", "<leader>t", ":NERDTreeToggle<CR>", opts)
map("n", "<C-t>", ":NERDTreeFocus<CR>", opts)

-- Cambiar buffer
map("n", "<leader>n", ":bnext<CR>", opts)
map("n", "<leader>p", ":bprevious<CR>", opts)
map("n", "<leader>x", ":bdelete<CR>", opts)

-- Ejecutar archivo actual
map("n", "<leader>r", ":RunFile<CR>", opts)

-- Copilot
map("n", "<leader>i", ":lua CopilotToggle()<CR>", opts)

	-- Aceptar sugerencia con Ctrl+i si no hay menú visible
vim.api.nvim_set_keymap(
  "i",
  "<C-l>",
  'copilot#Accept("<CR>")',
  { expr = true, silent = true }
)
------------------------------------------------------------
--- Plugins
------------------------------------------------------------
-- Instalar plugins
require("lazy").setup({
  -- NERDTree
  { "preservim/nerdtree" },

  -- Themes
  { "mhartington/oceanic-next" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "nordtheme/vim" },
  { "rebelot/kanagawa.nvim" },

  -- Airline
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes" },

  -- Syntax y completado
  { 'nvim-treesitter/nvim-treesitter' },
  { 'williamboman/mason.nvim', config = true }, -- :Mason; I para instalar y U para actualizar
  { 'williamboman/mason-lspconfig.nvim', config = true },
  { "neovim/nvim-lspconfig" }, 

  { "Saghen/blink.cmp", version = "v1.6.0"},

  { "jiangmiao/auto-pairs" },
  { "alvan/vim-closetag" },
  { "ap/vim-css-color" },

  -- IA
  { "github/copilot.vim" }, -- :Copilot setup
})

------------------------------------------------------------
-- Config de plugins
------------------------------------------------------------
-- blink.cmp
require("blink.cmp").setup({
	cmdline = { enabled = true },
	completion = { 
		menu = {
			draw = { columns = { { "label", gap = 3 }, { "kind_icon" }  } },
		},
		list = {
			selection = { preselect = true }, -- selecciona el primer elemento auto
		},
		documentation = { auto_show = true, auto_show_delay_ms = 1000 },
		ghost_text = { enabled = false },
		accept = {
			auto_brackets = { enabled = true },
		},
	},
	sources = {
		default = { 'lsp', 'buffer', 'snippets', 'path' },
	},
	keymap = {
		-- ['<Tab>'] = { 'select', 'fallback' },
		--["<Tab>"] = { "select_next", "fallback" },     -- Tab = siguiente sugerencia
		-- ["<S-Tab>"] = { "select_prev", "fallback" },   -- Shift+Tab = anterior
		-- ["<S-CR>"] = { "accept", "fallback" }, -- Aceptar con enter

		-- ["<S-CR>"] = { "select_next", "fallback" },     -- Sift+Enter = siguiente sugerencia
		-- ["<C-CR>"] = { "select_prev", "fallback" },   -- Ctrl+Enter = anterior
		["<Tab>"] = { "accept", "fallback" }, -- Aceptar con Tab



		-- ["<Up>"] = { "fallback" }, -- deshabilitar flechas
		-- ["<Down>"] = { "fallback" },
	},
	fuzzy = {
		implementation = "prefer_rust_with_warning",
		prebuilt_binaries = { download = true, },
	},
})


-- NerdTree
-- autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.fn.winnr("$") == 1 and vim.b.NERDTree and vim.b.NERDTree.isTabTree then
      vim.cmd("quit")
    end
  end,
})
-- LSP (Servidor de lenguajes); Mason (instala los servidores)

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    "pyright",
    "bashls",
    "intelephense",
    "html",
    "cssls",
    "clangd",
    "lua_ls",
    "jdtls",
    "omnisharp",
  },
  automatic_installation = true,
})

local lspconfig = require('lspconfig')

-- Mostrar diagnóstico en un popup al mover el cursor sobre la línea
vim.o.updatetime = 300
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end
})


--tree-sitter (Resalta sintaxis)
require "nvim-treesitter.configs".setup({
	-- ensure_installed = { "svelte", "typescript", "javascript", "html", "css", "php", "cpp", "rust", "astro", "zig", "python", "bash", "lua" },
	highlight = { enable = true },
	modules = {},
	sync_install = true,
	ignore_install = {},
	auto_install = true,
})
