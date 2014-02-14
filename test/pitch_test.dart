part of tonic_test;

void definePitchTests() {
  group('FlatNoteNames', () {
    test('should contain 12 pitches', () {
      expect(FlatNoteNames, hasLength(12));
    });

    test('should start with C', () {
      expect(FlatNoteNames[0], equals('C'));
    });

    test('should contain five flats', () {
      expect(FlatNoteNames[1], equals('D♭'));
      expect(FlatNoteNames[3], equals('E♭'));
      expect(FlatNoteNames[6], equals('G♭'));
      expect(FlatNoteNames[8], equals('A♭'));
      expect(FlatNoteNames[10], equals('B♭'));
    });
  });

  group('SharpNoteNames', () {
    test('should contain 12 pitches', () {
      expect(SharpNoteNames, hasLength(12));
    });

    test('should start with C', () {
      expect(SharpNoteNames[0], equals('C'));
    });

    test('should contain five flats', () {
      expect(SharpNoteNames[1], equals('C♯'));
      expect(SharpNoteNames[3], equals('D♯'));
      expect(SharpNoteNames[6], equals('F♯'));
      expect(SharpNoteNames[8], equals('G♯'));
      expect(SharpNoteNames[10], equals('A♯'));
    });
  });

  group('NoteNames', () {
    test('should equal SharpNoteNames', () {
      expect(NoteNames, equals(SharpNoteNames));
    });
  });


  //
  // Functions
  //

  group('accidentalsToString', () {
    test('should convert semitone counts to strings', () {
      expect(accidentalsToString(0), equals(''));
      expect(accidentalsToString(-1), equals('♭'));
      expect(accidentalsToString(-2), equals('𝄫'));
      expect(accidentalsToString(-3), equals('♭𝄫'));
      expect(accidentalsToString(-4), equals('𝄫𝄫'));
      expect(accidentalsToString(-5), equals('♭𝄫𝄫'));
      expect(accidentalsToString(1), equals('♯'));
      expect(accidentalsToString(2), equals('𝄪'));
      expect(accidentalsToString(3), equals('♯𝄪'));
      expect(accidentalsToString(4), equals('𝄪𝄪'));
      expect(accidentalsToString(5), equals('♯𝄪𝄪'));
    });
  });

  group('parseScientificNotation', () {
    test('should parse the pitch class', () {
      expect(parseScientificNotation('C4'), equals(60));
      expect(parseScientificNotation('D4'), equals(62));
      expect(parseScientificNotation('E4'), equals(64));
      expect(parseScientificNotation('F4'), equals(65));
      expect(parseScientificNotation('G4'), equals(67));
      expect(parseScientificNotation('A4'), equals(69));
      expect(parseScientificNotation('B4'), equals(71));
    });

    test('should parse the octave', () {
      expect(parseScientificNotation('C1'), equals(24));
      expect(parseScientificNotation('C2'), equals(36));
      expect(parseScientificNotation('C3'), equals(48));
      expect(parseScientificNotation('C4'), equals(60));
      expect(parseScientificNotation('C5'), equals(72));
      expect(parseScientificNotation('C6'), equals(84));
    });

    test('should parse accidentals', () {
      expect(parseScientificNotation('Cb4'), equals(59));
      expect(parseScientificNotation('C#4'), equals(61));
      expect(parseScientificNotation('C♭4'), equals(59));
      expect(parseScientificNotation('C♯4'), equals(61));
      expect(parseScientificNotation('C♭♭4'), equals(58));
      expect(parseScientificNotation('C♯♯4'), equals(62));
    });

    test('should parse double accidentals', () {
      expect(parseScientificNotation('C𝄫4'), equals(58));
      expect(parseScientificNotation('C𝄪4'), equals(62));
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

  group('midi2name', () {
    test('should return a pitch name', () {
      expect(midi2name(0), equals('C-1'));
      expect(midi2name(12), equals('C0'));
      expect(midi2name(13), equals('C♯0'));
      expect(midi2name(23), equals('B0'));
      expect(midi2name(24), equals('C1'));
      expect(midi2name(36), equals('C2'));
      expect(midi2name(127), equals('G9'));
    });
  });

  group('name2midi', () {
    test('should return a midi number', () {
      expect(name2midi('C-1'), equals(0));
      expect(name2midi('C0'), equals(12));
      expect(name2midi('C♯0'), equals(13));
      expect(name2midi('B0'), equals(23));
      expect(name2midi('C1'), equals(24));
      expect(name2midi('C2'), equals(36));
      expect(name2midi('G9'), equals(127));
    });
  });


  group('Pitch', () {
    test('.parse should read pitch names in scientific notation', () {
      expect(Pitch.parse('C4').midiNumber, equals(60));
      expect(Pitch.parse('C5').midiNumber, equals(72));
      expect(Pitch.parse('E4').midiNumber, equals(64));
      expect(Pitch.parse('G5').midiNumber, equals(79));
      expect(Pitch.parse('C#4').midiNumber, equals(61));
      expect(Pitch.parse('C♯4').midiNumber, equals(61));
      expect(Pitch.parse('Cb4').midiNumber, equals(59));
      expect(Pitch.parse('C♭4').midiNumber, equals(59));
      expect(Pitch.parse('C𝄪4').midiNumber, equals(62));
      expect(Pitch.parse('C𝄫4').midiNumber, equals(58));
    });

    test('.parse should read pitch names in Helmholtz notation', () {
      expect(Pitch.parse('C,').midiNumber, equals(24));
      expect(Pitch.parse('D,').midiNumber, equals(26));
      expect(Pitch.parse('C').midiNumber, equals(36));
      expect(Pitch.parse('c').midiNumber, equals(48));
      expect(Pitch.parse('c♯').midiNumber, equals(49));
      expect(Pitch.parse('c♭').midiNumber, equals(47));
      expect(Pitch.parse("c'").midiNumber, equals(60));
      expect(Pitch.parse("c'''").midiNumber, equals(84));
      expect(Pitch.parse("d'''").midiNumber, equals(86));
      expect(Pitch.parse('C#,').midiNumber, equals(25));
      expect(Pitch.parse('C♯,').midiNumber, equals(25));
      expect(Pitch.parse('Cb,').midiNumber, equals(23));
      expect(Pitch.parse('C♭,').midiNumber, equals(23));
      expect(Pitch.parse('C𝄪,').midiNumber, equals(26));
      expect(Pitch.parse('C𝄫,').midiNumber, equals(22));
    });

    test('.fromMidiNumber should convert midi numbers into pitches', () {
      expect(new Pitch.fromMidiNumber(60), equals(Pitch.parse('C4')));
      expect(new Pitch.fromMidiNumber(72), equals(Pitch.parse('C5')));
      expect(new Pitch.fromMidiNumber(64), equals(Pitch.parse('E4')));
      expect(new Pitch.fromMidiNumber(79), equals(Pitch.parse('G5')));
    });

    test('#toString should return scientific notation', () {
      expect(new Pitch.fromMidiNumber(60).toString(), equals('C4'));
      expect(new Pitch.fromMidiNumber(72).toString(), equals('C5'));
      expect(new Pitch.fromMidiNumber(64).toString(), equals('E4'));
      expect(new Pitch.fromMidiNumber(79).toString(), equals('G5'));
      expect(new Pitch.fromMidiNumber(61).toString(), equals('C♯4'));
    });

    test('should add to an interval', () {
      expect((Pitch.parse('C4') + Interval.parse('P1')).toString(), equals('C4'));
      expect((Pitch.parse('C4') + Interval.parse('M2')).toString(), equals('D4'));
      expect((Pitch.parse('C4') + Interval.parse('P8')).toString(), equals('C5'));
    });

    test('#toPitch should return itself', () {
      expect(Pitch.parse('C4').toPitch(), equals(Pitch.parse('C4')));
    });

    test('#toPitchClass should return the pitch class', () {
      expect(Pitch.parse('C4').toPitchClass(), equals(PitchClass.parse('C')));
      expect(Pitch.parse('D4').toPitchClass(), equals(PitchClass.parse('D')));
    });
  });
}
