# Almost?

[![Firebase](https://img.shields.io/badge/Firebase-console-orange?logo=firebase)](https://console.firebase.google.com/project/dev-leolem-almost/overview)

*A reflective tool to help you learn from your near misses.*  
Now rebuilt as a Firebase-powered portfolio app.

## ✨ Features

- Log daily “almosts” — things you meant to do but didn’t  
- Reflect on what happened and how to grow from it  
- Mark favorites for review  
- Tag your mood to uncover emotional patterns  
- Filter insights and explore your journey  
- Remote Config to toggle features dynamically  
- Subtle haptics, smooth animations, and dark mode support


## 🔧 Tech Stack

- **SwiftUI** with modern `@Observable` architecture  
- **Firebase**:
  - Auth (anonymous & email)
  - Firestore (real-time sync)
  - Analytics
  - Remote Config  
- Clean MV-ish structure using `SessionState`, dependency injection, and `AsyncStream`  
- Preview/test support, launch screen, and app icon variants (light, dark, tinted)

Planned:
- Reflection prompts  
- Public/private insight sharing  
- Streaks and reminders

## 🚧 Status

The App Store version is a placeholder.  
A full rewrite is in progress with sync, analytics, and feature flags already integrated, as well as polished UI and onboarding.  
Next up: marketing.

---

## 🛠️ Building

You’ll need:

- `GoogleService-Info.plist` (Firebase config)
- Xcode 15+

---

Built by [@Leo‑Lem](https://github.com/leolem) — passionate about clean code, automation, and thoughtful UX.
