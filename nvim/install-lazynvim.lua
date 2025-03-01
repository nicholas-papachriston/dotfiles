-- LazyVim bootstrap script
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  print("Done installing lazy.nvim!")
end

vim.opt.rtp:prepend(lazypath)

-- Check if starter.nvim exists
local starter_path = vim.fn.stdpath("config") .. "/lua/plugins/starter.lua"
if not vim.loop.fs_stat(starter_path) then
  -- Create the starter plugin config
  local starter_dir = vim.fn.stdpath("config") .. "/lua/plugins"
  vim.fn.mkdir(starter_dir, "p")
  
  local f = io.open(starter_path, "w")
  if f then
    f:write([[
-- First plugins to install
return {
  -- LazyVim core
  { 
    "LazyVim/LazyVim", 
    import = "lazyvim.plugins", 
    version = "*",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  
  -- Color scheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      term_colors = true,
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = true,
        mini = true,
      },
    },
  },
  
  -- Editor UI
  { "nvim-neo-tree/neo-tree.nvim", opts = {} },
  { "nvim-telescope/telescope.nvim", opts = {} },
  { "folke/which-key.nvim", opts = {} },
  
  -- LSP & Completion
  { "neovim/nvim-lspconfig", opts = {} },
  { "hrsh7th/nvim-cmp", opts = {} },
  
  -- Git
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "sindrets/diffview.nvim", opts = {} },
  
  -- Terminal
  { "akinsho/toggleterm.nvim", opts = {} },
}
]])
    f:close()
    print("Created starter plugin configuration.")
  else
    print("Failed to create starter configuration.")
  end
end

-- Load lazy and plugins
require("lazy").setup("plugins")

-- Install and sync all plugins
require("lazy").install()
require("lazy").sync()

print("LazyVim installation complete!") 