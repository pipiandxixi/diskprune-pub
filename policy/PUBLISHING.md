# Publishing a new policy

The policy is a signed rule pack. Apps download `stable/policy.json` and `stable/policy.sig`, check the signature against the public key inside the app, and use it only if it is valid, **higher in version** than what they have, and passes the same checks as the built-in pack. Anything else is ignored and the app keeps its current rules.

The private key signs; it never goes into this repository, the app, or the build tree. Scripts take it **by path** and only read it.

## Every time

1. **Start from the rules in the app.** The source of truth is `engine/Sources/CleanupsCore/Resources/rules/rules.json` in the app repository. Make the change there, run `cd engine && swift test`, and try it with `cleanups scan --rules <file>` or the app.
2. **Stage it.** Copy the file to `pub/policy/candidate/policy.json` and set `"version"` to a **higher** dotted number than the one in `policy/stable/policy.json` (the convention is the date and a counter: `2026.10.23.2`). Versions compare number by number.
   Also set `"changes"`: a short list of plain sentences saying what is different (what is now found, what is no longer offered, what moved between Safe and Decide). The app shows them next to the Update button so the person can decide, and the scripts refuse a candidate without them. Write them for a user, not for us; the same lines go into `CHANGELOG.md`.
3. **Build the tool** the scripts use: `engine/scripts/build-app.sh` (it provides `engine/build/DiskPrune.app/Contents/MacOS/cleanups`).
4. **Sign** (reads the key, writes `candidate/policy.sig`, checks it against `keys/policy-ed25519.pub`):
   `pub/scripts/sign-policy.sh ~/diskprune-keys/policy-private.key`
   Decrypt the key first if it is kept encrypted, and delete the plain copy afterwards.
5. **Promote** (the only step that releases anything: verifies again, refuses a version that is not higher, copies to `archive/<version>/` and `stable/`):
   `pub/scripts/promote-policy.sh`
6. **Check** that what is about to go out is consistent: `pub/scripts/check-policy.sh`
7. **Commit and push inside `pub/`** with a message that says what changed. Add a line to `policy/CHANGELOG.md`.
8. **Confirm from the outside** a minute later: `curl -s https://raw.githubusercontent.com/pipiandxixi/diskprune-pub/main/policy/stable/policy.json | head -5`, then About → Scanning policy → Check for Updates shows the new version with its "What changed" list, and Update installs it. Nothing is installed without the person pressing Update.

If a script refuses, read what it says: it is protecting the users, not being difficult.

## Rolling back
Never lower the version. Put the **old rules** in `candidate/` under a **new, higher version** and publish as above. Apps that already took the bad pack will take the fixed one because it is newer.

## If the private key may have leaked
Anyone with it can publish a pack the apps accept (it still cannot touch what the code protects, and the administrator tool ignores policies). Generate a new pair (`cleanups policy-keygen`), put the new public key in `PolicySource.current` and `keys/policy-ed25519.pub`, ship an app update, then publish. Until the update reaches users, the old key remains trusted by old versions, which is why the key is kept encrypted and off the daily machine.

## Tests
`swift test --filter PolicyPublishTests` checks both that the policy now in `stable/` is signed with the app's key, valid and installable, and that the scripts sign, promote and refuse correctly (same or lower version, a changed file, a stranger's key, a key inside the repository) using a throw-away key in a temporary copy.
