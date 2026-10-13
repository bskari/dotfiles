# Plan: Replace custom setup scripts with GNU Stow

## What the scripts do today

| Mechanism | Files | Script |
|---|---|---|
| Generated stub that `source`s/`include`s the repo file | `.bashrc`, `.my.cnf`, `.tmux.conf`, `.hiverc`, `.gitconfig`, `.vimrc`, fish `config.fish` | `setup.sh`, `setup-fish.sh` |
| Symlink `~/.X` -> repo | `ackrc bcrc gdbinit gitignore_global irbrc psqlrc pylintrc screenrc` | `setup.sh` |
| Symlink into Firefox profile dir (found by globbing `*default`) | `user.js`, `chrome/userChrome.css` | `setup.sh` |
| Copy (no-clobber) | VS Code `settings.json`, `keybindings.json` (Linux and macOS paths) | `setup.sh` |
| Copy `bin/*` to `~/.bin` | `bin/git-diff-line.sh` | `setup.sh` |
| Symlink `git-prompt.sh` found via `locate` | `git-prompt.sh` | `setup.sh` |
| Fish function symlink | `fish_prompt.fish` | `setup-fish.sh` |
| Download pathogen and clone vim plugins | `~/.vim/bundle/*` | `setup-vim.sh` |

Stow only does symlinking. It replaces the first four rows and the fish and bin rows cleanly. The rest (vim plugins, Firefox profile, git-prompt) needs a different approach or a small leftover script.

## Key design decisions

1. **Layout: one stow package per tool.** Each package directory mirrors the path relative to `$HOME`. The repo already lives at `~/.dotfiles`, so stow's default target (the parent of the stow dir) is `$HOME` with no flags.
2. **Stop generating stub files. Symlink the real config files instead.** The stubs existed so machine-local overrides could live in `~/.bashrc` and similar files. With stow, `~/.bashrc` becomes a symlink to the repo file, so local overrides must live elsewhere. The repo already has the mechanism: `bash-custom`, `fish-custom` and `vimrc-custom` (all gitignored) are sourced if present. Extend that to the other tools (see "Local overrides").
3. **Fix hardcoded `$HOME/.dotfiles/...` paths** in `bashrc` and fish config. Stow keeps the repo at the same place, so these still work. Switch to paths relative to the symlink only if the repo is ever moved.
4. **Drop pathogen. Use Vim's native `pack/` directory** (Vim 8+). Plugins become git submodules, or a small script that clones them.
5. **Delete `setup.sh`, `setup-fish.sh` and `setup-vim.sh`** once verified. Replace with a short README and, at most, a tiny `bootstrap.sh`.

## Proposed repo layout

```
.dotfiles/
  README                  # updated instructions
  bootstrap.sh            # optional; only the things stow can't do
  bash/
    .bashrc
    .bash-aliases ...     # see note below
  fish/
    .config/fish/config.fish
    .config/fish/functions/fish_prompt.fish
    .config/fish/conf.d/{aliases,exports,settings}.fish
  git/
    .gitconfig
    .gitignore_global
  vim/
    .vimrc
    .vim/pack/skari/start/...   # plugins (submodules)
  tmux/.tmux.conf
  screen/.screenrc
  ack/.ackrc
  bc/.bcrc
  gdb/.gdbinit
  irb/.irbrc
  psql/.psqlrc
  pylint/.pylintrc
  mysql/.my.cnf
  hive/.hiverc
  bin/.bin/git-diff-line.sh
  vscode-linux/.config/Code/User/{settings,keybindings}.json
  vscode-macos/Library/Application Support/Code/User/{settings,keybindings}.json
  firefox/                # see "Firefox", probably not stowed
```

