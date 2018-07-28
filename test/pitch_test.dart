part of tonic_test;

void definePitchTests() {
  group('flatNoteNames', () {
    test('should contain 12 pitches', () {
      expect(flatNoteNames, hasLength(12));
    });

    test('should start with C', () {
      expect(flatNoteNames[0], equals('C'));
    });

    test('should contain five flats', () {
      expect(flatNoteNames[1], equals('D♭'));
      expect(flatNoteNames[3], equals('E♭'));
      expect(flatNoteNames[6], equals('G♭'));
      expect(flatNoteNames[8], equals('A♭'));
      expect(flatNoteNames[10], equals('B♭'));
    });
  });

  group('sharpNoteNames', () {
    test('should contain 12 pitches', () {
      expect(sharpNoteNames, hasLength(12));
    });

    test('should start with C', () {
      expect(sharpNoteNames[0], equals('C'));
    });

    test('should contain five flats', () {
      expect(sharpNoteNames[1], equals('C♯'));
      expect(sharpNoteNames[3], equals('D♯'));
      expect(sharpNoteNames[6], equals('F♯'));
      expect(sharpNoteNames[8], equals('G♯'));
      expect(sharpNoteNames[10], equals('A♯'));
    });
  });

  group('NoteNames', () {
    test('should equal sharpNoteNames', () {
      expect(noteNames, equals(sharpNoteNames));
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
      expect(Pitch.parseScientificNotation('C4').midiNumber, equals(60));
      expect(Pitch.parseScientificNotation('D4').midiNumber, equals(62));
      expect(Pitch.parseScientificNotation('E4').midiNumber, equals(64));
      expect(Pitch.parseScientificNotation('F4').midiNumber, equals(65));
      expect(Pitch.parseScientificNotation('G4').midiNumber, equals(67));
      expect(Pitch.parseScientificNotation('A4').midiNumber, equals(69));
      expect(Pitch.parseScientificNotation('B4').midiNumber, equals(71));
    });

    test('should parse the octave', () {
      expect(Pitch.parseScientificNotation('C1').midiNumber, equals(24));
      expect(Pitch.parseScientificNotation('C2').midiNumber, equals(36));
      expect(Pitch.parseScientificNotation('C3').midiNumber, equals(48));
      expect(Pitch.parseScientificNotation('C4').midiNumber, equals(60));
      expect(Pitch.parseScientificNotation('C5').midiNumber, equals(72));
      expect(Pitch.parseScientificNotation('C6').midiNumber, equals(84));
    });

    test('should parse accidentals', () {
      expect(Pitch.parseScientificNotation('Cb4').midiNumber, equals(59));
      expect(Pitch.parseScientificNotation('C#4').midiNumber, equals(61));
      expect(Pitch.parseScientificNotation('C♭4').midiNumber, equals(59));
      expect(Pitch.parseScientificNotation('C♯4').midiNumber, equals(61));
      expect(Pitch.parseScientificNotation('C♭♭4').midiNumber, equals(58));
      expect(Pitch.parseScientificNotation('C♯♯4').midiNumber, equals(62));
    });

    test('should parse double accidentals', () {
      expect(Pitch.parseScientificNotation('C𝄫4').midiNumber, equals(58));
      expect(Pitch.parseScientificNotation('C𝄪4').midiNumber, equals(62));
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
    group('parse', () {
      test('should read pitch names in scientific notation', () {
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

      test('should read pitch names in Helmholtz notation', () {
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

      test('should preserve accidentals', () {
        expect(Pitch.parse('C5').toString(), equals('C5'));
        expect(Pitch.parse('C♯5').toString(), equals('C♯5'));
        expect(Pitch.parse('C♭5').toString(), equals('C♭5'));
        expect(Pitch.parse('C𝄪5').toString(), equals('C𝄪5'));
        expect(Pitch.parse('C𝄫5').toString(), equals('C𝄫5'));

        expect(Pitch.parse('C♭,').midiNumber, equals(23));
        expect(Pitch.parse('D♭,').midiNumber, equals(25));
        expect(Pitch.parse('C♭').midiNumber, equals(35));
        expect(Pitch.parse('c♭').midiNumber, equals(47));
        expect(Pitch.parse("c♭'").midiNumber, equals(59));
        // TODO: add sharp, doubles
      });

      test('should throw FormatException', () {
        expect(() => Pitch.parse('H'), throwsFormatException);
        expect(() => Pitch.parse('CC'), throwsFormatException);
        expect(() => Pitch.parse('C^'), throwsFormatException);
        expect(() => Pitch.parse('C+'), throwsFormatException);
        expect(() => Pitch.parse('+C'), throwsFormatException);
      });
    });

    test('fromMidiNumber should convert midi numbers into pitches', () {
      expect(new Pitch.fromMidiNumber(60), equals(Pitch.parse('C4')));
      expect(new Pitch.fromMidiNumber(72), equals(Pitch.parse('C5')));
      expect(new Pitch.fromMidiNumber(64), equals(Pitch.parse('E4')));
      expect(new Pitch.fromMidiNumber(79), equals(Pitch.parse('G5')));
    });

    test('toString should return scientific notation', () {
      expect(new Pitch.fromMidiNumber(60).toString(), equals('C4'));
      expect(new Pitch.fromMidiNumber(72).toString(), equals('C5'));
      expect(new Pitch.fromMidiNumber(64).toString(), equals('E4'));
      expect(new Pitch.fromMidiNumber(79).toString(), equals('G5'));
      expect(new Pitch.fromMidiNumber(61).toString(), equals('C♯4'));
    });

    test('toPitch should return itself', () {
      expect(Pitch.parse('C4').toPitch(), equals(Pitch.parse('C4')));
    });

    test('toPitchClass should return the pitch class', () {
      expect(Pitch.parse('C4').toPitchClass(), equals(PitchClass.parse('C')));
      expect(Pitch.parse('D4').toPitchClass(), equals(PitchClass.parse('D')));
    });

    test('+ Interval should return a Pitch', () {
      expect((Pitch.parse('C4') + Interval.iP1), equals(Pitch.parse('C4')));
      expect((Pitch.parse('C4') + Interval.im2), equals(Pitch.parse('D♭4')));
      expect((Pitch.parse('C4') + Interval.iM2), equals(Pitch.parse('D4')));
      expect((Pitch.parse('C4') + Interval.im3), equals(Pitch.parse('E♭4')));
      expect((Pitch.parse('C4') + Interval.iM3), equals(Pitch.parse('E4')));
      expect((Pitch.parse('C4') + Interval.iP4), equals(Pitch.parse('F4')));
      expect((Pitch.parse('C4') + Interval.iTT), equals(Pitch.parse('G♭4')));
      expect((Pitch.parse('C4') + Interval.iP5), equals(Pitch.parse('G4')));
      expect((Pitch.parse('C4') + Interval.im6), equals(Pitch.parse('A♭4')));
      expect((Pitch.parse('C4') + Interval.iM6), equals(Pitch.parse('A4')));
      expect((Pitch.parse('C4') + Interval.im7), equals(Pitch.parse('B♭4')));
      expect((Pitch.parse('C4') + Interval.iM7), equals(Pitch.parse('B4')));
      expect((Pitch.parse('C4') + Interval.iP8), equals(Pitch.parse('C5')));

      expect((Pitch.parse('E4') + Interval.iP1), equals(Pitch.parse('E4')));
      expect((Pitch.parse('E4') + Interval.im2), equals(Pitch.parse('F4')));
      expect((Pitch.parse('E4') + Interval.iM2), equals(Pitch.parse('F♯4')));
      expect((Pitch.parse('E4') + Interval.im3), equals(Pitch.parse('G4')));
      expect((Pitch.parse('E4') + Interval.iM3), equals(Pitch.parse('G♯4')));
      expect((Pitch.parse('E4') + Interval.iP4), equals(Pitch.parse('A4')));
      expect((Pitch.parse('E4') + Interval.iTT), equals(Pitch.parse('B♭4')));
      expect((Pitch.parse('E4') + Interval.iP5), equals(Pitch.parse('B4')));
      expect((Pitch.parse('E4') + Interval.im6), equals(Pitch.parse('C5')));
      expect((Pitch.parse('E4') + Interval.iM6), equals(Pitch.parse('C♯5')));
      expect((Pitch.parse('E4') + Interval.im7), equals(Pitch.parse('D5')));
      expect((Pitch.parse('E4') + Interval.iM7), equals(Pitch.parse('D♯5')));
      expect((Pitch.parse('E4') + Interval.iP8), equals(Pitch.parse('E5')));

      expect((Pitch.parse('E♭4') + Interval.iP1), equals(Pitch.parse('E♭4')));
      expect((Pitch.parse('E♯4') + Interval.iP1), equals(Pitch.parse('E♯4')));
      expect((Pitch.parse('E𝄫4') + Interval.iP1), equals(Pitch.parse('E𝄫4')));
      expect((Pitch.parse('E𝄪4') + Interval.iP1), equals(Pitch.parse('E𝄪4')));

      expect((Pitch.parse('E♭4') + Interval.im2), equals(Pitch.parse('F♭4')));
      expect((Pitch.parse('E♯4') + Interval.im2), equals(Pitch.parse('F♯4')));
      expect((Pitch.parse('E𝄫4') + Interval.im2), equals(Pitch.parse('F𝄫4')));
      expect((Pitch.parse('E𝄪4') + Interval.im2), equals(Pitch.parse('F𝄪4')));

      expect((Pitch.parse('E♭4') + Interval.iM2), equals(Pitch.parse('F4')));
      expect((Pitch.parse('E♯4') + Interval.iM2), equals(Pitch.parse('F𝄪4')));
      expect((Pitch.parse('E𝄫4') + Interval.iM2), equals(Pitch.parse('F♭4')));
      expect((Pitch.parse('E𝄪4') + Interval.iM2), equals(Pitch.parse('F♯𝄪4')));
    });

    test('- Pitch should return an Interval', () {
      expect(Pitch.parse('C4') - Pitch.parse('C4'), Interval.iP1);
      expect(Pitch.parse('C♯4') - Pitch.parse('C4'), Interval.a1);
      expect(Pitch.parse('D♭4') - Pitch.parse('C4'), Interval.im2);
      expect(Pitch.parse('D4') - Pitch.parse('C4'), Interval.iM2);
      expect(Pitch.parse('D♯4') - Pitch.parse('C4'), Interval.a2);
      expect(Pitch.parse('C5') - Pitch.parse('C4'), Interval.iP8);

      expect(Pitch.parse('C4') - Pitch.parse('B3'), Interval.im2);
      expect(Pitch.parse('C♯4') - Pitch.parse('B3'), Interval.iM2);
      expect(Pitch.parse('D♭4') - Pitch.parse('B3'), Interval.d3);
      expect(Pitch.parse('D4') - Pitch.parse('B3'), Interval.im3);
      expect(Pitch.parse('D♯4') - Pitch.parse('B3'), Interval.iM3);
    });
  });
}
