# 📝 Notes App (Flutter + Firebase)

This is a 3-screen note-taking app built with Flutter and Firebase as part of **Individual Assignment 2** for the Mobile Development course.

It allows users to sign up and log in with email/password, then create, read, update, and delete notes in Firestore. State management is handled using the Provider package, and the app follows a clean architecture (presentation, provider, domain, data layers).

---

## 🚀 Features

- 🔐 **Firebase Authentication**
  - Email/password sign-up and login
  - Error handling with SnackBars
- 📄 **Note Management (CRUD)**
  - Create, edit, and delete notes stored per-user in Firestore
  - Shows empty hint if no notes exist
- 🧠 **State Management**
  - Provider for app-wide reactive state
- ✅ **Clean Architecture**
  - Separation between UI, business logic, and data layer
- 🎯 **UI/UX**
  - Floating action button for new notes
  - Loading indicator during fetch
  - SnackBars for success/error
  - AlertDialog for delete confirmation
- 📱 Works on both emulator and physical device

---

## 📂 Folder Structure

```

lib/
├── data/               # Firebase interaction (NoteRepository)
├── domain/             # Note model
├── presentation/       # UI screens & widgets
│   ├── notes/          # Notes screen
│   └── widgets/        # NoteCard widget
├── provider/           # AuthProvider and NoteProvider
main.dart

````

---

## 🛠 Setup Instructions

### 1. Clone this repo:
```bash
git clone https://github.com/yourusername/notes_app.git
cd notes_app
````

### 2. Add Firebase files

* Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the correct folders:

  * `android/app/`
  * `ios/Runner/`

### 3. Enable Firebase services

* Enable **Authentication > Email/Password**
* Create Firestore with structure:

  ```
  users → {uid} → notes → {noteId}
  ```

### 4. Install dependencies

```bash
flutter pub get
```

### 5. Run the app

```bash
flutter run
```

---

## 🔍 Dart Analyzer Report

> ✅ All warnings and issues fixed (see screenshot in submitted PDF)
> 
<img width="1470" alt="Screenshot 2025-07-06 at 9 17 01 PM" src="https://github.com/user-attachments/assets/f650d66e-2a07-4bdf-8531-883036e10f56" />

---

## 📹 Demo Video

Watch the 5–10 minute walkthrough demo here:
**[👉 Demo Video Link](https://drive.google.com/your-video-link)**

---

## 💻 GitHub Repository

This is the repo submitted for grading:
**[📎 GitHub Repo Link](https://github.com/yourusername/notes_app)**

---

## 📧 Author

**Muhirwa Jean De Dieu**
Mobile Development Student
Individual Assignment 2


---
