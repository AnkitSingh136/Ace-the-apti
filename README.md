# AceTheApti - Flutter Aptitude Practice App

AceTheApti is a full-featured, production-ready Flutter application designed for aptitude practice. It's a cross-platform app that runs on Android, iOS, and Web. The project includes Firebase integration, Riverpod state management, a gamified coin system, and a premium "Test Series" feature.

## Features

- **Cross-Platform:** Built with Flutter 3.x for a consistent experience on Android, iOS, and Web.
- **Firebase Backend:**
  - **Authentication:** Email/Password and Google Sign-In.
  - **Firestore:** Database for user profiles, questions, and test series data.
  - **Firebase Storage:** For user avatar uploads.
- **State Management:** Uses `hooks_riverpod` for efficient and scalable state management.
- **Gamification:** Earn coins for correct answers and spend them to unlock premium content.
- **Three Practice Categories:** Quantitative, Logical Reasoning, and Analogy.
- **Premium Test Series:** A special locked section with mixed-difficulty questions.
- **User Profiles:** View and edit your name, avatar, and coin balance.
- **Modern UI:** Built with Material 3, light and dark themes, and Google Fonts.
- **Reusable Components:** A clean, organized codebase with reusable widgets.
- **Unit Tested:** Critical business logic for scoring and rewards is unit-tested.

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### 1. Prerequisites

- **Flutter SDK:** Ensure you have Flutter 3.x installed. [Installation Guide](https://flutter.dev/docs/get-started/install)
- **Firebase Account:** You will need a Firebase project. [Create a project](https://firebase.google.com/)
- **Firebase CLI:** Install the Firebase command-line tools. `npm install -g firebase-tools`
- **FlutterFire CLI:** Install the FlutterFire command-line tools. `dart pub global activate flutterfire_cli`

### 2. Firebase Project Setup

1.  **Create a Firebase Project:** Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.

2.  **Enable Firebase Services:**
    - In the project dashboard, go to **Authentication** -> **Sign-in method** and enable **Email/Password** and **Google**.
    - Go to **Firestore Database** and create a new database in **production mode**.
    - Go to **Storage** and set it up.

3.  **Configure for Your App:**
    - In your project's root directory, run the FlutterFire configure command:
      ```sh
      flutterfire configure
      ```
    - This command will prompt you to select your Firebase project and the platforms (Android, iOS, Web) you want to configure.
    - It will automatically generate the `lib/core/firebase/firebase_options.dart` file with your project's specific credentials.

4.  **Set Up Firestore Security Rules:**
    - In the Firebase Console, go to **Firestore Database** -> **Rules**.
    - Copy the content of the `firestore.rules` file from this project and paste it into the rules editor.
    - Click **Publish**.

### 3. Data Seeding (Optional but Recommended)

To populate your Firestore database with sample questions, you can use the provided `seed_data.json` file.

1.  **Install `firestore-import-export`:** This is a helpful tool for importing JSON data into Firestore.
    ```sh
    npm install -g node-firestore-import-export
    ```

2.  **Import the Data:**
    - You will need a Firebase service account key. In the Firebase Console, go to **Project Settings** -> **Service accounts** and generate a new private key. Save the downloaded JSON file (e.g., `serviceAccountKey.json`) in a secure location **outside** of the project directory.
    - Run the following commands to import the `questions` and `testSeries` collections.

    ```sh
    # Import questions
    firestore-import -a /path/to/your/serviceAccountKey.json -b seed_data.json -n questions

    # Import testSeries
    firestore-import -a /path/to/your/serviceAccountKey.json -b seed_data.json -n testSeries
    ```
    *Note: The `-n` flag specifies the top-level node in the JSON to import from.*

### 4. Run the App

1.  **Get Dependencies:**
    ```sh
    flutter pub get
    ```

2.  **Generate Mocks for Tests (Optional):**
    If you want to run the unit tests, you need to generate the mock files:
    ```sh
    dart run build_runner build
    ```

3.  **Run the Application:**
    ```sh
    flutter run
    ```
    You can also choose a specific platform:
    - `flutter run -d chrome` (for Web)
    - `flutter run -d <your_device_id>` (for Android/iOS)

## Folder Structure

The project follows a feature-first folder structure to keep the code organized and scalable.

```
lib/
├── core/               # Core services, theme, router
├── features/           # Feature-based modules
│   ├── auth/           # Authentication
│   ├── home/           # Main screen shell
│   ├── practice/       # Practice feature
│   ├── profile/        # User profile
│   └── test_series/    # Test Series feature
├── widgets/            # Reusable shared widgets
└── main.dart           # App entry point
```

## Next Steps

- **Add More Questions:** Expand the `seed_data.json` file with more questions for all categories and difficulties.
- **Implement More Features:** Consider adding features like leaderboards, performance analytics, or different quiz modes.
- **UI/UX Enhancements:** Further polish the UI with animations and custom transitions.
- **Push Notifications:** Use Firebase Cloud Messaging to send reminders or updates.
