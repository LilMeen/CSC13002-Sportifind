# Sportifind

An Football Matchmaking and Field Booking platform that connects football enthusiasts, enables team formation, and streamlines field reservations.  
Built with **Flutter**, **Firebase**, and **Android SDK**, Sportifind integrates **Google Maps API** to provide intelligent features such as opponent suggestion and location-based search.

---

## 📌 Features

- **Field Booking System** – Book available football fields in real-time.
- **Team Management** – Create, join, and manage football teams.
- **Live Chat** – Communicate with other players or teams within the app.
- **Match Scheduling** – Organize and view upcoming matches.
- **Push Notifications** – Get notified about new matches, booking confirmations, and updates.
- **Location Services** – Find nearby football fields using Google Maps integration.

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend Services**: Firebase Cloud Firestore (NoSQL real-time database)
- **Location Services**: Google Maps API
- **Mobile Development**: Android SDK
- **Authentication**: Firebase Auth
- **Push Notifications**: Firebase Cloud Messaging (FCM)

---

## 🚀 Getting Started

### 1️⃣ Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/) with Flutter extension
- Firebase project with:
  - Firestore Database
  - Firebase Authentication
  - Firebase Cloud Messaging (optional for push notifications)
- Google Maps API key

--- 

### 2️⃣ Installation

Clone the repository:
```bash
git clone https://github.com/LilMeen/CSC13002-Sportifind.git
cd CSC13002-Sportifind
```

Install dependencies:
```bash
git clone https://github.com/LilMeen/CSC13002-Sportifind.git
cd CSC13002-Sportifind
```

Configure Firebase:
```bash
# Place your Firebase configuration files:
# - google-services.json in /android/app/
# - GoogleService-Info.plist in /ios/Runner/
```

Add Google Maps API key:
```bash
// Inside api_key.dart
const String googleMapsApiKey = "YOUR_API_KEY";
```

Run the app:
```bash
flutter run
```