Notes:
- Packages that are a single dotfile (`ack`, `bc`, `gdb`, ...) could be merged into one `misc` package to reduce directory clutter. One package per tool is easier to install selectively, e.g. skip `hive` on a laptop.
- Use `git mv` for every move to preserve history.
- Bash helper files (`bash-aliases`, `bash-exports`, `bash-settings`) can stay inside the `bash` package as `.bash-aliases` and so on. Adjust the `source` lines in `.bashrc` to match. Alternative: put them under `~/.config/bash/`.
- Fish: the current `config.fish` loop sources `fish-aliases`, `fish-exports`, `fish-settings` and `fish-custom`. Stow-native replacement is `~/.config/fish/conf.d/*.fish`, which fish auto-loads, so the loop is no longer needed. Keep `fish-custom` as a gitignored `conf.d/custom.fish`, or keep a tiny `config.fish` that sources it.

## Handling each tricky case

### Local overrides
- **bash, fish, vim:** already have `*-custom` hooks. Keep these and add them to `.gitignore` if missing.
- **git:** `git config --global user.email ...` writes to the target of the `~/.gitconfig` symlink, which dirties the repo. Fix: put the shared config in the repo's `.gitconfig`, and add `[include] path = ~/.gitconfig.local` (plus `.gitconfig.local` in `.gitignore`). Alternative: stow into `~/.config/git/config` (git's XDG path) so `~/.gitconfig` stays machine-local. This second option is simpler and lets git read both files.
- **tmux, mysql, hive:** these have `source`/`!include` syntax. Add an optional include of a `*.local` file, if one is ever needed. Skip until it is.
- **vim:** the old stub set `expandtab` and called `pathogen#infect()` before sourcing. Move `set expandtab` into `vimrc` (or `vimrc-custom`) and delete the pathogen call.

### Vim plugins
- Remove `~/.vim/autoload/pathogen.vim` usage.
- Vim 8+ and Neovim load plugins from `~/.vim/pack/<any-name>/start/<plugin>` automatically.
- Option A (recommended): add plugins as git submodules under `vim/.vim/pack/skari/start/`. Setup becomes `git submodule update --init --recursive`. Versions are pinned and updates are explicit.
- Option B: keep a small `vim-plugins.sh` that clones into `~/.vim/pack/skari/start`. This is closest to the current behavior but doesn't pin versions.
- Replace `scrooloose/syntastic` (renamed and archived upstream) and `ambv/black` (now `psf/black`) as part of this. Out of scope for the migration itself, so make it a separate commit.
- Keep the conditional for `black` (only with `+python3`) in the script version, or drop it if submodules are used. Vim ignores the plugin's Python code when unsupported, but verify.
- Stow caveat: if `~/.vim` already exists as a real directory, stow links files inside it. If it doesn't exist, stow links the whole `.vim` directory, and plugins would then be written into the repo. Run `mkdir -p ~/.vim` first, or use `stow --no-folding`. See "Tree folding".

### Firefox (`user.js`, `userChrome.css`)
The profile directory name is random (`xxxx.default`) and differs per OS. Stow can't glob. Options:
- **Recommended:** keep ~10 lines in `bootstrap.sh` that find the profile and `ln -s` the two files (current logic, trimmed).
- Alternative: run `stow -d ~/.dotfiles -t "$PROFILE_DIR" firefox` where `firefox/` contains `user.js` and `chrome/userChrome.css`. This reuses stow's conflict handling. `bootstrap.sh` only has to compute `$PROFILE_DIR`.

### VS Code
- Paths differ between Linux and macOS, so use two packages (`vscode-linux`, `vscode-macos`). Stow only the matching one.
- Current behavior is `cp -n`, a copy, probably because VS Code rewrites these files. Writes go through the symlink into the repo, which is arguably desired (settings sync to git), but `settings.json` will show as modified whenever VS Code changes it. Decide whether that's acceptable. If not, keep copying in `bootstrap.sh`.

### `~/.bin`
Stow `bin/.bin/git-diff-line.sh`. Permissions: the old script ran `chmod go-rwx`. Git doesn't track group and other bits, so just keep the file executable in git (`git update-index --chmod=+x`). Verify `~/.bin` is on `PATH` (check `bash-exports` and `fish-exports`).

