#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
backup_dir="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)}"
dry_run=0

if [ "${1:-}" = "--dry-run" ]; then
  dry_run=1
fi

link_file() {
  rel_path=$1
  src="$repo_dir/$rel_path"
  dest="$HOME/$rel_path"
  dest_dir=$(dirname -- "$dest")
  rel_dir=$(dirname -- "$rel_path")

  if [ "$dry_run" -eq 1 ]; then
    printf 'link %s -> %s\n' "$dest" "$src"
    return
  fi

  mkdir -p -- "$dest_dir"

  if [ -L "$dest" ]; then
    current=$(readlink -- "$dest" || true)
    if [ "$current" = "$src" ]; then
      return
    fi
    mkdir -p -- "$backup_dir/$rel_dir"
    mv -- "$dest" "$backup_dir/$rel_path"
  elif [ -e "$dest" ]; then
    mkdir -p -- "$backup_dir/$rel_dir"
    mv -- "$dest" "$backup_dir/$rel_path"
  fi

  ln -s -- "$src" "$dest"
}

find "$repo_dir" -type f \
  ! -path "$repo_dir/.git/*" \
  ! -name install.sh \
  ! -name README.md \
  ! -name .gitignore \
  | while IFS= read -r file; do
    rel_path=${file#"$repo_dir/"}
    link_file "$rel_path"
  done

if [ "$dry_run" -eq 0 ]; then
  printf 'Dotfiles installed. Backups, if any, are in %s\n' "$backup_dir"
fi
