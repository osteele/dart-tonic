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

  group('parsePitchClass', () {
    test('should parse naturals', () {
      expect(parsePitchClass('C'), equals(0));
      expect(parsePitchClass('D'), equals(2));
      expect(parsePitchClass('E'), equals(4));
      expect(parsePitchClass('F'), equals(5));
      expect(parsePitchClass('G'), equals(7));
      expect(parsePitchClass('A'), equals(9));
      expect(parsePitchClass('B'), equals(11));
    });

    test('should parse sharps', () {
      expect(parsePitchClass('C#'), equals(1));
      expect(parsePitchClass('C♯'), equals(1));
    });

    test('should parse flats', () {
      expect(parsePitchClass('Cb'), equals(11));
      expect(parsePitchClass('C♭'), equals(11));
    });

    test('should parse double sharps and flats', () {
      expect(parsePitchClass('C𝄪'), equals(2));
      expect(parsePitchClass('C𝄫'), equals(10));
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
    test('parse', () {
      expect(PitchClass.parse('C').number, equals(0));
      expect(PitchClass.parse('E').number, equals(4));
      expect(PitchClass.parse('G').number, equals(7));
      expect(PitchClass.parse('C♭').number, equals(11));
      expect(PitchClass.parse('C♯').number, equals(1));
    });

    test('fromSemitones', () {
      expect(new PitchClass.fromSemitones(60).number, equals(0));
      expect(new PitchClass.fromSemitones(61).number, equals(1));
      expect(new PitchClass.fromSemitones(62).number, equals(2));
      expect(new PitchClass.fromSemitones(48).number, equals(0));
      expect(new PitchClass.fromSemitones(72).number, equals(0));
      expect(new PitchClass.fromSemitones(50).number, equals(2));
      expect(new PitchClass.fromSemitones(74).number, equals(2));
    });

    test('toString', () {
      expect(new PitchClass.fromSemitones(0).toString(), equals('C'));
      expect(new PitchClass.fromSemitones(2).toString(), equals('D'));
      expect(new PitchClass.fromSemitones(4).toString(), equals('E'));
      expect(new PitchClass.fromSemitones(60).toString(), equals('C'));
      expect(new PitchClass.fromSemitones(61).toString(), equals('C♯'));
      expect(new PitchClass.fromSemitones(62).toString(), equals('D'));
      expect(new PitchClass.fromSemitones(48).toString(), equals('C'));
      expect(new PitchClass.fromSemitones(72).toString(), equals('C'));
      expect(new PitchClass.fromSemitones(50).toString(), equals('D'));
      expect(new PitchClass.fromSemitones(74).toString(), equals('D'));
    });

    test('should normalize its input', () {
      expect(new PitchClass.fromSemitones(12).number, equals(0));
      expect(new PitchClass.fromSemitones(14).number, equals(2));
      expect(new PitchClass.fromSemitones(24).number, equals(0));
      expect(new PitchClass.fromSemitones(26).number, equals(2));
    });

    test('should add to an interval', () {
      expect((PitchClass.parse('C') + Interval.parse('M2')).toString(), equals('D'));
    });

    test('toPitch should return a pitch within the specified octave', () {
      expect(PitchClass.parse('C').toPitch(), equals(Pitch.parse('C0')));
      expect(PitchClass.parse('D').toPitch(octave: -1), equals(Pitch.parse('D-1')));
      expect(PitchClass.parse('D').toPitch(octave: 0), equals(Pitch.parse('D0')));
      expect(PitchClass.parse('D').toPitch(octave: 1), equals(Pitch.parse('D1')));
      expect(PitchClass.parse('D').toPitch(octave: 3), equals(Pitch.parse('D3')));
      expect(PitchClass.parse('D').toPitch(octave: 5), equals(Pitch.parse('D5')));
    });

    test('toPitchClass should return itself', () {
      expect(PitchClass.parse('C').toPitchClass(), equals(PitchClass.parse('C')));
      expect(PitchClass.parse('D').toPitchClass(), equals(PitchClass.parse('D')));
    });
  });
}
