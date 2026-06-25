<p align="center">
  <img src="https://github.com/RevOnCodeX/WidgetNote/assets/WidgetNoteIconPlaceholder" width="128" alt="WidgetNote Icon" />
</p>

<h1 align="center">WidgetNote</h1>

<p align="center">
  <b>A hyper-lightweight, 100% native macOS desktop widget platform for tasks and quick notes.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-14.0%2B-black?style=for-the-badge&logo=apple" alt="macOS 14.0+">
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift" alt="Swift 5.9">
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="MIT License">
  <img src="https://img.shields.io/badge/Size-<1MB-brightgreen?style=for-the-badge" alt="Size <1MB">
</p>

---

## ✨ Overview

**WidgetNote** is an elegant, zero-friction desktop application built specifically for macOS. Instead of opening a heavy window or keeping a dock icon active, WidgetNote renders beautiful, interactive widgets directly onto your desktop wallpaper. 

It feels exactly like a native macOS feature.

### Why WidgetNote?
Most modern task apps are bundled inside massive Electron wrappers that consume hundreds of megabytes of RAM and drain your battery. **WidgetNote is different.** 
- Built in pure **SwiftUI** and **AppKit**.
- Runs as an invisible background accessory (`LSUIElement`).
- The entire installer is **under 700 KB**.
- **0.0% CPU overhead** while idle.

---

## 🚀 Features

* 🪟 **Desktop Integration**: Widgets sit behind your other windows, feeling like part of the wallpaper.
* 🎨 **Native Aesthetics**: Beautiful frosted glass (`NSVisualEffectView`), rounded squircle corners, and buttery-smooth spring animations.
* 🔋 **Ultra-Battery Efficient**: Smart disk-write debouncing and native App Nap support means it consumes virtually zero energy.
* ⌨️ **Global Shortcut**: Press `Option + Space` (customizable) to instantly bring your notes to the front and start typing.
* ⚙️ **Premium Settings**: A stunning, native settings panel to configure custom accent colors, startup behavior, and widget opacity.
* 💾 **Auto-Saving**: Never lose a thought. Everything saves silently in the background.

---

## 📦 Installation (End Users)

1. Navigate to the **[Releases](#)** tab.
2. Download the latest `WidgetNote.dmg` file.
3. Double-click the `.dmg` and drag **WidgetNote** into your `Applications` folder.
4. Launch the app! It will quietly appear on your desktop.

---

## 🛠 Building from Source

WidgetNote uses the modern **Swift Package Manager (SPM)**. No `.xcodeproj` or `.xcworkspace` required.

### Prerequisites
- macOS 14.0 (Sonoma) or newer.
- Swift 5.9 toolchain.

### Build Instructions
Open your terminal and run:

```bash
git clone https://github.com/RevOnCodeX/WidgetNote.git
cd WidgetNote
swift build -c release
```

This will produce an optimized binary in the `.build/release/` directory.

---

## 🏗 Architecture

WidgetNote is built on a hybrid SwiftUI + AppKit foundation to achieve the ultimate native experience:
- **`WidgetContainer`**: Applies AppKit materials (blurs and shadows) behind SwiftUI views.
- **`DesktopWindowController`**: Manages the underlying `NSWindow`, ensuring it stays on the `kCGDesktopWindowLevel` without becoming a distraction.
- **`SettingsManager`**: An `@Observable` source of truth tied directly to macOS `UserDefaults` and `SMAppService` for login-item management.
- **`DataStore`**: An energy-optimized JSON persistence layer utilizing GCD for write-debouncing.

---

## 🤝 Contributing

Contributions are always welcome! Whether it's adding new widget types, refining the UI, or optimizing performance, feel free to open a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

<p align="center">
  <i>Designed for the modern Mac.</i>
</p>
