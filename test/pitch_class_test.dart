part of tonic_test;

void definePitchClassTests() {
  group('pitchClassToString', () {
    test('should return natural names', () {
      expect(pitchClassToString(0), equals('C'));
      expect(pitchClassToString(2), equals('D'));
      expect(pitchClassToString(4), equals('E'));
      expect(pitchClassToString(5), equals('F'));
      expect(pitchClassToString(7), equals('G'));
      expect(pitchClassToString(9), equals('A'));
      expect(pitchClassToString(11), equals('B'));
    });

    test('should default to flat names', () {
      expect(pitchClassToString(1), equals('D♭'));
      expect(pitchClassToString(3), equals('E♭'));
      expect(pitchClassToString(6), equals('G♭'));
      expect(pitchClassToString(8), equals('A♭'));
      expect(pitchClassToString(10), equals('B♭'));
    });

    test('should return flat names', () {
      expect(pitchClassToString(1, flat: true), equals('D♭'));
      expect(pitchClassToString(3, flat: true), equals('E♭'));
      expect(pitchClassToString(6, flat: true), equals('G♭'));
      expect(pitchClassToString(8, flat: true), equals('A♭'));
      expect(pitchClassToString(10, flat: true), equals('B♭'));
    });

    test('should return sharp names', () {
      expect(pitchClassToString(1, sharp: true), equals('C♯'));
      expect(pitchClassToString(3, sharp: true), equals('D♯'));
      expect(pitchClassToString(6, sharp: true), equals('F♯'));
      expect(pitchClassToString(8, sharp: true), equals('G♯'));
      expect(pitchClassToString(10, sharp: true), equals('A♯'));
    });

    test('should return both names with both options', () {
      expect(pitchClassToString(1, sharp: true, flat: true), equals("D♭/\nC♯"));
    });
  });

  group('normalizePitchClass', () {
    test('should return an integer in 0..11', () {
      expect(normalizePitchClass(0), equals(0));
      expect(normalizePitchClass(11), equals(11));
      expect(normalizePitchClass(-1), equals(11));
      expect(normalizePitchClass(-13), equals(11));
      expect(normalizePitchClass(12), equals(0));
      expect(normalizePitchClass(13), equals(1));
      expect(normalizePitchClass(25), equals(1));
    });
  });

  group('pitchToPitchClass', () {
    test('should return an integer in [0...12]', () {
      expect(pitchToPitchClass(0), equals(0));
      expect(pitchToPitchClass(1), equals(1));
      expect(pitchToPitchClass(12), equals(0));
      expect(pitchToPitchClass(13), equals(1));
      expect(pitchToPitchClass(-1), equals(11));
      expect(pitchToPitchClass(-13), equals(11));
    });
  });

  group('PitchClass', () {
    group('parse', () {
      test('should parse naturals', () {
        expect(PitchClass.parse('C').integer, equals(0));
        expect(PitchClass.parse('D').integer, equals(2));
        expect(PitchClass.parse('E').integer, equals(4));
        expect(PitchClass.parse('F').integer, equals(5));
        expect(PitchClass.parse('G').integer, equals(7));
        expect(PitchClass.parse('A').integer, equals(9));
        expect(PitchClass.parse('B').integer, equals(11));
      });

      test('should parse sharps', () {
        expect(PitchClass.parse('C#').integer, equals(1));
        expect(PitchClass.parse('C♯').integer, equals(1));
      });

      test('should parse flats', () {
        expect(PitchClass.parse('Cb').integer, equals(11));
        expect(PitchClass.parse('C♭').integer, equals(11));
      });

      test('should parse double sharps and flats', () {
        expect(PitchClass.parse('C𝄪').integer, equals(2));
        expect(PitchClass.parse('C𝄫').integer, equals(10));
      });

      test('should throw a FormatException', () {
        expect(() => PitchClass.parse('H'), throwsFormatException);
        expect(() => PitchClass.parse('CC'), throwsFormatException);
        expect(() => PitchClass.parse('C^'), throwsFormatException);
        expect(() => PitchClass.parse('C+'), throwsFormatException);
        expect(() => PitchClass.parse('+C'), throwsFormatException);
      });
    });

    test('fromSemitones', () {
      expect(new PitchClass.fromSemitones(60).integer, equals(0));
      expect(new PitchClass.fromSemitones(61).integer, equals(1));
      expect(new PitchClass.fromSemitones(62).integer, equals(2));
      expect(new PitchClass.fromSemitones(48).integer, equals(0));
      expect(new PitchClass.fromSemitones(72).integer, equals(0));
      expect(new PitchClass.fromSemitones(50).integer, equals(2));
      expect(new PitchClass.fromSemitones(74).integer, equals(2));
    });

    test('toString', () {
      expect(new PitchClass.fromSemitones(0).toString(), equals('C'));
      expect(new PitchClass.fromSemitones(1).toString(), equals('C♯'));
      expect(new PitchClass.fromSemitones(2).toString(), equals('D'));
      expect(new PitchClass.fromSemitones(3).toString(), equals('D♯'));
      expect(new PitchClass.fromSemitones(4).toString(), equals('E'));
      expect(new PitchClass.fromSemitones(5).toString(), equals('F'));
      expect(new PitchClass.fromSemitones(6).toString(), equals('F♯'));
      expect(new PitchClass.fromSemitones(7).toString(), equals('G'));
      expect(new PitchClass.fromSemitones(8).toString(), equals('G♯'));
      expect(new PitchClass.fromSemitones(9).toString(), equals('A'));
      expect(new PitchClass.fromSemitones(10).toString(), equals('A♯'));
      expect(new PitchClass.fromSemitones(11).toString(), equals('B'));

      expect(PitchClass.parse('C').toString(), equals('C'));
      expect(PitchClass.parse('E').toString(), equals('E'));
      expect(PitchClass.parse('G').toString(), equals('G'));
      expect(PitchClass.parse('C♭').toString(), equals('B'));
      expect(PitchClass.parse('C♯').toString(), equals('C♯'));
      expect(PitchClass.parse('C𝄫').toString(), equals('A♯'));
      expect(PitchClass.parse('C𝄪').toString(), equals('D'));
    });

    test('should normalize its input', () {
      expect(new PitchClass.fromSemitones(12).integer, equals(0));
      expect(new PitchClass.fromSemitones(14).integer, equals(2));
      expect(new PitchClass.fromSemitones(24).integer, equals(0));
      expect(new PitchClass.fromSemitones(26).integer, equals(2));
    });

    test('+ Interval should return a PitchClass', () {
      expect((PitchClass.parse('C') + Interval.P1).toString(), equals('C'));
      expect((PitchClass.parse('C') + Interval.m2).toString(), equals('C♯'));
      expect((PitchClass.parse('C') + Interval.M2).toString(), equals('D'));
      expect((PitchClass.parse('C') + Interval.m3).toString(), equals('D♯'));
      expect((PitchClass.parse('C') + Interval.M3).toString(), equals('E'));
      expect((PitchClass.parse('C') + Interval.P4).toString(), equals('F'));
      expect((PitchClass.parse('C') + Interval.TT).toString(), equals('F♯'));
      expect((PitchClass.parse('C') + Interval.P5).toString(), equals('G'));
      expect((PitchClass.parse('C') + Interval.m6).toString(), equals('G♯'));
      expect((PitchClass.parse('C') + Interval.M6).toString(), equals('A'));
      expect((PitchClass.parse('C') + Interval.m7).toString(), equals('A♯'));
      expect((PitchClass.parse('C') + Interval.M7).toString(), equals('B'));

      expect((PitchClass.parse('D') + Interval.P1).toString(), equals('D'));
      expect((PitchClass.parse('D') + Interval.m2).toString(), equals('D♯'));
      expect((PitchClass.parse('D') + Interval.M2).toString(), equals('E'));
      expect((PitchClass.parse('D') + Interval.m3).toString(), equals('F'));
      expect((PitchClass.parse('D') + Interval.M3).toString(), equals('F♯'));
      expect((PitchClass.parse('D') + Interval.P4).toString(), equals('G'));
      expect((PitchClass.parse('D') + Interval.TT).toString(), equals('G♯'));
      expect((PitchClass.parse('D') + Interval.P5).toString(), equals('A'));
      expect((PitchClass.parse('D') + Interval.m6).toString(), equals('A♯'));
      expect((PitchClass.parse('D') + Interval.M6).toString(), equals('B'));
      expect((PitchClass.parse('D') + Interval.m7).toString(), equals('C'));
      expect((PitchClass.parse('D') + Interval.M7).toString(), equals('C♯'));
    });

    test('toPitch should return a pitch within the specified octave', () {
      expect(PitchClass.parse('C').toPitch(), equals(Pitch.parse('C0')));
      expect(PitchClass.parse('D').toPitch(octave: -1),
          equals(Pitch.parse('D-1')));
      expect(
          PitchClass.parse('D').toPitch(octave: 0), equals(Pitch.parse('D0')));
      expect(
          PitchClass.parse('D').toPitch(octave: 1), equals(Pitch.parse('D1')));
      expect(
          PitchClass.parse('D').toPitch(octave: 3), equals(Pitch.parse('D3')));
      expect(
          PitchClass.parse('D').toPitch(octave: 5), equals(Pitch.parse('D5')));
    });

    test('toPitchClass should return itself', () {
      expect(
          PitchClass.parse('C').toPitchClass(), equals(PitchClass.parse('C')));
      expect(
          PitchClass.parse('D').toPitchClass(), equals(PitchClass.parse('D')));
    });
  });
}
