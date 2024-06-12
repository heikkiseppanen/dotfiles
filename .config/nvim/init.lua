vim.o.autoindent = true
vim.o.background = 'dark'
vim.o.colorcolumn = '80,120'
vim.o.shell = vim.fn.filereadable('/bin/fish') == 1 and '/bin/fish' or '/bin/bash'
vim.o.copyindent = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.relativenumber = true
vim.o.ruler = true
vim.o.scroll = 10
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.tabstop = 4
vim.o.wildmenu = true
vim.o.wildmode = 'longest:full,full'
vim.o.wrap = false
vim.o.list = true
vim.o.listchars = 'tab:  |'
vim.o.swapfile = false
vim.o.updatetime = 500

vim.g.mapleader = ' '

--------------------------------------------------------------------------------
-- PLUGINS
--------------------------------------------------------------------------------

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.local/share/nvim/site/plugged')

Plug('arcticicestudio/nord-vim')
Plug('morhetz/gruvbox')

Plug('neovim/nvim-lspconfig')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')

Plug('jackguo380/vim-lsp-cxx-highlight', {commit = '0e7476ff41cd65e55f92fdbc7326335ec33b59b0'})

Plug('42Paris/42header')

Plug('ziglang/zig.vim')

vim.call('plug#end')

--------------------------------------------------------------------------------

local opts = { noremap = true, silent = true }

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, opts)
vim.keymap.set('n', '<leader>fg', telescope.live_grep, opts)
vim.keymap.set('n', '<leader>fb', telescope.buffers, opts)
vim.keymap.set('n', '<leader>fh', telescope.help_tags, opts)

vim.g.user42 = 'hseppane'
vim.g.mail42 = 'marvin@42.ft'

vim.cmd('colorscheme gruvbox')
vim.g.gruvbox_contrast_dark='hard'

local on_attach = function(client, bufnr)
    local options = { buffer = bufnr, noremap = true, silent = true }

    vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', {} )

    vim.keymap.set('n', 'fs',         telescope.lsp_workspace_symbols, options)
    vim.keymap.set('n', 'fr',         telescope.lsp_references,    options)
    vim.keymap.set('n', 'gd',         telescope.lsp_definitions,   options)

    vim.keymap.set('n', '<leader>d',  vim.diagnostic.open_float,   options)
    vim.keymap.set('n', '<leader>gh', vim.lsp.buf.implementation,  options)
    vim.keymap.set('n', '<leader>td', vim.lsp.buf.type_definition, options)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,          options)
    vim.keymap.set('i', '<c-s>',      vim.lsp.buf.signature_help,  options)

    vim.cmd("set completeopt=menu,longest")
end

local handlers = {
    ["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
            border = "single"
        }
    )
}

local html_cap = vim.lsp.protocol.make_client_capabilities()
html_cap.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.html.setup{
    capabilities = html_cap,
    on_attach = on_attach,
    handlers = handlers,
}

require'lspconfig'.tsserver.setup{
    on_attach = on_attach,
    handlers = handlers,
}

require'lspconfig'.clangd.setup{
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gh', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
    end,
    handlers = handlers,
}

require'lspconfig'.zls.setup {
    on_attach = on_attach,
    handlers = handlers,
}

require'lspconfig'.pyright.setup {
    on_attach = on_attach,
    handlers = handlers,
}

require'lspconfig'.rust_analyzer.setup {
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true
            },
        }
    }
}

require'lspconfig'.lua_ls.setup {
    on_attach = on_attach,
    handlers = handlers,
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.json') then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = { version = 'LuaJit' },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            }
        })
    end,
    settings = {
        Lua = {
            telemetry = false,
        }
    }
}

-- Split movement
vim.keymap.set('n', '<M-h>', '<C-w>h', opts)
vim.keymap.set('n', '<M-j>', '<C-w>j', opts)
vim.keymap.set('n', '<M-k>', '<C-w>k', opts)
vim.keymap.set('n', '<M-l>', '<C-w>l', opts)

-- Term setup
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', opts)
vim.keymap.set('t', '<M-h>', '<C-\\><C-n><C-w>h', opts)
vim.keymap.set('t', '<M-j>', '<C-\\><C-n><C-w>j', opts)
vim.keymap.set('t', '<M-k>', '<C-\\><C-n><C-w>k', opts)
vim.keymap.set('t', '<M-l>', '<C-\\><C-n><C-w>l', opts)

vim.api.nvim_create_autocmd( {'TermOpen', 'TermEnter'}, {
    pattern = '*',
    callback = function()
        vim.wo.relativenumber = false
        vim.wo.number = false
    end
})

vim.api.nvim_create_user_command('ProjectOpen',
    function(options)
        vim.cmd('args ' .. options.fargs[1] .. '/**/*.*')
    end,
    {nargs = 1, complete = 'file'}
)

vim.cmd("echo 'Custom config loaded succesfully'")
