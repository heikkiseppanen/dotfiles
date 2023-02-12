local o = vim.opt
local g = vim.g
local w = vim.wo
local b = vim.bo
local fn = vim.fn
local api = vim.api
local cmd = vim.cmd
local call = vim.call

if g.vscode then

else

	--------------------------------------------------------------------------------
	-- PLUGINS
	--------------------------------------------------------------------------------

	local Plug = vim.fn['plug#']

	call('plug#begin', '~/.local/share/nvim/site/plugged')

	-- Nord theme (4.3.2022)
	Plug('arcticicestudio/nord-vim', {commit = 'a8256787edbd4569a7f92e4e163308ab8256a6e5'})

	-- Lspconfig (4.3.2022)
	Plug('neovim/nvim-lspconfig', {commit = 'cdc2ec53e028d32f06c51ef8b2837ebb8460ef45'})

	-- C++ LSP semantic higlights (4.3.2022)
	Plug('jackguo380/vim-lsp-cxx-highlight', {commit = '0e7476ff41cd65e55f92fdbc7326335ec33b59b0'})

	Plug('42Paris/42header', {commit = '71e6a4df6d72ae87a080282bf45bb993da6146b2'})

	call('plug#end')

	--------------------------------------------------------------------------------
	-- LSP CONFIG
	--------------------------------------------------------------------------------

	local opts = { noremap = true, silent = true }

	local on_attach = function(client, bufnr)
		api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
		api.nvim_buf_set_keymap(bufnr, 'n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
		api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
		api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
		api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
		api.nvim_buf_set_keymap(bufnr, 'n', '<leader>td', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
		api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		cmd("set completeopt-=preview")
	end

	require'lspconfig'.ccls.setup{
		on_attach = on_attach,
		init_options = {
			client = {
				snippetSupport = true
				},
			codeLens = {
				localVariables = true
			},
			completion = {
				caseSensitivity = 2,
				detailedLabel = true,
				placeholder = false
			},
			highlight = {
				lsRanges = true
			},
			index = {
				threads = 4
			}
		}
	}

	require'lspconfig'.rust_analyzer.setup{
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

g.user42 = 'hseppane'
g.mail42 = 'marvin@42.ft'

cmd('colorscheme nord')

end

o.autoindent = true
o.background = 'dark'
o.colorcolumn = { 80 }
o.copyindent = true
o.cursorline = true
o.expandtab = false
o.mouse = 'a'
o.number = true
o.relativenumber = true
o.ruler = true
o.scroll = 5
o.shiftwidth = 4
o.smarttab = true
o.tabstop = 4
o.wildmenu = true
o.wrap = false
o.list = true
o.listchars = 'tab:  |'

g.mapleader = ','

cmd("echo 'Custom config loaded succesfully'")
