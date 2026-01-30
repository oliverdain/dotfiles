-- For posterirty, I've tried several times to use https://github.com/coder/claudecode.nvim instead of
-- "greggh/claude-code.nvim". It promises more "real" IDE integration but I've found several issues with it:
-- First, it runs in a terminal mode which makes things like copy paste really annoying (e.g. see
-- https://stackoverflow.com/questions/41681739/how-can-i-paste-neovim-registers-in-terminal-mode). Second, the IDE
-- integration doesn't actually work very well (see my bug here: https://github.com/coder/claudecode.nvim/issues/182)
-- and most of what it does can be replicated by just copy/pasting the path to the currently open buffer. Third, some of
-- the seemingly nice benefits like side-by-side diffs are actually awkard because they get embedded between open buffer
-- and are thus hard to read. Finally, by default it can only put the Claude window on the left or right, but not on the
-- bottom where I want it (though I was able to fix with this hack:
-- https://github.com/coder/claudecode.nvim/issues/153#issuecomment-3647955480. Still, at the end of the day I find
-- greggh more intuitive so I'm sticking with that for now but maybe re-evaluate in the future.
return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
      require("claude-code").setup({
        -- Terminal window settings
        window = {
          split_ratio = 0.3,      -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
          position = "botright",  -- Position of the window: "botright", "topleft", "vertical", "rightbelow vsplit", etc.
          enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
          hide_numbers = true,    -- Hide line numbers in the terminal window
          hide_signcolumn = true, -- Hide the sign column in the terminal window
        },
        -- File refresh settings
        refresh = {
          enable = true,           -- Enable file change detection
          updatetime = 100,        -- updatetime when Claude Code is active (milliseconds)
          timer_interval = 1000,   -- How often to check for file changes (milliseconds)
          show_notifications = true, -- Show notification when files are reloaded
        },
        -- Git project settings
        git = {
          use_git_root = false,     -- Set CWD to git root when opening Claude Code (if in git project)
        },
        -- Shell-specific settings
        shell = {
          separator = '&&',        -- Command separator used in shell commands
          pushd_cmd = 'pushd',     -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
          popd_cmd = 'popd',       -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
        },
        -- Command settings
        command = "claude",        -- Command used to launch Claude Code
        -- Command variants
        command_variants = {
          -- Conversation management
          continue = "--continue", -- Resume the most recent conversation
          resume = "--resume",     -- Display an interactive conversation picker

          -- Output options
          verbose = "--verbose",   -- Enable verbose logging with full turn-by-turn output
        },
        -- Keymaps
        keymaps = {
          toggle = {
            normal = "<C-,>",       -- Normal mode keymap for toggling Claude Code, false to disable
            terminal = "<C-,>",     -- Terminal mode keymap for toggling Claude Code, false to disable
            variants = {},
          },
          window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
          scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
        }
      })
      vim.api.nvim_create_user_command("Cc", "ClaudeCode", {})
  end
}
