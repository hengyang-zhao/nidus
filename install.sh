#!/usr/bin/env bash

BACKUP_DIR="$HOME/.nidus_backup"
SITE_DIR="$HOME/.nidus_site_config"

NIDUS_DIR="$(builtin cd "$(dirname $0)"; builtin pwd -P)"

OVERWRITE=0
NO_BACKUP=0
FORCE_LEGACY=0

function put {

    local severity="$1"
    local text="$2"
    local indent=${indent:=""}

    case "$severity" in
        info)
            builtin echo "$indent$text"
            ;;
        emph)
            builtin echo $(tput bold)"$indent$text"$(tput sgr0)
            ;;
        warn)
            builtin echo $(tput setaf 3)"$indent$text"$(tput sgr0)
            ;;
        error)
            builtin echo $(tput setaf 1)"$indent$text"$(tput sgr0)
            ;;
        fatal)
            builtin echo $(tput setab 1)"$indent$text"$(tput sgr0)
            ;;
    esac
}

function random_digits {
    local n_digits="$1"
    local digit

    while [ "$n_digits" != 0 ]; do
        let 'digit = RANDOM % 10'
        builtin echo -n $digit
        let 'n_digits -= 1'
    done
}

function prepare_site_dir {
    local indent="  "

    if ! mkdir -p "$SITE_DIR"; then
        put fatal "Unable to setup nidus site directory."
        return 1
    fi

    local proj_link="$SITE_DIR/nidus"
    local site_link="${SITE_LINK:=$HOME/.n}"

    if [ -e "$proj_link" ] && ! [ -L "$proj_link" ]; then
        put fatal "Unable to setup nidus symbolic link."
        put fatal "Target $proj_link exists but is not a symbolic link."
        return 1
    else
        rm -f "$proj_link"

        if (builtin cd "$SITE_DIR" && ln -s "$NIDUS_DIR" "$(basename "$proj_link")"); then
            put info "Linked $proj_link to $NIDUS_DIR."
        else
            put fatal "Unable to setup symbolic link to nidus project directory."
            return 1
        fi
    fi

    if [ -L "$site_link" ]; then
        if [ "$(readlink "$site_link")" = "$SITE_DIR" ]; then
            : # We're just good.
        else
            put fatal "Unable to setup site config symbolic link."
            put fatal "Link $site_link was created by another application."
            return 1
        fi
    elif ! [ -e "$site_link" ]; then
        if (builtin cd "$HOME" && ln -s "$SITE_DIR" "$(basename "$site_link")"); then
            put info "Linked $site_link to $SITE_DIR."
        else
            put fatal "Unable to setup symbolic link to nidus site config directory."
            return 1
        fi
    else
        put fatal "Unable to setup site config symbolic link."
        put fatal "Target $site_link exists but is not a symbolic link."
        return 1
    fi

    put info "Site directory $SITE_DIR is ready."

    return 0
}

function backup {

    local src="$1"
    local dst="$BACKUP_DIR/$2__$(random_digits 8).backup"

    if [ ! -L "$src" ] && [ ! -e "$src" ]; then
        return 0
    fi

    if [ -e "$dst" ]; then
        put error "Unable to backup file $src to $dst. Destination file exists."
        return 1
    fi

    local dst_dir="$(dirname $dst)"
    if ! mkdir -p "$dst_dir"; then
        put error "Unable to make backup directory $dst_dir."
        return 1
    fi

    if ! mv "$src" "$dst"; then
        put error "Unable to backup file $src to $dst."
        return 1
    fi
    put warn "Backed up file $src to $dst."

    return 0
}

function deploy {
    local dir="$1"
    local info_file="$dir/config.sh"

    local indent="  "

    (
        if ! source "$info_file"; then
            put error "Invalid info file: $dir/config.sh."
            return 1
        fi

        if [ -e "$install" ] || [ -L "$install" ]; then

            if diff "$dir/$source" "$install" &>/dev/null; then
                put info "File $install is identical to the installation source."
                put info "Skipped backup and/or installation."
                return 0
            fi

            if [ "$OVERWRITE_ALL" = 1 ]; then
                conflict=backup
            fi

            case "$conflict" in
                backup)
                    if [ "$NO_BACKUP" = 0 ]; then
                        backup "$install" "$backup_name" || return 1
                    fi
                    rm -f "$install"
                    ;;
                skip)
                    put info "File $install exists."
                    put info "Skipped installation according to conflict policy."
                    return 0
                    ;;
                *)
                    put error "File $install exists. Unsupported conflict policy: $conflict"
                    return 1
                    ;;
            esac
        fi

        case "$type" in
            dynamic)
                local cmd="'$dir/$source' '$install'"
                ;;
            link)
                local cmd="ln -s '$dir/$source' '$install'"
                ;;
            copy)
                local cmd="cp -r '$dir/$source' '$install'"
                ;;
            *)
                put error "Unsupported install type: $type"
                return 1
                ;;
        esac

        local install_dir="$(dirname "$install")"
        if ! mkdir -p "$install_dir"; then
            put error "Unable to create directory $install_dir."
            return 1
        fi

        if ! eval "$cmd"; then
            put error "Unable to install $install."
            return 1
        fi

        put info "Wrote file $install."
    )
}

function parse_args {

    while [ "$#" -ge 1 ]; do
        case "$1" in
            --overwrite-all)
                OVERWRITE_ALL=1
                put emph "Will overwrite all conflicting files."
                ;;

            --no-backup)
                NO_BACKUP=1
                put warn "Will not backup conflicting files."
                ;;

            --force-legacy)
                FORCE_LEGACY=1
                put warn "Will install disregard bash version."
        esac
        shift
    done
}

function main {

    parse_args $*

    if [ "${BASH_VERSINFO[0]}" -lt "$(<$NIDUS_DIR/install.d/minimum_bash_version/major)" ]; then
        if [ "${FORCE_LEGACY}" = 1 ]; then
            put warn "Will force install nidus disregard the current legacy bash (version $BASH_VERSION)"
        else
            put fatal "Current bash ($BASH_VERSION) is not supported."
            put fatal "To force install nidus, turn on switch --force-legacy."
            return 1
        fi
    fi

    put emph "Setting up site config directory:"
    prepare_site_dir || return 1

    local has_error=no

    for conf_dir in $NIDUS_DIR/configs/???-*; do
        local base="$(basename "$conf_dir")"
        put emph "Installing $base:"
        if ! deploy "$conf_dir"; then
            has_error=yes
        fi
    done

    if [ "$has_error" == yes ]; then
        put error "Error occured. Installation may be incomplete."
        return 1
    fi

    put emph "Installation complete."
    put emph "Nidus will take effect on your next login."
}

main $*

