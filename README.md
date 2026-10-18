# MacRefresh

**MacRefresh is an independent, open-source app updater for macOS.** It scans the apps on your Mac, finds newer versions from multiple independent sources, and can download and install them for you — no manual web hunting, no account, no tracking. It also includes a free app shop, a download manager, and a set of maintenance and reporting tools.

> MacRefresh is an original, community project. It is **not** affiliated with, endorsed by, or related to any other update utility, and it ships no third-party code or branding. It is released under the MIT license.

![MacRefresh](icon.png)

---

## What's new in 1.0.2 beta 2

- **Fixed: self-update now finds beta releases.** Tags like `MacRefresh_v1.0.2b` are parsed correctly (the prerelease suffix is preserved), so the updater no longer silently skips a release because its version looked "stable" while GitHub flagged it as pre-release.
- **Fixed: no more false "binary changed" alerts after updating.** The SHA-256 tamper check is now version-aware — a version bump records the new hash and moves on; only a same-version hash mismatch is flagged.
- **Fixed: broken "X" entries filtered from Updates.** Rows with an empty name, empty bundle ID, or a 1–2 character name with no version are dropped, and update rows must carry a plausible latest version.
- **Fixed: search lag.** Typing in the search box is debounced (180 ms) so fast typing no longer triggers a full table reload per keystroke.
- **Self-update hardening.** Downloads retry 3× with backoff, files under 500 KB are rejected (catches HTML error pages), and the staged bundle is verified to be `com.macrefresh.fixed` and not older than the running build.
- **Window position memory.** The window frame (position + size) is saved on move/resize and restored on launch.
- **Overview second row:** Last scan, Free disk space (red if <10 GB), Network status, Update channel.
- **Overview quick actions:** Rescan apps, Find duplicates, Open Tools, Settings.
- **⌘U shortcut** for Update All Outdated (alongside ⌘R check, ⌘⇧R rescan, ⌘1–7 panes, ⌘L search).
- **Settings → Updates & install behavior:** check on launch, backup before update, open after install, rescan after install, verify checksums, install pending on quit, rollback retention (1/3/5/10).
- **Settings → Accessibility:** larger text, high contrast, reduce transparency, keyboard shortcuts.
- **Settings → Export/Import settings** (plist, with restart on import).
- **Tools → Diagnostics & network:** View log in window, Network diagnostics (ping/DNS/GitHub), Login items, Disk space analyzer, Copy system profile.
- **Last-scan timestamp** saved and displayed on the Overview.
- **35 new preference keys** with safe defaults; **10 new self-tests** (233 total, all passing).

## What's new in 1.0.2 (beta)

- **Scrolling fixed.** The Tools and Settings panes no longer clip content below the window — every section is reachable.
- **Cleaner channel badge.** The loud orange BETA pill is replaced with a soft, subtle amber tag (Release = green, Alpha = red, same soft treatment).
- **Selectable update channels.** Choose **Stable**, **Beta** or **Alpha** in Tools → Security & updates; a stable user can opt into betas, and a beta user can lock to stable-only.
- **Faster updates.** Fast mode (on by default) raises parallel update checks to 18 and download concurrency to 6–10.
- **Stronger security (anti file-theft).** Optionally lock `~/Documents`, `~/Desktop` and `~/Downloads` to owner-only (700); scan them for world/group-writable items; detect a tampered MacRefresh binary via SHA-256 integrity hash checked at launch.
- **Security score 0–100** shown on the Overview and Tools panes.
- **New Settings:** Compact UI, Reduce Motion, default launch pane, auto-install minor/patch updates, show/hide security score, fast mode toggle.
- **Overview "Update All Outdated"** button alongside Check for Updates.
- **Context menu additions:** Skip this version, Copy path, Open homepage, Show in Shop.
- **Reset all settings** (with confirm + restart) in Settings → Storage.
- **12 new self-tests** — 223 total, all passing.

## What's new in 1.0.1 (beta)

Note: 1.0.1 might contains errors.

- **In-app self-update.** MacRefresh checks its own GitHub releases and can download, verify, stage and install a new build, then restart itself — with an automatic backup you can restore from. Choose **MacRefresh → Check for MacRefresh Updates…**, or open **Tools → Security & updates**.
- **Release-channel indicator.** The sidebar, title bar, About panel and menu show whether you are on an **Alpha**, **Beta** or **Release** build (e.g. `1.0.1b · Beta`). Pre-release builds only see pre-release updates; stable builds only see stable updates unless you opt in.
- **Folder protection.** MacRefresh can lock its private data folder (`~/Library/Application Support/MacRefresh/`) to owner-only (700/600) so other users and processes cannot read or tamper with downloaded installers, logs or catalogs.
- **App-folder security scan.** Scan all installed apps for over-permissive permissions (world/group-writable bundles and executables), unsigned apps, and stray quarantine flags, with one-click repair.
- **Self-integrity verification.** Verify that the installed MacRefresh bundle is intact with `codesign`.
- The test suite now covers 211 checks (channel gating, self-update selection, the swapper script, permission lockdown and scan/repair).

