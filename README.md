# 🏙️ Blockup — Community Issue Reporting App

**Blockup** is a modern, community-driven mobile application built with **Flutter** that allows citizens to capture, analyze, and report local infrastructure issues—such as potholes, streetlighting failures, and uncollected waste. 

By integrating **Gemini AI / Computer Vision** for instant issue detection and **Firebase Firestore** for real-time synchronization, Blockup provides a seamless, TikTok-style vertical feed experience where neighbors can view, upvote, comment on, and track local civic reports in real-time.

---

## ✨ Features

- 📸 **Visual Issue Reporting**: Take a picture or pick from your device library to start a report.
- 🤖 **AI-Powered Issue Detection**: Automatic categorization (Roads, Lighting, Waste) powered by Gemini AI / YOLO Vision.
- 📲 **Real-Time Vertical Feed**: TikTok-style smooth vertical scrolling `PageView` showing community reports instantly upon submission.
- 📍 **Location Context**: Displays neighborhood and address information for each report.
- ☁️ **Cloudinary Media Storage**: High-speed cloud upload and hosting for images.
- 🤝 **Community Upvoting & Engagement**: Dynamic upvoting ("Support"), live comment sheets, and sharing functionality.

---

## 🛠️ Tech Stack & Dependencies

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Backend / Real-time DB:** [Firebase Firestore](https://firebase.google.com/docs/firestore)
- **Media Storage:** [Cloudinary](https://cloudinary.com/)
- **AI / Issue Detection:** Gemini API / YOLO Custom Service
- **Key Flutter Packages:**
  - `cloud_firestore`
  - `image_picker`
  - `http`

---

## 📋 Prerequisites

Before running this project, ensure you have the following installed and configured on your machine:

1. **Flutter SDK** (`>=3.0.0`): [Install Flutter](https://docs.flutter.dev/get-started/install)
2. **Dart SDK**: Included with Flutter.
3. **Android Studio** or **VS Code** with Flutter extensions installed.
4. **Android Emulator** or **iOS Simulator** (or a physical mobile device enabled for USB debugging).
5. **Firebase Account**: Set up a Firebase Project with Cloud Firestore enabled.
6. **Cloudinary Account**: For cloud image storage.

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/blockup.git
cd blockup
```

### 2. Install Dependencies

Fetch all necessary Flutter packages:

```bash
flutter pub get
```

### 3. Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
2. Add Android/iOS apps in your Firebase console settings.
3. Place `google-services.json` (for Android) inside `android/app/`.
4. Place `GoogleService-Info.plist` (for iOS) inside `ios/Runner/`.
5. Enable **Firestore Database** in test mode or with appropriate security rules.

#### Firestore Collection Schema: `reports`

| Field Name | Type | Description |
| :--- | :--- | :--- |
| `title` | `String` | Brief title or description of the issue |
| `category` | `String` | Issue category (`Roads`, `Lighting`, `Waste`) |
| `imageUrl` | `String` | Direct Cloudinary image URL |
| `location` | `String` | Street name / intersection |
| `subLocation`| `String` | Neighborhood detail |
| `status` | `String` | Status flag (e.g., `Reported`) |
| `upvotes` | `Number` | Initial upvote count |
| `createdAt` | `Timestamp` | Server timestamp for ordering in the live feed |

---

### 4. Configure Services

Ensure your services (`cloudinary_service.dart` and `gemini_service.dart` / `yolo_service.dart`) are populated with your credentials:

- **Cloudinary:** Add your `cloud_name` and `upload_preset`.
- **Gemini / AI:** Add your API key and endpoint configuration.

---

### 5. Run the Application

Run the app on your connected device or emulator:

```bash
flutter run
```

---

## 📱 Project Architecture

```text
lib/
├── main.dart                      # App Entry Point
├── feed_and_events_screen.dart    # Real-time vertical TikTok-style Feed & Events tab
├── capture_report_sheet.dart      # Issue submission sheet with AI analysis & picker
├── cloudinary_service.dart        # Cloudinary REST API integration for image uploads
└── gemini_service.dart            # AI issue detection engine
```

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).