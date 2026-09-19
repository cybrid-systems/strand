#!/usr/bin/env bash
# Run Strand against a local Aura host binary.
#
# Usage (from strand repo root):
#   ./scripts/run.sh
#   ./scripts/run.sh loop.aura
#
# Env:
#   AURA_BIN   default ../aura-grok/build/aura, then ../aura/build/aura
#   AURA_LIB   default ../aura-grok/lib, then ../aura/lib
#   STRAND_PROPOSE  catalog (default) | swarm | llm

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

pick_bin() {
  if [[ -n "${AURA_BIN:-}" && -x "${AURA_BIN}" ]]; then
    echo "${AURA_BIN}"
    return
  fi
  local c
  for c in "$ROOT/../aura-grok/build/aura" "$ROOT/../aura/build/aura"; do
    if [[ -x "$c" ]]; then
      echo "$c"
      return
    fi
  done
  echo ""
}

pick_lib() {
  if [[ -n "${AURA_LIB:-}" && -d "${AURA_LIB}/std" ]]; then
    echo "${AURA_LIB}"
    return
  fi
  local c
  for c in "$ROOT/../aura-grok/lib" "$ROOT/../aura/lib"; do
    if [[ -d "$c/std" ]]; then
      echo "$c"
      return
    fi
  done
  echo ""
}

BIN="$(pick_bin)"
LIB="$(pick_lib)"

if [[ -z "$BIN" ]]; then
  echo "error: aura binary not found. Set AURA_BIN or build ../aura-grok or ../aura" >&2
  exit 1
fi

if [[ -z "$LIB" ]]; then
  echo "error: Aura stdlib not found. Set AURA_LIB to the directory that contains std/" >&2
  exit 1
fi

SRC="${1:-$ROOT/loop.aura}"
if [[ ! -f "$SRC" ]]; then
  echo "error: file not found: $SRC" >&2
  exit 1
fi

mkdir -p "$ROOT/.strand"

export AURA_PATH="${AURA_PATH:-$LIB}"
export AURA_SANDBOX="${AURA_SANDBOX:-off}"
export AURA_PIPELINE_STRICT="${AURA_PIPELINE_STRICT:-0}"
export STRAND_PROPOSE="${STRAND_PROPOSE:-catalog}"
export STRAND_SOUL="${STRAND_SOUL:-$ROOT/.strand/session.aura-soul}"

_KEY_FILE="${MINIMAX_KEY_FILE:-$HOME/code/keys/minimax}"
if [[ -z "${LLM_API_KEY:-}" && -f "$_KEY_FILE" ]]; then
  _raw="$(tr -d '\r\n' < "$_KEY_FILE" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  if [[ "$_raw" == *=* ]]; then
    export LLM_API_KEY="${_raw#*=}"
  else
    export LLM_API_KEY="$_raw"
  fi
  unset _raw
  export LLM_BASE_URL="${LLM_BASE_URL:-https://api.minimaxi.com/v1}"
  export LLM_MODEL="${LLM_MODEL:-MiniMax-M3}"
fi
unset _KEY_FILE

echo "strand: bin=$BIN lib=$LIB propose=${STRAND_PROPOSE} soul=${STRAND_SOUL} model=${LLM_MODEL:-} base=${LLM_BASE_URL:-}"
exec "$BIN" < "$SRC"
