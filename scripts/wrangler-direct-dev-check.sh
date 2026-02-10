#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="$ROOT_DIR/.tmp.wrangler-direct.log"
RESP_FILE="$ROOT_DIR/.tmp.wrangler-direct-response.json"
ERR_FILE="$ROOT_DIR/.tmp.wrangler-direct-curl.err"
PORT="${WRANGLER_DIRECT_PORT:-8795}"

cleanup() {
  if [[ -n "${DEV_PID:-}" ]] && kill -0 "$DEV_PID" 2>/dev/null; then
    kill "$DEV_PID" >/dev/null 2>&1 || true
    wait "$DEV_PID" >/dev/null 2>&1 || true
  fi
  rm -f "$LOG_FILE" "$RESP_FILE" "$ERR_FILE"
}
trap cleanup EXIT

cd "$ROOT_DIR"

CI=1 pnpm exec wrangler dev --config wrangler.direct.json --port "$PORT" >"$LOG_FILE" 2>&1 &
DEV_PID=$!

for _ in {1..20}; do
  if curl -fsS "http://127.0.0.1:${PORT}" >"$RESP_FILE" 2>"$ERR_FILE"; then
    break
  fi
  sleep 1
done

if [[ ! -s "$RESP_FILE" ]]; then
  cat "$LOG_FILE"
  echo "Direct wrangler check failed: worker did not return a response." >&2
  exit 1
fi

if ! rg -q "\"ok\":true" "$RESP_FILE"; then
  cat "$RESP_FILE"
  echo "Direct wrangler check failed: unexpected response payload." >&2
  exit 1
fi

echo "Direct wrangler check passed."
