# dotfiles

Configs for macOS and Arch Linux, managed with
[GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is a
package whose contents mirror `$HOME`; `stow <package>` symlinks it into
place.

| Package | Contents | Machines |
| --- | --- | --- |
| `nvim` | Neovim config, see [its README](nvim/.config/nvim/README.md) | all |
| `alacritty` | Alacritty terminal: Terminus font, IBM CGA colours | all |
| `zsh` | `.zshrc` (vim mode, prompt, plugins) and `.zprofile` (PATH, env) | all |
| `git` | `.gitconfig` (name, email) and global hooks that scan commits for secrets with [gitleaks](https://github.com/gitleaks/gitleaks) | all |
| `arch` | `~/.config/alacritty-font.toml`: `Terminus` | Arch |
| `macos` | `~/.config/alacritty-font.toml`: `Terminus (TTF)` | macOS |

## Setup

```sh
# Arch: sudo pacman -S git stow    macOS: brew install git stow
git clone git@github.com:ewencb/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow nvim alacritty zsh git
stow arch    # or: stow macos
```

`stow -D <package>` removes a package's links. Stow refuses to overwrite
existing files, so move any old config out of the way first.

## Adding a config

Move it into a package folder with the same path it has under `$HOME`,
then stow it:

```sh
mkdir -p ~/dotfiles/tmux
mv ~/.tmux.conf ~/dotfiles/tmux/
cd ~/dotfiles && stow tmux
```

Put config that only applies to one OS in its own package (e.g. `macos`,
`arch`) and only stow it on that machine. Keep those files outside folders
another package owns (hence `~/.config/alacritty-font.toml`, not a file
inside `~/.config/alacritty/`): when only one package uses a folder, stow
links the whole folder, so new files in it land in the repo automatically.

Secrets and machine-specific environment variables go in
`~/.zprofile.local`, which `.zprofile` sources and git never sees.

## Secret scanning

The `git` package sets `core.hooksPath` to `~/.config/git/hooks`, so every
repo on the machine runs `gitleaks` before each commit and blocks it if a
staged change looks like a secret. Install gitleaks first
(`sudo pacman -S gitleaks` / `brew install gitleaks`); without it the hook
warns and lets the commit through.

Every hook name in that folder links to one script, which then runs the
repo's own `.git/hooks/<name>`, so per-repo hooks keep working. Repos that
set their own `core.hooksPath` (e.g. husky) skip the global hooks. For a
false positive, add a `gitleaks:allow` comment on the line.
