------------------------------------------------------------
-- Config de plugins
------------------------------------------------------------
-- lualine
require('config.lualine')
-- bufferline
require("bufferline").setup({
  options = {
    show_buffer_icons = false,
    show_buffer_close_icons = true,
    show_close_icon = false,
  }
})

-- blink.cmp
require("blink.cmp").setup({
	cmdline = { enabled = true },
	completion = { 
		menu = {
			draw = { columns = { { "label", gap = 3 }, { "kind_icon" }  } },
		},
		list = {
			selection = { preselect = false }, -- selecciona el primer elemento auto
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
		["<Tab>"] = { "select_next", "fallback" },     -- Tab = siguiente sugerencia
		-- ["<S-Tab>"] = { "select_prev", "fallback" },   -- Shift+Tab = anterior
		["<C-CR>"] = { "accept", "fallback" }, -- Aceptar con ctrl enter

		-- ["<S-CR>"] = { "select_next", "fallback" },     -- Sift+Enter = siguiente sugerencia
		-- ["<C-CR>"] = { "select_prev", "fallback" },   -- Ctrl+Enter = anterior
		-- ["<Tab>"] = { "accept", "fallback" }, -- Aceptar con Tab

		-- ["<Up>"] = { "fallback" }, -- deshabilitar flechas
		-- ["<Down>"] = { "fallback" },
	},
	fuzzy = {
		implementation = "prefer_rust_with_warning",
		prebuilt_binaries = { download = true, },
	},
})

-- fzf
local fzf = require("fzf-lua")
fzf.setup({
	winopts = {
		border = "solid",
		fullscreen = true,
		preview = {
			border = "solid",
			winopts = {
				number = false,
			},
		},
	},
})

-- binds-fzf
vim.keymap.set("n", "<leader>f", fzf.files)
vim.keymap.set("n", "<leader>ls", fzf.lsp_document_symbols) -- navega entre las variables
vim.keymap.set("n", "<leader>ld", fzf.diagnostics_document) -- navega entre errores

-- Oil
require("oil").setup({
	confirmation = {
		border = "solid",
	},
})

-- LSP (Servidor de lenguajes); Mason (instala los servidores)
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    "pyright",
    "bashls",
    "html",
    "cssls",
    "clangd",
	"rust_analyzer",
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
	highlight = { enable = true },
	modules = {},
	sync_install = true,
	ignore_install = {},
	auto_install = false,  -- viene bien dejarlo en true los primeros dias para que vaya instalando lo necesario
})

-- Plegar funciones
vim.cmd("set foldmethod=expr")
vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
vim.cmd("set foldlevel=99")

vim.opt.foldtext = "v:lua.MyFoldText()"

function _G.MyFoldText()
	local line = vim.fn.getline(vim.v.foldstart)
	line = line:gsub("{%s*$", "")
	return "" .. line
end

vim.defer_fn(function()
	vim.cmd("normal! zx")
end, 0)

