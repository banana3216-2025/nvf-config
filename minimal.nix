{pkgs, ...}: {
  vim = {
    extraLuaFiles = [
      (pkgs.writeText "dashboard-banner.lua" ''
        local status, alpha = pcall(require, "alpha")
        if status then
          local dashboard = require("alpha.themes.dashboard")

          -- 1. Create your custom blue highlight group safely
          vim.api.nvim_set_hl(0, "AlphaBlueHeader", { fg = "#8aadf4" })

          local banner_placed = false

          -- 2. Modify dashboard elements dynamically
          for _, element in ipairs(dashboard.config.layout) do
            if element.type == "text" then
              if not banner_placed then
                element.opts.hl = "AlphaBlueHeader"
                element.val = {
                  "                                                                       ",
                  "                                                                     ",
                  "       ████ ██████           █████      ██                     ",
                  "      ███████████             █████                             ",
                  "      █████████ ███████████████████ ███   ███████████   ",
                  "     █████████  ███    █████████████ █████ ██████████████   ",
                  "    █████████ ██████████ █████████ █████ █████ ████ █████   ",
                  "  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
                  " ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
                  "                                                                       ",
                }
                banner_placed = true
              else
                element.val = {}
              end
            end

            -- 3. Filter buttons using legacy v2 character sets
            if element.type == "group" then
              -- SWAPPED: Using legacy symbols to ensure absolute fallback compatibility
              local b1 = dashboard.button("e", "  New file", "<cmd>ene <BAR> startinsert <CR>")
              local b2 = dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>")
              local b3 = dashboard.button("t", "  Find Notes", "<cmd>TodoTelescope<CR>")
              local b4 = dashboard.button("q", "  Exit", "<cmd>qa<CR>")

              b1.opts.hl_shortcut = "Number"
              b2.opts.hl_shortcut = "Number"
              b3.opts.hl_shortcut = "Number"
              b4.opts.hl_shortcut = "Number"

              element.val = { b1, b2, b3, b4 }
            end
          end

          alpha.setup(dashboard.config)
        end
      '')
    ];

    theme = {
      enable = true;
      name = "catppuccin";
      style = "macchiato";
    };

    visuals = {
      nvim-web-devicons.enable = true;
      indent-blankline.enable = true;
    };

    statusline.lualine = {
      enable = true;
      theme = "auto";
    };

    dashboard.alpha = {
      enable = true;
      theme = "dashboard";
    };

    notes.todo-comments = {
      enable = true;
      setupOpts = {
        signs = true; # Show icons in the signs column
        highlight = {
          before = "";
          keyword = "wide"; # Highlight styles: "fg", "bg", "wide"
          after = "fg";
        };
        keywords = {
          FIX = {
            icon = " ";
            color = "error";
            alt = ["FIXME" "BUG"];
          };
          TODO = {
            icon = " ";
            color = "info";
          };
          NOTE = {
            icon = " ";
            color = "hint";
            alt = ["INFO"];
          };
          TEST = {
            icon = "⏲ ";
            color = "test";
            alt = ["TESTING"];
          };
          HACK = {
            icon = " ";
            color = "warning";
          };
          WARN = {
            icon = " ";
            color = "warning";
            alt = ["WARNING"];
          };
        };
      };
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      trouble.enable = true;
    };

    autocomplete.blink-cmp = {
      enable = true;

      friendly-snippets.enable = true;
      setupopts = {
        keymap.preset = "default"; # options: "default", "super-tab", "enter"
        sources.default = ["lsp" "path" "snippets" "buffer"];
      };
    };

    diagnostics.enable = true;
    diagnostics.config = {
      virtual_text = true;
      underline = true;
      signs = true;
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableDAP = true;

      clang = {
        enable = true;

        lsp.enable = true;
        lsp.servers = ["clangd"];

        treesitter.enable = true;
        dap.enable = true;

        format.enable = true;
        format.type = ["clang-format"];
      };

      markdown = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        extensions.render-markdown-nvim.enable = true;
      };

      nix = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };
    };

    extraPackages = with pkgs; [
      lazygit # for the popup
    ];

    telescope.enable = true;
    filetree.neo-tree.enable = true;
    tabline.nvimBufferline.enable = true;
    git.enable = true;

    terminal.toggleterm = {
      enable = true;
      lazygit.enable = true;
    };

    viAlias = false;
    vimAlias = true;

    options.shiftwidth = 2;
    #    luaConfigRC.filetype-tabs = ''
    #      local tab_group = vim.api.nvim_create_augroup("FileTypeTabs", { clear = true })
    #
    #      vim.api.nvim_create_autocmd("FileType", {
    #        group = tab_group,
    #        pattern = { "c", "cpp", "python", "go", "rust", "javascript", "js", "qml", "qmljs", "html" },
    #        callback = function()
    #          -- Use a scheduled callback to run AFTER other plugins settle down
    #          vim.schedule(function()
    #            vim.opt_local.tabstop = 4
    #            vim.opt_local.softtabstop = 4
    #            vim.opt_local.shiftwidth = 4
    #            vim.opt_local.expandtab = true
    #          end)
    #        end,
    #      })
    #    '';

    formatter.conform-nvim.setupOpts = {
      formatters_by_ft = {
      };

      formatters = {
        clang-format = {
          # This appends the exact 4-space argument to the binary command array
          prepend_args = ["-style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4}"];
        };
      };
    };

    globals.mapleader = " ";
    options.timeoutlen = 500;

    keymaps = [
      {
        key = "<leader>fg";
        mode = "n";
        action = ":Telescope find_files<CR>";
        silent = true;
        desc = "Telescope Find Files";
      }

      {
        key = "<leader>ff";
        mode = "n";
        action = ":Telescope live_grep<CR>";
        silent = true;
        desc = "Telescope Live Grep";
      }

      {
        key = "<leader><C-a>";
        mode = "n";
        action = ":lua vim.lsp.buf.code_action()<CR>";
        silent = true;
        desc = "LSP: trigger code actions";
      }

      {
        key = "<leader>aa";
        mode = "n";
        action = ":Neotree toggle<CR>";
        silent = true;
        desc = "Toggles Neo-Tree";
      }

      {
        key = "<C-d>";
        mode = "n";
        action = "<C-d>zz";
        silent = true;
        desc = "Scrolls down but keeps cursor in center";
      }

      {
        key = "<C-b>";
        mode = "n";
        action = "<C-u>zz";
        silent = true;
        desc = "Scrolls up but keeps cursor in center";
      }

      {
        key = "qs";
        mode = "n";
        action = ":w | bp | bd #<CR>";
        silent = true;
        desc = "Saves and cloes the buffer tab(closes tab on tob bar)";
      }

      {
        key = "gt";
        mode = "n";
        action = ":bnext<CR>";
        silent = true;
        desc = "moves to the next buffer with tab moving keys";
      }

      {
        key = "g<S-t>";
        mode = "n";
        action = ":bprev<CR>";
        silent = true;
        desc = "moves to the next buffer with tab moving keys";
      }

      {
        key = "<Esc>";
        mode = "t";
        action = "<C-\\><C-n>";
        silent = true;
        desc = "Escape terminal mode";
      }
    ];
  };
}
