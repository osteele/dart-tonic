library tonic_test;

import 'package:unittest/unittest.dart';
import 'package:tonic/tonic.dart';

part 'interval_test.dart';
part 'pitch_class_test.dart';
part 'pitch_test.dart';

main() {
  defineIntervalTests();
  definePitchClassTests();
  definePitchTests();
}
