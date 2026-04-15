<<<<<<< HEAD
# spendwise

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
SpendWise is a modern expense tracking mobile application that helps users monitor, manage, and analyze their daily spending. The app is built using Flutter with a scalable architecture and integrates Firebase for authentication and real-time database operations.
Features
🔐 User Authentication (Login & Signup)
💸 Add, Edit, Delete Expenses (CRUD)
📊 Real-time Expense Tracking
📅 Category-wise Expense Management
📈 Dashboard with Spending Insights
🔄 Instant UI Updates using BLoC
🧾 Form Validation & Error Handling
🎨 Clean and Responsive UI
The project follows Clean Architecture principles:

Presentation Layer: UI + BLoC (State Management)
Domain Layer: Business logic and use cases
Data Layer: Repository, models, and Firebase integration

This ensures scalability, maintainability, and separation of concerns.
Tech Stack
Frontend: Flutter
State Management: BLoC
Navigation: GoRouter
Backend Services: Firebase
Database: Cloud Firestore
Data Flow

User actions trigger BLoC events, which call domain use cases. These use cases interact with repositories that communicate with Firebase services. The UI updates dynamically based on state changes.
Security
Secure authentication using Firebase Auth
User-specific data isolation
Input validation to prevent invalid data
Screens
Login / Signup
Dashboard
Add Expense
Expense List
Edit/Delete Expense
>>>>>>> c1ace47d97f25072af29ad507034a9bfb719f9c4
