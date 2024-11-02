[![volunteerexpress-testing](https://github.com/anthonycasarta/volunteerexpress/actions/workflows/ci.yaml/badge.svg)](https://github.com/anthonycasarta/volunteerexpress/actions/workflows/ci.yaml)

# VolunteerExpress

Welcome to **VolunteerExpress**! This application is built using Flutter and Firebase, providing a platform for both organizers and volunteers to interact. Below are the steps to set up and run the application on your local machine.

## Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) SDK installed
- [VS Code](https://code.visualstudio.com/) preferably, or another code editor of your choice
- iOS or Android emulator installed (no web support currently)

## Setup Instructions

### 1. Clone the Repository

First, clone this repository to your local machine:

```bash
git clone https://github.com/username/volunteerexpress.git
cd volunteerexpress
```

### 2. Install Dependencies
After cloning, install the required packages by running the following command in the root directory:

```bash
flutter pub get
```
This will fetch all the dependencies listed in pubspec.yaml.

### 3. Run the Application
Open **one** of any iOS or Android emulator.
Use the following command to launch the app:
```bash
flutter run
```
Alternatively, you can use VS Code by pressing F5 or selecting Run > Start Debugging.

### 4. Once the Application is Running
Once you the application opens in your desired emulator, the Login page should be displayed. 
**For first time users**, click on 'Already have an account? Log in here.', register with any email address (real or fake as of now) and password. **NOTE:** you have the choice of choosing either Admin or Volunteer account types. Once you hit 'Register', you should be re-directed to the Login page where you are prompted to login with your newly registerd account.
Once you have logged in, you will be redirected to the home page which demonstrates your account type (admin or volunteer) at the top, as well as a list of buttons that take you to the various menus the application offers.
To log out, simply hit the three-dotted button at the top right of the screen at any time you desire.

### Testing
To run unit tests and check code coverage:

```bash
flutter test --coverage
```

### Troubleshooting

Dependency Issues: If you encounter any dependency-related issues, try running:
```bash
flutter clean
flutter pub get
```

**Emulator Issues:** Ensure that your emulator is running in a compatible version. Ensure that only one emulator (iOS or Android) is running to avoid any connection issues. Restart the emulator or use a different device if issues persist.

**Plugin Version Conflicts:** If you run into plugin version conflicts, ensure all dependencies in pubspec.yaml are compatible with your Flutter SDK version, or use **flutter pub upgrade** to resolve any version mismatches.
