# Almost?

[![Download on the App Store](https://img.shields.io/badge/App%20Store-Download-blue?logo=apple)](https://apps.apple.com/de/app/keepinon/id6742201361?l=en-GB)
[![Get Beta Access](https://img.shields.io/badge/TestFlight-Beta_Access-007AFF?logo=apple)](https://testflight.apple.com/join/Z8hzF2qr)
[![Firebase](https://img.shields.io/badge/Firebase-console-orange?logo=firebase)](https://console.firebase.google.com/project/dev-leolem-almost/overview)
[![App Store Connect](https://img.shields.io/badge/App%20Store%20Connect-Dashboard-green?logo=apple)](https://appstoreconnect.apple.com/apps/6742201361/distribution)

Almost? is a small reflective tool for tracking near misses: the things you almost did, almost forgot, or almost got wrong. It helps you spot patterns in those moments and turn them into concrete adjustments.

## What you can do

- Capture almosts quickly
- Tag what contributed to them
- Review recurring patterns
- Turn patterns into adjustments
- Keep adjustments active, stabilize them, or archive them
- Sync through Firebase or use the app locally

## How it works

The app is built around a simple loop:

1. Capture an almost
2. Review recurring patterns
3. Create an adjustment
4. See whether the pattern improves over time

## Tech

- SwiftUI
- Observation with `@Observable`
- Firebase Authentication
- Firestore
- Analytics
- Remote Config
- TipKit

## Build

You’ll need:

- Xcode 15 or newer
- macOS with Swift 6+
- a `GoogleService-Info.plist` if you want to use your own Firebase project

Place the plist in `resource/firebase`, open `portfolio.xcodeproj`, choose the `Almost?` scheme, and build.
