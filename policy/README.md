# Scanning policy

The rule pack that decides what DiskPrune offers for cleaning. The app only uses a pack that is signed with our key, newer than what it has, valid under the same checks as the built-in pack, and it never lets a pack weaken the protections written in the code itself.

```
policy/
  stable/      what apps download:  policy.json + policy.sig  (signature over the exact bytes of policy.json)
  candidate/   the next pack under test; apps never read it
  archive/     every published version, one folder each: archive/<version>/policy.json + policy.sig
  CHANGELOG.md what changed in each version, in plain words
```

## Publishing

1. Edit the rules and put the pack in `candidate/`.
2. Test it (the tests and a scan on real machines).
3. On the offline machine, sign it and promote it: `scripts/promote-policy.sh`. This copies `candidate/` to `archive/<version>/` and to `stable/`, and refuses a version that is not higher than the one in `stable/`.
4. Commit and push. Apps pick it up the next time they check.

Moving `stable/` is the only step that releases anything.
