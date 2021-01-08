# Dance Chaos

Real-Time Dance Partner finder app

## Set-up

1) Set up a Firestore instance at [Firebase Console](https://console.firebase.google.com/).

2) Enable anonymous authentication by going to 'Authentication' in left hand menu, selecting
'Sign-in Method', and enabling Anonymous at the bottom of the page.

3) For Android:

4) For iOS:

## Testing

For integration testing, we need to pass through a Mock `UserRepository` and Mock `ReactiveTodosRepository`.

  1. `flutter test` will run all unit tests.
    * `flutter test test/selectors_test.dart` for selectors unit testing.
    * `flutter test test/reducer_test.dart` for reducers unit testing.
    * `flutter test test/middleware_test.dart` for middleware unit testing.
  2. `flutter drive --target=integration_test/todo_app.dart` to run integrations test. Integrations tests are unchanged from the original redux repo.
