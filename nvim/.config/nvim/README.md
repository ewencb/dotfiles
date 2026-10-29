# nvim

A small Neovim config for Python, Rust, Lua, shell and system files. It
uses Neovim's built-in completion and LSP client, a handful of plugins, and
installs every language server automatically on first start. The same repo
runs on macOS and Arch Linux.

## Requirements

- Neovim **0.12+** (uses `autocomplete`, `vim.lsp.enable` and `vim.lsp.config`)
- `git`, `curl`, `unzip`, `tar`, `gzip`: used by lazy.nvim and Mason
- Node.js + `npm`: for the bash, YAML, JSON and Dockerfile servers and prettierd
- Python 3: for the nginx server
- The `tree-sitter` CLI and a C compiler: to build Treesitter parsers
- A Rust toolchain: `rustfmt` comes from it, not Mason
- `ripgrep`: recommended for file search and live grep

No Nerd Font is needed; icons are plain text.

## Install

### Arch Linux

```sh
sudo pacman -S --needed neovim git curl unzip tar gzip nodejs npm python \
    base-devel tree-sitter-cli rustup ripgrep
rustup default stable
git clone <repo-url> ~/.config/nvim
nvim
```

### macOS

```sh
brew install neovim git node python ripgrep rustup
rustup default stable
cargo install tree-sitter-cli
git clone <repo-url> ~/.config/nvim
nvim
```

On first start lazy.nvim installs the plugins, Treesitter builds its
parsers, and Mason installs every language server and tool in the
background. Give it a minute, then restart.

## Layout

```text
init.lua                    leader keys, then loads lua/config/*
lua/config/options.lua      editor settings and filetype detection
lua/config/keymaps.lua      keymaps that don't belong to a plugin
lua/config/lazy.lua         plugin manager
lua/config/lsp.lua          language servers, LSP keymaps, completion
lua/plugins/lsp.lua         Mason (auto-install) and nvim-lspconfig
lua/plugins/formatting.lua  conform.nvim: format on save
lua/plugins/mini.lua        mini.nvim modules and their keymaps
lua/plugins/treesitter.lua  parsers and highlighting
```

## Plugins

| Plugin | Used for |
| --- | --- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | Installs language servers and tools |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Default server configs |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Format on save |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Parsers and highlighting |
| [mini.nvim](https://github.com/nvim-mini/mini.nvim) | ai, surround, files, pick, extra, diff, icons |

## Languages

| Language | Server | Formatter |
| --- | --- | --- |
| Python | pyright (types) + ruff (lint) | ruff |
| Rust | rust-analyzer | rustfmt |
| Lua | lua-language-server | stylua |
| Shell, PKGBUILD | bash-language-server + shellcheck | shfmt |
| Markdown | rumdl | rumdl |
| TOML | taplo | taplo |
| YAML, Docker Compose | yaml-language-server | prettierd |
| JSON | json-lsp | json-lsp |
| Dockerfile | dockerfile-language-server | dockerfile-language-server |
| systemd units | systemd-lsp | |
| nginx | nginx-language-server (no diagnostics) | |

Pyright uses the project's `.venv` automatically when there is one (e.g.
from `uv`).

## Keymaps

Leader is `Space`, local leader is `,`.

| Keys | Action |
| --- | --- |
| `<leader>/f` | Find files |
| `<leader>/g` | Live grep |
| `<leader>/b` | Buffers |
| `<leader>/o` | Recent files |
| `<leader>/h` | Help |
| `<leader>/d` | Diagnostics |
| `<leader>/s` | Symbols in buffer |
| `<leader>o` / `<leader>O` | File explorer at current file / cwd |
| `<leader>f` | Format buffer |
| `gd` | Go to definition |
| `K` | Hover docs |
| `grr` | References |
| `grn` or `<leader>rn` | Rename |
| `gra` or `<leader>ca` | Code action |
| `<leader>e` | Line diagnostics |
| `[d` / `]d` | Previous / next diagnostic |
| `[h` / `]h` | Previous / next git change |
| `sa` / `sd` / `sr` | Add / delete / replace surrounding |
| `gc` / `gcc` | Comment |
| `<C-n>` / `<C-p>` / `<C-y>` | Completion: next / previous / accept |
| `<Esc>` | Clear search highlight |

## Common changes

**Add a language server.** Add one line to `servers` in
`lua/config/lsp.lua`, mapping the
[nvim-lspconfig name](https://github.com/neovim/nvim-lspconfig/tree/master/lsp)
to the [Mason package](https://mason-registry.dev/registry/list):

```lua
gopls = "gopls",
```

It is installed on the next start and enabled for its filetypes.

**Add a formatter.** Add the filetype to `formatters_by_ft` in
`lua/plugins/formatting.lua`, and the Mason package to `tools` in
`lua/config/lsp.lua`. Filetypes not listed use the language server's
formatter.

**Add a Treesitter parser.** Add it to the list in
`lua/plugins/treesitter.lua`.

## Keeping machines in sync

- After `:Lazy update`, commit `lazy-lock.json`. On the other machine,
  `git pull` then run `:Lazy restore` to get the same plugin versions.
- Mason packages are not pinned. Update them with `:Mason`, then `U`.
