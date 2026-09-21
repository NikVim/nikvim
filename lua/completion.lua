local opt = vim.opt

-- Popup menu
opt.completeopt = "menuone,noselect"
opt.pumheight = 10

-- Command-line completion
opt.wildmode = "noselect:lastused,full"
opt.wildoptions = "pum" -- popup-style wildmenu, matching the completion popup's look
opt.wildignorecase = true

-- Server-advertised triggerCharacters (e.g. "." for lua_ls) only fire the
-- popup after punctuation. Extending them with identifier characters makes
-- autotrigger fire on every typed letter/digit too. See :h lsp-autocompletion.
local identifier_chars = vim.split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_", "")

local augroup = vim.api.nvim_create_augroup("nikvim_completion", {})

-- Auto-show the popup-style wildmenu as you type on the command line and
-- in search, instead of requiring a manual 'wildchar' press. See
-- :h cmdline-autocompletion.
vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = augroup,
  pattern = { ":", "/", "?" },
  callback = function()
    vim.fn.wildtrigger()
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client:supports_method("textDocument/completion") then
      return
    end

    local completion_provider = client.server_capabilities.completionProvider
    if completion_provider then
      local triggers = completion_provider.triggerCharacters or {}
      completion_provider.triggerCharacters = vim.list_extend(vim.deepcopy(triggers), identifier_chars)
    end

    vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
  end,
})
