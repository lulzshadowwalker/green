import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:green/contract/summary_repository.dart';
import 'package:green/repository/mock_summary_repository.dart';

final summaryRepositoryProvider =
    Provider<SummaryRepository>((ref) => MockSummaryRepository());

final summaryStreamProvider = StreamProvider<String>((ref) {
  final repo = ref.read(summaryRepositoryProvider);
  return (() async* {
    var buffer = '';
    await for (final chunk in repo.summarize()) {
      buffer += chunk;
      yield buffer;
    }
  })();
});
