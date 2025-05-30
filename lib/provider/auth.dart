import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:green/contract/auth_repository.dart';
import 'package:green/repository/mock_auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => MockAuthRepository(storage: const FlutterSecureStorage()),
);

class AuthStateNotifier extends StateNotifier<bool> {
  final AuthRepository repo;
  AuthStateNotifier(this.repo) : super(false) {
    _init();
  }

  Future<void> _init() async {
    state = await repo.isAuthenticated();
    repo.authState.addListener(() async {
      state = await repo.isAuthenticated();
    });
  }

  Future<void> login(String username, String password) async {
    await repo.login(username: username, password: password);
    state = await repo.isAuthenticated();
  }

  Future<void> logout() async {
    await repo.logout();
    state = await repo.isAuthenticated();
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthStateNotifier(repo);
});