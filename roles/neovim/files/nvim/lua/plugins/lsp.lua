-- LSP Support (nvim 0.11+ native vim.lsp.config API)
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

        -- Keymaps on LSP attach
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func)
                    vim.keymap.set('n', keys, func, { buffer = event.buf })
                end
                map('gd',         vim.lsp.buf.definition)
                map('K',          vim.lsp.buf.hover)
                map('gr',         vim.lsp.buf.references)
                map('gi',         vim.lsp.buf.implementation)
                map('<leader>rn', vim.lsp.buf.rename)
                map('<leader>ca', vim.lsp.buf.code_action)
                map('<leader>tt', '<Cmd>!pytest %<CR>')
            end,
        })

        -- Rounded borders for floating windows (nvim 0.11+ way)
        vim.diagnostic.config({
            float = { border = 'rounded' },
            virtual_text = true,
            signs = true,
            update_in_insert = false,
        })

        -- Configure servers using new vim.lsp.config API
        vim.lsp.config('bashls',   { capabilities = capabilities })
        vim.lsp.config('lemminx',  { capabilities = capabilities })
        vim.lsp.config('marksman', { capabilities = capabilities })

        vim.lsp.config('lua_ls', {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { 'vim' } },
                },
            },
        })

        vim.lsp.config('pyright', {
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

        -- Enable all configured servers
        vim.lsp.enable({ 'bashls', 'lua_ls', 'pyright', 'lemminx', 'marksman' })
    end
}
