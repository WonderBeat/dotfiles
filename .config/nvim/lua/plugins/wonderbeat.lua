return {
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

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
  {
    "nvim-telescope/telescope.nvim",
    -- keys = {
    --    -- add a keymap to browse plugin files
    --    -- stylua: ignore
    --    {
    --      "<leader>fp",
    --      function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
    --      desc = "Find Plugin File",
    --    },
    --   {
    --     "<leader>bb",
    --     function()
    --       require("telescope.builtin").buffers()
    --     end,
    --     desc = "Telescope Buffers",
    --   },
    -- },
    -- change some options
    opts = {
      defaults = {
        file_ignore_patterns = { "^./.git/", "^node_modules/", "^vendor/", "^.devbox", "^.cache", "^zig-cache" },
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
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
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
           -- stylua: ignore
           vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
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
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, "😄")
    end,
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
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
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },

  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionToggle", "CodeCompanionAdd", "CodeCompanionChat" },

    opts = function()
      local options = require("codecompanion.config")
      local user = vim.env.USER or "User"

      options.strategies.chat.roles = {
        llm = "  CodeCompanion",
        user = "  " .. user,
      }

      options.strategies.chat.keymaps.close.modes = {
        n = "q",
        i = "<Esc>",
      }
      options.strategies.chat.keymaps.stop.modes.n = "<Esc>"
      options.strategies.chat.keymaps.send.modes.n = "<CR>"

      return options
    end,

    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Prompt Actions (CodeCompanion)" },
      { "<leader>aa", "<cmd>CodeCompanionToggle<cr>", mode = { "n", "v" }, desc = "Toggle (CodeCompanion)" },
      { "<leader>ac", "<cmd>CodeCompanionAdd<cr>", mode = "v", desc = "Add code to CodeCompanion" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Inline prompt (CodeCompanion)" },
    },
  },
  { "ellisonleao/gruvbox.nvim" },
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
    config = true,
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
    "brianhuster/dirvish-git.nvim",
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
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "openrouter_gemini",
      vendors = {
        openrouter_sonnet = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API_KEY",
          model = "anthropic/claude-3.7-sonnet",
        },
        openrouter_gemini = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API_KEY",
          model = "google/gemini-2.0-flash-001",
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
