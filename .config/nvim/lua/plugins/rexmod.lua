-- Review comments for your coding agent and the editor side of the Rex Changes panel.
-- Installed by rexmod into ~/Library/Application Support/rexmod/nvim.
return {
  {
    dir = vim.fn.expand("~/Library/Application Support/rexmod/nvim"),
    name = "rexmod.nvim",
    lazy = false,
    config = function()
      require("rexmod").setup()
    end,
  },

  -- Media previews in the editor pane. Rex speaks the kitty graphics protocol, so snacks.image
  -- draws images in Neovim: images and PDFs open as pictures, videos show their first frame
  -- (ffmpeg), and images and mermaid blocks in markdown render beside the text.
  -- `<leader>uo` opens the file in its macOS app, e.g. to play a video.
  {
    "folke/snacks.nvim",
    init = function()
      -- snacks knows kitty, ghostty and wezterm; Rex identifies itself through TERM_PROGRAM.
      -- Unicode placeholders aren't verified in Rex, so images use direct placements.
      local envs = require("snacks.image.terminal").envs()
      table.insert(envs, 1, { name = "rex", env = { TERM_PROGRAM = "rex" }, supported = true, placeholders = false })

      -- Neovim 0.12 runs the TUI and the editor as two processes, and snacks sends images with
      -- nvim_ui_send, which doesn't reach Rex. In Rex, write them to the TUI's terminal instead:
      -- the parent process's tty.
      if vim.env.TERM_PROGRAM == "rex" then
        local tty
        local function open_tty()
          if tty == nil then
            local name = vim.trim(vim.fn.system({ "ps", "-o", "tty=", "-p", tostring(vim.uv.os_getppid()) }))
            tty = (vim.v.shell_error == 0 and name ~= "" and name ~= "??") and io.open("/dev/" .. name, "w") or false
          end
          return tty
        end
        local terminal = require("snacks.image.terminal")
        local write = terminal.write
        terminal.write = function(data)
          local f = open_tty()
          if not f then
            return write(data)
          end
          data = terminal.transform and terminal.transform(data) or data
          f:write(data)
          f:flush()
        end

        -- Without placeholders an image is a direct placement, and snacks only marks it hidden
        -- when its buffer leaves the window: it stays on screen over the next buffer. Delete
        -- the placement when it hides; snacks places it again when the buffer comes back.
        local placement = require("snacks.image.placement")
        local hide = placement.hide
        placement.hide = function(self)
          -- snacks never clears `hidden` when the image shows again, so don't check it;
          -- hide only runs when the window state changed, and a second delete is harmless.
          if self:ready() then
            terminal.request({ a = "d", d = "i", i = self.img.id, p = self.id })
          end
          return hide(self)
        end
      end
    end,
    opts = {
      image = {
        enabled = true,
        doc = { enabled = true, inline = false, float = true, max_width = 80, max_height = 30 },
      },
    },
    keys = {
      {
        "<leader>uo",
        function()
          local file = vim.api.nvim_buf_get_name(0)
          if file ~= "" then
            vim.ui.open(file)
          end
        end,
        desc = "Open File in System App",
      },
    },
  },

  -- Markdown renders in the buffer: headings, lists, tables, code blocks.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {},
  },

  -- `<leader>cp` toggles a live preview of the markdown file in the browser.
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>cp", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}
