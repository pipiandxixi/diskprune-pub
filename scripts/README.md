# Scripts

Run on the maintainer's machine. The private key is passed by path and never copied here.

- `sign-policy.sh KEYFILE` — sign `policy/candidate/policy.json`, then check the signature against `keys/policy-ed25519.pub`
- `promote-policy.sh` — verify the candidate and copy it to `policy/archive/<version>/` and `policy/stable/`; refuses a version that is not higher
- `check-policy.sh` — check that `policy/stable/` is validly signed and identical to its archive copy

They use the `cleanups` tool from the app build (`engine/build/DiskPrune.app/Contents/MacOS/cleanups`).
