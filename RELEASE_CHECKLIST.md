# Release Checklist

## App Store Release Candidate

- Version: `1.1` (`CURRENT_PROJECT_VERSION = 2`)
- Bundle ID: `cn.corlin.hneveryday.HNEveryDay`
- Deployment target: iOS `18.6`
- Swift language mode: `5.0`
- Current status: App Store release preparation

## Automated Checks

- [ ] Unit tests pass for version `1.1`.
- [ ] `git diff --check` passes for version `1.1`.
- [ ] Release archive succeeds for version `1.1` build `2`.
- [x] CHANGELOG describes the current version `1.1` scope.

Command:

```bash
xcodebuild test -project HNEveryDay.xcodeproj -scheme HNEveryDay -destination id=9CFE28FE-F334-43F7-BBC2-3770BB6DF0E9 -derivedDataPath build/DerivedData CODE_SIGNING_ALLOWED=NO
```

Last automated verification: 2026-06-08, 20 unit tests passed. Version 1.1 UI and Magic Summary changes were manually tested before tagging.

## Smoke QA

- [x] App installs and launches on iPhone 17 Pro Max Simulator.
- [x] First-launch onboarding appears or, after completion, the Hacker News feed appears.
- [x] Feed loads top stories.
- [x] Feed signal cards render compactly with readable score, source, translation, saved, and comment states.
- [x] Story detail opens from the feed.
- [x] Story detail article/comments shell matches the compact feed visual system.
- [x] Comment rows and Magic Summary states preserve readability after the visual refresh.
- [x] Magic Summary waits for comments and includes nested replies when summarizing discussion.
- [x] Reader mode shows parsed article content or falls back to web view cleanly.
- [x] Article translation can be enabled from Settings and toggled in Reader mode.
- [x] Feed titles auto-translate in Auto mode and show the original title as secondary text.
- [x] Feed title translation batches visible titles and keeps cached/title-fallback behavior.
- [x] AI response language picker offers English, Simplified/Traditional Chinese, Japanese, Korean, Spanish, French, German, Portuguese, and Russian.
- [x] On-demand translation shows translated title/body and caches the result.
- [x] Auto translation only runs when source language differs from the preferred reading language.
- [x] Comments tab loads and comment collapse/expand works.
- [x] Save/unsave story updates the saved filter.
- [x] Summary sheet opens without an API key and shows a useful configuration error.
- [x] Markdown export share sheet opens from story detail.
- [x] Settings opens and displays AI provider, language, cache, and app version sections.
- [x] Settings displays app version `1.1`.

Smoke note: on 2026-06-08, installed and launched the Debug app on iPhone 17 Pro Max Simulator (`CBA84A70-F9C4-4945-87D6-9B8AE5DF0B14`). The first-launch onboarding screen rendered correctly. After presetting `has_completed_onboarding`, the Hacker News feed loaded top stories. Deeper interaction checks remain manual until UI tapping automation is available.

## Known Limits Before Release

- AI summaries require the user to bring a compatible API key.
- Reader parsing depends on each article site's markup and can fall back to web view.
- Manual App Store archive/export validation is not covered by the simulator test run.

## Release Steps

- [x] Complete Smoke QA.
- [ ] Confirm `CHANGELOG.md` is updated.
- [ ] Archive `HNEveryDay` with Release configuration.
- [ ] Validate archive in Xcode Organizer.
- [ ] Upload build `1.1 (2)` to App Store Connect.
- [ ] Add App Store release notes for version `1.1`.
- [ ] Submit the version for App Review.
- [ ] Confirm working tree is clean.
- [ ] Create release tag, for example `v1.1`.
- [ ] Push tag to origin.
