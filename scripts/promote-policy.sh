#!/bin/bash
# Makes the signed candidate the stable policy (the only step that releases anything), after checking it.
. "$(dirname "$0")/_common.sh"
C="$PUB/policy/candidate" S="$PUB/policy/stable"
"$CLEANUPS" policy-verify "$C/policy.json" "$C/policy.sig" "$PUB/keys/policy-ed25519.pub"
NEW="$(version_of "$C/policy.json")"
if [ -f "$S/policy.json" ]; then
  OLD="$(version_of "$S/policy.json")"
  newer "$NEW" "$OLD" || { echo "refusing: $NEW is not higher than the published $OLD (to roll back, publish the old rules under a higher version)" >&2; exit 1; }
fi
mkdir -p "$PUB/policy/archive/$NEW" "$S"
cp "$C/policy.json" "$C/policy.sig" "$PUB/policy/archive/$NEW/"
cp "$C/policy.json" "$C/policy.sig" "$S/"
echo "published $NEW: now commit and push $PUB"
