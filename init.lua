vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"

vim.keymap.set('n', '<leader>s', ':source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/Vigemus/iron.nvim" },
})

vim.cmd.colorscheme("vague")

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

require "mini.pick".setup()
require "oil".setup()

vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
vim.keymap.set('n', '<leader>e', ':Oil<CR>')

vim.lsp.config('lua_ls', {
	settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
})

vim.lsp.enable({ "lua_ls", "pyright" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

vim.cmd(":hi statusline guibg=NONE")

-- IRON
local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup {
	config = {
		scratch_repl = true,
		repl_definition = {
			sh = {
				command = { "zsh" }
			},
			python = {
				command = { "ipython3", "--no-banner", "--no-autoindent" },
				format = common.bracketed_paste_python,
				block_dividers = { "# %%", "#%%" },
				env = { PYTHON_BASIC_REPL = "1" }
			}
		},
		repl_filetype = function(bufnr, ft)
			return ft
		end,
		dap_integration = true,
		repl_open_cmd = view.split.vertical.rightbelow("%40"),
	},
	keymaps = {
		toggle_repl = "<space>rr",
		restart_repl = "<space>rR",
		send_motion = "<space>sc",
		visual_send = "<space>sm",
		send_file = "<space>sf",
		send_line = "<space>sl",
		send_paragraph = "<space>sp",
		send_until_cursor = "<space>su",
		send_mark = "<space>ms",
		send_code_block = "<space>sb",
		send_code_block_and_move = "<space>sn",
		mark_motion = "<space>mc",
		mark_visual = "<space>mc",
		remove_mark = "<space>md",
		cr = "<space>s<cr>",
		interrupt = "<space>c<space>",
		exit = "<space>rq",
		clear = "<space>cl",
	},
	highlight = { italic = true },
	ignore_blank_lines = true,
}

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
