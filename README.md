# Fitness App

A cross-platform Flutter application to track workouts, manage goals, and maintain your fitness streak. Integrates with Firebase for authentication and data storage, with dark-mode support, customizable workouts, and a clean, modern UI.

---

## Table of Contents

1. [Features](#-features)  
2. [Demo](#-demo)  
3. [Getting Started](#-getting-started)  
4. [Architecture & Tech](#-architecture--tech)  
5. [Screenshots](#-screenshots)  
6. [Usage](#-usage)  
7. [Configuration](#-configuration)  
8. [Contributing](#-contributing)  
9. [License](#-license)  

---

## Features

- **User Authentication** (sign up, log in, password reset) via Firebase Auth  
- **Profile Management**: capture weight, goals, gender, disabilities  
- **Workout Tracking**: select pre-built workouts or create custom entries  
- **Workout Log**: view history of custom workouts in Firestore  
- **Calendar View**: see your scheduled and completed workouts  
- **Theming**: light/dark mode toggle  
- **Settings**: update display name, toggle dark mode  

---

## Getting Started

 Prerequisites:

- Flutter SDK (>=3.x)  
- Dart (>=2.18)  
- Firebase project with Auth & Firestore enabled  

 Installation:

    1.**Clone the repo**  
        ```bash
        git clone https://github.com/yourusername/fitness-app.git
        cd fitness-app
    2.flutter pub get
    3.Configure Firebase
        Place your google-services.json (Android) and GoogleService-Info.plist (iOS) in the appropriate folders

        Ensure your firebase_options.dart is generated (or manually configure Firebase.initializeApp())
    4.flutter run

---

### Architecture & Tech

- Flutter for UI

- Provider for state management (theme, auth state)

- Firebase Auth for user authentication

- Cloud Firestore for persisting profile & workout data

- SharedPreferences for local flags (e.g. profileComplete, isLoggedIn)

---

#### Screenshots

- [Upload here]

---

##### Usage

1.Sign up with name, age, weight

2.Complete your profile (weight goal, gender, etc.)

3.Tap “Workout” on the Home screen to start a preset workout

4.Or select “Custom Workout” to log your own exercises

5.Check your workout log in the Profile or Calendar views

---

##### Configuration

Key Description
assets/images/ Local images (register in pubspec.yaml)
Firebase options lib/firebase_options.dart (auto-generated)
Theme colors Defined in theme_provider.dart

---

###### Contributing

1.Fork the repo

2.Create a feature branch (git checkout -b feature/X)

3.Commit your changes (git commit -m "Add X")

4.Push (git push origin feature/X)

5.Open a Pull Request

Please follow the existing code style and write descriptive commit changes.

---

###### License
