local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp_installer = require "nvim-lsp-installer"

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = 0 })
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = 0 }) -- Allow for signature_help in insert mode
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 }) -- Allow for signature_help in insert mode
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 }) -- Allow for signature_help in insert mode
    vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, {buffer = 0})
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end



-- Include the servers you want to have installed by default below
local servers = {
  "bashls",
  "pyright",
  "tsserver",
  "rust_analyzer",
  "gopls",
  "sumneko_lua",
  "yamlls"
}

for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    print("Installing " .. name)
    server:install()
  end
end


local enhance_server_opts = {
  -- Provide settings that should only apply to the "eslint" server
  ["eslint"] = function(opts)
    opts.settings = {
      format = {
        enable = true,
      },
    }
  end,
  ["sumneko_lua"] = function (opts)
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
      opts.settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim', 'use' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },

      }
      
  end
}

lsp_installer.on_server_ready(function(server)
  -- Specify the default options which we'll use to setup all servers
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if enhance_server_opts[server.name] then
    -- Enhance the default opts with the server-specific ones
    enhance_server_opts[server.name](opts)
  end

  server:setup(opts)
end)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--local servers = { 'pyright', 'rust_analyzer', 'tsserver', 'gopls' }
--for _, lsp in pairs(servers) do
--    require('lspconfig')[lsp].setup {
--        on_attach = on_attach,
--        capabilities = capabilities,
--        flags = {
--            -- This will be the default in neovim 0.7+
--            debounce_text_changes = 150,
--        }
--    }
--end
--
--
---- Language specific configuration
---- Lua
--
--local runtime_path = vim.split(package.path, ';')
--table.insert(runtime_path, "lua/?.lua")
--table.insert(runtime_path, "lua/?/init.lua")
--
--require 'lspconfig'.sumneko_lua.setup {
--    on_attach = on_attach,
--    capabilities = capabilities,
--    settings = {
--        Lua = {
--            runtime = {
--                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--                version = 'LuaJIT',
--                -- Setup your lua path
--                path = runtime_path,
--            },
--            diagnostics = {
--                -- Get the language server to recognize the `vim` global
--                globals = { 'vim' },
--            },
--            workspace = {
--                -- Make the server aware of Neovim runtime files
--                library = vim.api.nvim_get_runtime_file("", true),
--            },
--            -- Do not send telemetry data containing a randomized but unique identifier
--            telemetry = {
--                enable = false,
--            },
--        },
--    },
--}
