------------------------------------------------------------
--- Plugins
------------------------------------------------------------
return{
  --fzf (archivos) (instalar el paquete fzf desde la terminal)
  "ibhagwan/fzf-lua",

  --Oil
  "stevearc/oil.nvim",

  -- Lualine
  "nvim-lualine/lualine.nvim", "nvim-tree/nvim-web-devicons",
  -- Bufferline
  "akinsho/bufferline.nvim", "nvim-tree/nvim-web-devicons",

  -- Syntax y completado
  "nvim-treesitter/nvim-treesitter",
  "williamboman/mason.nvim", -- :Mason; I para instalar y U para actualizar
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig", 

  'saghen/blink.lib', 'saghen/blink.cmp',

  "windwp/nvim-autopairs",

  "alvan/vim-closetag",
  "ap/vim-css-color",

  -- IA
  "github/copilot.vim", -- :Copilot setup
}
