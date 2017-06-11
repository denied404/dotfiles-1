. ~/bin/environment-variables

export TERM=rxvt-unicode-256color
if [ "$TMUX" ]; then
    export TERM=screen-256color-so
fi

export HISTSIZE=1000
export SAVEHIST=100000
export KEYTIMEOUT=1
export WORDCHARS=-

# :prezto
{
    zstyle ':prezto:*:*' color 'yes'
    zstyle ':prezto:load' pmodule \
        'helper' \
        'environment' \
        'terminal' \
        'editor' \
        'history' \
        'directory' \
        'completion' \
        'history-substring-search' \
        'git'

    zstyle ':prezto:module:editor' key-bindings 'vi'
    zstyle ':completion:*' rehash true
}

# :zgen
{
    if [ ! -d ~/.zgen ]; then
        git clone https://github.com/tarjoilija/zgen ~/.zgen
    fi

    if [ ! -d ~/.zpezto ]; then
        ln -sfT ~/.zgen/sorin-ionescu/prezto-master ~/.zprezto
    fi

    source ~/.zgen/zgen.zsh

    AUTOPAIR_INHIBIT_INIT=1

    if ! zgen saved; then
        zgen load seletskiy/zsh-zgen-compinit-tweak

        zgen load sorin-ionescu/prezto

        zgen load kovetskiy/zsh-quotes
        zgen load kovetskiy/zsh-add-params
        zgen load kovetskiy/zsh-fastcd
        zgen load kovetskiy/zsh-smart-ssh
        zgen load kovetskiy/zsh-insert-dot-dot-slash

        zgen load seletskiy/zsh-prompt-lambda17
        zgen load seletskiy/zsh-ssh-urxvt
        zgen load seletskiy/zsh-hash-aliases

        zgen load deadcrew/deadfiles

        zgen load s7anley/zsh-geeknote
        zgen load seletskiy/zsh-smart-kill-word

        zgen load hlissner/zsh-autopair autopair.zsh
        zgen load mafredri/zsh-async
        zgen load seletskiy/zsh-fuzzy-search-and-edit
        zgen load Tarrasch/zsh-bd

        #zgen load brnv/zsh-too-long

        zgen load seletskiy/zsh-autosuggestions
        zgen load kovetskiy/zsh-alias-search
        #zgen load seletskiy/zsh-syntax-highlighting
        #zgen load hchbaw/auto-fu.zsh

        zgen oh-my-zsh plugins/sudo

        ZGEN_AUTOLOAD_COMPINIT="-d $ZGEN_DIR/zcompdump"
        zgen save
    fi
}


#function zle-line-init () {
    #auto-fu-init
#}
#zle -N zle-line-init
#zstyle ':completion:*' completer _oldlist _complete

# :reset
{
    unalias -a
    unsetopt cdablevars
    unsetopt noclobber
    unsetopt correct
    unsetopt correct_all
    unsetopt interactivecomments
}

# :binds
{
    bindkey -a '^[' vi-insert
    bindkey -v "^R" fzf-history-widget
    bindkey -v "^[[A" history-substring-search-up
    bindkey -v "^[[B" history-substring-search-down
    bindkey -v "^[[7~" beginning-of-line
    bindkey -v "^A" beginning-of-line
    bindkey -v "^Q" push-line
    bindkey -v "^[[8~" end-of-line
    bindkey -v '^?' backward-delete-char
    bindkey -v '^H' backward-delete-char
    bindkey -v '^[[3~' delete-char
    bindkey -v '^B' backward-word
    bindkey -v '^E' forward-word
    bindkey -v "^L" clear-screen
    bindkey -v '^K' add-params
    bindkey -v '^O' toggle-quotes

    bindkey '^W' smart-backward-kill-word
    bindkey '^F' smart-forward-kill-word
    bindkey '^P' fuzzy-search-and-edit

    bindkey "^S" sudo-command-line
    bindkey "^F" alias-search
    bindkey "^T" :rtorrent:select
}

