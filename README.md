# Almost?

[![Download on the App Store](https://img.shields.io/badge/App%20Store-Download-blue?logo=apple)](https://apps.apple.com/de/app/keepinon/id6742201361?l=en-GB)
[![Get Beta Access](https://img.shields.io/badge/TestFlight-Beta_Access-007AFF?logo=apple)](https://testflight.apple.com/join/Z8hzF2qr)
[![Firebase](https://img.shields.io/badge/Firebase-console-orange?logo=firebase)](https://console.firebase.google.com/project/dev-leolem-almost/overview)
[![App Store Connect](https://img.shields.io/badge/App%20Store%20Connect-Dashboard-green?logo=apple)](https://appstoreconnect.apple.com/apps/6742201361/distribution)

*A reflective tool to help you learn from your near misses.*  
All new and rebuilt with Firebase under the hood.

## ✨ Features

- Log daily “almosts” — things you meant to do but didn’t  
- Reflect on what happened and how to grow from it  
- Mark favorites for review  
- Tag your mood to uncover emotional patterns  
- Filter insights and explore your journey  
- Remote Config to toggle features dynamically  
- Subtle haptics, smooth animations, and dark mode support


## 🔧 Tech Stack

- **SwiftUI** with modern `@Observable`-based architecture
- **Firebase**:
  - Authentication (anonymous and email/password)
  - Firestore (real-time sync)
  - Analytics
  - Remote Config
- Clean MV-ish architecture:
  - Feature modules and navigation via `@Dependency`
  - Central `SessionState` abstraction
- Launch screen via Storyboard and app icon variants (light, dark, tinted)
- Remote configuration toggles (e.g., favorites, mood tags, analytics opt-in)
- Responsive UI with TipKit, haptics, and custom styling

## 🛠️ Building

You’ll need:

- `GoogleService-Info.plist` for Firebase (place in [resource/firebase](resource/firebase))
- Xcode 15 or newer
- macOS with Swift 6.0+

No additional setup needed — simply open `portfolio.xcodeproj`, choose the `Almost?` scheme, and build.

---

Built by [@Leo‑Lem](https://github.com/leolem) — passionate about clean code, automation, and thoughtful UX.
