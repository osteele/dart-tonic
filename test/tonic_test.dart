library tonic_test;

import 'package:unittest/unittest.dart';
import 'package:tonic/tonic.dart';

part 'matchers.dart';
part 'interval_test.dart';
part 'pitch_class_test.dart';
part 'pitch_test.dart';
part 'scales_test.dart';
part 'chord_test.dart';
part 'instrument_test.dart';
part 'fretting_test.dart';

main() {
  defineIntervalTests();
  definePitchClassTests();
  definePitchTests();
  defineScaleTests();
  defineChordTests();
  defineInstrumentTests();
  defineFrettingTests();
}
