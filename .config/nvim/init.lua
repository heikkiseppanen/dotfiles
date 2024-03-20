local o = vim.opt
local g = vim.g
local w = vim.wo
local b = vim.bo
local fn = vim.fn
local api = vim.api
local cmd = vim.cmd
local call = vim.call
local lsp = vim.lsp

--------------------------------------------------------------------------------
-- PLUGINS
--------------------------------------------------------------------------------

local Plug = vim.fn['plug#']

call('plug#begin', '~/.local/share/nvim/site/plugged')

Plug('arcticicestudio/nord-vim')
Plug('morhetz/gruvbox')

Plug('neovim/nvim-lspconfig')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', {tag = '0.1.4'})

Plug('jackguo380/vim-lsp-cxx-highlight', {commit = '0e7476ff41cd65e55f92fdbc7326335ec33b59b0'})

Plug('42Paris/42header', {commit = '71e6a4df6d72ae87a080282bf45bb993da6146b2'})

Plug('ziglang/zig.vim')

call('plug#end')

--------------------------------------------------------------------------------
-- NVIM CONFIG
--------------------------------------------------------------------------------

cmd('colorscheme gruvbox')

g.user42 = 'hseppane'
g.mail42 = 'marvin@42.ft'
g.mapleader = ','

o.autoindent = true
o.background = 'dark'
o.colorcolumn = { 80, 120 }
o.copyindent = true
o.cursorline = true
o.expandtab = true
o.mouse = 'a'
o.number = true
o.relativenumber = true
o.ruler = true
o.scroll = 10
o.shiftwidth = 4
o.smarttab = true
o.tabstop = 4
o.wildmenu = true
o.wildmode = 'longest:full,full'
o.wrap = false
o.list = true
o.listchars = 'tab:  |'
o.swapfile = false

vim.api.nvim_create_user_command('ProjectOpen',
	function(options)
		vim.cmd('args ' .. options.fargs[1] .. '/**/*.*')
	end,
	{nargs = 1, complete = 'file'}
)

local opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
	api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	api.nvim_buf_set_keymap(bufnr, 'n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	api.nvim_buf_set_keymap(bufnr, 'n', '<leader>td', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	api.nvim_buf_set_keymap(bufnr, 'i', '<c-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	cmd("set completeopt=menu,longest")
end

local handlers = {
	["textDocument/signatureHelp"] = lsp.with(
		lsp.handlers.signature_help, {
			border = "single"
		}
	)
}

require'lspconfig'.pyright.setup{
	on_attach = on_attach,
	handlers = handlers,
	settings = {
	    python = {
	        analysis = {
	            autoSearchPaths = true,
	            diagnosticMode = 'openFilesOnly',
	            useLibraryCodeForTypes = true,
	            typeCheckingMode = 'off'
            }
        }
    },
}

require'lspconfig'.tsserver.setup{
	on_attach = on_attach,
	handlers = handlers,
}

require'lspconfig'.clangd.setup{
	on_attach = on_attach,
	handlers = handlers,
}

require'lspconfig'.zls.setup {
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

local ts = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', ts.find_files, opts)
vim.keymap.set('n', '<leader>fg', ts.live_grep, opts)
vim.keymap.set('n', '<leader>fb', ts.buffers, opts)
vim.keymap.set('n', '<leader>fh', ts.help_tags, opts)

cmd("echo 'Custom config loaded succesfully'")
