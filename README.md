# NeuroRite - Advanced Note Taking Application

A feature-rich note taking application built with Flutter, designed for seamless note management and organization.

## 🚀 Features

- 📝 Create and manage notes with rich text formatting
- 🔐 Secure user authentication with Firebase
- ☁️ Cloud synchronization using Firestore
- 🎨 Clean and intuitive user interface
- 📱 Responsive design for mobile and tablet
- 🔍 Search functionality for quick note retrieval
- 📂 Organize notes with categories and tags

## 🛠️ Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: GetX
- **Backend**: Firebase (Authentication, Firestore)
- **Local Storage**: Shared Preferences
- **UI Components**: Custom design with Material 3
- **Markdown Support**: Flutter Markdown

## 📋 Prerequisites

- Flutter SDK (>=3.4.4)
- Dart SDK (>=3.0.0)
- Firebase project setup (for authentication and database)
- Android Studio / VS Code with Flutter extensions

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/neurorite.git
   cd neurorite
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Firebase**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android/iOS app to your Firebase project
   - Download the configuration files and place them in the appropriate directories
   - Enable Email/Password authentication in Firebase Console

4. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
- `get`: ^4.6.6 - State management and dependency injection
- `firebase_core`: ^3.5.0 - Firebase core functionality
- `firebase_auth`: ^5.3.0 - User authentication
- `cloud_firestore`: ^5.4.2 - Cloud database
- `shared_preferences`: ^2.0.15 - Local storage
- `flutter_markdown`: ^0.7.4 - Markdown support

### Dev Dependencies
- `flutter_test`: SDK test package
- `flutter_launcher_icons`: ^0.13.1 - App icon generation
- `flutter_lints`: ^3.0.0 - Linting rules

## 🏗️ Project Structure

```
lib/
├── main.dart          # App entry point
├── app/              # App configuration and initialization
├── core/             # Core functionality and utilities
├── data/             # Data layer (repositories, models)
├── modules/          # Feature modules
│   ├── auth/         # Authentication
│   ├── notes/        # Notes feature
│   └── settings/     # App settings
└── shared/           # Shared widgets and utilities
```

## 🧪 Testing

Run tests using:
```bash
flutter test
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📬 Contact

For any queries, please open an issue in the repository.