---


## Highlights

- **Scans every app**, not just one folder: `/Applications`, your user Applications folder, the Desktop, and any folders you add. Duplicate copies are detected and surfaced.
- **Six independent update sources**, queried with strict version rules so you never get a bogus "update" (no downgrades, no betas on stable channels, no foreign-region App Store results).
- **One-click download + install**: it downloads, verifies, quits the running app, replaces it in place (with a rollback copy), and optionally relaunches it. `.pkg` installers can be installed silently through the native macOS password prompt.
- **Free App Shop**: 190+ genuinely free apps installed straight from each developer's official URL as published in the Homebrew cask catalog. Nothing is paid, cracked, or repackaged.
- **Menu-bar item**, scheduled background checks, quiet hours, a download queue, signatures, reports, and a full tools panel.
- Runs entirely on your machine. No accounts, no telemetry, no phone-home.

## Requirements

- macOS 12.4 Monterey or later (Intel **and** Apple Silicon)
- The Xcode Command Line Tools only if you build from source; the release build needs nothing extra.

## Install

### Prebuilt release (recommended)

1. Open `MacRefresh.dmg`.
2. Drag **MacRefresh** onto the **Applications** folder.
3. Launch it. The first time you update or remove an app macOS may ask for permission; that is the standard App Management / admin prompt.

> The app is ad-hoc signed (not notarized). If Gatekeeper stops it, right-click the app → **Open** → **Open**, or go to **System Settings → Privacy & Security → Open Anyway**. See the GitHub release guide for details.

### Build from source

```bash
# Native build for this Mac
./build.sh

# Universal binary (arm64 + x86_64)
UNIVERSAL=1 ./build.sh
```

Then open `MacRefresh.app`. The build only uses the Swift compiler that ships with Xcode Command Line Tools — there are no third-party dependencies.

---

## Self-update and release channels

MacRefresh updates itself from this repository's GitHub releases.

- A **Release** build (version like `1.0.0`, `1.0.1`) offers only stable releases.
- A **Beta** build (version ends in `b`, `beta`, `rc` or `pre`, e.g. `1.0.1b`) offers newer stable **and** beta/rc builds.
- An **Alpha** build (version ends in `a`, `alpha`, `dev`, `nightly` or `canary`) offers any newer build.
- Stable users can opt into beta builds in **Tools → Security & updates → Include beta/alpha builds**.

Releases are matched by a versioned **Git tag** (`v1.0.0`, `v1.0.1b`, …). Tags without a version number are ignored. The updater downloads the attached `.dmg`, stages it locally, and runs a detached swap script that waits for MacRefresh to quit, backs the current copy up as `.bak_<timestamp>`, installs the new build, clears quarantine and relaunches it. If anything fails it restores the previous copy and reopens the disk image for a manual install.

> Packaging note for maintainers: the self-updater only reads releases that are tagged with a version number (e.g. `v1.0.1b`), and a `.dmg` asset must be attached. Mark beta builds as a GitHub **pre-release**.

## Security

- **Protect my data folders** sets the private support directory and its Downloads/Logs/Mounts/Extracts/Parked folders to owner-only (700/600).
- **Verify MacRefresh integrity** runs `codesign --verify --deep --strict` on the running bundle.
- **Scan app folders for risks** flags world/group-writable app bundles and executables, unsigned apps, and unexpected quarantine flags.
- **Repair risky permissions** removes group/world write access, restores the executable bit and strips quarantine flags.

---

## The seven panes

### 1. Overview
A dashboard with app count, update count, last-check time and quick actions. Start a scan, see network status, and jump straight to pending updates.

### 2. Updates
Every app with a genuine newer version. Search, filter by source, show direct-download-only updates, update one app or all at once. Each row shows the installed and available version, the source, and release notes when available.

### 3. Installed
Everything MacRefresh found. Sort by name/version/date/size, filter by architecture (Universal / Intel / Apple Silicon), signature status, and quarantine, and search. Double-click to open; right-click for update, verify, reveal, copy bundle ID/version, ignore, or uninstall.

### 4. Shop
The free app shop. Browse 190+ curated free apps by category (Browsers, Communication, Media, Productivity, Developer, Utilities, Internet, Graphics, Audio, Security, Games), with icons, versions, and one-click install. Filter to All / Not installed / Installed / Favorites and multi-select.

### 5. Downloads
A real download queue: pause, resume, cancel, retry, reveal, clear, and bulk pause/resume/retry/cancel. Live progress, per-app download speed, and an empty-state when there is nothing queued.

### 6. Tools
Update history with rollback builds, storage management with real sizes, reports in six formats, signature verification, maintenance actions, and a **Security & updates** section for in-app self-update, data-folder protection, integrity verification and app-folder security scans.

### 7. Settings
Behavior, scheduled checks, speed/concurrency, storage and retention, downloads folder, custom update sources, ignored apps, and appearance.

---

## Update sources

