return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      }
    },
    config = function()
      local lspconfig = require("lspconfig")

      local servers = {
        rust_analyzer = {
          diagnostics = {
            refreshSupport = false
          }
        },
        lua_ls = {},
        gopls = {},
        zls = {},
        arduino_language_server = {},
        denols = {
          root_dir = require("lspconfig").util.root_pattern({"deno.json", "deno.jsonc"}),
          -- single_file_support = false,
          settings = {},
        },
        clangd = {}
      }
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end


      -- Workaround for rust_analyzer issue -> known issue https://github.com/neovim/neovim/issues/30985#issuecomment-2447329525
      for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
        local default_diagnostic_handler = vim.lsp.handlers[method]
        vim.lsp.handlers[method] = function(err, result, context, config)
          if err ~= nil and err.code == -32802 then
            return
          end
          return default_diagnostic_handler(err, result, context, config)
        end
      end

      vim.keymap.set("n", "gd", vim.lsp.buf.definition)
      vim.keymap.set("n", "gI", vim.lsp.buf.implementation)
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename)
      vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action)
      vim.keymap.set("n", "<space>fo", vim.lsp.buf.format)
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      -- TODO:
      -- Finish kemap sets for LSP actions
      -- Find a way to figure out which LSP needs setup() called based on
      --   what's installed already
    end
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  }
}
