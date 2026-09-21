local opt = vim.opt

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split" -- live preview substitutions in a split

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Files & undo
opt.undofile = true -- persist undo history across sessions
opt.swapfile = false
opt.backup = false
opt.updatetime = 250
opt.timeoutlen = 300

-- Editing
opt.clipboard = "unnamedplus"
opt.virtualedit = "block" -- allow cursor to move past end of line in visual block mode
opt.confirm = true -- prompt to save unsaved changes instead of erroring