| Source | How it works |
|---|---|
| **Homebrew cask index** | The public Homebrew cask catalog; versions are matched against the exact app token. |
| **Sparkle / Squirrel feeds** | The standard app-update XML feeds embedded in apps themselves. |
| **App Store lookup** | The public iTunes lookup API, restricted to your own storefront and the exact bundle ID. |
| **GitHub releases** | Release assets for GitHub-hosted apps (many Electron apps). |
| **`asar` / package.json** | Version metadata for Electron apps. |
| **Custom web URLs** | Any feed URL you add yourself. |

### Strict version rules (no fake updates)

- Leading prefixes (`v`, `V`, `version `), parentheses, brackets and underscores are normalized, so **v1.63 and 1.63 are the same version** and never flag an update.
- Pre-release/beta/rc versions are **not** offered on the stable channel.
- Placeholder versions like `0.0.0.x` are ignored.
- An older catalog version never downgrades a newer installed app (e.g. Chrome's self-updated build).
- App Store results must match the exact bundle ID and your storefront, so an app that is already current in the App Store never appears.

## Installing and replacing apps

- Before replacing an app, MacRefresh asks it (and all of its helper processes) to quit, waits, then force-quits only what remains inside that bundle.
- The previous copy is moved aside for **rollback** and is restored automatically if the new copy fails.
- On macOS Sequoia's App Management protection, it falls back to the native administrator password dialog.
- `.pkg` installers can be installed silently (`/usr/sbin/installer` with the native password prompt) instead of merely opening the installer.
- App Store apps are handed off to the App Store, which performs that update itself.

## Duplicate apps

When several copies of the same app are found (for example one on the Desktop and one in `/Applications`), Installed and Tools let you: reveal the duplicates, keep a specific copy, move the extras to the Trash, or clear all duplicates in one action.

---

## Command-line usage

MacRefresh is a GUI app, but it includes a small headless interface for automation:

```bash
# Run the built-in test suite (writes only to a temp directory)
./MacRefresh.app/Contents/MacOS/MacRefresh --selfcheck

# Print a scan of installed apps and available updates
./MacRefresh.app/Contents/MacOS/MacRefresh --scan

# The same scan as CSV
./MacRefresh.app/Contents/MacOS/MacRefresh --csv

# Inspect a Homebrew cask (read-only; prints version and download URL)
./MacRefresh.app/Contents/MacOS/MacRefresh --resolve-cask google-chrome

# Download and install a cask (performs the full install pipeline)
./MacRefresh.app/Contents/MacOS/MacRefresh --install-cask the-unarchiver

# Silently install a local .pkg via the native password prompt
./MacRefresh.app/Contents/MacOS/MacRefresh --install-pkg /path/to/installer.pkg

# Open a specific pane: overview|updates|installed|shop|downloads|tools|settings
./MacRefresh.app/Contents/MacOS/MacRefresh --pane updates
```

## Features (summary)

- **Updating:** multi-source checks, strict version comparison, bulk update, update all, skip-this-version, release notes, direct-only filter, source filter, retry/backoff, pre-release and placeholder gates, build-equivalence checks.
- **Installing:** automatic download, verify, quit-tree, force-quit of a bundle's helpers, in-place replace with rollback, admin fallback, silent PKG install, App Store handoff, relaunch-after-update.
- **Scanning:** multiple standard folders, extra folders, Desktop and home Applications, duplicate detection, architecture and signature and quarantine metadata, ignore list (browse to ignore), persisted sorting.
- **Shop:** 190+ free apps, categories, search, real and monogram icons, favorites, segments, single/multi/all install, homepage link.
- **Downloads:** queue with pause/resume/cancel/retry/clear and bulk controls, per-app speed, configurable concurrency and attempts, custom downloads folder.
- **Tools:** update history, rollback builds, reveal/clear, storage management with real sizes, reports in CSV/JSON/HTML/Markdown/PDF, copy report, export diagnostics, run diagnostics, verify all signatures, force catalog refresh, rotate logs, reveal log, install essentials bundle, self-update, data-folder lockdown, integrity verification and security scan/repair.
- **Customization:** scheduled checks, quiet hours, launch at login, menu-bar item with quick menu and recent activity, dock badge, click-to-open, dark/light/system appearance, downloads folder, retention/pruning, settings export/import/reset.
- **Safety:** signature verification, quarantine awareness, owner-only data-folder lockdown, app-folder permission scan and repair, self-integrity checks, uninstall with confirmation, duplicate trash with confirmation, no tracking, local-only data.
- **Self-update:** channel-aware GitHub release checks (alpha/beta/release), download-verify-stage-swap with automatic backup and restore, opt-in beta channel, and a visible channel badge.

## Privacy

MacRefresh does not collect or send any personal data. It only contacts the public update sources listed above when you ask for a check, the public GitHub API (`api.github.com/repos/JaydenLeung0818/MacRefresh`) for its own self-updates, and GitHub release downloads when you choose to install an update. It stores its catalog and downloads in `~/Library/Application Support/MacRefresh/`.

## License

[MIT](LICENSE) — Copyright © Jayden Leung. All app and company names mentioned are the property of their respective owners and are used only to identify those apps.
