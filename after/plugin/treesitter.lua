if not vim.g.vscode then
    require 'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = { "c", "php", "lua", "vim", "java", "javascript", "typescript", "python", "html", "scss", "vimdoc", "query" },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        autotag = {
            enable = true,
        },
        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = false,

        -- List of parsers to ignore installing (for "all")
        ignore_install = { "markdown", "shell" },
        -- Needed because treesitter highlight turns off autoindent for php files
        indent = {
            enable = true,
        },

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
            enable = true,

            -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
            -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
            -- the name of the parser)
            -- list of language that will be disabled
            disable = { "markdown", "shell", "sql" },
            -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
    }
    -- Register the language
    vim.filetype.add {
        extension = {
            templ = "templ"
        }
    }

    -- Register the LSP as a config
    local configs = require 'lspconfig.configs'
    if not configs.templ then
        configs.templ = {
            default_config = {
                cmd = { "templ", "lsp" },
                filetypes = { 'templ' },
                root_dir = require "lspconfig.util".root_pattern("go.mod", ".git"),
                settings = {},
            },
        }
    end
    if not configs.templ then
        configs.html = {
            default_config = {
                cmd = { "html", "lsp" },
                filetypes = { 'templ', 'html', 'twig' },
                settings = {},
            },
        }
    end
end
