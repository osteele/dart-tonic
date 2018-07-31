// part of tonic_test;
import 'package:test/test.dart';
import 'tonic_test.dart';
import 'package:tonic/tonic.dart';

void defineIntervalTests() {
  group('intervalClassDifference', () {
    test('should return an integer in [0...12]', () {
      expect(intervalClassDifference(0, 5), equals(5));
      expect(intervalClassDifference(5, 0), equals(7));
      expect(intervalClassDifference(0, 12), equals(0));
    });
  });

  group('IntervalNames', () {
    test('should contain 13 intervals', () {
      expect(intervalNames, hasLength(13));
    });

    test('should start with P1', () {
      expect(intervalNames[0], equals('P1'));
    });

    test('should end with P8', () {
      expect(intervalNames[12], equals('P8'));
    });
  });

  group('LongIntervalNames', () {
    test('should contain 13 intervals', () {
      expect(longIntervalNames, hasLength(13));
    });

    test('should start with Unison', () {
      expect(longIntervalNames[0], equals('Unison'));
    });

    test('should end with Octave', () {
      expect(longIntervalNames[12], equals('Octave'));
    });
  });

  group('Interval', () {
    test('parse should return an interval', () {
      expect(Interval.parse('P1'), equals(Interval.P1));
      expect(Interval.parse('m2'), equals(Interval.m2));
      expect(Interval.parse('M2'), equals(Interval.M2));
      expect(Interval.parse('m3'), equals(Interval.m3));
      expect(Interval.parse('M3'), equals(Interval.M3));
      expect(Interval.parse('P4'), equals(Interval.P4));
      expect(Interval.parse('TT'), equals(Interval.TT));
      expect(Interval.parse('P5'), equals(Interval.P5));
      expect(Interval.parse('m6'), equals(Interval.m6));
      expect(Interval.parse('M6'), equals(Interval.M6));
      expect(Interval.parse('m7'), equals(Interval.m7));
      expect(Interval.parse('M7'), equals(Interval.M7));
      expect(Interval.parse('P8'), equals(Interval.P8));
    });

    test('parse should throw a FormatException', () {
      expect(() => Interval.parse('M1'), throwsFormatException);
      expect(() => Interval.parse('m1'), throwsFormatException);
      expect(() => Interval.parse('P2'), throwsFormatException);
      expect(() => Interval.parse('P1x'), throwsFormatException);
      expect(() => Interval.parse('x1'), throwsFormatException);
      expect(() => Interval.parse('1'), throwsFormatException);
      expect(() => Interval.parse('x1'), throwsFormatException);
      expect(() => Interval.parse('M8'), throwsFormatException);
    });

    test('constructor should default to Perfect or Major', () {
      expect(new Interval(number: 1), equals(Interval.P1));
      expect(new Interval(number: 2), equals(Interval.M2));
      expect(new Interval(number: 3), equals(Interval.M3));
      expect(new Interval(number: 4), equals(Interval.P4));
      expect(new Interval(number: 5), equals(Interval.P5));
      expect(new Interval(number: 6), equals(Interval.M6));
      expect(new Interval(number: 7), equals(Interval.M7));
      expect(new Interval(number: 8), equals(Interval.P8));
    });

    test('fromSemitones should return an Interval', () {
      expect(new Interval.fromSemitones(0), equals(Interval.P1));
      expect(new Interval.fromSemitones(1), equals(Interval.m2));
      expect(new Interval.fromSemitones(2), equals(Interval.M2));
      expect(new Interval.fromSemitones(3), equals(Interval.m3));
      expect(new Interval.fromSemitones(4), equals(Interval.M3));
      expect(new Interval.fromSemitones(5), equals(Interval.P4));
      expect(new Interval.fromSemitones(6), equals(Interval.TT));
      expect(new Interval.fromSemitones(7), equals(Interval.P5));
      expect(new Interval.fromSemitones(8), equals(Interval.m6));
      expect(new Interval.fromSemitones(9), equals(Interval.M6));
      expect(new Interval.fromSemitones(10), equals(Interval.m7));
      expect(new Interval.fromSemitones(11), equals(Interval.M7));
      expect(new Interval.fromSemitones(12), equals(Interval.P8));
    });

    test('fromSemitones should compute the quality', () {
      expect(new Interval.fromSemitones(0, number: 1), equals(Interval.P1));
      expect(new Interval.fromSemitones(0, number: 2), equals(Interval.d2));
      expect(new Interval.fromSemitones(1, number: 1), equals(Interval.A1));
      expect(new Interval.fromSemitones(1, number: 2), equals(Interval.m2));
      expect(new Interval.fromSemitones(2, number: 2), equals(Interval.M2));
      expect(new Interval.fromSemitones(2, number: 3), equals(Interval.d3));
      expect(new Interval.fromSemitones(3, number: 2), equals(Interval.A2));
      expect(new Interval.fromSemitones(3, number: 3), equals(Interval.m3));
      expect(new Interval.fromSemitones(4, number: 3), equals(Interval.M3));
      expect(new Interval.fromSemitones(4, number: 4), equals(Interval.d4));
      expect(new Interval.fromSemitones(5, number: 3), equals(Interval.A3));
      expect(new Interval.fromSemitones(5, number: 4), equals(Interval.P4));
      expect(new Interval.fromSemitones(6, number: 4), equals(Interval.A4));
      expect(new Interval.fromSemitones(6, number: 5), equals(Interval.d5));
      expect(new Interval.fromSemitones(7, number: 5), equals(Interval.P5));
      expect(new Interval.fromSemitones(7, number: 6), equals(Interval.d6));
      expect(new Interval.fromSemitones(8, number: 5), equals(Interval.A5));
      expect(new Interval.fromSemitones(8, number: 6), equals(Interval.m6));
      expect(new Interval.fromSemitones(9, number: 6), equals(Interval.M6));
      expect(new Interval.fromSemitones(9, number: 7), equals(Interval.d7));
      expect(new Interval.fromSemitones(10, number: 6), equals(Interval.A6));
      expect(new Interval.fromSemitones(10, number: 7), equals(Interval.m7));
      expect(new Interval.fromSemitones(11, number: 7), equals(Interval.M7));
      expect(new Interval.fromSemitones(11, number: 8), equals(Interval.d8));
      expect(new Interval.fromSemitones(12, number: 7), equals(Interval.A7));
      expect(new Interval.fromSemitones(12, number: 8), equals(Interval.P8));
      // expect(new Interval.fromSemitones(13, number: 8), equals(Interval.A8));
    });

    test('toString should return the interval name', () {
      expect(Interval.P1.toString(), equals('P1'));
      expect(Interval.m2.toString(), equals('m2'));
      expect(Interval.M3.toString(), equals('M3'));
      expect(Interval.P8.toString(), equals('P8'));
      expect(Interval.A3.toString(), equals('A3'));
      expect(Interval.d6.toString(), equals('d6'));
    });

    test('toString should include the quality', () {
      expect(Interval.d2.toString(), equals('d2'));
      expect(Interval.m2.toString(), equals('m2'));
      expect(Interval.M2.toString(), equals('M2'));
      expect(Interval.A2.toString(), equals('A2'));
    });

    test('should be interned', () {
      expect(Interval.parse('P1'), equals(Interval.P1));
      expect(Interval.parse('M2'), equals(Interval.M2));
      expect(Interval.parse('P1'), isNot(equals(Interval.M2)));
    });

    test('should define the major intervals', () {
      expect(Interval.M2.semitones, equals(2));
      expect(Interval.M3.semitones, equals(4));
      expect(Interval.M6.semitones, equals(9));
      expect(Interval.M7.semitones, equals(11));
    });

    test('should define the minor intervals', () {
      expect(Interval.m2.semitones, equals(1));
      expect(Interval.m3.semitones, equals(3));
      expect(Interval.m6.semitones, equals(8));
      expect(Interval.m7.semitones, equals(10));
    });

    test('should define the perfect intervals', () {
      expect(Interval.P1.semitones, equals(0));
      expect(Interval.P4.semitones, equals(5));
      expect(Interval.P5.semitones, equals(7));
      expect(Interval.P8.semitones, equals(12));
    });

    test('should define the tritone', () {
      expect(Interval.TT.semitones, equals(6));
    });

    test('should define the augmented intervals', () {
      expect(Interval.A1.semitones, equals(1));
      expect(Interval.A2.semitones, equals(3));
      expect(Interval.A3.semitones, equals(5));
      expect(Interval.A4.semitones, equals(6));
      expect(Interval.A5.semitones, equals(8));
      expect(Interval.A6.semitones, equals(10));
      expect(Interval.A7.semitones, equals(12));
    });

    test('should define the diminished intervals', () {
      expect(Interval.d2.semitones, equals(0));
      expect(Interval.d3.semitones, equals(2));
      expect(Interval.d4.semitones, equals(4));
      expect(Interval.d5.semitones, equals(6));
      expect(Interval.d6.semitones, equals(7));
      expect(Interval.d7.semitones, equals(9));
      expect(Interval.d8.semitones, equals(11));
    });

    test('+Interval should return an Interval', () {
      expect(Interval.P1 + Interval.M2, equals(Interval.M2));
      expect(Interval.M2 + Interval.P1, equals(Interval.M2));
      expect(Interval.m2 + Interval.m2, equals(Interval.d3));
      expect(Interval.m2 + Interval.M2, equals(Interval.m3));
      expect(Interval.M2 + Interval.m2, equals(Interval.m3));
      expect(Interval.M2 + Interval.M2, equals(Interval.M3));
      expect(Interval.d2 + Interval.M2, equals(Interval.d3));
      expect(Interval.M2 + Interval.d2, equals(Interval.d3));
      expect(Interval.M2 + Interval.A2, equals(Interval.A3));
      expect(Interval.A2 + Interval.M2, equals(Interval.A3));
      expect(Interval.M2 + Interval.d2, equals(Interval.d3));
      expect(Interval.A2 + Interval.d2, equals(Interval.m3));
      expect(Interval.M2 + Interval.A4, equals(Interval.A5));
      expect(Interval.M2 + Interval.d5, equals(Interval.m6));
      expect(Interval.M3 + Interval.m3, equals(Interval.P5));
      expect(Interval.m3 + Interval.M3, equals(Interval.P5));
      expect(Interval.m3 + Interval.m3, equals(Interval.d5));
      expect(Interval.M3 + Interval.M3, equals(Interval.A5));
      expect(Interval.P5 + Interval.m3, equals(Interval.m7));
      expect(Interval.P5 + Interval.M3, equals(Interval.M7));
    });

    test('+Interval should throw an error when the quality is out of range',
        () {
      expect(() => Interval.d2 + Interval.m2, throwsArgumentError);
      expect(() => Interval.m2 + Interval.d2, throwsArgumentError);
    });

    test('-Interval should return an Interval', () {
      expect(Interval.P5 - Interval.M3, Interval.m3);
      expect(Interval.P5 - Interval.m3, Interval.M3);
      expect(Interval.A5 - Interval.m3, Interval.A3);
      expect(Interval.A5 - Interval.M3, Interval.M3);
      expect(Interval.d5 - Interval.m3, Interval.m3);
      expect(Interval.d5 - Interval.M3, Interval.d3);
      expect(Interval.M7 - Interval.M3, Interval.P5);
      expect(Interval.M7 - Interval.m3, Interval.A5);
    });
  });
}
