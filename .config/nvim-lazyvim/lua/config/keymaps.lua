-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Exit Insert Mode
vim.keymap.set("i", "jj", "<ESC>", { desc = "Exit Insert Mode" })
vim.keymap.set("i", "ｊｊ", "<ESC>", { desc = "Exit Insert Mode" })
vim.keymap.set("i", "っｊ", "<ESC>", { desc = "Exit Insert Mode" })

-- Select All
vim.keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select All" })

-- Split Window
vim.keymap.set("n", "ss", "<Cmd>split<CR>", { desc = "Split Window Horizontally" })
vim.keymap.set("n", "sv", "<Cmd>vsplit<CR>", { desc = "Split Window Vertically" })
vim.keymap.set("n", "sx", "<Cmd>close<CR>", { desc = "Close Window" })

-- Focus Window
vim.keymap.set("n", "sh", "<C-w>h", { desc = "Focus Left Window" })
vim.keymap.set("n", "sl", "<C-w>l", { desc = "Focus Right Window" })
vim.keymap.set("n", "sj", "<C-w>j", { desc = "Focus Lower Window" })
vim.keymap.set("n", "sk", "<C-w>k", { desc = "Focus Upper Window" })

-- buffer next/prev
vim.keymap.set("n", "<C-n>", "<Cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<C-p>", "<Cmd>bprev<CR>", { desc = "Previous Buffer" })

-- tab
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<S-Tab>", ":tabprev<CR>", { desc = "Next previous" })
vim.keymap.set("n", "te", ":tabedit<CR>", { desc = "Open tab" })
vim.keymap.set("n", "tx", ":tabclose<CR>", { desc = "Colse tab" })

-- Do not yank with x
vim.keymap.set("n", "x", '"_x', { desc = "Delete without yank" })

-- Visual Paste時にコピー元レジスタを保持する
vim.keymap.set("x", "p", '"_dP', { desc = "Paste Without Overwriting Register" })

-- Resize Window
vim.keymap.set("n", "<S-left>", "<C-w><", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<S-right>", "<C-w>>", { desc = "Increase Window Width" })
vim.keymap.set("n", "<S-up>", "<C-w>+", { desc = "Increase Window Height" })
vim.keymap.set("n", "<S-down>", "<C-w>-", { desc = "Decrease Window Height" })
vim.keymap.set("n", "=", "<C-w>=", { desc = "Equalize Window Sizes" })

-- 画面上のカーソル位置を固定したままテキストをスクロールする
vim.keymap.set("n", "<C-k>", "<C-y>k", { desc = "Scroll up keeping cursor in place" })
vim.keymap.set("n", "<C-j>", "<C-e>j", { desc = "Scroll down keeping cursor in place" })

-- undo/redo
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })
vim.keymap.set("n", "<C-r>", "<Nop>", { desc = "Disable Ctrl+r" })

--------------------------------------------------
-- Snacks.Picker Keybind
--------------------------------------------------

vim.keymap.set("n", ";f", function()
  Snacks.picker.files()
end, { desc = "Snacks Find Files" })

vim.keymap.set("n", ";g", function()
  Snacks.picker.grep()
end, { desc = "Snacks Grep" })

vim.keymap.set("n", ";d", function()
  Snacks.picker.diagnostics()
end, { desc = "Snacks Diagnostics" })

vim.keymap.set("n", ";b", function()
  Snacks.picker.buffers()
end, { desc = "Snacks Buffers" })

vim.keymap.set("n", ";h", function()
  Snacks.picker.help()
end, { desc = "Snacks Help" })

vim.keymap.set("n", ";k", function()
  Snacks.picker.keymaps()
end, { desc = "Snacks keymaps" })

vim.keymap.set("n", ";s", function()
  Snacks.picker.lsp_symbols()
end, { desc = "Snacks Document Symbols" })

vim.keymap.set("n", ";S", function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = "Snacks Workspace Symbols" })

--------------------------------------------------
-- Telescope file_browser
--------------------------------------------------
vim.keymap.set("n", "sf", function()
  local filename = vim.api.nvim_buf_get_name(0)

  local dir = filename ~= "" and vim.fn.fnamemodify(filename, ":p:h") or vim.fn.getcwd()

  require("telescope").extensions.file_browser.file_browser({
    path = dir,
    cwd = dir,
  })
end, { desc = "Telescope File Browser" })
