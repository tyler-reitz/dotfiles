-- Set leader key
vim.g.mapleader = " " -- sets <leader> to Space
vim.g.maplocalleader = " " -- optional: local leader also to Space

-- Add Mason bin folder to PATH
local mason_path = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = mason_path .. ":" .. vim.env.PATH

-- ====================================================================
-- Bootstrap lazy.nvim
-- ====================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ====================================================================
-- Plugins
-- ====================================================================
require("lazy").setup({

	-- LSP + tooling
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim", config = true },
	{ "williamboman/mason-lspconfig.nvim" },

	-- Autocompletion
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "L3MON4D3/LuaSnip" },

	-- Treesitter (syntax highlighting)
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	-- Telescope (fuzzy finder)
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Statusline
	{ "nvim-lualine/lualine.nvim" },

	-- Git integration
	{ "lewis6991/gitsigns.nvim" },

	-- Inline image rendering
	{
		"3rd/image.nvim",
		build = false,
		opts = {
			backend = "ueberzug",
			processor = "magick_cli",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki" },
				},
				html = {
					enabled = false,
				},
				css = {
					enabled = false,
				},
			},
			max_height_window_percentage = 50,
			window_overlap_clear_enabled = true,
			editor_only_render_when_focused = true,
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
		},
	},

	-- Linting & Formatting
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvimtools/none-ls-extras.nvim" },
	},

	-- Github Copilot
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	cmd = "Copilot",
	-- 	event = "InsertEnter",
	-- 	config = function()
	-- 		require("copilot").setup({
	-- 			suggestion = { enabled = true, auto_trigger = true, keymap = { accept = "<C-l>" } },
	-- 			panel = { enabled = true },
	-- 		})
	-- 	end,
	-- },

	-- Optional: show Copilot as a cmp source (instead of only ghost text)
	-- {
	-- 	"zbirenbaum/copilot-cmp",
	-- 	dependencies = { "zbirenbaum/copilot.lua" },
	-- 	config = function()
	-- 		require("copilot_cmp").setup()
	-- 	end,
	-- },

	-- ChatGPT
	--  {
	--  	"jackMort/ChatGPT.nvim",
	--  	config = function()
	--  		require("chatgpt").setup({
	--  			api_key_cmd = "echo $OPENROUTER_API_KEY",
	--  			api_host = "https://openrouter.ai/api/v1",
	--  			openai_params = {
	--  				model = "gpt-4o-mini",
	--  			},
	--  			debug = true,
	--  		})
	--  	end,
	--  	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	--  },

	-- {
	-- 	"yetone/avante.nvim",
	-- 	event = "VeryLazy",
	-- 	build = "make",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
  --     "nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	config = function()
	-- 		require("avante").setup({
	-- 			provider = "ollama",
	-- 			providers = {
	-- 				ollama = {
	-- 					model = "qwen2.5-coder:3b",
	-- 					-- Avante disables ollama by default unless this returns true
	-- 					is_env_set = function()
	-- 						return true
	-- 					end,
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      provider = "openrouter",
      providers = {
        openrouter = {
          __inherited_from = "openai",
          api_key_name = "OPENROUTER_API_KEY",
          endpoint = "https://openrouter.ai/api/v1",
          model = "openrouter/free",
          extra_request_body = {
            temperature = 0,
          },
        },
      },
    },
  }

})

-- ====================================================================
-- Basic Settings
-- ====================================================================
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.cursorline = true

-- ====================================================================
-- pywal Theme
-- ====================================================================
local function apply_pywal_theme()
  local wal_file = vim.fn.expand("~/.cache/wal/colors-wal.vim")
  if vim.fn.filereadable(wal_file) == 0 then
    return nil
  end

  vim.cmd("source " .. vim.fn.fnameescape(wal_file))

  local c = {
    bg = vim.g.background,
    fg = vim.g.foreground,
    cursor = vim.g.cursor,
    black = vim.g.color0,
    red = vim.g.color1,
    green = vim.g.color2,
    yellow = vim.g.color3,
    blue = vim.g.color4,
    magenta = vim.g.color5,
    cyan = vim.g.color6,
    white = vim.g.color7,
    muted = vim.g.color8,
    bright_red = vim.g.color9,
    bright_green = vim.g.color10,
    bright_yellow = vim.g.color11,
    bright_blue = vim.g.color12,
    bright_magenta = vim.g.color13,
    bright_cyan = vim.g.color14,
    bright_white = vim.g.color15,
  }

  vim.o.background = "dark"
  vim.cmd("highlight clear")
  vim.g.colors_name = "pywal-custom"

  local set = vim.api.nvim_set_hl
  set(0, "Normal", { fg = c.fg, bg = c.bg })
  set(0, "NormalFloat", { fg = c.fg, bg = c.bg })
  set(0, "FloatBorder", { fg = c.blue, bg = c.bg })
  set(0, "CursorLine", { bg = c.black })
  set(0, "CursorLineNr", { fg = c.blue, bold = true })
  set(0, "LineNr", { fg = c.muted })
  set(0, "SignColumn", { bg = c.bg })
  set(0, "EndOfBuffer", { fg = c.bg, bg = c.bg })
  set(0, "VertSplit", { fg = c.black, bg = c.bg })
  set(0, "WinSeparator", { fg = c.black, bg = c.bg })
  set(0, "StatusLine", { fg = c.fg, bg = c.black })
  set(0, "StatusLineNC", { fg = c.muted, bg = c.black })
  set(0, "Pmenu", { fg = c.fg, bg = c.black })
  set(0, "PmenuSel", { fg = c.bg, bg = c.blue, bold = true })
  set(0, "Visual", { bg = c.magenta, fg = c.bg })
  set(0, "Search", { bg = c.yellow, fg = c.bg })
  set(0, "IncSearch", { bg = c.red, fg = c.bg })
  set(0, "MatchParen", { fg = c.bright_white, bg = c.black, bold = true })
  set(0, "Comment", { fg = c.muted, italic = true })
  set(0, "Constant", { fg = c.yellow })
  set(0, "String", { fg = c.green })
  set(0, "Character", { fg = c.green })
  set(0, "Number", { fg = c.magenta })
  set(0, "Boolean", { fg = c.magenta })
  set(0, "Identifier", { fg = c.fg })
  set(0, "Function", { fg = c.blue })
  set(0, "Statement", { fg = c.red })
  set(0, "Keyword", { fg = c.red })
  set(0, "PreProc", { fg = c.magenta })
  set(0, "Type", { fg = c.cyan })
  set(0, "Special", { fg = c.bright_yellow })
  set(0, "DiagnosticError", { fg = c.red })
  set(0, "DiagnosticWarn", { fg = c.yellow })
  set(0, "DiagnosticInfo", { fg = c.blue })
  set(0, "DiagnosticHint", { fg = c.cyan })
  set(0, "Directory", { fg = c.blue, bold = true })
  set(0, "netrwDir", { fg = c.blue, bold = true })
  set(0, "netrwClassify", { fg = c.yellow })
  set(0, "netrwExe", { fg = c.green })
  set(0, "netrwSymLink", { fg = c.cyan })
  set(0, "netrwLink", { fg = c.cyan, underline = true })
  set(0, "netrwPlain", { fg = c.fg })
  set(0, "netrwComment", { fg = c.muted, italic = true })
  set(0, "netrwTreeBar", { fg = c.muted })
  set(0, "netrwHelpCmd", { fg = c.magenta })
  set(0, "netrwCmdSep", { fg = c.muted })
  set(0, "netrwVersion", { fg = c.yellow })

  return c
end

local wal_colors = apply_pywal_theme()

-- ====================================================================
-- Lualine
-- ====================================================================
local lualine_opts = {}
if wal_colors then
  lualine_opts = {
    options = {
      theme = {
        normal = {
          a = { fg = wal_colors.bg, bg = wal_colors.blue, gui = "bold" },
          b = { fg = wal_colors.fg, bg = wal_colors.black },
          c = { fg = wal_colors.muted, bg = wal_colors.bg },
        },
        insert = {
          a = { fg = wal_colors.bg, bg = wal_colors.green, gui = "bold" },
          b = { fg = wal_colors.fg, bg = wal_colors.black },
        },
        visual = {
          a = { fg = wal_colors.bg, bg = wal_colors.magenta, gui = "bold" },
          b = { fg = wal_colors.fg, bg = wal_colors.black },
        },
        replace = {
          a = { fg = wal_colors.bg, bg = wal_colors.red, gui = "bold" },
          b = { fg = wal_colors.fg, bg = wal_colors.black },
        },
        command = {
          a = { fg = wal_colors.bg, bg = wal_colors.yellow, gui = "bold" },
          b = { fg = wal_colors.fg, bg = wal_colors.black },
        },
        inactive = {
          a = { fg = wal_colors.muted, bg = wal_colors.bg },
          b = { fg = wal_colors.muted, bg = wal_colors.bg },
          c = { fg = wal_colors.muted, bg = wal_colors.bg },
        },
      },
    },
  }
end

require("lualine").setup(lualine_opts)

-- ====================================================================
-- Treesitter
-- ====================================================================
require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	indent = { enable = true },
})

