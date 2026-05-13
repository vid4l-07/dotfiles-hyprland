------------------------------------------------------------
--- Plugins
------------------------------------------------------------
return{
  --fzf (archivos) (instalar el paquete fzf desde la terminal)
  {"ibhagwan/fzf-lua"},
  --Oil
  {"stevearc/oil.nvim"},

  --themes
  -- {"catppuccin/nvim"},
  -- {"AlexvZyl/nordic.nvim"},
  -- {"rebelot/kanagawa.nvim"},

  -- Lualine
  {"nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }},
  -- Bufferline
  {"akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons"},

  -- Syntax y completado
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "williamboman/mason.nvim", config = true }, -- :Mason; I para instalar y U para actualizar
  { "williamboman/mason-lspconfig.nvim", config = true },
  { "neovim/nvim-lspconfig" }, 

  { "Saghen/blink.cmp", version = "v1.6.0"},

  { "windwp/nvim-autopairs", event = "InsertEnter", config = true},

  { "alvan/vim-closetag" },
  { "ap/vim-css-color" },

  -- IA
  { "github/copilot.vim" }, -- :Copilot setup
}
