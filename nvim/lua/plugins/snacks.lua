local function snacks(callback)
  return function()
    local ok, Snacks = pcall(require, "snacks")
    if not ok then
      vim.notify("snacks.nvim is not available", vim.log.levels.ERROR)
      return
    end
    callback(Snacks)
  end
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      explorer = { enabled = true },
      image = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      { "<leader><space>", snacks(function(Snacks) Snacks.picker.smart() end), desc = "Smart Find Files" },
      { "<leader>,", snacks(function(Snacks) Snacks.picker.buffers() end), desc = "Buffers" },
      { "<leader>/", snacks(function(Snacks) Snacks.picker.grep() end), desc = "Grep" },
      { "<leader>e", snacks(function(Snacks) Snacks.explorer() end), desc = "File Explorer" },
      { "<leader>ff", snacks(function(Snacks) Snacks.picker.files() end), desc = "Find Files" },
      { "<leader>fg", snacks(function(Snacks) Snacks.picker.git_files() end), desc = "Find Git Files" },
      { "<leader>fr", snacks(function(Snacks) Snacks.picker.recent() end), desc = "Recent Files" },
      { "<leader>sg", snacks(function(Snacks) Snacks.picker.grep() end), desc = "Grep" },
      { "<leader>sw", snacks(function(Snacks) Snacks.picker.grep_word() end), desc = "Search Word" },
      { "<leader>un", snacks(function(Snacks) Snacks.picker.notifications() end), desc = "Notification History" },
    },
  },
}
