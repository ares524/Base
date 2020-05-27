base
====

- Jump to [Usage section](https://github.com/kenjyco/base/blob/master/README.md#usage)
  below for examples

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

> Note: these shell functions and scripts are named for easy tab-complete
> (typing part of the command's name, then hitting the `<Tab>` key to fill in
> the rest, or `<Tab>` twice to show all the commands that match what was typed
> so far).

### Working with `repos-` commands

> These are all scripts in <https://github.com/kenjyco/base/tree/master/bin>

```
$ repos-list            # List all git repos (or abs path of current repo)

$ repos-dirs            # List directories that have git repos in them (with counts)

$ repos-fetch           # Perform a git fetch on repos found and output updates only

$ repos-status          # Show repos with any changes, untracked files, or stashes
                        # Also show if branch is behind or ahead of remote

$ repos-files           # List files in current directory (recursive) by commit date
                        # Arg passed in to filter list of files matched/returned

$ repos-commits         # Show latest commits on all repos (args passed to git log)
                        # (i.e "--since 2.days", "--grep alias -5", etc)

$ repos-branches        # Show latest 10 remote branches and all local branches
                        # Arg passed in to filter list of branch names matched

$ repos-last-tag        # List last tag of git repos that have tags

$ repos-diffs           # List all git repos and show diff

$ repos-update          # Stash changes and git pull --rebase (then git stash pop)

$ repos-commits-not-on-master   # Show commits on an origin branch not on origin/master

$ repos-commits-since-last-tag  # Show commits since the last tag for each repo
```

### The `findit` command

```
$ findit --help
Usage: findit [dir] [options]

  Wrapper to the find command

Options:

  --depth number              maxdepth to search for files
  --type character            regular (f)ile, (d)irectory, symbolic (l)ink, (s)ocket, (b)lock special
  --pattern string            comma-separated list of filename patterns
  --ipattern string           comma-separated list of filename patterns (case insensitive)
  --complex string            raw options passed directly to 'find'
  --exclude_dirs string       comma-separated list of directories/patterns to exclude
  --iexclude_dirs string      comma-separated list of directories/patterns to exclude (case insensitive)
  --exclude_exts string       comma-separated list of extensions to exclude
  --iexclude_exts string      comma-separated list of extensions to exclude (case insensitive)
  --exclude string            comma-separated list of filename patterns to exclude
  --iexclude string           comma-separated list of filename patterns to exclude (case insensitive)
  --exts string               comma-separated list of extensions to include
  --iexts string              comma-separated list of extensions to include (case insensitive)
  --sizes string              comma-separated list of sizes, prefixed with +/- and unit of k M or G (i.e. +2G)
  --empty                     only match files that are empty
  --not_empty                 only match files that are not empty
  --months number             only match files modified in a number of months
  --weeks number              only match files modified in a number of weeks
  --days number               only match files modified in a number of days
  --hours number              only match files modified in a number of hours
  --minutes number            only match files modified in a number of minutes
  --pipe command              pipe files to a SINGLE command
  --pipesort command          pipe sorted files to a SINGLE command
  --zero                      print matching filenames delimited by null char (-print0)... to pipe to 'xargs -0 -I {}' manually
  --stamp                     prepend timestamps to output
  --help                      show this message and exit

Examples:

  findit --exts "md" --weeks 1 --stamp
  findit --exts "md" --weeks 1 --pipesort "cp -av {} /tmp/stuff"
  findit ~ --exts "md, txt" --exclude_dirs "venv, node_modules, Library" --months 2 --depth 3
  findit --pattern ".*.sw[po]" --pipe "ls -gothr"
  findit --exts "mp4, mkv" --pipesort "vlc --fullscreen"
  findit --exts "jpg, jpeg, png, gif" --pipe "du -sch"
  findit --exts "xml" --pipesort "grep --color {{[^}]*}}"
  findit --depth 3 --exts "log" --not_empty --pipesort "wc -l"
  findit --complex "-iname '*.log' -type f ! -size 0"
  findit --complex "-iname '*.log' -type f -empty -delete"
  findit --pattern "node_modules" --type d
  findit --sizes "+1G" --pipesort "du -sh"
  findit --depth 4 --sizes "+1M, -10M" --exclude_dirs ".cache" --pipesort "du -sh"
  findit --type d --exclude_dirs ".git" --depth 2
  findit --exclude_dirs "node_modules, .git, venv, build, alembic, __pycache__, .pytest_cache" --exclude_exts "json, yml, xml, txt, md" --pipe "wc -l"
  findit --exclude_dirs "venv, env" --exclude_exts "js, json, java, map, htm, html, pyc" --pattern "test*" --pipe "grep assert" | egrep "(==|!=)"
  findit --pattern "__init__.py" --exclude_dirs "venv" --not_empty --pipesort "wc -l" | sort -n
  findit --depth 4 --type d --exclude_dirs ".git, *.egg-info, venv" --not_empty --pipesort "du -sh {}" | sort -h
  findit --exclude_dirs "venv" --pattern "settings.ini" --zero | xargs -0 -I {} sh -c "echo \"\n\n\n==================\n{}\"; cat {}"
```

### The `grepit` commands

- **`grepit`**: recursively search current directory for matching lines (`-HnI
  --color -R` in use, as well as `--exclude` for many file extensions` and
  `--exclude-dir` for many directories); any options received get passed to `grep`
    - `-i pattern` to ignore case in search
    - `-E '(pattern1|pattern2|..)'` to match multiple patterns (i.e. `egrep`)
    - `-B 1 -A 2 pattern` to show context lines (1 before match and 2 after)
    - `\bpattern\b` to only match when pattern is surrounded by a "word
      boundary" character (i.e. don't match a sub-string in a longer word)
- **`grepit-count`**: use `grepit` to show how many times pattern is matched in
  files (sorted by count and not showing zero matches)
- **`grepit-no-docs`**: use `grepit`, but also ignore txt/md/rst files
- **`grepit-py`**: similar to `grepit`, but only include .py files and ignore
  common directories
- **`grepit-py-no-tests`**: similar to `grepit-py`, but also exclude .py files
  in test directories
