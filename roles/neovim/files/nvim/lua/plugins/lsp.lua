-- LSP Support (nvim 0.11+ native API)
return {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
        { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
        -- Mason setup
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                'bashls',
                'lua_ls',
                'pyright',
                'lemminx',
                'marksman',
            }
        })

        require('mason-tool-installer').setup({
            ensure_installed = {
                'black',
                'debugpy',
                'flake8',
                'isort',
                'mypy',
                'pylint',
            },
        })

        require('fidget').setup({})

        -- Keymaps on LSP attach
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
                end

                map('gd',          vim.lsp.buf.definition,     'Go to definition')
                map('K',           vim.lsp.buf.hover,           'Hover docs')
                map('gr',          vim.lsp.buf.references,      'References')
                map('gi',          vim.lsp.buf.implementation,  'Implementation')
                map('<leader>rn',  vim.lsp.buf.rename,          'Rename')
                map('<leader>ca',  vim.lsp.buf.code_action,     'Code action')
                map('<leader>tt',  '<Cmd>!pytest %<CR>',        'Run pytest')

                -- Diagnostics
                vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                    vim.lsp.diagnostic.on_publish_diagnostics, {
                        virtual_text = true,
                        signs = true,
                        update_in_insert = false,
                    }
                )
            end,
        })

        -- Capabilities for cmp
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
        if ok then
            capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end

        -- Python path detection
        local function get_python_path(workspace)
            if vim.env.VIRTUAL_ENV then
                return vim.env.VIRTUAL_ENV .. '/bin/python'
            end
            local match = vim.fn.glob(workspace .. '/.venv/bin/python')
            if match ~= '' then return match end
            return 'python3'
        end

        -- Setup LSPs
        local lspconfig = require('lspconfig')

        local servers = { 'bashls', 'lemminx', 'marksman' }
        for _, server in ipairs(servers) do
            lspconfig[server].setup({ capabilities = capabilities })
        end

        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { 'vim' } },
                },
            },
        })

        lspconfig.pyright.setup({
            capabilities = capabilities,
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
