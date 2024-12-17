-- Lazy
return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  config = function()
    local home = vim.fn.expand("$HOME")
    require("chatgpt").setup({
      api_key_cmd = "gpg --decrypt " .. home .. "/openaikey.txt.gpg",
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim", -- optional
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>gc", "<cmd>ChatGPT<CR>", "ChatGPT" },
    { "<leader>ge", "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
    { "<leader>gg", "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
    { "<leader>gt", "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
    { "<leader>gk", "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
    { "<leader>gd", "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
    { "<leader>ga", "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
    { "<leader>go", "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
    { "<leader>gs", "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
    { "<leader>gf", "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
    { "<leader>gx", "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
    { "<leader>gr", "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
    { "<leader>gl", "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
  },
}