# :setup
{
    autoload -U add-zsh-hook
    autoload -Uz promptinit

    promptinit
    prompt lambda17

    :prompt-pwd() {
        if [[ "$PWD" == "$HOME" || "$PWD" == "$HOME/" ]]; then
            lambda17:print ''
            return
        fi

        local branch=$(basename "$PWD")
        local tree=$(
            dirname "$PWD" \
                | sed "s|$HOME|~|" \
                | sed -r 's#(/\w)[^/]+#\1#g'
        )

        lambda17:print "$tree/$branch"
    }

    zstyle -d 'lambda17:00-main' transform
    zstyle -d 'lambda17:25-head' when
    zstyle 'lambda17:05-sign' text "$"
    zstyle 'lambda17>00-root>00-main>00-status>10-dir' 15-pwd :prompt-pwd
    # uncomment if got troubles with async
    # zstyle -d 'lambda17::async' pre-draw

    zstyle 'lambda17:00-banner' right " "
    zstyle 'lambda17:09-arrow' transition ""

    :lambda17:read-terminal-background () {
        :
    }


    case $PROFILE in
        laptop)
            zstyle lambda17:05-sign fg "white"
            zstyle 'lambda17:00-banner' bg "red"
            ;;
        *)
            zstyle 'lambda17:00-banner' bg "green"
            zstyle lambda17:05-sign fg "white"
            ;;
    esac

    compinit -d $ZGEN_DIR/zcompdump

    autoload -U colors
    colors

    setopt autocd
    setopt auto_name_dirs
    setopt auto_pushd
    setopt pushd_ignore_dups
    setopt rmstarsilent
    setopt append_history
    setopt extended_history
    setopt hist_expire_dups_first
    setopt hist_ignore_dups
    setopt hist_ignore_space
    setopt hist_verify
    setopt inc_append_history
    setopt share_history

    hash-aliases:install
    autopair-init

    zstyle ':zle:smart-kill-word' precise always
    zstyle ':zle:smart-kill-word' keep-slash true
}

# :hash
{
    hash -d dotfiles=~/dotfiles/
    hash -d deadfiles=~/deadfiles/
    hash -d src=~/sources/
}

# :fastcd
{
    bindkey -v '^N' cd-to-directory-favorites
    zle -N cd-to-directory-favorites
    cd-to-directory-favorites() {
        local __dir="$(fzf-choose-favorite)"
        if [[ ! "$__dir" ]]; then
            return
        fi

        eval cd "$__dir"

        unset __dir

        clear
        zle -R
        lambda17:update
        zle reset-prompt
        ls -lah --color=always
        git status -s
    }
}

{
    :fzf:cd() {
        local target
        target=$(find ${1:-.} -type d -printf '%P\n' 2>/dev/null \
            | fzf-tmux +m)
        eval cd "$target"
        zle -R
        lambda17:update
        zle reset-prompt
    }

    bindkey -v '^X' :fzf:cd
    zle -N :fzf:cd
}

