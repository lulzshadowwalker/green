import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:green/model/control_status.dart';
import 'package:green/repository/go_control_repository.dart';
import '../contract/control_repository.dart';

final controlRepositoryProvider =
    Provider<ControlRepository>((ref) => GoControlRepository());

final controlStatusProvider =
    StreamProvider<ControlStatus>((ref) =>
        ref.read(controlRepositoryProvider).watchAll());
