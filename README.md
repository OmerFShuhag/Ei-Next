# Ei Next! 🎓

**Streamline your Viva sessions.**

Ei Next! is a Flutter application designed to efficiently manage viva sessions in academic settings. It allows teachers to create viva rooms, manage student queues, and track session progress in real-time. Students can join rooms, see their position in the queue, and receive notifications about their turn.

## ✨ Features

### 👨‍🏫 For Teachers
- **Create Rooms**: Set up a viva session with a custom Start ID, Batch Size, and Time per Student.
- **Micro-Batch Management**: Automatically groups students into manageable batches.
- **Real-time Queue**: View the current queue and active student status.
- **Progress Tracking**: Monitor session progress and estimated completion time.

### 👨‍🎓 For Students
- **Easy Join**: Join a session using a Room Code and Student ID.
- **Live Queue Position**: See exactly where you are in the queue.
- **Status Updates**: Get real-time updates on your wait time and session status.
- **Notifications**: Know when it's your turn.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Backend / Database**: [Firebase Firestore](https://firebase.google.com/products/firestore)
- **Architecture**: Clean Architecture (Presentation, Domain, Data layers)
- **Design System**: Custom design with Google Fonts (Outfit) and Material 3.

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- [Firebase CLI](https://firebase.google.com/docs/cli) installed and logged in.
- Identify your Android/iOS device or emulator.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/next.git
    cd next
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Firebase Setup:**
    - Create a project in the [Firebase Console](https://console.firebase.google.com/).
    - Add an Android app with package name `com.example.next`.
    - Download `google-services.json` and place it in `android/app/`.
    - **Important**: Create a Cloud Firestore database in the Firebase Console (Start in Test Mode for development).

4.  **Run the App:**
    ```bash
    flutter run
    ```

## 📱 Configuration

### Android Permissions
This app requires internet permission to connect to Firestore. This is already configured in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---
Built with ❤️ using Flutter.
