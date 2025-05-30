import 'package:flutter/foundation.dart';

abstract class AuthRepository {
  /// Attempts to log in with the given username and password.
  /// Returns an access token if successful, otherwise throws.
  Future<String> login({
    required String username,
    required String password,
  });

  /// Logs out the current user and clears any stored credentials.
  Future<void> logout();

  /// Returns the currently stored access token, or null if not logged in.
  Future<String?> getAccessToken();

  /// Returns whether the user is currently authenticated.
  Future<bool> isAuthenticated();

  /// Optionally, stream for auth state changes.
  ValueListenable<bool> get authState;
}