-- Treat .mjs files as JavaScript
vim.filetype.add({
	extension = {
		mjs = "javascript",
	},
})

-- ====================================================================
-- Mason + LSP (Neovim 0.11+ native config)
-- ====================================================================
require("mason").setup()

-- You can keep mason-lspconfig *just* for ensure_installed, even if you don't use lspconfig.
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "ts_ls", "pyright" },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- lua_ls (Lua)
vim.lsp.config.lua_ls = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".git", ".luarc.json", ".luarc.jsonc" },
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
    },
  },
}

-- ts_ls (typescript-language-server for JS/TS)
vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  capabilities = capabilities,
}

-- pyright (Python)
vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  capabilities = capabilities,
}

-- Enable the servers (auto-start when a matching filetype opens)
vim.lsp.enable({ "lua_ls", "ts_ls", "pyright" })

-- ====================================================================
-- Formatting + linting (via null-ls / none-ls)
-- ====================================================================
local null_ls = require("null-ls")

null_ls.setup({
	debug = true,
	sources = {
		-- Formatters
		null_ls.builtins.formatting.prettier, -- JS/TS/JSON/Markdown
		null_ls.builtins.formatting.stylua, -- Lua

		-- Linters
		-- null_ls.builtins.diagnostics.eslint_d, -- JS/TS
		require("none-ls.diagnostics.eslint_d"), -- faster eslint
	},
})

