# Scripts

Run on the maintainer's machine, never in CI with secrets.

- `sign-policy.sh` — sign `policy/candidate/policy.json` with the offline private key (to be added)
- `promote-policy.sh` — copy a signed candidate to `archive/` and `stable/` if its version is higher (to be added)
- `check-policy.sh` — verify structure, version order and signature (also used by CI) (to be added)
