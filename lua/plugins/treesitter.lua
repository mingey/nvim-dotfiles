return {
  'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "powershell", "json" },
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      highlight = {enable = true},
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
}