### `git-prompt.sh`
It is symlinked from wherever the system ships it (via `locate`), not from the repo. Stow can't do this. Options: keep the lookup in `bootstrap.sh`, or vendor a copy of `git-prompt.sh` into the bash package (license is GPLv2, which is fine for a personal repo) and drop the lookup. Vendoring is simpler and more portable.

### Tree folding
By default stow replaces a whole directory with one symlink when nothing else lives in it. This is a problem for directories that apps also write into: `~/.config/fish`, `~/.vim`, `~/.config/Code`. Use `--no-folding`, or pre-create the directories. Put this in a `.stowrc`:

```
--no-folding
--target=~
--ignore=README
--ignore=plan.md
--ignore=bootstrap.sh
```

Place a `.stowrc` in the repo (stow reads it from the current directory and `$HOME`), or wrap it in a Makefile target.

## Migration steps

1. **Back up** existing `~` dotfiles: `mkdir ~/dotfiles-backup && cp -a ~/.bashrc ~/.vimrc ... ~/dotfiles-backup/`.
2. Install stow (`dnf`/`apt`/`brew install stow`) and add it to the README as the only prerequisite.
3. **Restructure the repo** with `git mv` into the layout above. One commit per logical group.
4. **Move machine-specific content out of generated stubs.** For each existing stub (`~/.bashrc`, `~/.vimrc`, `~/.gitconfig`, ...), copy any local-only lines into the matching `*-custom` or `*.local` file before replacing it.
5. **Dry run:** `cd ~/.dotfiles && stow -n -v --no-folding bash fish git vim ...`. Fix conflicts. Stow refuses to overwrite existing real files; remove or move them aside first. Existing symlinks pointing into the repo can be adopted by deleting them or using `stow --restow`.
6. **Real run:** `stow bash fish git vim tmux ...` (omit the `vscode-*` package for the other OS).
7. **Verify:** open new bash, fish and tmux sessions; run `vim` and check the plugins load (`:scriptnames`); check `git config --list --show-origin`; confirm `~/.bin` is on `PATH`.
8. **Run `bootstrap.sh`** (Firefox and any plugin steps) on a clean VM or container to check a from-scratch install works. This is the real test of the plan.
9. **Delete** `setup.sh`, `setup-fish.sh`, `setup-vim.sh`. Update the README.
10. Optional: add a `Makefile` with `make install` (`stow` the OS-appropriate packages), `make uninstall` (`stow -D`) and `make update` (`git pull && git submodule update --init && stow -R ...`).

## New README (sketch)

```
Dotfiles for various things.

    git clone --recurse-submodules <repo> ~/.dotfiles
    cd ~/.dotfiles
    stow bash fish git vim tmux ...      # or: make install
    ./bootstrap.sh                        # Firefox profile only

Machine-specific settings go in bash-custom, fish-custom, vimrc-custom, ~/.gitconfig.local (not tracked).
```

## Risks and open questions

- **Settings that tools write back** (VS Code, `git config --global`, fish universal variables in `fish_variables`) will modify repo files through the symlinks. Mitigated by local-override files above. Add `fish_variables` to `.gitignore` if the fish package ever includes it.
- **macOS support:** the old script handles Darwin. Stow works there too, and `vscode-macos` plus the Firefox path in `bootstrap.sh` cover it. Is macOS still needed?
Answer: no
- **Do you want VS Code settings symlinked or copied?** (See above.)
Answer: Copy the VS Code settings.
- **Vendor `git-prompt.sh` or keep looking it up?**
Answer: vendor
- **Is `hive`/`mysql`/`psql` config needed on every machine?** The per-tool packages let those be optional.
Answer: Optional
- **Vim plugin management:** submodules or script? (Recommended: submodules.)
Answer: Submodules.
