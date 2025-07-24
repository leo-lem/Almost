# Almost?

[![Firebase](https://img.shields.io/badge/Firebase-console-orange?logo=firebase)](https://console.firebase.google.com/project/dev-leolem-almost/overview)

*A reflective tool to help you learn from your near misses.*  
Currently being rebuilt as a Firebase-powered portfolio app.

## ✨ Features

- Log daily “almosts” — things you meant to do but didn’t  
- Reflect on what went wrong and how to improve  
- Mark favorites for deeper review  
- Tag your mood to uncover emotional patterns  
- Filter insights and observe your journey over time  
- Remote Config to toggle features dynamically

## 🔧 Tech

- **SwiftUI** with modern `@Observable`-based architecture  
- **Firebase** for:
  - Auth (email, anonymous, etc.)
  - Firestore (real-time sync)
  - Analytics
  - Remote Config  
- Clean MV-like structure with `SessionState`, async streams, and preview/test support  
- Planned: iCloud sync, reflection prompts, public/private sharing, streak logic

## 🚧 Status

The App Store version is a minimal stub.  
A full rewrite is underway with real-time sync, analytics, and feature toggles already in place.

## 🛠️ Building

You’ll need:

- Firebase config (`GoogleService-Info.plist`)
- Xcode 15+

---

Built by [@Leo‑Lem](https://github.com/leolem) — passionate about clean code, automation, and thoughtful UX.
