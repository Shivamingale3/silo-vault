<p align="center">
  <img src="assets/app_logo.png" width="120" alt="Silo Vault Logo"/>
</p>

<h1 align="center">Silo Vault</h1>

<p align="center">
  <strong>Your secrets, encrypted. Your data, yours.</strong>
</p>

<p align="center">
  A military-grade encrypted vault for your passwords and private notes — with zero-knowledge cloud sync.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android%20|%20iOS-blue?style=flat-square" alt="Platform"/>
  <img src="https://img.shields.io/badge/Encryption-AES--256-green?style=flat-square" alt="Encryption"/>
  <img src="https://img.shields.io/badge/Sync-E2E%20Encrypted-purple?style=flat-square" alt="Sync"/>
  <img src="https://img.shields.io/badge/License-MIT-orange?style=flat-square" alt="License"/>
</p>

---

## Why Silo Vault?

Most password managers ask you to trust their servers. **Silo Vault doesn't.** Everything is encrypted on your device with AES-256 before it ever touches the cloud. Even if someone breaches Firestore, they get nothing but ciphertext.

- 🔐 **Zero-knowledge architecture** — your data is encrypted/decrypted locally, never on a server
- 🛡️ **No master password sent anywhere** — keys are derived on-device using PBKDF2
- ☁️ **Optional cloud sync** — works fully offline, sync only when you choose to
- 🧬 **Biometric unlock** — fingerprint or face ID, your choice

---

## Features

### 🔑 Password Manager

- Store unlimited passwords with usernames, URLs, and notes
- Password strength indicator (Weak → Very Strong)
- One-tap copy to clipboard
- Show/hide password toggle with auto-clear

### 📝 Secure Notes

- Rich text notes encrypted at rest
- Categorize with tags and categories
- Search across all your notes instantly

### 🎲 Password Generator

- Generate strong, random passwords
- Customize length, symbols, numbers, and case
- One-tap generate and save

### 🔒 App Security

- **PIN lock** — 4-digit PIN with brute-force lockout (escalating timeouts)
- **Biometric authentication** — fingerprint/face unlock
- **Auto-lock** — configurable auto-lock timer (immediate to 10 minutes)
- **Secure splash** — no content flash before lock screen

### ☁️ Cloud Sync (End-to-End Encrypted)

- **Google Sign-In** — authenticate to enable sync
- **Sync Password** — separate password that wraps your encryption key
- **Cross-device sync** — set up on a new device with just your sync password
- **Manual sync control** — sync only when you tap "Sync Now"
- **Conflict resolution** — last-write-wins with timestamp-based merging
- **Offline-first** — works completely offline, syncs when connected

### 🎨 User Experience

- **Dark & Light themes** — automatic or manual toggle
- **Pull-to-refresh** — swipe down to reload your vault
- **Categories** — Personal, Work, Finance, Social, Development, Entertainment, Travel, Health
- **Tags & Favorites** — organize and quick-access your most-used items
- **Trash & Restore** — deleted items go to trash first, permanent delete when ready
- **Dashboard** — quick stats, recent activity, and favorite items at a glance

---

## Security Architecture

```
┌─────────────────────────────────────────────────────┐
│                    Your Device                       │
│                                                     │
│  ┌──────────┐    ┌──────────────┐    ┌───────────┐ │
│  │ Raw Data │───▶│ AES-256-CBC  │───▶│ Isar DB   │ │
│  │          │    │ Encryption   │    │ (Local)   │ │
│  └──────────┘    └──────────────┘    └─────┬─────┘ │
│                                            │       │
│                        ┌───────────────────┘       │
│                        ▼                           │
│              ┌──────────────────┐                  │
│              │  Already-Encrypted│                  │
│              │  Ciphertext       │                  │
│              └────────┬─────────┘                  │
└───────────────────────┼─────────────────────────────┘
                        │ (Only ciphertext leaves device)
                        ▼
              ┌──────────────────┐
              │   Firebase /     │
              │   Firestore      │
              │   (Encrypted)    │
              └──────────────────┘
```

| Layer               | Mechanism                                                   |
| ------------------- | ----------------------------------------------------------- |
| **Data Encryption** | AES-256-CBC with random IV per field                        |
| **Key Storage**     | Device Keystore via `flutter_secure_storage`                |
| **Key Sync**        | PBKDF2-derived key wraps device key for cross-device access |
| **Auth**            | Firebase Auth (Google Sign-In)                              |
| **PIN Hashing**     | bcrypt with salt                                            |
| **Transport**       | TLS 1.3 (Firebase default)                                  |

> **Zero-knowledge guarantee**: Firestore stores only ciphertext. There is no server-side key, no admin backdoor, and no way to decrypt without your device key or sync password.

---

## Getting Started

### Download

> Coming soon to Google Play Store and TestFlight.

### Build from Source

```bash
# Clone the repository
git clone https://github.com/Shivamingale3/silo-vault.git
cd silo-vault

# Install dependencies
flutter pub get

# Generate Isar schemas
dart run build_runner build

# Run on your device
flutter run
```

> See [CONTRIBUTING.md](CONTRIBUTING.md) for full development setup, architecture guide, and contribution guidelines.

---

## Permissions

| Permission | Why                     |
| ---------- | ----------------------- |
| Internet   | Cloud sync (optional)   |
| Biometric  | Fingerprint/face unlock |
| Clipboard  | Copy passwords          |

No contacts, no camera, no location, no tracking. **Ever.**

---

## Roadmap

- [ ] Export/import vault (encrypted backup file)
- [ ] Auto-fill service (Android Autofill Framework)
- [ ] Password breach detection (Have I Been Pwned API)
- [ ] Shared vaults for teams/families
- [ ] Browser extension
- [ ] Desktop app (Windows, macOS, Linux)

---

## Privacy Policy

Silo Vault collects **zero** personal data. Your vault data is encrypted on-device and never readable by anyone — not even us. Cloud sync is optional and end-to-end encrypted. We have no analytics, no tracking, no telemetry.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <strong>Built with 🛡️ by <a href="https://github.com/Shivamingale3">Shivam Ingale</a></strong>
</p>
