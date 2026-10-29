# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a package whose contents mirror `$HOME`.

```
zsh/.zshrc              -> ~/.zshrc
git/.gitconfig          -> ~/.gitconfig
nvim/.config/nvim/      -> ~/.config/nvim/
```

## Usage

```bash
git clone git@github.com:ewencb/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow zsh git nvim    # symlink packages into ~
stow -D zsh          # remove a package's symlinks
stow -R zsh          # restow after adding files
```

To adopt an existing config: move it into the package (e.g. `mv ~/.zshrc zsh/`), then `stow zsh`.
