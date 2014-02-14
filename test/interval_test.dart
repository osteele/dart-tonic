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
      expect(IntervalNames, hasLength(13));
    });

    test('should start with P1', () {
      expect(IntervalNames[0], equals('P1'));
    });

    test('should end with P8', () {
      expect(IntervalNames[12], equals('P8'));
    });
  });

  group('LongIntervalNames', () {
    test('should contain 13 intervals', () {
      expect(LongIntervalNames, hasLength(13));
    });

    test('should start with Unison', () {
      expect(LongIntervalNames[0], equals('Unison'));
    });

    test('should end with Octave', () {
      expect(LongIntervalNames[12], equals('Octave'));
    });
  });

  group('Interval', () {
    test('should implement parse', () {
      expect(Interval.parse('P1').semitones, equals(0));
      expect(Interval.parse('m2').semitones, equals(1));
      expect(Interval.parse('M2').semitones, equals(2));
      expect(Interval.parse('m3').semitones, equals(3));
      expect(Interval.parse('M3').semitones, equals(4));
      expect(Interval.parse('P4').semitones, equals(5));
      expect(Interval.parse('TT').semitones, equals(6));
      expect(Interval.parse('P5').semitones, equals(7));
      expect(Interval.parse('m6').semitones, equals(8));
      expect(Interval.parse('M6').semitones, equals(9));
      expect(Interval.parse('m7').semitones, equals(10));
      expect(Interval.parse('M7').semitones, equals(11));
      expect(Interval.parse('P8').semitones, equals(12));
    });

    test('should implement toString', () {
      expect(new Interval.fromSemitones(0).toString(), equals('P1'));
      expect(new Interval.fromSemitones(1).toString(), equals('m2'));
      expect(new Interval.fromSemitones(4).toString(), equals('M3'));
      expect(new Interval.fromSemitones(12).toString(), equals('P8'));
    });

    test('should be interned', () {
      expect(Interval.parse('P1'), equals(Interval.parse('P1')));
      expect(Interval.parse('M2'), equals(Interval.parse('M2')));
      expect(Interval.parse('P1'), isNot(equals(Interval.parse('M2'))));
    });

    test('should add to an interval', () {
      expect((Interval.parse('m2') + Interval.parse('M2')).semitones, equals(3));
    });

    group('between', () {
      test('should return the interval between two pitches', () {
        // expect(Interval.between(Pitch.parse('E4'), Pitch.parse('E4')).toString(), equals('P1'));
    //     expect(Interval.between(Pitch.parse('E4'), Pitch.parse('F4')).toString(), equals('m2'));
    //     expect(Interval.between(Pitch.parse('E4'), Pitch.parse('G4')).toString(), equals('m3'));
      });

    //   test('should use modular arithmetic', () {
    //     expect(Interval.between(Pitch.parse('F4'), Pitch.parse('C4')).toString(), equals('P5'));
    //   });
    });
  });

  group('Intervals array', () {
    test('should be an array of Interval', () {
    });
  });

}
