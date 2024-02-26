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

![Login](https://digital.curitiba.br/wp-content/uploads/2024/02/WhatsApp-Image-2024-02-26-at-14.53.00.jpeg)

### Home Screen
After logging in, the user is directed to the home screen, where they can view all tasks assigned to them.

![Home](https://digital.curitiba.br/wp-content/uploads/2024/02/WhatsApp-Image-2024-02-26-at-14.40.16.jpeg)

### User Registration Screen
Allows administrators to create new users.

![New User](https://digital.curitiba.br/wp-content/uploads/2024/02/WhatsApp-Image-2024-02-26-at-14.34.26-3.jpeg)

### User Editing Screen
Allows administrators to edit existing user information.

![Edit User](https://digital.curitiba.br/wp-content/uploads/2024/02/WhatsApp-Image-2024-02-26-at-14.34.26.jpeg)

### Task Registration Screen
Allows users to create new tasks.

![New Task](https://digital.curitiba.br/wp-content/uploads/2024/02/WhatsApp-Image-2024-02-26-at-14.34.26-4.jpeg)

### Task Editing Screen
Allows users to edit existing tasks.

![Edit Task](https://digital.curitiba.br/wp-content/uploads/2024/02/WhatsApp-Image-2024-02-26-at-14.34.26-1.jpeg)

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

@[Gestão de tarefas](https://www.youtube.com/watch?v=5XD16i72A5A)




## First Login

When accessing the app for the first time, please use the following default credentials:

- **Email:** admin@example.com
- **Password:** password

We strongly recommend changing the default password immediately after your first login to ensure the security of your account. To change the password, navigate to the profile settings within the app.

Please note that initial access is set up with administrator permissions, allowing you to explore all functionalities of the app, including managing users and tasks.

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
