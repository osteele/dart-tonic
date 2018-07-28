part of tonic_test;

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

    test('should start with iP1', () {
      expect(intervalNames[0], equals('iP1'));
    });

    test('should end with iP8', () {
      expect(intervalNames[12], equals('iP8'));
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
      expect(Interval.parse('iP1'), equals(Interval.iP1));
      expect(Interval.parse('im2'), equals(Interval.im2));
      expect(Interval.parse('iM2'), equals(Interval.iM2));
      expect(Interval.parse('im3'), equals(Interval.im3));
      expect(Interval.parse('iM3'), equals(Interval.iM3));
      expect(Interval.parse('iP4'), equals(Interval.iP4));
      expect(Interval.parse('iTT'), equals(Interval.iTT));
      expect(Interval.parse('iP5'), equals(Interval.iP5));
      expect(Interval.parse('im6'), equals(Interval.im6));
      expect(Interval.parse('iM6'), equals(Interval.iM6));
      expect(Interval.parse('im7'), equals(Interval.im7));
      expect(Interval.parse('iM7'), equals(Interval.iM7));
      expect(Interval.parse('iP8'), equals(Interval.iP8));
    });

    test('parse should throw a FormatException', () {
      expect(() => Interval.parse('M1'), throwsFormatException);
      expect(() => Interval.parse('m1'), throwsFormatException);
      expect(() => Interval.parse('P2'), throwsFormatException);
      expect(() => Interval.parse('iP1x'), throwsFormatException);
      expect(() => Interval.parse('x1'), throwsFormatException);
      expect(() => Interval.parse('1'), throwsFormatException);
      expect(() => Interval.parse('x1'), throwsFormatException);
      expect(() => Interval.parse('M8'), throwsFormatException);
    });

    test('constructor should default to Perfect or Major', () {
      expect(new Interval(number: 1), equals(Interval.iP1));
      expect(new Interval(number: 2), equals(Interval.iM2));
      expect(new Interval(number: 3), equals(Interval.iM3));
      expect(new Interval(number: 4), equals(Interval.iP4));
      expect(new Interval(number: 5), equals(Interval.iP5));
      expect(new Interval(number: 6), equals(Interval.iM6));
      expect(new Interval(number: 7), equals(Interval.iM7));
      expect(new Interval(number: 8), equals(Interval.iP8));
    });

    test('fromSemitones should return an Interval', () {
      expect(new Interval.fromSemitones(0), equals(Interval.iP1));
      expect(new Interval.fromSemitones(1), equals(Interval.im2));
      expect(new Interval.fromSemitones(2), equals(Interval.iM2));
      expect(new Interval.fromSemitones(3), equals(Interval.im3));
      expect(new Interval.fromSemitones(4), equals(Interval.iM3));
      expect(new Interval.fromSemitones(5), equals(Interval.iP4));
      expect(new Interval.fromSemitones(6), equals(Interval.iTT));
      expect(new Interval.fromSemitones(7), equals(Interval.iP5));
      expect(new Interval.fromSemitones(8), equals(Interval.im6));
      expect(new Interval.fromSemitones(9), equals(Interval.iM6));
      expect(new Interval.fromSemitones(10), equals(Interval.im7));
      expect(new Interval.fromSemitones(11), equals(Interval.iM7));
      expect(new Interval.fromSemitones(12), equals(Interval.iP8));
    });

    test('fromSemitones should compute the quality', () {
      expect(new Interval.fromSemitones(0, number: 1), equals(Interval.iP1));
      expect(new Interval.fromSemitones(0, number: 2), equals(Interval.d2));
      expect(new Interval.fromSemitones(1, number: 1), equals(Interval.a1));
      expect(new Interval.fromSemitones(1, number: 2), equals(Interval.im2));
      expect(new Interval.fromSemitones(2, number: 2), equals(Interval.iM2));
      expect(new Interval.fromSemitones(2, number: 3), equals(Interval.d3));
      expect(new Interval.fromSemitones(3, number: 2), equals(Interval.a2));
      expect(new Interval.fromSemitones(3, number: 3), equals(Interval.im3));
      expect(new Interval.fromSemitones(4, number: 3), equals(Interval.iM3));
      expect(new Interval.fromSemitones(4, number: 4), equals(Interval.d4));
      expect(new Interval.fromSemitones(5, number: 3), equals(Interval.a3));
      expect(new Interval.fromSemitones(5, number: 4), equals(Interval.iP4));
      expect(new Interval.fromSemitones(6, number: 4), equals(Interval.a4));
      expect(new Interval.fromSemitones(6, number: 5), equals(Interval.d5));
      expect(new Interval.fromSemitones(7, number: 5), equals(Interval.iP5));
      expect(new Interval.fromSemitones(7, number: 6), equals(Interval.d6));
      expect(new Interval.fromSemitones(8, number: 5), equals(Interval.a5));
      expect(new Interval.fromSemitones(8, number: 6), equals(Interval.im6));
      expect(new Interval.fromSemitones(9, number: 6), equals(Interval.iM6));
      expect(new Interval.fromSemitones(9, number: 7), equals(Interval.d7));
      expect(new Interval.fromSemitones(10, number: 6), equals(Interval.a6));
      expect(new Interval.fromSemitones(10, number: 7), equals(Interval.im7));
      expect(new Interval.fromSemitones(11, number: 7), equals(Interval.iM7));
      expect(new Interval.fromSemitones(11, number: 8), equals(Interval.d8));
      expect(new Interval.fromSemitones(12, number: 7), equals(Interval.a7));
      expect(new Interval.fromSemitones(12, number: 8), equals(Interval.iP8));
      // expect(new Interval.fromSemitones(13, number: 8), equals(Interval.A8));
    });

    test('toString should return the interval name', () {
      expect(Interval.iP1.toString(), equals('iP1'));
      expect(Interval.im2.toString(), equals('im2'));
      expect(Interval.iM3.toString(), equals('iM3'));
      expect(Interval.iP8.toString(), equals('iP8'));
      expect(Interval.a3.toString(), equals('a3'));
      expect(Interval.d6.toString(), equals('d6'));
    });

    test('toString should include the quality', () {
      expect(Interval.d2.toString(), equals('d2'));
      expect(Interval.im2.toString(), equals('im2'));
      expect(Interval.iM2.toString(), equals('iM2'));
      expect(Interval.a2.toString(), equals('a2'));
    });

    test('should be interned', () {
      expect(Interval.parse('iP1'), equals(Interval.iP1));
      expect(Interval.parse('iM2'), equals(Interval.iM2));
      expect(Interval.parse('iP1'), isNot(equals(Interval.iM2)));
    });

    test('should define the major intervals', () {
      expect(Interval.iM2.semitones, equals(2));
      expect(Interval.iM3.semitones, equals(4));
      expect(Interval.iM6.semitones, equals(9));
      expect(Interval.iM7.semitones, equals(11));
    });

    test('should define the minor intervals', () {
      expect(Interval.im2.semitones, equals(1));
      expect(Interval.im3.semitones, equals(3));
      expect(Interval.im6.semitones, equals(8));
      expect(Interval.im7.semitones, equals(10));
    });

    test('should define the perfect intervals', () {
      expect(Interval.iP1.semitones, equals(0));
      expect(Interval.iP4.semitones, equals(5));
      expect(Interval.iP5.semitones, equals(7));
      expect(Interval.iP8.semitones, equals(12));
    });

    test('should define the tritone', () {
      expect(Interval.iTT.semitones, equals(6));
    });

    test('should define the augmented intervals', () {
      expect(Interval.a1.semitones, equals(1));
      expect(Interval.a2.semitones, equals(3));
      expect(Interval.a3.semitones, equals(5));
      expect(Interval.a4.semitones, equals(6));
      expect(Interval.a5.semitones, equals(8));
      expect(Interval.a6.semitones, equals(10));
      expect(Interval.a7.semitones, equals(12));
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
      expect(Interval.iP1 + Interval.iM2, equals(Interval.iM2));
      expect(Interval.iM2 + Interval.iP1, equals(Interval.iM2));
      expect(Interval.im2 + Interval.im2, equals(Interval.d3));
      expect(Interval.im2 + Interval.iM2, equals(Interval.im3));
      expect(Interval.iM2 + Interval.im2, equals(Interval.im3));
      expect(Interval.iM2 + Interval.iM2, equals(Interval.iM3));
      expect(Interval.d2 + Interval.iM2, equals(Interval.d3));
      expect(Interval.iM2 + Interval.d2, equals(Interval.d3));
      expect(Interval.iM2 + Interval.a2, equals(Interval.a3));
      expect(Interval.a2 + Interval.iM2, equals(Interval.a3));
      expect(Interval.iM2 + Interval.d2, equals(Interval.d3));
      expect(Interval.a2 + Interval.d2, equals(Interval.im3));
      expect(Interval.iM2 + Interval.a4, equals(Interval.a5));
      expect(Interval.iM2 + Interval.d5, equals(Interval.im6));
      expect(Interval.iM3 + Interval.im3, equals(Interval.iP5));
      expect(Interval.im3 + Interval.iM3, equals(Interval.iP5));
      expect(Interval.im3 + Interval.im3, equals(Interval.d5));
      expect(Interval.iM3 + Interval.iM3, equals(Interval.a5));
      expect(Interval.iP5 + Interval.im3, equals(Interval.im7));
      expect(Interval.iP5 + Interval.iM3, equals(Interval.iM7));
    });

    test('+Interval should throw an error when the quality is out of range',
        () {
      expect(() => Interval.d2 + Interval.im2, throwsArgumentError);
      expect(() => Interval.im2 + Interval.d2, throwsArgumentError);
    });

    test('-Interval should return an Interval', () {
      expect(Interval.iP5 - Interval.iM3, Interval.im3);
      expect(Interval.iP5 - Interval.im3, Interval.iM3);
      expect(Interval.a5 - Interval.im3, Interval.a3);
      expect(Interval.a5 - Interval.iM3, Interval.iM3);
      expect(Interval.d5 - Interval.im3, Interval.im3);
      expect(Interval.d5 - Interval.iM3, Interval.d3);
      expect(Interval.iM7 - Interval.iM3, Interval.iP5);
      expect(Interval.iM7 - Interval.im3, Interval.a5);
    });
  });
}
