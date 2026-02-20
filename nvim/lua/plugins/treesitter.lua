return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local ts = require 'nvim-treesitter'

    local install_languages = {
      'bash',
      'blade',
      'c',
      'diff',
      'dockerfile',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'php',
      'query',
      'vim',
      'vimdoc',
    }

    local blade_parser = {
      install_info = {
        url = 'https://github.com/EmranMR/tree-sitter-blade',
        files = { 'src/parser.c' },
        branch = 'main',
      },
      filetype = 'blade',
    }

    local function register_blade_parser()
      require('nvim-treesitter.parsers').blade = blade_parser
      vim.treesitter.language.register('blade', { 'blade' })
    end

    -- Keep custom parser registration persistent across updates.
    vim.api.nvim_create_autocmd('User', {
      pattern = 'TSUpdate',
      callback = register_blade_parser,
    })
    register_blade_parser()

    ts.setup {}
    ts.install(install_languages)

    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function(event)
        pcall(vim.treesitter.start, event.buf)
        if vim.bo[event.buf].filetype ~= 'ruby' then
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