-- Create a :Format command
vim.api.nvim_create_user_command("Format", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format current buffer with LSP" })

vim.keymap.set("n", "<leader>f", "<cmd>Format<CR>", { desc = "Format file" })

-- DIAGNOSTIC SHORTCUTS
local opts = { noremap = true, silent = true }

-- Show the diagnostic message for the current line
vim.api.nvim_set_keymap("n", "<leader>e", '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>', opts)

-- Jump to the next diagnostic in the buffer
vim.api.nvim_set_keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ float = { border = "rounded" }})<CR>', opts)

-- Jump to the previous diagnostic in the buffer
vim.api.nvim_set_keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ float = { border = "rounded" }})<CR>', opts)

-- Open all diagnostics for the current buffer in the location list
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

-- ====================================================================
-- Autocompletion (nvim-cmp)
-- ====================================================================
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		-- { name = "copilot" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

-- ====================================================================
-- Telescope keymaps
-- ====================================================================
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- ====================================================================
-- GhatGPT keymaps
-- ====================================================================
vim.keymap.set("n", "<leader>cg", ":ChatGPT<CR>", { desc = "ChatGPT prompt" })

-- Basic LSP navigation keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })

-- ====================================================================
-- ChatGPT keymaps (editing workflow)
-- ====================================================================
vim.keymap.set("n", "<leader>cg", "<cmd>ChatGPT<CR>", { desc = "ChatGPT prompt" })

-- Edit the current buffer with instructions (great for refactors)
vim.keymap.set("n", "<leader>ce", "<cmd>ChatGPTEditWithInstructions<CR>", { desc = "Edit buffer w/ instructions" })

-- Edit a visual selection with instructions (great for a component/function)
vim.keymap.set("v", "<leader>ce", "<cmd>ChatGPTEditWithInstructions<CR>", { desc = "Edit selection w/ instructions" })

-- Avante keymaps (adjust if you prefer different keys)
vim.keymap.set("n", "<leader>aa", "<cmd>AvanteAsk<CR>", { desc = "Avante: ask" })
vim.keymap.set("v", "<leader>aa", "<cmd>AvanteAsk<CR>", { desc = "Avante: ask (selection)" })
vim.keymap.set("n", "<leader>ar", "<cmd>AvanteRefresh<CR>", { desc = "Avante: refresh" })
