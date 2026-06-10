# App Store Submission Guide

## Version

- App version: `1.1`
- Build: `2`
- Bundle ID: `cn.corlin.hneveryday.HNEveryDay`
- Scheme: `HNEveryDay`

## Before Archive

- Confirm App Store Connect has version `1.1` created for this app.
- Confirm signing uses team `5M726V7N7X`.
- Confirm `APP_STORE_RELEASE_NOTES.md` has the final release notes.
- Confirm manual smoke QA in `RELEASE_CHECKLIST.md` is complete.

## Archive With Xcode

1. Open `HNEveryDay.xcodeproj`.
2. Select scheme `HNEveryDay`.
3. Select destination `Any iOS Device (arm64)`.
4. Choose `Product > Archive`.
5. In Organizer, confirm the archive shows version `1.1` and build `2`.
6. Click `Validate App`.
7. Click `Distribute App > App Store Connect > Upload`.
8. After processing completes in App Store Connect, attach the build to version `1.1`.
9. Paste release notes from `APP_STORE_RELEASE_NOTES.md`.
10. Complete export compliance, privacy, and review metadata, then submit for review.

## Optional CLI Archive

```bash
xcodebuild archive \
  -project HNEveryDay.xcodeproj \
  -scheme HNEveryDay \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath build/HNEveryDay-1.1.xcarchive
```

Use Xcode Organizer for validation/upload unless command-line signing and App Store Connect credentials are already configured locally.
