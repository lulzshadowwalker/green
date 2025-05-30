import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:green/contract/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  static const _tokenKey = 'mock_access_token';
  final FlutterSecureStorage _storage;
  final ValueNotifier<bool> _authState = ValueNotifier(false);

  MockAuthRepository({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage() {
    _init();
  }

  Future<void> _init() async {
    final token = await _storage.read(key: _tokenKey);
    _authState.value = token != null;
  }

  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    print(
      'username ${username == 'user'}, password: ${password == 'password'}',
    );
    if (username == 'user' && password == 'password') {
      const token = 'mock_token_123456';
      await _storage.write(key: _tokenKey, value: token);
      _authState.value = true;
      return token;
    } else {
      throw Exception('Invalid username or password');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    _authState.value = false;
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }

  @override
  ValueListenable<bool> get authState => _authState;
}
