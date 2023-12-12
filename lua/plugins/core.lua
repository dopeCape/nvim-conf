return {
  "nvim-lua/plenary.nvim",
  { "AstroNvim/astrotheme",         opts = { plugins = { ["dashboard-nvim"] = true } } },
  { "famiu/bufdelete.nvim",         cmd = { "Bdelete", "Bwipeout" } },
  { "max397574/better-escape.nvim", event = "InsertCharPre",                           opts = { timeout = 300 } },
  {
    "NMAC427/guess-indent.nvim",
    event = "User AstroFile",
    config = require "plugins.configs.guess-indent",
  },
  { "Shatur/neovim-session-manager", event = "BufWritePost",         cmd = "SessionManager" },
  { "s1n7ax/nvim-window-picker",     opts = { use_winbar = "smart" } },
  {
    "mrjones2014/smart-splits.nvim",
    opts = { ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" }, ignored_buftypes = { "nofile" } },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = { java = false },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
    config = require "plugins.configs.nvim-autopairs",
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = { group = vim.g.icons_enabled and "" or "+", separator = "" },
      disable = { filetypes = { "TelescopePrompt" } },
    },
    config = require "plugins.configs.which-key",
  },
  {
    "kevinhwang91/nvim-ufo",
    event = { "User AstroFile", "InsertEnter" },
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      preview = {
        mappings = {
          scrollB = "<C-b>",
          scrollF = "<C-f>",
          scrollU = "<C-u>",
          scrollD = "<C-d>",
        },
      },
      provider_selector = function(_, filetype, buftype)
        local function handleFallbackException(bufnr, err, providerName)
          if type(err) == "string" and err:match "UfoFallbackException" then
            return require("ufo").getFolds(bufnr, providerName)
          else
            return require("promise").reject(err)
          end
        end

        return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
            or function(bufnr)
              return require("ufo")
                  .getFolds(bufnr, "lsp")
                  :catch(function(err) return handleFallbackException(bufnr, err, "treesitter") end)
                  :catch(function(err) return handleFallbackException(bufnr, err, "indent") end)
            end
      end,
    },
  },
  {
    "numToStr/Comment.nvim",
    keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
    opts = function()
      local commentstring_avail, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      return commentstring_avail and commentstring and { pre_hook = commentstring.create_pre_hook() } or {}
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      size = 10,
      open_mapping = [[<F7>]],
      shading_factor = 2,
      direction = "float",
      float_opts = {
        border = "curved",
        highlights = { border = "Normal", background = "Normal" },
      },
    },
  },
  {
    "ggandor/leap.nvim",
    keys = { { "s", mode = { "n", "v" } } },
  },
  {
    "ellisonleao/gruvbox.nvim",
    event = "VimEnter",
    opts = {
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        keywords = true,
        comments = true,
        operators = true,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "",  -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
  },
  {
    "xiyaowong/transparent.nvim",

    event = "VimEnter",
  },

  {
    "nvim-lua/plenary.nvim",

    event = "VimEnter",
  },
  {
    "lervag/vimtex",

    event = "VimEnter",
  },
  {
    "ray-x/aurora",

    event = "VimEnter",
  },
  {
    "0xStabby/chatgpt-vim",
    event = "VimEnter",
  },
  {
    "tpope/vim-fugitive",

    event = "VimEnter",
  },
  {
    "RRethy/vim-illuminate",

    event = "VimEnter",
  },
  {
    "Bryley/neoai.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    event = "VimEnter",
    cmd = {
      "NeoAI",
      "NeoAIOpen",
      "NeoAIClose",
      "NeoAIToggle",
      "NeoAIContext",
      "NeoAIContextOpen",
      "NeoAIContextClose",
      "NeoAIInject",
      "NeoAIInjectCode",
      "NeoAIInjectContext",
      "NeoAIInjectContextCode",
    },
    keys = {

      { "<leader>ag", desc = "generate git message" },
    },
    config = function()
      require("neoai").setup {
        -- Below are the default options, feel free to override what you would like changed
        ui = {
          output_popup_text = "NeoAI",
          input_popup_text = "Prompt",
          width = 30,               -- As percentage eg. 30%
          output_popup_height = 80, -- As percentage eg. 80%
          submit = "<Enter>",       -- Key binding to submit the prompt
        },
        models = {
          {
            name = "openai",
            model = "gpt-3.5-turbo",
            params = nil,
          },
        },
        register_output = {
          ["g"] = function(output) return output end,
          ["c"] = require("neoai.utils").extract_code_snippets,
        },
        inject = {
          cutoff_width = 75,
        },
        prompts = {
          context_prompt = function(context)
            return "Hey, I'd like to provide some context for future "
                .. "messages. Here is the code/text that I want to refer "
                .. "to in our upcoming conversations:\n\n"
                .. context
          end,
        },
        mappings = {
          ["select_up"] = "<C-k>",
          ["select_down"] = "<C-j>",
        },
        open_api_key_env = "OPENAI_KEY",
        shortcuts = {
          {
            name = "textify",
            key = "<leader>as",
            desc = "fix text with AI",
            use_context = true,
            prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
            modes = { "v" },
            strip_function = nil,
          },
          {
            name = "gitcommit",
            key = "<leader>ag",
            desc = "generate git commit message",
            use_context = false,
            prompt = function()
              return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system "git diff --cached"
            end,
            modes = { "n" },
            strip_function = nil,
          },
        },
      }
      -- Options go here
    end,
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function() require("lsp_lines").setup() end,
    event = "VimEnter",
  },
  {
    "anuvyklack/windows.nvim",

    event = "VimEnter",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require("windows").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",

    event = "VimEnter",
    -- config = require "plugins.configs.nvimbuddy",

    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
      },
    },
  },

  {
    "prisma/vim-prisma",
    event = "VimEnter",
  },
  {
    "lervag/vimtex",

    event = "VimEnter",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    event = "VimEnter",
  },
  {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "VimEnter",
    config = function()
      require("telekasten").setup {
        home = vim.fn.expand "~/notes", -- Put the name of your notes directory here
      }
    end,
  },
  {
    "renerocksai/calendar-vim",
    event = "VimEnter",
  },
  {
    "fredford/opulo-nvim",
    as = "opulo",

    event = "VimEnter",
  },
  {
    "David-Kunz/gen.nvim",

    event = "VimEnter",
    -- config = require "plugins.configs.gen",
  },
}
