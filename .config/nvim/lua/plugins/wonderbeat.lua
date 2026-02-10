-- lua/plugins/rose-pine.lua
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end,
  },

  {
    "stevearc/overseer.nvim",
    tag = "v1.6.0",
  },

  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "kanagawa-wave",
  --   },
  -- },

  -- change trouble config
  -- {
  --   "folke/trouble.nvim",
  --   -- opts will be merged with the parent spec
  --   opts = { use_diagnostic_signs = true },
  -- },
  --
  -- -- disable trouble
  -- { "folke/trouble.nvim", enabled = false },
  --
  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  -- {
  --   "nvim-telescope/telescope.nvim",
  --   keys = {
  --     { "<leader><space>", "<cmd>Telescope frecency workspace=CWD<cr>", mode = "n", desc = "Recent (cwd)" },
  --     { "<leader>fr", "<cmd>Telescope frecency<cr>", mode = "n", desc = "Recent" },
  --     -- {
  --     --   "<leader>bb",
  --     --   function()
  --     --     require("telescope.builtin").buffers()
  --     --   end,
  --     --   desc = "Telescope Buffers",
  --     -- },
  --   },
  --   -- change some options
  --   opts = {
  --     defaults = {
  --       file_ignore_patterns = { "^./.git/", "^node_modules/", "^vendor/", "^.devbox", "^.cache", "^zig-cache" },
  --       layout_strategy = "horizontal",
  --       layout_config = { prompt_position = "top" },
  --       sorting_strategy = "ascending",
  --       winblend = 0,
  --     },
  --   },
  -- },
  --
  -- -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
        zls = {},
        biome = {}, -- ts
      },
    },
  },

  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        -- require("snacks").util.lsp.on(function(_, buffer)
        --    -- stylua: ignore
        --    vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
        --   vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        -- end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        --tsserver = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "java",
        "scala",
        "kotlin",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- the opts function can also be used to change the default opts:
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     table.insert(opts.sections.lualine_x, "😄")
  --   end,
  -- },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        sections = {
          lualine_x = { "overseer" },
        },
      }
    end,
  },
  --
  -- -- use mini.starter instead of alpha
  -- -- { import = "lazyvim.plugins.extras.ui.mini-starter" },
  --
  -- -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  -- { import = "lazyvim.plugins.extras.lang.json" },
  --
  -- add any tools you want to have installed below
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },

  -- {
  --   "copilotlsp-nvim/copilot-lsp",
  --   init = function()
  --     vim.g.copilot_nes_debounce = 100
  --     vim.lsp.enable("copilot_ls")
  --     vim.keymap.set({ "n", "i" }, "<S-tab>", function()
  --       local bufnr = vim.api.nvim_get_current_buf()
  --       local state = vim.b[bufnr].nes_state
  --       if state then
  --         -- Try to jump to the start of the suggestion edit.
  --         -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
  --         local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
  --           or (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())
  --         return nil
  --       else
  --         -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
  --         return "<C-i>"
  --       end
  --     end, { desc = "Accept Copilot NES suggestion", expr = true })
  --   end,
  -- },

  { "ellisonleao/gruvbox.nvim" },
  { "rebelot/kanagawa.nvim" },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua", -- optional
      -- "echasnovski/mini.pick", -- optional
    },

    config = function()
      require("neogit").setup({
        process_spinner = true,
      })
    end,
    keys = {
      {
        "<leader>gg",
        function()
          require("neogit").open()
        end,
        desc = "Magit Status",
      },
    },
  },
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = false,
      -- Methods of detecting the root directory. **"lsp"** uses the native neovim
      -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
      -- order matters: if one is not detected, the other is used as fallback. You
      -- can also delete or rearangne the detection methods.
      detection_methods = { "lsp", "pattern" },

      -- All the patterns used to detect root dir, when **"pattern"** is in
      -- detection_methods
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

      -- Table of lsp clients to ignore by name
      -- eg: { "efm", ... }
      ignore_lsp = {},

      -- Don't calculate root dir on specific directories
      -- Ex: { "~/.cargo/*", ... }
      exclude_dirs = {},
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("project_nvim").setup(opts)
      local history = require("project_nvim.utils.history")
      history.delete_project = function(project)
        for k, v in pairs(history.recent_projects) do
          if v == project.value then
            history.recent_projects[k] = nil
            return
          end
        end
      end
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension("projects")
      end)
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      ensure_installed = {
        "python", -- Debugpy
        "codelldb", -- C, C++, Rust, Zig
        -- "firefox",
        "bash",
        "js",
      },
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      --   typescript = {
      --     {
      --       name = "TS attach to process",
      --       type = "js",
      --       request = "attach",
      --       processId = require("dap.utils").pick_process,
      --       cwd = "${workspaceFolder}",
      --       sourceMaps = true,
      --     },
      --   },
      -- },
      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
        js = function(config)
          local dap = require("dap")
          dap.configurations["typescript"] = {
            {
              name = "TS attach to process",
              type = "typescript",
              request = "attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
              sourceMaps = true,
            },
            {
              type = "js",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
          }
          config.adapters = {
            type = "executable",
            command = vim.fn.exepath("js-debug-adapter"),
          }
          require("mason-nvim-dap").default_setup(config) -- don't forget this!
        end,
        -- js = function(config)
        --   config.adapters = {
        --     type = "server",
        --     port = "${port}",
        --     executable = {
        --       command = "/nvim/mason/bin/codelldb",
        --       args = { "--port", "${port}" },
        --     },
        --   }
        --   config.configurations = {
        --     name = "launch file",
        --     type = "codelldb",
        --     request = "launch",
        --     program = "${fileDirname}/" .. "${fileBasenameNoExtension}",
        --     cwd = "${fileDirname}",
        --     stopOnEntry = false,
        --     args = {},
        --   }
        --   -- config.adapters = {
        --   --   type = "server",
        --   --   host = "localhost",
        --   --   port = "${port}",
        --   --   executable = {
        --   --     command = "node",
        --   --     -- 💀 Make sure to update this path to point to your installation
        --   --     args = { "/path/to/js-debug/src/dapDebugServer.js", "${port}" },
        --   --   },
        --   -- }
        --   --
        --   -- config.configurations = {
        --   --   name = "TS attach to process",
        --   --   type = "node2",
        --   --   request = "attach",
        --   --   processId = require("dap.utils").pick_process,
        --   --   cwd = "${workspaceFolder}",
        --   --   sourceMaps = true,
        --   -- }
        --   -- type = "pwa-node",
        --   -- request = "launch",
        --   -- name = "Launch file",
        --   -- program = "${file}",
        --   -- cwd = "${workspaceFolder}",
        --   require("mason-nvim-dap").default_setup(config) -- don't forget this!
        -- end,
      },
    },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionToggle", "CodeCompanionAdd", "CodeCompanionChat" },

    opts = function()
      local options = {
        show_default_actions = true, -- Show the default actions in the action palette?
        show_default_prompt_library = true, -- Show the default prompt library in the action palette?
        log_level = "ERROR", -- TRACE|DEBUG|ERROR|INFO
        memory = {
          claude = {
            description = "Memory files for Claude Code users",
            files = {
              "~/.claude/CLAUDE.md",
              "CLAUDE.md",
              "CLAUDE.local.md",
            },
          },
          opts = {
            chat = {
              enabled = true,
              default_memory = { "claude" },
            },
          },
        },
      }
      local user = vim.env.USER or "User"

      options.strategies = {
        chat = {
          -- adapter = "GLM_ACP",
          adapter = "opencode",
          roles = {
            llm = "  CodeCompanion",
            user = "  " .. user,
          },
        },
        inline = {
          adapter = "GLM",
        },
        cmd = {
          adapter = "GLM",
        },
      }
      options.adapters = {
        acp = {
          GLM_ACP = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {},
            })
          end,
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              commands = {
                devbox = {
                  "devbox",
                  "run",
                  "gemini",
                },
                flash = {
                  "geminiz",
                  "--experimental-acp",
                  "-m",
                  "gemini-2.5-flash",
                },
                pro = {
                  "geminiz",
                  "--experimental-acp",
                  "-m",
                  "gemini-2.5-pro",
                },
                glm = {
                  "devbox",
                  "run",
                  "glm-acp",
                },
              },
              defaults = {
                auth_method = "gemini-api-key",
                -- auth_method = "gemini-api-key", -- "oauth-personal" | "gemini-api-key" | "vertex-ai"
                -- auth_method = "oauth-personal",
                -- auth_method = "vertex-ai",
              },
            })
          end,
        },

        Claude = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "anthropic/claude-3.7-sonnet",
              },
            },
          })
        end,
        Gemini = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "google/gemini-2.0-flash-001",
              },
            },
          })
        end,
        QWEN = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "qwen/qwen3-coder:free",
              },
            },
          })
        end,
        GLM = function()
          return require("codecompanion.adapters.http").extend("openai_compatible", {
            env = {
              --url = "https://api.z.ai/api/anthropic",
              url = "https://api.z.ai/api/coding/paas/v4",
              api_key = "GLM_API_KEY",
              chat_url = "/chat/completions",
            },
            opts = {
              show_model_choices = false,
            },
            schema = {
              model = {
                default = "GLM-4.7",
              },
            },
          })
        end,
      }

      return options
    end,

    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Prompt Actions (CodeCompanion)" },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle (CodeCompanion)" },
      { "<leader>ac", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add code to CodeCompanion" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Inline prompt (CodeCompanion)" },
    },
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "lawrence-laz/neotest-zig", -- Installation
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-zig")({
            dap = {
              adapter = "lldb",
            },
          }),
        },
      })
    end,
  },

  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>fR", LazyVim.pick("oldfiles"), desc = "Recent" },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent({ filter = { cwd = true } })
        end,
        desc = "Recent (cwd)",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep({
            cwd = vim.fn.expand("%:p:h"),
            desc = "Grep in Current File Directory",
          })
        end,
        desc = "Grep (Current Dir)",
      },
    },
  },

  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  {
    "nvim-mini/mini.move",
    event = "VeryLazy",
    opts = {
      mappings = {
        left = "<M-Left>",
        right = "<M-Right>",
        down = "<M-Down>",
        up = "<M-Up>",
      },
    },
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ "n", "x" }, "<leader>aA", function()
        require("opencode").ask("@this: ", { submit = true })
      end, { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>ax", function()
        require("opencode").select()
      end, { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "x" }, "<leader>ao", function()
        require("opencode").prompt("@this")
      end, { desc = "Add to opencode" })
      vim.keymap.set({ "n", "t" }, "<leader>at", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })
      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command("session.half.page.up")
      end, { desc = "opencode half page up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("session.half.page.down")
      end, { desc = "opencode half page down" })
      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
    end,
  },
  -- {
  --   "nvim-telescope/telescope-frecency.nvim",
  --   version = "*",
  --   config = function()
  --     require("telescope").load_extension("frecency")
  --   end,
  -- },
}
