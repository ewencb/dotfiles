# dotfiles

macOS and Arch configs, managed with [stow](https://www.gnu.org/software/stow/).

| Package | What | Where |
| --- | --- | --- |
| `nvim` | Neovim ([README](nvim/.config/nvim/README.md)) | all |
| `alacritty` | Terminus, CGA colours | all |
| `zsh` | `.zshrc`, `.zprofile` | all |
| `git` | `.gitconfig`, gitleaks hooks | all |
| `arch` | Alacritty font | Arch |
| `macos` | Alacritty font | macOS |

## Setup

```sh
# needs git, stow, gitleaks
git clone git@github.com:ewencb/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow nvim alacritty zsh git
stow arch  # or macos
```

Stow won't overwrite real files, so move old configs out first.
`stow -D <pkg>` unlinks.

## Adding things

```sh
mkdir -p ~/dotfiles/tmux
mv ~/.tmux.conf ~/dotfiles/tmux/
cd ~/dotfiles && stow tmux
```

OS-specific files go in `arch` or `macos`. Keep them out of folders
another package uses, or stow links file by file instead of the whole
folder and new files won't end up in the repo.

Secrets go in `~/.zprofile.local`, which isn't tracked.

## Hooks

`core.hooksPath` points every repo at `~/.config/git/hooks`. Pre-commit
runs gitleaks, then each hook falls through to the repo's own
`.git/hooks/<name>`. Repos with their own `core.hooksPath` (husky etc.)
skip it. Use `gitleaks:allow` on a line for false positives.
