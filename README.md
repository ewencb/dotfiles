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
| `git` | `.gitconfig`: name and email | all |

## Setup

```sh
# Arch: sudo pacman -S git stow    macOS: brew install git stow
git clone git@github.com:ewencb/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow nvim alacritty zsh git
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
`arch`) and only stow it on that machine.

Secrets and machine-specific environment variables go in
`~/.zprofile.local`, which `.zprofile` sources and git never sees.
