# DiskPrune — public files

Everything public about [DiskPrune](https://github.com/pipiandxixi/diskprune-pub), a macOS storage cleanup tool for developers and AI work, lives here. The app itself is built elsewhere; this repository holds what the world is meant to read, download or check.

| Folder | What is in it | Who reads it |
| --- | --- | --- |
| `policy/` | The scanning policy (rule pack) the app downloads, signed. `stable/` is what apps get, `candidate/` is under test, `archive/` keeps every published version. | The app, anyone auditing the rules |
| `keys/` | **Public** keys only: the one that verifies policy files and the one that verifies license codes, with fingerprints. | The app, anyone auditing |
| `releases/` | Update feed and release notes for the direct-download edition. Installers are attached to GitHub Releases, not stored in git. | The app (updates), users |
| `site/` | The website. | Visitors |
| `docs/` | Privacy policy, support, how the rules work, FAQ. | Users, App Review |
| `scripts/` | Tools to sign, check and publish policy files. They run on the maintainer's machine. | Maintainer |
| `.github/workflows/` | Checks that run on every push (policy files are valid and properly signed). | CI |

## Rules of this repository

- **Private keys never go here.** Only public keys are committed. Signing happens on an offline machine.
- **Nothing here is edited by hand once published.** Policy files are produced by `scripts/`, so the signature always matches the bytes.
- **Rolling back means publishing again.** `policy/stable/` only ever moves to a newer version number; to undo a bad policy, publish the old rules under a higher version.
- Binaries do not live in git history. Use GitHub Releases.

## Where the app looks

- Policy: `https://raw.githubusercontent.com/pipiandxixi/diskprune-pub/main/policy/stable/` (`policy.json` and `policy.sig`)
