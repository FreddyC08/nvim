vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorcolumn = false
vim.o.ignorecase = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.clipboard = "unnamedplus"
vim.o.signcolumn = "yes"

local map = vim.keymap.set

map("n", "<leader>o", ":source<CR>")
map("n", "<leader>w", ":write<CR>")
map({ "n", "v", "x" }, "<leader>s", ":e #<CR>")
map({ "n", "v", "x" }, "<leader>S", ":sf #<CR>")

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/Vigemus/iron.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/mgierada/lazydocker.nvim" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
})

vim.cmd.colorscheme("vague")

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

require("mini.pick").setup()
require("oil").setup()
-- require("toggleterm").setup()
require("nvim-treesitter.configs").setup({
	ensure_installed = { "python", "julia", "dockerfile", "javascript" },
	highlight = { enable = true },
})

map("n", "<leader>f", ":pick files<cr>")
map("n", "<leader>h", ":pick help<cr>")
map("n", "<leader>e", ":oil<cr>")
map("n", "<leader>i", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
map("n", "<leader>lg", ":LazyGit<CR>", { desc = "Open lazygit" })
-- map("n", "<leader>ld", ":Lazydocker<CR>", { desc = "Open lazydocker" })
map({ "n", "t" }, "<leader>ld", function()
	require("lazydocker").open()
end, { desc = "Toggle Lazydocker floating window" })

-- LSP
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"pyright",
		"ruff",
		"julia-lsp",
		"oxlint",
		"dockerfile-language-server",
		"docker-language-server",
		"docker-compose-language-service",
	},
})
map("n", "<leader>lf", vim.lsp.buf.format)

-- lua requires config
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
					"require",
					"client",
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- python
-- julia
-- docker
-- js

vim.cmd(":hi statusline guibg=NONE")

-- IRON
local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup({
	config = {
		scratch_repl = true,
		repl_definition = {
			sh = {
				command = { "zsh" },
			},
			python = {
				command = {
					"ipython3",
					"--no-banner",
					"--no-autoindent",
					"--TerminalInteractiveShell.confirm_exit=False",
				},
				format = common.bracketed_paste_python,
				block_dividers = { "# %%", "#%%" },
				env = { PYTHON_BASIC_REPL = "1" },
			},
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
})

-- iron also has a list of commands, see :h iron-commands for all available commands
map("n", "<space>rf", "<cmd>IronFocus<cr>")
map("n", "<space>rh", "<cmd>IronHide<cr>")
