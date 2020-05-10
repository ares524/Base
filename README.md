base
====

Use `base` as an **easy way** to install the minimum essential libs/programs
for opensource exploration and development. Works for Linux (Debian-based
for now with more distros coming), Mac (includes installing homebrew), and
Windows (requires a Bash shell like MINGW via Git Bash/Docker Toolkit or
Windows Subsystem for Linux to be setup already).

# About

When you source the `install.sh` script, your package manager will install
or update some packages, three symbolic links will be created in your
`$HOME` directory, and `~/commands.sh` will be auto-sourced at the end
(if using bash/zsh):

- `~/bin-base` -> /path/to/base/bin
    - directory containing some executable shell scripts
- `~/commands.fish` -> /path/to/base/commands.fish
    - file that can/should be sourced if using an interactive fish session
    - *only a small subset of what is available in commands.sh*
- `~/commands.sh` -> /path/to/base/commands.sh
    - file that can/should be sourced if using an interactive bash/zsh session
    - contains definitions of **many useful shell functions and aliases**

When you source `~/commands.sh` or `~/commands.fish` (directly or indirectly):

- GNU versions of `find`, `grep`, `sort`, and `xargs` will be used if they are
  installed on a Mac (over the default BSD versions)
- shell completions will be enabled and completions for your installed versions
  of `git`, `docker` and `docker-compose` will be loaded
- vi keybindings will be used for navigating/editing the command line
    - *i.e. hit <Esc> to enter "command mode" (to issue vi commands) and
      `i`/`I`/`a`/`A` to get back to "insert mode"*
- any shell functions defined inside can be called
    - *Note: most functions/aliases are conditionally defined, meaning that
      no assumptions are made about what programs are available to your
      system...*
        - if a shell func or alias makes use of a particular program and you
          don't have that program installed on your system, the func or alias
          will not be defined
        - if a shell func or alias requires using `sudo` (and you're not in
          the sudo/admin group, or the root user), the func or alias will not
          be defined
- the `~/bin-base` directory will be added to your `$PATH` environment variable,
  allowing you to invoke any of the scripts in there

# Install

### If `git` is available

```
% git clone https://github.com/kenjyco/base

% cd base

% source ./install.sh
```

> Note: If you are in an interactive fish shell, do not source `install.sh`, but
> invoke either `bash ./install.sh` OR `zsh ./install.sh`

The `install.sh` script behaves differently if any of the following strings are
passed in:

- **`clean`**: ensures the git/docker/docker-compose completion files match
  installed versions (if packages were updated)
- **`extras`**: also installs non-essential, but light-weight CLI packages like
  `vim`, `tmux`, `tree`, `ncdu`, `glances`, `nnn` and more
- **`gui`**: also installs some light-weight GUI packges for Linux (including
  xorg-server, `awesome`, `rxvt-unicode`, `feh`, `scrot`, etc) or Mac (iTerm, vlc)
- **`all`**: clean extras gui

# Update

```
% cd /path/to/base

% source ./install.sh
```

# Usage

> TODO
