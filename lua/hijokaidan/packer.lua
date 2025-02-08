local packer = require("packer")
packer.init({ compile_path = vim.fn.stdpath("data") .. "/lua/packer_compiled.lua" })

if not vim.g.vscode then
    vim.cmd [[packadd packer.nvim]]
    return require('packer').startup(function(use)
        use 'wbthomason/packer.nvim'
        use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
        use('nvim-treesitter/playground');
        use({
            'rose-pine/neovim',
            as = 'rose-pine',
            config = function()
                vim.cmd('colorscheme rose-pine')
            end
        })
        use {
            'nvim-telescope/telescope.nvim', tag = '0.1.4',
            -- or                            , branch = '0.1.x',
            requires = { { 'nvim-lua/plenary.nvim' } }
        }
        use('nvim-lua/plenary.nvim')
        use('ThePrimeagen/harpoon')
        use('mbbill/undotree')
        use('tpope/vim-fugitive')
        use("nvim-lua/plenary.nvim")
        use { 'm00qek/baleia.nvim', tag = 'v1.3.0' }

        use {
            "olexsmir/gopher.nvim",
            requires = { -- dependencies
                "nvim-lua/plenary.nvim",
                "nvim-treesitter/nvim-treesitter",
            },
        }
        use('simrat39/rust-tools.nvim')
        use {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v2.x',
            requires = {
                -- LSP Support
                { 'neovim/nvim-lspconfig' }, -- Required
                {                          -- Optional
                    'williamboman/mason.nvim',
                    run = function()
                        pcall(vim.cmd, 'MasonUpdate')
                    end,
                },
                { 'williamboman/mason-lspconfig.nvim' }, -- Optional

                -- Autocompletion
                { 'hrsh7th/nvim-cmp' },
                { 'hrsh7th/cmp-nvim-lsp' }, -- Required
                { 'hrsh7th/cmp-nvim-lsp-signature-help' },
                { 'hrsh7th/cmp-vsnip' },
                { 'hrsh7th/cmp-path' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/vim-vsnip' },
                { 'L3MON4D3/LuaSnip' }, -- Required
            }
        }
        use "rafamadriz/friendly-snippets"
        use { 'saadparwaiz1/cmp_luasnip' }
        use('mfussenegger/nvim-jdtls')
        use {
            'nvim-tree/nvim-tree.lua',
            requires = {
                'nvim-tree/nvim-web-devicons', -- optional
            },
            config = function()
                require("nvim-tree").setup {}
            end
        }
        use('nvim-tree/nvim-web-devicons')
        use {
            'nvim-lualine/lualine.nvim',
            requires = { 'nvim-tree/nvim-web-devicons', opt = true }
        }
        use('windwp/nvim-ts-autotag')
        -- use 'Exafunction/codeium.vim'
        use {
            "supermaven-inc/supermaven-nvim",
            config = function()
                require("supermaven-nvim").setup({})
            end,
        }
    end)
end
