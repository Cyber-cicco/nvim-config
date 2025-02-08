if not vim.g.vscode then
    local lsp = require('lsp-zero').preset({})
    local builtin = require('telescope.builtin')

    -- telescope + lsp specfications
    lsp.on_attach(function(_, bufnr)
        -- NOTE: Remember that lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself
        -- many times.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local nmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>r', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>c', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
        nmap('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

        -- Lesser used LSP functionality
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
    end
)

    -- (Optional) Configure lua language server for neovim
    require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
        -- Add this configuration before lsp.setup()
    require('lspconfig').tailwindcss.setup({
        filetypes = { "templ", "html", "javascript", "css", "scss", "javascriptreact", "typescript", "typescriptreact" },
        init_options = {
            userLanguages = {
                templ = "html"
            }
        },
        root_dir = require('lspconfig').util.root_pattern('tailwind.config.js', 'tailwind.config.ts', 'postcss.config.js'),
    })

    lsp.ensure_installed({
        'tsserver',
        'sqlls',
        'jdtls',
        'angularls',
        'clangd',
        'gopls',
        'templ',
        'kotlin-language_server',
        'intelephense',
        'gdtoolkit',
        'tailwindcss-language-server',
    })
    lsp.setup()

    -- Make sure you setup `cmp` after lsp-zero
    local cmp = require('cmp')

    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ['<Tab>'] = cmp.mapping.confirm({select = true}),
        }),
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        sources = cmp.config.sources({
            {name = "nvim_lsp"},
            {name = "luasnip"}
        }, {
            {name = "buffer"}
        })
    })
    require("luasnip.loaders.from_vscode").lazy_load()
end
