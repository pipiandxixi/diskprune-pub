#!/bin/bash
# Checks what is published in policy/stable: the signature matches the public key and the archive has the same bytes.
. "$(dirname "$0")/_common.sh"
S="$PUB/policy/stable"
"$CLEANUPS" policy-verify "$S/policy.json" "$S/policy.sig" "$PUB/keys/policy-ed25519.pub"
V="$(version_of "$S/policy.json")"
cmp "$S/policy.json" "$PUB/policy/archive/$V/policy.json" && cmp "$S/policy.sig" "$PUB/policy/archive/$V/policy.sig"
echo "stable is version $V and matches the archive"