# :func
{
    packages-add() {
        echo $@ >> ~/sources/dotfiles/packages
    }

    man-find() {
        man --regex -wK "$@" \
            | sed 's#.*/##g' \
            | cut -d. -f1 \
            | uniq
    }

    man-directive() {
        man $1 | less +"/^\s{7}$2\s"
    }
    compdef man-directive=man

    sed-replace() {
        local from=$(sed 's@/@\\/@g' <<< "$1")
        shift

        local to=""
        if [ $# -ne 0 ]; then
            to=$(sed 's@/@\\/@g' <<< "$1")
            shift
        fi

        if [ $# -ne 0 ]; then
            local diff=false
            local files=()
            for file in $@; do
                if [ "$file" = "!" ]; then
                    diff=true
                else
                    files+=("$file")
                fi
            done

            for file in "${files[@]}"; do
                if $diff; then
                    after=$(mktemp -u)
                    sed -r "s/$from/$to/g" $file > $after
                    git diff --color $file $after | diff-so-fancy
                else
                    sed -ri "s/$from/$to/g" $file
                fi
            done

        else
            sed -r "s/$from/$to/g"
        fi
    }

    sed-remove-all-before() {
        local query="$1"
        shift
        sed-replace ".*$query" "" $@
    }

    sed-remove-all-after() {
        local query="$1"
        shift
        sed-replace "$query.*" "" $@
    }

    cut-d-t() {
        local d="$1"
        shift
        cut -d"$d" -f"$@"
    }

    find-iname() {
        local query="$1"
        shift
        find -iname "*$query*" -not -path '.' -printf '%P\n' "$@" 2>/dev/null
    }

    xargs-eval() {
        local pass_stdin=false
        if [ "$1" = "-" ]; then
            pass_stdin=true
            shift
        fi

        local cmd="$(sed 's/@/"@"/g' <<< $@)"

        local line="{ $cmd ; }"
        if $pass_stdin; then
            line="$line <<< '@'"
        fi

        local main_input="$(cat)"

        xargs -n1 -I@ echo "$line" <<< "$main_input" \
            | while read subcmd; do
                eval "(${subcmd[@]})" </dev/tty
            done
    }

    cd-and-ls() {
        cd $@ && ls -lah --color=always
    }

    git-clone-github() {
        local uri="$1"
        local dir="$2"
        local user=$(cut -d/ -f1 <<< "$uri")
        local project=$(cut -d/ -f2 <<< "$uri")

        if ! grep -q "/" <<< "$uri"; then
            project="$user"
            user="kovetskiy"
        fi
        if [[ "$user" = "s" ]]; then
            user="seletskiy"
        fi
        if [[ "$user" = "r" ]]; then
            user="reconquest"
        fi
        if [[ "$user" = "k" ]]; then
            user="kovetskiy"
        fi

        uri="https://github.com/$user/$project"
        echo "$uri"
        git clone "$uri" $dir
    }

    git-checkout-orphan() {
        git checkout --orphan "$1"
        git status -s | awk '{print $2}' | xargs -n1 rm -rf
        git add .
    }

    git-create-and-commit-empty-gitignore() {
        gcor $1
        touch .gitignore
        git add .gitignore
        git commit -m ".gitignore added"
    }

    alias-grep() {
        local query="$*"
        if declare -f "$query" 2>/dev/null; then
            return
        fi

        alias | grep -F -- "$*"
    }

    git-remote-set-origin-me() {
        if ! git remote | grep -q upstream; then
            git remote rename origin upstream
        fi
        local new_url=$(
            git remote show -n upstream \
            | awk '/Fetch URL:/{print $3}' \
            | sed-replace '([:/])([a-zA-Z0-9_-]+)/(\w+)' '\1me/\3'
        )
        git remote rm origin
        echo "$new_url"
        git remote add origin "$new_url"
    }

    go-get-enhanced() {
        if [ $# -eq 0 ]; then
            go get
            return
        fi

        local url=""
        local dir=""
        local flags=("-v")
        local update=false
        if [ "$1" = "u" -o "$1" = "-u" -o "$1" = "-" ]; then
            flags+=("-u")
            update=true
            shift
        fi

        if [ $# -eq 0 ]; then
            go get ${flags[@]}
            return
        fi

        import=$(sed 's/.*:\/\///' <<< "$1")
        shift

        flags+=("$@")
        local slashes=$(grep -o '/'  <<< "$import" | wc -l)
        if [ $slashes = 1 ]; then
            user=$(cut -d/ -f1 <<< "$import")
            repo=$(cut -d/ -f2 <<< "$import")
            case "$user" in
                s)
                    import="seletskiy/$repo"
                    ;;

                r)
                    import="reconquest/$repo"
                    ;;

                d)
                    import="deadcrew/$repo"
                    ;;
            esac

            import="github.com/$import"
        fi

        if $update && [ $slashes = 0 ]; then
            dependency_import=$(
                go list -f \
                    '{{ range $dep := .Deps }}{{ $dep }}{{ "\n" }}{{ end }}' . \
                    | awk "/\/$import\$/ { print }"
            )
            if [ "$dependency_import" ]; then
                import=$dependency_import
            fi
        fi

        if [ ! "$dependency_import" ] && [ $slashes = 0 ]; then
            import="github.com/kovetskiy/$import"
        fi

        go get ${flags[@]} $import

        dir=$GOPATH/src/$import
        if [[ "$dir" == *.git ]]; then
            dir=$(sed 's/\.git//' <<< "$dir")
        fi

        if [ -d $dir ]; then
            cd $dir
            git submodule update --init
        fi
    }

    create-and-change-directory() {
        mkdir -p "$@"
        cd "$@"
    }

    aur-create-project() {
        local package="$1"

        if [[ "$package" == "" || "$package" == "-h" ]]; then
            echo "aur-create-project <package> [<file>]..."
            return
        fi

        local dir=$(mktemp -d --suffix=$package)
        local url="ssh://aur@aur.archlinux.org/$package.git"

        git clone $url $dir

        if [[ $# -gt 1 ]]; then
            while shift &>/dev/null; do
                cp -r $1 $dir/
            done
        fi

        cd $dir
    }

    aur-import-project-golang() {
        local package="$1"
        local desc="$2"
        local git="$3"

        if [[ "$package" == "" || "$package" == "-h" ]]; then
            echo "aur-import-project-golang <package> <description> <url>"
            return
        fi

        local dir=$(mktemp -d --suffix=$package)

        local url="ssh://aur@aur.archlinux.org/$package.git"

        git clone $url $dir
        cd $dir

        git=$(sed-replace 'https?://' 'git://' <<< "$git")

        go-makepkg -n "$package" -d . -c "$desc" "$git"
        mksrcinfo
        git add PKGBUILD .SRCINFO
    }

    aur-clone() {
        local package=$1

        :sources:get "ssh://aur@aur.archlinux.org/$package.git"
    }

    cd-pkgbuild() {
        local dir=$(basename "$(pwd)")
        if grep -q '\-pkgbuild' <<< "$dir"; then
            cd ../$(sed -r 's/\-pkgbuild//g' <<< "$dir")
            return
        fi

        local dir_pkgbuild="${dir}-pkgbuild"

        if [ -d "../$dir_pkgbuild" ]; then
            cd "../$dir_pkgbuild"
            return
        fi

        cp -r "../$dir" "../$dir_pkgbuild"

        cd "../$dir_pkgbuild"

        if [ "$(git rev-parse --abbrev-parse HEAD)" = "pkgbuild" ]; then
            return
        fi

        git fetch

        if git branch -a | grep -q pkgbuild; then
            git stash
            git checkout pkgbuild
            git-clean-powered
            return
        fi

        git-checkout-orphan pkgbuild
    }

    go-makepkg-enhanced() {
        if [[ "$1" = "-h" || $# == 0 ]]; then
            echo "<package> <description> [repo]" >&2
            return 1
        fi

        local package="$1"
        local description="$2"
        local repo="$3"
        shift 2

        if [ "$repo" ]; then
            shift
        else
            repo=$(git remote get-url origin)
            if grep -q "github.com" <<< "$repo"; then
                repo=$(sed-replace '.*@' 'git://' <<< "$repo")
                repo=$(sed-replace '.*://' 'git://' <<< "$repo")
            fi
        fi

        go-makepkg -g -c -n "$package" -d . $(echo $FLAGS) "$description" "$repo" $@
    }

    copy-to-clipboard() {
        if [ $# -ne 0 ]; then
            if [ -e "$1" ]; then
                xclip -selection clipboard < "$1"
            else
                xclip -selection clipboard <<< "$@"
            fi
        else
            xclip -selection clipboard
        fi

        xclip -o -selection clipboard | xclip -selection primary
    }

    restore-pkgver-pkgrel() {
        sed-replace 'pkgver=.*' 'pkgver=${PKGVER:-autogenerated}' ${1:-PKGBUILD}
        sed-replace 'pkgrel=.*' 'pkgrel=${PKGREL:-1}' ${1:-PKGBUILD}
    }

    migrate-to-deadfiles() {
        local subject="$1"
        shift

        (
            local dotfiles=~/dotfiles
            local deadfiles=~/deadfiles

            cd $dotfiles
            git stash
            git pull --rebase origin master

            cd $deadfiles
            git stash
            git pull --rebase origin master

            for file in $@; do
                install -DT $dotfiles/$file $deadfiles/$file
                rm -r $dotfiles/$file
            done

            cd $deadfiles
            git add .
            git commit -m "$subject migrated from kovetskiy/dotfiles"
            git push origin master
            git stash pop

            cd $dotfiles
            git add .
            git commit -m "$subject migrated to deadcrew/deadfiles"
            git push origin master
            git stash pop
        )
    }

    github-browse() {
        local file="$1"
        local line="${2:+#L$2}"
        hub browse -u -- blob/$(git rev-parse --abbrev-ref HEAD)/$file$line
    }
    compdef github-browse=ls

    git-pull() {
        local origin="origin"
        local branch=$(:git:branch)

        if [ $# -ne 0 ]; then
            local option=$1
            if [ "$option" = "upstream" ]; then
                origin=$option
            else
                branch=$option
            fi
        fi

        git pull --stat --rebase $origin $branch
    }

    aur-get-sources() {
        local package=$1
        cd /tmp/
        yaourt -G "$package"
        cd "$package"
        cat PKGBUILD
    }

    compdef vim-which=which
    compdef smash=ssh

    git-rebase-interactive() {
        if [[ "$1" =~ ^[0-9]+$ ]]; then
            git rebase -i "HEAD~$1"
            return $?
        fi

        git rebase -i $@
    }

    git-clean-powered() {
        git clean -ffdx
    }

    ssh-enhanced() {
        local hostname="$1"
        tmux set status on
        tmux set status-left "# $hostname"
        smash -z "$@"
        tmux set status off
    }
    makepkg-clean() {
        local branch="$1"
        rm -rf *.xz
        rm -rf src pkg
        BRANCH="$branch" makepkg -f
        restore-pkgver-pkgrel
    }

    sed-files() {
        local from="$1"
        local to="$2"
        shift 2
        sed-replace "$from" "$to" $(sift "$from" -l) "$@"
    }

    git-clone-sources() {
        cd ~/sources/
        git clone "$1"
    }

    :cd-sources() {
        cd ~/sources/"$@"
    }


    :is-interactive() {
        (
            exec 9>&1
            if [[ "$(readlink /dev/fd/9)" == *"pipe:"* ]]; then
                return 1
            else
                return 0
            fi
        )
        return $?
    }

    compdef guess=which

    :nmap:online() {
        nmap -sP -PS22 $@ -oG - \
            | awk '/Status: Up/{ print $2; }' \
            | tee /dev/stderr \
    }

    :sources:get() {
        local target="$1"
        target=$(sed -r '
            s|^gh:|git@github.com:|;
            s|^(git@github.com:)?k/|git@github.com:kovetskiy/|;
            s|^(git@github.com:)?s/|git@github.com:seletskiy/|;
            s|^(git@github.com:)?r/|git@github.com:reconquest/|;
            ' <<< "$target"
        )
        local dir=$(sed -r 's|^.*://[^/]+/||; s|^.*:||; ' <<< "$target")
        echo ":: $target -> $dir"
        if [[ ! -d ~/sources/$dir ]]; then
            git clone "$target" ~/sources/$dir
        fi

        cd ~/sources/$dir
    }

    :aur:spawn() {
        yes | EDITOR=cat yaourt --color "$@"
    }

    :aur:search() {
        local search=$(:aur:spawn -Ss "$@")
        {
            bmo -b '/^\033/'  '/^\033/' \
                -v 'name' '/^\033/' \
                -c "! match(name, /$@/)" <<< "$search"

            bmo -b '/^\033/'  '/^\033/' \
                -v 'name' '/^\033/' \
                -c "match(name, /$@/)" <<< "$search"
        } | grep -P "$@|"
    }

    :aur:install-or-search() {
        if [[ "$#" -eq 2 && "$2" == ":" ]]; then
            :aur:search "$1"
        else
            :aur:spawn -S "$@"
        fi
    }

    :git:master() {
        git fetch && \
            git checkout origin/master && \
            git branch -D master && \
            git checkout master

        if [[ "$1" ]]; then
            git checkout -b "$1"
        fi
    }

    :git:merge() {
        local branch=$(:git:branch)
        git checkout master
        git merge origin/"$branch"
    }

    :git:branch() {
         git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3
    }

    :rtorrent:select() {
        torrent=$(
            find ~/Downloads/ -maxdepth 1 -type f -name '*.torrent' \
                | while read filename; do
                name=$(transmission-show "$filename" \
                    | grep -P '^Name: ' \
                    | sed -r 's/Name:\s+//')
                echo "$(basename "$filename") :: $name"
            done \
                | fzf
        )

        if [[ "$torrent" ]]; then
            torrent=$(sed 's/ :: .*$//' <<< "$torrent")
            qbittorrent ~/Downloads/"$torrent"
        fi
    }

    :mplayer:run() {
        #if [[ $# -eq 0 ]]; then
            #mplayer $(/bin/ls | grep -vP '\.(jpg|jpeg|png|log|txt|cue)$')
        #else
            mplayer "$@"
        #fi
    }

    zle -N :rtorrent:select

    :move() {
        local from=""
        if [[ -f /var/run/$(id -u)/buffer-move ]]; then
            from="$(cat /var/run/$(id -u)/buffer-move)"
        fi

        if [[ ! "$from" ]]; then
            if [[ ! "$1" ]]; then
                echo "target is not specified" >&2
                return 1
            fi

            echo "$(readlink -f "$1")" > /var/run/$(id -u)/buffer-move
            return 0
        fi

        to="$1"
        if [[ ! "$to" ]]; then
            to=$(basename "$from")
        fi

        echo "$from -> $to" >&2
        mv "$from" "$to"
    }

    :rsync() {
        rsync -av --stats --progress "$@"
    }

    :axel() {
        local link=$1
        local threads=${2:-10}

        axel -a -n $threads "$link"
    }

    :process:info() {
        local name="$1"
        local processes=$(pgrep -d, -x "$name")
        if [[ ! "$processes" ]]; then
            return 1;
        fi

        ps uf -p "$processes"
    }

    :watcher() {
        local timeout=0.5
        if [[ $1 =~ ^-?[.0-9]+$ ]]; then
            timeout=$1
            shift
        fi

        echo "$(highlight bold){$timeout} ${@}$(highlight reset)";
        while :; do
            eval "${@}"
            sleep $timeout
        done
    }

    :process:kill() {
        local name="$1"
        pkill -9 "$name" || pkill -f -9 "$name"
    }
    compdef :process:kill=pkill

    :gitignore:add() {
        while [[ "$1" ]]; do
            echo "$1" >> .gitignore
            shift
        done
    }

    :pacman:filter-executable() {
        while read package file; do
            if [[ -f "$file" && -x "$file" ]]; then
                echo "$package $file"
            fi
        done
    }

    :alias:register() {
        local name="$1"
        local value="$2"

        #value="() { :alias:use \"$name\"; [[ "\$_SUDO" ]] && sudo $value \${@} }"
        alias "$name"="$value"
    }

    :alias() {
        :alias:register "${@}"
    }

    :alias:use() {
        local name="$1"
        echo "$name" >> ~/.zalias
    }

    :mplayer:dir-audio() {
        # subshell for trap
        (
        local playlist="$(mktemp)"
        find ${1:-.} \
            -type f \
            -iregex ".*\.\(m4a\|aac\|flac\|mp3\|ogg\|wav\)$" \
            -print0 \
            | xargs -0 -n1 readlink -f \
            | sort > "$playlist"
        trap "rm $playlist" EXIT
        mplayer -novideo -playlist "$playlist"
        )
    }
}

{
    alias -g SX='--exclude-path'
    alias -g sb='| sed-remove-all-before'
    alias -g sa='| sed-remove-all-after'
    alias -g I='<<<'
    alias -g S='| sed-replace'
    alias -g J='| jq .'
    alias -g '#pe'='| :pacman:filter-executable'
}

# :alias
{
    :alias 'sudo' 'sudo -E '
    :alias 'srcd' 'cd ~/sources/'
    :alias 'ol' ':mplayer:dir-audio'
    :alias 'zl' 'zfs list'
    :alias 'gia' ':gitignore:add'
    :alias 'pk' ':process:kill'
    :alias 'wa' ':watcher'
    :alias 'pp' ':process:info'
    :alias 'xc' 'marvex-erase-reserves && crypt'
    :alias 'a' 'cat'
    :alias 'ax' ':axel'
    :alias 'vlc' '/usr/bin/vlc --no-metadata-network-access' # fffuuu
    :alias 'mc' 'make clean'
    :alias 'm' 'make'
    :alias 'icv' '() { iconv -f WINDOWS-1251 -t UTF-8 $1 | vim - }'
    :alias 'sss' 'ssh -oStrictHostKeyChecking=no'
    :alias 'awf' '(){ audiowaveform -o "/tmp/$(basename "$1").png" -i "$1" -w 1920 -h 500 && catimg "/tmp/$(basename "$1").png" } '
    :alias 'rg' 'resolvconf-switch google'
    :alias 'goc' 'journalctl --user -u gocode.service -f'
    :alias 'gocleanup' "find . -type d -name '*-pkgbuild' -exec rm -rf {} \;"
    :alias 'j' ':move'
    :alias 'k' 'task-project'
    :alias 'o' ':mplayer:run'
    :alias 'op' ':mplayer:run -playlist ~/torrents/audio/.playlist -loop 0'
    :alias 'rt' ':rtorrent:select'
    :alias 'u' ':aur:install-or-search'
    :alias 'e' 'less'
    :alias 'sg' ':sources:get'
    :alias 'ver' 'sudo vim /etc/resolv.conf'

    :alias 'gm' ':git:master'
    :alias 'ge' ':git:merge'
    :alias 'q' ':nodes:query'
    :alias 'grr' 'gri --root'
    :alias 'g' 'guess'
    :alias 'cs' ':cd-sources'
    :alias 'pmp' 'sudo pacman -U $(/bin/ls -t *.pkg.*)'
    :alias 'psyuz' 'psyu --ignore linux,zfs-linux-git,zfs-utils-linux-git,spl-linux-git,spl-utils-linux-git'
    :alias 'mkl' 'sudo mkinitcpio -p linux'
    :alias 'x' ':launch-binary'
    :alias 'wh' 'which'
    :alias 'alq' 'alsamixer -D equal'
    :alias 'al' 'alsamixer'
    :alias 'p' 'vimpager'
    :alias 'sf' 'sed-files'
    :alias 'pas' 'packages-sync && { cd ~/dotfiles; git diff -U0 packages; }'
    :alias 'rx' 'sudo systemctl restart x@vt7.service xlogin@operator.service'
    :alias 'zgr' 'zgen reset'
    :alias 'mpk' 'makepkg-clean'
    :alias 'il' 'ip l'
    :alias 'td' 'touch  /tmp/debug; tail -f /tmp/debug'
    :alias 'vbs' 'vim-bundle-save'
    :alias 'vbr' 'vim-bundle-restore'
    :alias 'gbs' 'git-submodule-branch-sync'
    :alias 'str' 'strace -ff -s 100'
    :alias 'bx' 'chmod +x ~/bin/*; chmod +x ~/deadfiles/bin/*'
    :alias 'ck' 'create-and-change-directory'
    :alias 'mf' 'man-find'
    :alias 'md' 'man-directive'
    :alias 'c' 'cd-and-ls'
    :alias 'ss' 'sed-replace'

    :alias 'h' 'ssh-enhanced'

    :alias 'f' 'find-iname'

    :alias 'si' 'ssh-copy-id'

    :alias 'cdp' 'cd-pkgbuild'
    :alias 'gog' 'go-get-enhanced'
    :alias 'gme' 'go-makepkg-enhanced'
    :alias 'gmev' 'FLAGS="-p version" go-makepkg-enhanced'
    :alias 'gmevs' 'FLAGS="-p version -s" go-makepkg-enhanced'
    :alias 'gmel' 'gmev'
    :alias 'vw' 'vim-which'
    :alias 'tim' 'terminal-vim'

    :alias 'history' 'fc -ln 0'
    :alias 'rf' 'rm -rf'
    :alias 'ls' 'ls -lah --group-directories-first -v --color=always'
    :alias 'l' 'ls'
    :alias 'sls' 'ls'
    :alias 'sl' 'ls'
    :alias 'mp' 'mplayer -slave'
    :alias 'v' 'vim'
    :alias 'vi' 'vim'
    :alias 'se' 'sed -r'
    :alias 'py' 'python'
    :alias 'py2' 'python2'
    :alias 'god' 'godoc-search'
    :alias 'nhh' 'ssh'
    :alias 'nhu' 'container-status'
    :alias 'nhr' 'container-restart'
    :alias 'rto' 'qbittorrent "$(/usr/bin/ls --color=never -t ~/Downloads/*.torrent | head -n1)"'
    :alias 'mtd' 'migrate-to-deadfiles'
    :alias 'dt' 'cd ~/dotfiles; PAGER=cat git diff; git status -s ; '
    :alias 'rr' 'cd ~/torrents/'
    :alias 'de' 'cd ~/deadfiles; git status -s'
    :alias 'hf' 'hub fork && grsm'
    :alias 'hc' 'hub create'
    :alias 'hr' 'hub pull-request -f'
    :alias 'cc' 'copy-to-clipboard'

    :alias 's' 'sift -i -e'
    {
    }


    # :aur
    {
        :alias 'au' ':aur:spawn'
        :alias 'auk' 'au -S --nameonly -s'
        :alias 'aus' 'au -S'
        :alias 'aur' 'au -R'
        :alias 'aug' 'aur-get-sources'
        :alias 'aq' 'yaourt -Q'
        :alias 'pcr' 'packages-remove'
    }

    # :pacman
    {
        :alias 'pmr' 'sudo pacman -R'
        :alias 'pq' 'sudo pacman -Q'
        :alias 'pql' 'sudo pacman -Ql'
        :alias 'pqo' 'sudo pacman -Qo'
        :alias 'pqi' 'sudo pacman -Qi'
        :alias 'pms' 'sudo pacman -S'
        :alias 'psyu' 'zfs-snapshot && sudo pacman -Syu'
        :alias 'pmu' 'sudo pacman -U'
        :alias 'pf' 'pkgfile'
    }

    # :packages-local
    {
        :alias 'pl' 'packages-local'
        :alias 'pla' 'packages-local -a'
    }


    # :zsh
    {
        :alias 'viz' 'vim ~/.zshrc'
        :alias 'tiz' 'terminal-vim ~/.zshrc'
        :alias 'zr' 'source ~/.zshrc && print "zsh config has been reloaded"'
    }


    # :git
    {
        :alias 'gcp' 'git cherry-pick'
        :alias 'gcl' 'git clone'
        :alias 'gh' 'git show'
        :alias 'gd' 'git diff'
        :alias 'gdo' 'git diff origin/master'
        :alias 'gs' 'git status --short'
        :alias 'ga' 'git add --no-ignore-removal'
        :alias 'gb' 'github-browse'
        :alias 'gbr' 'git branch'
        :alias 'gn' 'git-clean-powered'
        :alias 'gi' 'git add -pi'
        :alias 'gp' 'git push'
        :alias 'gpo' 'git push origin'
        :alias 'gpl' 'git pull'
        :alias 'gpr' 'git pull --rebase'
        :alias 'gf' 'git fetch'
        :alias 'gcn' 'git commit'
        alias gcn!='git commit --amend'
        :alias 'gc' 'git-commit'
        :alias 'gck' 'git commit --amend -C HEAD'
        :alias 'gco' 'git checkout'

        :alias 'gci' 'git-create-and-commit-empty-gitignore'
        :alias 'gclg' 'git-clone-github'
        :alias 'gcla' 'aur-clone'
        :alias 'gclp' 'git-clone-profiles'
        :alias 'gcoo' 'git-checkout-orphan'
        :alias 'gcls' 'git-clone-sources'

        :alias 'gcb' 'git checkout -b'
        :alias 'gbn' ':git:br'
        :alias 'gpot' 'git push origin $(:git:branch) && { ghc || bhc }'
        alias gpot!='git push origin +$(:git:branch) && { ghc || bhc }'
        :alias 'gt' 'gpot'
        alias gt!='gpot!'
        :alias 'gut' 'gu && gt'
        :alias 'gu' 'git-pull'
        :alias 'gus' 'git stash && gu && git stash pop'
        :alias 'ggc' 'git gc --prune --aggressive'
        :alias 'gor' 'git pull --rebase origin master'
        :alias 'gsh' 'git stash'
        :alias 'gshp' 'git stash pop'
        :alias 'grt' 'git reset'
        :alias 'grh' 'git reset --hard'
        :alias 'grts' 'git reset --soft'
        :alias 'gr' 'git rebase'
        :alias 'grc' 'git rebase --continue'
        :alias 'gri' 'git-rebase-interactive'
        :alias 'gcom' 'git checkout master'
        :alias 'glo' 'git log --oneline --graph --decorate --all'
        :alias 'gl' 'PAGER=cat git log --oneline --graph --decorate --all --max-count=30'
        :alias 'gd' 'git diff'
        :alias 'gin' 'git init'
        :alias 'gdh' 'git diff HEAD'
        :alias 'psx' 'ps fuxa | grep'
        :alias 'gra' 'git remote add origin '
        :alias 'gro' 'git remote show'
        :alias 'gru' 'git remote get-url origin'
        :alias 'grg' 'git remote show origin -n'
        :alias 'grs' 'git remote set-url origin'
        :alias 'grsm' 'git-remote-set-origin-me'
        :alias 'grb' 'git rebase --abort'
        :alias 'ghu' 'hub browse -u'
        :alias 'ghc' 'hub browse -u -- commit/$(git rev-parse --short HEAD) 2>/dev/null'
        :alias 'glu' 'git submodule update --recursive --init'
        :alias 'gle' 'git submodule'
        :alias 'gla' 'git submodule add'
        :alias 'gld' 'git submodule deinit'
        :alias 'glf' 'git submodule foreach --recursive'
        :alias 'grm' 'git rm -rf'
        :alias 'gic' 'git add . ; git commit -m "initial commit"'
        :alias 'gig' 'touch .gitignore; git add .gitignore ; git commit -m "gitignore"'
        :alias 'bhc' 'BROWSER=/bin/echo bitbucket browse commits/$(git rev-parse --short HEAD) 2>/dev/null | sed "s@//projects/@/projects/@" '
    }


    # :poe
    {
        :alias 'po' 'poe -L -t 60'
        :alias 'pox' 'poe -X -v'
        :alias 'pof' 'poe -F -v'
    }

    # :go
    {
        :alias 'gob' 'go-fast-build'
        :alias 'b' 'go-fast-build'
        :alias 'goi' 'go install'
    }


    # :systemd
    {
        :alias 'sc' 'sudo systemctl'
        :alias 'scr' 'sudo systemctl restart'
        :alias 'scs' 'sudo systemctl start'
        :alias 'sce' 'sudo systemctl enable'
        :alias 'sct' 'sudo systemctl stop'
        :alias 'scd' 'sudo systemctl disable'
        :alias 'scu' 'sudo systemctl status'
        :alias 'scl' 'sudo systemctl list-units'
        :alias 'sdr' 'sudo systemctl daemon-reload'

        :alias 'us' 'systemctl --user'
        :alias 'uss' 'systemctl --user start'
        :alias 'ust' 'systemctl --user stop'
        :alias 'usr' 'systemctl --user restart'
        :alias 'use' 'systemctl --user enable'
        :alias 'usd' 'systemctl --user disable'
        :alias 'usu' 'systemctl --user status'
        :alias 'usl' 'systemctl --user list-units'
        :alias 'udr' 'systemctl --user daemon-reload'
    }

    # :journald
    {
        :alias 'jx' 'sudo journalctl -xe'
        :alias 'jxf' 'sudo journalctl -xef'
        :alias 'jxg' 'sudo journalctl -xe | grep '
        :alias 'jxfg' 'sudo journalctl -xef | grep '
        :alias 'ju' 'sudo journalctl -u'
        :alias 'juf' 'sudo journalctl -f -u'
    }

    :alias 'bs' '.bootstrap'
    :alias 'ss' '.sync'
}


ssh-add ~/.ssh/id_rsa 2>/dev/null
stty -ixon

FZF_TMUX_HEIGHT=0
FZF_ARGS=""

source ~/.zgen/fzf.zsh || {
    cat > ~/.zgen/fzf.zsh <<< "$(
        cat $(pacman -Ql fzf | grep '.zsh$' | cut -d' ' -f2) \
            | sed -r -e 's/\+s//' -e '/bindkey/d'
    )"
    source ~/.zgen/fzf.zsh
}

eval $(dircolors ~/.dircolors.$BACKGROUND)

unset -f colors

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
