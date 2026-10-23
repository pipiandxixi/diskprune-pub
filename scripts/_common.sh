# Shared by the policy scripts. Run them from anywhere; paths are worked out from this file.
set -euo pipefail
PUB="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# The command line tool of the app, built by engine/scripts/build-app.sh (override with CLEANUPS=...).
CLEANUPS="${CLEANUPS:-$PUB/../engine/build/DiskPrune.app/Contents/MacOS/cleanups}"
[ -x "$CLEANUPS" ] || { echo "cleanups tool not found at $CLEANUPS (run engine/scripts/build-app.sh)" >&2; exit 1; }
version_of() { python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "$1"; }
# true when the pack has a non-empty "changes" list (the short note the app shows before the person updates)
has_changes() { python3 -c 'import json,sys; c=json.load(open(sys.argv[1])).get("changes"); sys.exit(0 if isinstance(c,list) and any(str(x).strip() for x in c) else 1)' "$1"; }
# true when $1 is a higher dotted version than $2
newer() { python3 -c 'import sys; a=[int(x) for x in sys.argv[1].split(".")]; b=[int(x) for x in sys.argv[2].split(".")]; sys.exit(0 if a>b else 1)' "$1" "$2"; }
