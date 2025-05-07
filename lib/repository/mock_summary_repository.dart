import 'dart:async';
import 'dart:math';
import 'package:green/contract/summary_repository.dart';

class MockSummaryRepository implements SummaryRepository {
  final _rng = Random();

  @override
  Stream<String> summarize() async* {
    const text = '''
Over the last hour greenhouse temperature held steady at 22°C with fluctuations under 1°C 
humidity averaged 58% supporting optimal leaf transpiration 
soil moisture sensors report a gradual increase indicating recent irrigation 
CO₂ levels remain within target range 
no sensor errors detected 
LED grow lights cycled correctly on schedule 
overall plant health indicators are positive and growth rates are on track 
scheduled ventilation cycle completed successfully 
next maintenance check due in 6 hours
''';
    for (final word in text.split(RegExp(r'\s+'))) {
      final delay = Duration(milliseconds: 50 + _rng.nextInt(300));
      await Future.delayed(delay);
      yield '$word ';
    }
  }
}
