# FlutterAppDemo

Brief description of your app.

## Set Up and Run

### Prerequisites

- Flutter installed on your machine.
- Back4App account with an app created.

### Initialize Parse SDK

1. Open `main.dart` in your Flutter project.
2. Update the Parse initialization with your Back4App app details:
   ```dart
   await Parse().initialize(
     'your_app_id',
     'https://parseapi.back4app.com/',
     clientKey: 'your_client_key',
     autoSendSessionId: true,
     debug: true,
   );
