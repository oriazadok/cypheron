
# Cypheron

Cypheron is a secure messaging Flutter application that allows users to create encrypted messages, send them via WhatsApp, or decrypt files received through other apps. Using a custom C++ encryption algorithm integrated with Flutter's FFI, Cypheron provides secure communication channels with a focus on user privacy and ease of use.

## Features

- **User Authentication**: Cypheron supports user sign-up and sign-in functionality.
- **Contact Management**: Users can manually add contacts or access their phone contacts, storing them in the app for messaging.
- **Message Encryption and Decryption**: Messages can be encrypted using a user-defined key and sent to contacts, or decrypted upon reception.
- **File Sharing Support**: Cypheron can be opened from other apps using the 'Open with' option for files with `.zk` extension.
- **Hive Database**: For efficient local storage of user data and messages.
- **Flutter FFI Integration**: Cypheron’s encryption mechanism is powered by a C++ library connected through Dart FFI for seamless encryption and decryption.

## Project Structure

- **lib**: Contains the main application logic, UI screens, FFI integration, and widgets.
  - **auth**: Screens and logic for authentication (SignUp and SignIn).
  - **models**: Models like `UserModel` and `ContactModel` to manage user and contact data.
  - **services**: Contains `HiveService` for data storage and `ffi_service` for encryption/decryption functions.
  - **widgets**: Components like `ContactList` and buttons for user interaction.
- **android**: Android-specific configurations, including FFI setup and file handling for Android intents.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android SDK (for Android builds)
- C++ compiler (for building the native library)

### Installation

1. Clone the repository and navigate to the project root.
2. Run `flutter pub get` to install dependencies.
3. Set up an emulator or connect a physical device.
4. For debug build: `flutter run`.
5. For a release build, use `flutter build apk --release`.

### Configuring the Android App Icon

1. Place the app icon in `assets/icon.png`.
2. Update `flutter_launcher_icons.yaml` with the icon path.
3. Run `flutter pub run flutter_launcher_icons:main`.

## Building the APK

Use the following command to create a release APK:

```bash
flutter build apk --release
```

The APK will be located in the `build/app/outputs/flutter-apk` folder.

## Running the App

To test the app on a connected device in release mode:

```bash
flutter install --release
```

## License

This project is licensed under the MIT License.
