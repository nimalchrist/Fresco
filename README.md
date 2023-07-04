# Fresco Documentation

Welcome to the documentation for Fresco, the first iteration of an educational social media platform developed using Flutter for the front end, Node.js for the back end, and MySQL for the database. Fresco aims to connect learners and educators in a collaborative environment.

## Team member:
Mary Fency J - flutter pages developing and api binding

## Installation and Setup

Before running Fresco, you need to set up Flutter, Node.js, and MySQL on your machine.

### Flutter

To install Flutter:

1. Visit the [Flutter website](https://flutter.dev/) and download the Flutter SDK for your operating system.

2. Extract the downloaded SDK archive to a location of your choice.

3. Add the Flutter `bin` directory to your system's `PATH` variable.

   Example (for macOS/Linux):
   ```
   export PATH="$PATH:/path/to/flutter/bin"
   ```

4. Run `flutter doctor` in your terminal to verify the installation and check for any additional dependencies.

### Node.js

To install Node.js:

1. Visit the [Node.js website](https://nodejs.org/) and download the LTS (Long Term Support) version for your operating system.

2. Run the installer and follow the instructions.

3. After installation, run `node -v` and `npm -v` in your terminal to verify the installation.

### MySQL

To install MySQL:

1. Visit the [MySQL website](https://www.mysql.com/) and download the appropriate version for your operating system.

2. Run the installer and follow the instructions.

3. Set up a MySQL user and password for your development environment.

## Project Structure

The Fresco repository consists of two main folders:

1. `freso/` - Contains the Flutter project for the front end of the application.
2. `fresco-rest-api/` - Contains the Node.js application for the back end of the application.

The structure of each folder is as follows:

### Frontend (Flutter)

- `lib/` - Contains the main Dart code for the Flutter app.
- `assets/` - Holds static assets such as images, fonts, and configuration files.

### Backend (Node.js)

- `src/` - Contains the main Node.js code for the back end.

## Database Table Design

Fresco utilizes a MySQL database with the following table design:

1. `users` - Stores user details, including username, email, and other relevant information.
2. `posts` - Manages the posts created by users, including the post content, timestamps, and associated user ID.

Please note that this is the first iteration of the Fresco application, and it may undergo further development and improvements in subsequent iterations.

Feel free to explore the project's code and modify it to suit your requirements.

---
