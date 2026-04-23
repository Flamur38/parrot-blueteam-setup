-- LSP Support
return {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
        { 'j-hui/fidget.nvim', opts = {} },
        { 'folke/neodev.nvim', opts = {} },
    },
    config = function ()
        -- Mason setup
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                'bashls',
                'lua_ls',
                'pyright',
                'lemminx',
                'marksman',
                'quick_lint_js',
            }
        })

        -- Mason tool installer setup
        require('mason-tool-installer').setup({
            ensure_installed = {
                'black',
                'debugpy',
                'flake8',
                'isort',
                'mypy',
                'pylint',
                'pytest',
                'ipython',
                'jupyter',
            },
        })

        require('fidget').setup({})

        local lspconfig = require('lspconfig')
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Python path detection (for virtualenv support)
        local function get_python_path(workspace)
            -- Use activated virtualenv
            if vim.env.VIRTUAL_ENV then
                return vim.env.VIRTUAL_ENV .. '/bin/python'
            end
            -- Look for venv folder in workspace
            local match = vim.fn.glob(workspace .. '/.venv/bin/python')
            if match ~= '' then return match end
            return 'python3' -- Default fallback
        end

        local lsp_attach = function(client, bufnr)
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = true,
                signs = true,
                update_in_insert = false,
            })

            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            local opts = { noremap = true, silent = true }

            buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
            buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
            buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
            buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
            buf_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)

            -- This keymap binds <leader>tt to run pytest on the current Python file.
            -- `!pytest %` invokes the shell command `pytest` on the current file in the buffer, 
            -- and the result will be shown in the Neovim command line.
            buf_set_keymap('n', '<leader>tt', '<Cmd>!pytest %<CR>', opts)

            if client.server_capabilities.document_formatting then
                vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
            end
        end

        -- Setup LSPs
        local servers = { 'bashls', 'lua_ls', 'lemminx', 'marksman', 'quick_lint_js' }
        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                on_attach = lsp_attach,
                capabilities = lsp_capabilities,
            })
        end

        -- Lua-specific settings
        lspconfig.lua_ls.setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = {'vim'} },
                },
            },
        })

        -- Python-specific settings
        lspconfig.pyright.setup({
            on_attach = lsp_attach,
            capabilities = lsp_capabilities,
            before_init = function(_, config)
                local root_dir = config.root_dir or vim.fn.getcwd()
                config.settings = {
                    python = {
                        pythonPath = get_python_path(root_dir),
                    }
                }
            end,
        })

        -- Rounded borders for floating windows
        local orig_util = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or "rounded"
            return orig_util(contents, syntax, opts, ...)
        end
    end
}
