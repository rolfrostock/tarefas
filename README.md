<<<<<<< HEAD
# Tasks App Documentation

This document provides an overview of the Tasks App, a task management application developed with Flutter. The app allows users to create, edit, and delete tasks, as well as manage users and their permissions.

## Features

- **User Authentication:** User login and logout.
- **Task Management:** Users can add, edit, and delete tasks. Each task includes a name, a photo, a difficulty level, start and end dates, and an assigned user.
- **User Management:** Administrators can add, edit, and delete users. Each user has a name, email, password, and role, which can be 'administrator' or 'collaborator'.
- **Task Viewing:** Displays all tasks in a grid, with detailed information and options to edit or delete.
- **Task Selection:** Users can select one or more tasks for bulk deletion.

## App Screens

### Login Screen
Allows the user to log into the app.

### Home Screen
After logging in, the user is directed to the home screen, where they can view all tasks assigned to them.

### User Registration Screen
Allows administrators to create new users.

### User Editing Screen
Allows administrators to edit existing user information.

### Task Registration Screen
Allows users to create new tasks.

### Task Editing Screen
Allows users to edit existing tasks.

## Project Structure

The project is divided into several main folders and files:

- **lib/**
    - **components/:** Contains reusable widgets, such as the task difficulty widget.
    - **data/:** Contains data access logic, including DAOs and database configuration.
    - **models/:** Defines the data models for the app, such as `UserModel` and `TaskModel`.
    - **screens/:** Contains all the app screens.
    - **main.dart:** Entry point of the Flutter application. Defines the theme, routes, and initial screen.

## Database Configuration

The app uses SQLite to store data locally. The `users` and `tasks` tables are created to store user and task information, respectively.

## Dependencies

- **flutter:** Flutter SDK.
- **sqflite:** Plugin for accessing SQLite in Flutter.
- **path:** Used to locate the database on the device.
- **shared_preferences:** Used for storing simple preference data.
- **intl:** Provides support for date formatting.
- **uuid:** Generates unique IDs for users and tasks.
- **crypto:** Used to encrypt user passwords.

## How to Run

To run the app, Flutter must be installed in your development environment. After cloning the repository, execute the following commands in the terminal:

```sh
flutter pub get
flutter run

>>>>>>> 8a901cf56762b97eb1e85c761be6644e366d243d
