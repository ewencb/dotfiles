# dotfiles

macOS and Arch configs, managed with [stow](https://www.gnu.org/software/stow/).

Each top-level folder is a package. `arch` and `macos` hold the files
for one OS only; every other package is shared.

## Layout

A package mirrors `$HOME`. Stow links each file to the same path under
`~`, so a file's place in the package is where it ends up:

```
~/dotfiles/
├── zsh/
│   └── .zshrc                    → ~/.zshrc
└── alacritty/
    └── .config/
        └── alacritty/
            └── alacritty.toml    → ~/.config/alacritty/alacritty.toml
```

Most of a package is hidden, so use `ls -a` to see what's in it.
Anything at the top of a package that shouldn't be linked (READMEs,
`.DS_Store`) goes in `.stow-local-ignore`.

## Setup

```sh
# needs git, stow, gitleaks
git clone git@github.com:ewencb/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow <package>...   # every shared package, see `ls`
stow arch           # or macos
theme               # generate the font and colour files the configs include
```

Stow won't overwrite real files, so move old configs out first, or use
`stow --adopt <pkg>` to pull them into the repo (check `git diff` after).
`stow -D <pkg>` unlinks.

## Adding things

Make a package, recreate the file's path from `~` inside it, move the
file in, then stow:

```sh
mkdir -p ~/dotfiles/tmux/.config/tmux
mv ~/.config/tmux/tmux.conf ~/dotfiles/tmux/.config/tmux/
cd ~/dotfiles && stow tmux
```

To add a file to an existing package, move it in the same way and run
`stow <pkg>` again.

OS-specific files go in `arch` or `macos`. Keep them out of folders
another package uses, or stow links file by file instead of the whole
folder and new files won't end up in the repo.

Secrets go in `~/.zprofile.local`, which isn't tracked.

## Themes

Fonts and colours live in one file per theme, `~/.config/theme/<name>.sh`
(`theme/.config/theme/` here). Edit one, or copy it to add a theme, then:

```sh
theme           # reapply the current theme
theme gruvbox   # switch theme
theme -l        # list themes
```

The generated files are not tracked, so a new machine needs one `theme` run.

`font` changes the font and size across every theme, without editing them:

```sh
font                    # pick with fzf
font Departure Mono 12  # set font and size
font 12                 # set size only
font -r                 # back to each theme's own font
```

## Hooks

`core.hooksPath` points every repo at `~/.config/git/hooks`. Pre-commit
runs gitleaks, then each hook falls through to the repo's own
`.git/hooks/<name>`. Repos with their own `core.hooksPath` (husky etc.)
skip it. Use `gitleaks:allow` on a line for false positives.
