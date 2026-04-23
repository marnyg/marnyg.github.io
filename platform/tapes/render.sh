#!/usr/bin/env bash
# Render all .tape files to demos/*.mp4.
# Each tape outputs a .gif via vhs, which we then transcode to mp4 (so it
# doesn't autoplay on the slides) and delete the intermediate gif.
#
# Run from anywhere: ./tapes/render.sh [name1 name2 ...]
# With no args, renders every tape.
#
# Required env vars:
#   DEMO_APP_DIR — absolute path to a grove-registered app with a clean
#                  working tree, on branch main. Used by pr-preview and
#                  push-to-prod tapes (exported into the vhs shell).
# Preflight aborts early if prereqs aren't met.

set -euo pipefail

cd "$(dirname "$0")/.."

need() {
  command -v "$1" >/dev/null 2>&1 || { echo "error: $1 not on PATH" >&2; exit 1; }
}
need vhs
need ffmpeg
need grove

require_demo_app_dir() {
  local need_branch="$1"
  if [ -z "${DEMO_APP_DIR:-}" ]; then
    echo "error: DEMO_APP_DIR not set — point it at a grove-registered app" >&2
    exit 1
  fi
  if [ ! -d "$DEMO_APP_DIR/.git" ]; then
    echo "error: $DEMO_APP_DIR is not a git repo" >&2
    exit 1
  fi
  if [ -n "$(git -C "$DEMO_APP_DIR" status --porcelain)" ]; then
    echo "error: $DEMO_APP_DIR has uncommitted changes — commit or stash first" >&2
    exit 1
  fi
  local branch
  branch=$(git -C "$DEMO_APP_DIR" rev-parse --abbrev-ref HEAD)
  if [ "$branch" != "$need_branch" ]; then
    echo "error: $DEMO_APP_DIR is on '$branch', need '$need_branch'" >&2
    exit 1
  fi
}

preflight() {
  case "$1" in
    grove-register)
      : # mktemp-dir + timestamped app name, no external prereqs
      ;;
    pr-preview)
      require_demo_app_dir main
      ;;
    push-to-prod)
      require_demo_app_dir main
      ;;
  esac
}

tapes=("$@")
if [ ${#tapes[@]} -eq 0 ]; then
  mapfile -t tapes < <(cd tapes && ls *.tape | sed 's/\.tape$//')
fi

for name in "${tapes[@]}"; do
  tape="tapes/${name}.tape"
  gif="demos/${name}.gif"
  mp4="demos/${name}.mp4"

  if [ ! -f "$tape" ]; then
    echo "skip: $tape not found" >&2
    continue
  fi

  preflight "$name"

  echo "==> rendering $tape"
  vhs "$tape"

  if [ ! -f "$gif" ]; then
    echo "error: expected $gif was not produced" >&2
    continue
  fi

  echo "==> transcoding $gif -> $mp4"
  ffmpeg -y -loglevel error \
    -i "$gif" \
    -movflags +faststart \
    -pix_fmt yuv420p \
    -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" \
    "$mp4"

  rm -f "$gif"
done
