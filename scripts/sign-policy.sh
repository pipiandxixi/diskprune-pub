#!/bin/bash
# Signs policy/candidate/policy.json with the private key file given as the only argument.
# The key stays where it is: it is read, never copied. Keep it outside this repository.
. "$(dirname "$0")/_common.sh"
KEY="${1:?usage: sign-policy.sh PATH-TO-PRIVATE-KEY-FILE}"
case "$(cd "$(dirname "$KEY")" && pwd)/" in "$PUB"/*) echo "refusing: the key file is inside this repository" >&2; exit 1;; esac
has_changes "$PUB/policy/candidate/policy.json" || { echo "refusing: the candidate has no \"changes\" list. Say in a few plain sentences what is different in this version." >&2; exit 1; }
"$CLEANUPS" policy-sign "$PUB/policy/candidate/policy.json" "$KEY" > "$PUB/policy/candidate/policy.sig"
"$CLEANUPS" policy-verify "$PUB/policy/candidate/policy.json" "$PUB/policy/candidate/policy.sig" "$PUB/keys/policy-ed25519.pub"
echo "signed version $(version_of "$PUB/policy/candidate/policy.json")"
