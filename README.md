# dotfiles

Configs for macOS and Arch Linux, managed with
[GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is a
package whose contents mirror `$HOME`; `stow <package>` symlinks it into
place.

| Package | Contents | Machines |
| --- | --- | --- |
| `nvim` | Neovim config, see [its README](nvim/.config/nvim/README.md) | all |
| `alacritty` | Alacritty terminal: Terminus font, IBM CGA colours | all |

## Setup

```sh
# Arch: sudo pacman -S git stow    macOS: brew install git stow
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
stow nvim alacritty
```

`stow -D <package>` removes a package's links. Stow refuses to overwrite
existing files, so move any old config out of the way first.

## Adding a config

Move it into a package folder with the same path it has under `$HOME`,
then stow it:

```sh
mkdir -p ~/dotfiles/git
mv ~/.gitconfig ~/dotfiles/git/
cd ~/dotfiles && stow git
```

Put config that only applies to one OS in its own package (e.g. `macos`,
`arch`) and only stow it on that machine.
