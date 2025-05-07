import 'package:green/contract/health_repository.dart';
import 'package:green/repository/go_health_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final healthRepositoryProvider = Provider<HealthRepository>((ref) => GoHealthRepository());
final healthStatusProvider = FutureProvider<SystemStatus>((ref) => ref.watch(healthRepositoryProvider).fetchStatus());
