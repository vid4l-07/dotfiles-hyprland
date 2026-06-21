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
local blink = require("blink.cmp")
blink.build()
blink.setup({
	cmdline = { 
		enabled = true,
		keymap = {
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
		},
	},
	completion = { 
		menu = {
			draw = { columns = { { "label", gap = 5 }, { "kind_icon" }  } },
		},
		list = {
			selection = { preselect = false }, -- selecciona el primer elemento
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
		["<Tab>"] = { "select_next", "fallback" },     -- Tab = siguiente sugerencia
		["<C-CR>"] = { "accept", "fallback" }, -- Aceptar con ctrl enter
	},
	fuzzy = {
		implementation = "prefer_rust_with_warning",
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

-- autopairs
require("nvim-autopairs").setup({})

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
local nvim_treesitter = require("nvim-treesitter")

local ensure_installed = {
	"lua",
	"python",
	"sh",
	"cpp",
	"c",
	"rust",
	"css",
	"html",
	"js",
	"jsonc",
}

vim.api.nvim_create_autocmd("FileType", {
  -- pattern = "*", -- auto install activo, para desactivar cambie "*" por ensure_installed
  pattern = ensure_installed, -- auto install activo, para desactivar cambie "*" por ensure_installed

  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(ft)
    if lang == nil then
      return
    end

    -- check if parser is available
    local is_parser_available = vim.treesitter.language.add(lang)
    if not is_parser_available then
      local available_langs = vim.g.ts_available or nvim_treesitter.get_available()
      if not vim.g.ts_available then
        vim.g.ts_available = available_langs
      end

      if vim.tbl_contains(available_langs, lang) then
        -- install treesitter parsers and queries
        local install_msg = string.format("Installing parsers and queries for %s", lang)
        vim.print(install_msg)
        require("nvim-treesitter").install(lang)
      end
    end

    if vim.treesitter.language.add(lang) then
      -- start treesitter highlighting
      vim.treesitter.start(args.buf, lang)
    end
  end,
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

