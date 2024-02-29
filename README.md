# Scalp Smart

Scalp Smart is a platform designed to predict baldness stages using AI and computer vision technologies. It analyzes images uploaded by users and provides predictions ranging from Normal to various stages of baldness (Stage 1, Stage 2, Stage 3, Bald). Additionally, the platform recommends products tailored to individual needs.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Contributing](#contributing)

## Installation

### Flutter App

<h1>Hello</h1>

1. Clone the repository:

    ```bash
    git clone https://github.com/ameyk2004/scalp-smart.git
    ```

2. Navigate to the project directory:

    ```bash
    cd scalp-smart
    ```

3. Install dependencies:

    ```bash
    flutter pub get
    ```

4. Run the app:

    ```bash
    flutter run
    ```

## File Structure
# lib

## auth

### authServices.dart

- This file contains services related to authentication, handling user authentication logic.

### authWrapper.dart

- Wrapper for authentication services, responsible for determining the appropriate screen to show based on the user's authentication status.

## screens

- This directory contains the different screens of your app.
  - **screen1.dart**: Description of Screen 1.
  - **screen2.dart**: Description of Screen 2.
  - ...

## services

- This directory holds various services that your app may need, beyond authentication.
  - **api_service.dart**: Service for handling communication with your backend or APIs.
  - **data_service.dart**: Service for managing app data.
  - ...

## widgets

- The widgets directory contains reusable UI components that can be used across different screens or parts of your app.
  - **custom_button.dart**: A customizable button widget.
  - **app_bar.dart**: Custom app bar widget with specific styling.
  - ...

### colors.dart

- Centralized file for defining color constants used throughout your app.

### firebase_options.dart

- Configuration file for Firebase options, such as API keys, project settings, etc.

## main.dart

- The entry point of your Flutter application, where the app is initialized and run.


## Usage

1. Open the Scalp Smart app or visit the website.
2. Upload an image of your scalp.
3. Receive predictions on your baldness stage.
4. Explore product recommendations tailored to your needs.
5. Use the AI-powered chatbot for assistance with Scalp Smart and hairfall-related queries.

## Features

- **AI-powered Baldness Prediction:**
  - Utilizes computer vision to predict baldness stages, ranging from Normal to Stage 1, Stage 2, Stage 3, and Bald.

- **Product Recommendations:**
  - Recommends hair care products based on individual needs and predicted baldness stage.

- **AI-powered Chatbot:**
  - Provides assistance with Scalp Smart usage and answers hairfall-related queries using AI.

- **Cross-Platform:**
  - Available on both the website and mobile platforms, built with Flutter.

## Contributing

We welcome contributions! If you'd like to contribute to Scalp Smart, follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Submit a pull request.

