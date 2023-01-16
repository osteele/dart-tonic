import 'package:test/test.dart';
import 'package:tonic/tonic.dart';

void main() {
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

    test('helmholtzName should return helmholtz notation', () {
      expect(Pitch.parse('C0').helmholtzName, equals("C,,"));
      expect(Pitch.parse('C1').helmholtzName, equals("C,"));
      expect(Pitch.parse('C2').helmholtzName, equals("C"));
      expect(Pitch.parse('C3').helmholtzName, equals("c"));
      expect(Pitch.parse('C4').helmholtzName, equals("c'"));
      expect(Pitch.parse('C5').helmholtzName, equals("c''"));
      expect(Pitch.parse('C6').helmholtzName, equals("c'''"));
      expect(Pitch.parse('C7').helmholtzName, equals("c''''"));
      expect(Pitch.parse('C8').helmholtzName, equals("c'''''"));
      expect(Pitch.parse('G5').helmholtzName, equals("g''"));
      expect(Pitch.parse('C♯4').helmholtzName, equals("c♯'"));
    });

    test('toPitch should return itself', () {
      expect(Pitch.parse('C4').toPitch(), equals(Pitch.parse('C4')));
    });

    test('toPitchClass should return the pitch class', () {
      expect(Pitch.parse('C4').toPitchClass(), equals(PitchClass.parse('C')));
      expect(Pitch.parse('D4').toPitchClass(), equals(PitchClass.parse('D')));
    });

    test('+ Interval should return a Pitch', () {
      expect((Pitch.parse('C4') + Interval.P1), equals(Pitch.parse('C4')));
      expect((Pitch.parse('C4') + Interval.m2), equals(Pitch.parse('D♭4')));
      expect((Pitch.parse('C4') + Interval.M2), equals(Pitch.parse('D4')));
      expect((Pitch.parse('C4') + Interval.m3), equals(Pitch.parse('E♭4')));
      expect((Pitch.parse('C4') + Interval.M3), equals(Pitch.parse('E4')));
      expect((Pitch.parse('C4') + Interval.P4), equals(Pitch.parse('F4')));
      expect((Pitch.parse('C4') + Interval.TT), equals(Pitch.parse('G♭4')));
      expect((Pitch.parse('C4') + Interval.P5), equals(Pitch.parse('G4')));
      expect((Pitch.parse('C4') + Interval.m6), equals(Pitch.parse('A♭4')));
      expect((Pitch.parse('C4') + Interval.M6), equals(Pitch.parse('A4')));
      expect((Pitch.parse('C4') + Interval.m7), equals(Pitch.parse('B♭4')));
      expect((Pitch.parse('C4') + Interval.M7), equals(Pitch.parse('B4')));
      expect((Pitch.parse('C4') + Interval.P8), equals(Pitch.parse('C5')));

      expect((Pitch.parse('E4') + Interval.P1), equals(Pitch.parse('E4')));
      expect((Pitch.parse('E4') + Interval.m2), equals(Pitch.parse('F4')));
      expect((Pitch.parse('E4') + Interval.M2), equals(Pitch.parse('F♯4')));
      expect((Pitch.parse('E4') + Interval.m3), equals(Pitch.parse('G4')));
      expect((Pitch.parse('E4') + Interval.M3), equals(Pitch.parse('G♯4')));
      expect((Pitch.parse('E4') + Interval.P4), equals(Pitch.parse('A4')));
      expect((Pitch.parse('E4') + Interval.TT), equals(Pitch.parse('B♭4')));
      expect((Pitch.parse('E4') + Interval.P5), equals(Pitch.parse('B4')));
      expect((Pitch.parse('E4') + Interval.m6), equals(Pitch.parse('C5')));
      expect((Pitch.parse('E4') + Interval.M6), equals(Pitch.parse('C♯5')));
      expect((Pitch.parse('E4') + Interval.m7), equals(Pitch.parse('D5')));
      expect((Pitch.parse('E4') + Interval.M7), equals(Pitch.parse('D♯5')));
      expect((Pitch.parse('E4') + Interval.P8), equals(Pitch.parse('E5')));

      expect((Pitch.parse('E♭4') + Interval.P1), equals(Pitch.parse('E♭4')));
      expect((Pitch.parse('E♯4') + Interval.P1), equals(Pitch.parse('E♯4')));
      expect((Pitch.parse('E𝄫4') + Interval.P1), equals(Pitch.parse('E𝄫4')));
      expect((Pitch.parse('E𝄪4') + Interval.P1), equals(Pitch.parse('E𝄪4')));

      expect((Pitch.parse('E♭4') + Interval.m2), equals(Pitch.parse('F♭4')));
      expect((Pitch.parse('E♯4') + Interval.m2), equals(Pitch.parse('F♯4')));
      expect((Pitch.parse('E𝄫4') + Interval.m2), equals(Pitch.parse('F𝄫4')));
      expect((Pitch.parse('E𝄪4') + Interval.m2), equals(Pitch.parse('F𝄪4')));

      expect((Pitch.parse('E♭4') + Interval.M2), equals(Pitch.parse('F4')));
      expect((Pitch.parse('E♯4') + Interval.M2), equals(Pitch.parse('F𝄪4')));
      expect((Pitch.parse('E𝄫4') + Interval.M2), equals(Pitch.parse('F♭4')));
      expect((Pitch.parse('E𝄪4') + Interval.M2), equals(Pitch.parse('F♯𝄪4')));
    });

    test('- Pitch should return an Interval', () {
      expect(Pitch.parse('C4') - Pitch.parse('C4'), Interval.P1);
      expect(Pitch.parse('C♯4') - Pitch.parse('C4'), Interval.m2);
      expect(Pitch.parse('C♯6') - Pitch.parse('C4'), Interval.m2);
      expect(Pitch.parse('D♭4') - Pitch.parse('C4'), Interval.m2);
      expect(Pitch.parse('D♭5') - Pitch.parse('C4'), Interval.m2);
      expect(Pitch.parse('C4') - Pitch.parse('B3'), Interval.m2);
      expect(Pitch.parse('C6') - Pitch.parse('B3'), Interval.m2);
      expect(Pitch.parse('C♯4') - Pitch.parse('B3'), Interval.M2);
      expect(Pitch.parse('C♯5') - Pitch.parse('B3'), Interval.M2);
      expect(Pitch.parse('D4') - Pitch.parse('C4'), Interval.M2);
      expect(Pitch.parse('D6') - Pitch.parse('C4'), Interval.M2);
      expect(Pitch.parse('D♯4') - Pitch.parse('C4'), Interval.m3);
      expect(Pitch.parse('D♯5') - Pitch.parse('C4'), Interval.m3);
      expect(Pitch.parse('D♭4') - Pitch.parse('B3'), Interval.M2);
      expect(Pitch.parse('D♭6') - Pitch.parse('B3'), Interval.M2);
      expect(Pitch.parse('D4') - Pitch.parse('B3'), Interval.m3);
      expect(Pitch.parse('D5') - Pitch.parse('B3'), Interval.m3);
      expect(Pitch.parse('D♯4') - Pitch.parse('B3'), Interval.M3);
      expect(Pitch.parse('D♯6') - Pitch.parse('B3'), Interval.M3);
      expect(Pitch.parse('D4') - Pitch.parse('A♯3'), Interval.M3);
      expect(Pitch.parse('D5') - Pitch.parse('A♯3'), Interval.M3);
      expect(Pitch.parse('D4') - Pitch.parse('A3'), Interval.P4);
      expect(Pitch.parse('D6') - Pitch.parse('A3'), Interval.P4);
      expect(Pitch.parse('D4') - Pitch.parse('G♯3'), Interval.d5);
      expect(Pitch.parse('D5') - Pitch.parse('G♯3'), Interval.d5);
      expect(Pitch.parse('D4') - Pitch.parse('G3'), Interval.P5);
      expect(Pitch.parse('D6') - Pitch.parse('G3'), Interval.P5);
      expect(Pitch.parse('D4') - Pitch.parse('F♯3'), Interval.m6);
      expect(Pitch.parse('D5') - Pitch.parse('F♯3'), Interval.m6);
      expect(Pitch.parse('D4') - Pitch.parse('F3'), Interval.M6);
      expect(Pitch.parse('D6') - Pitch.parse('F3'), Interval.M6);
      expect(Pitch.parse('D4') - Pitch.parse('E3'), Interval.m7);
      expect(Pitch.parse('D5') - Pitch.parse('E3'), Interval.m7);
      expect(Pitch.parse('D#4') - Pitch.parse('E3'), Interval.M7);
      expect(Pitch.parse('D#6') - Pitch.parse('E3'), Interval.M7);
      expect(Pitch.parse('D4') - Pitch.parse('D♯3'), Interval.M7);
      expect(Pitch.parse('D5') - Pitch.parse('D♯3'), Interval.M7);
      expect(Pitch.parse('C4') - Pitch.parse('C3'), Interval.P8);
      expect(Pitch.parse('C6') - Pitch.parse('C3'), Interval.P8);
      expect(Pitch.parse('C5') - Pitch.parse('C4'), Interval.P8);

      expect(Pitch.parse('C4') - Pitch.parse('D♭4'), Interval.m2);
      expect(Pitch.parse('C4') - Pitch.parse('D♭5'), Interval.m2);
      expect(Pitch.parse('C4') - Pitch.parse('D4'), Interval.M2);
      expect(Pitch.parse('C4') - Pitch.parse('D5'), Interval.M2);
      expect(Pitch.parse('C4') - Pitch.parse('D#4'), Interval.m3);
      expect(Pitch.parse('C4') - Pitch.parse('D#5'), Interval.m3);
      expect(Pitch.parse('C4') - Pitch.parse('E4'), Interval.M3);
      expect(Pitch.parse('C4') - Pitch.parse('E5'), Interval.M3);
      expect(Pitch.parse('C4') - Pitch.parse('F4'), Interval.P4);
      expect(Pitch.parse('C4') - Pitch.parse('F5'), Interval.P4);
      expect(Pitch.parse('C4') - Pitch.parse('F#4'), Interval.d5);
      expect(Pitch.parse('C4') - Pitch.parse('F#5'), Interval.d5);
      expect(Pitch.parse('C3') - Pitch.parse('G3'), Interval.P5);
      expect(Pitch.parse('C3') - Pitch.parse('G4'), Interval.P5);
      expect(Pitch.parse('C3') - Pitch.parse('G#3'), Interval.m6);
      expect(Pitch.parse('C3') - Pitch.parse('G#4'), Interval.m6);
      expect(Pitch.parse('C3') - Pitch.parse('A3'), Interval.M6);
      expect(Pitch.parse('C3') - Pitch.parse('A4'), Interval.M6);
      expect(Pitch.parse('C3') - Pitch.parse('A#3'), Interval.m7);
      expect(Pitch.parse('C3') - Pitch.parse('A#4'), Interval.m7);
      expect(Pitch.parse('C3') - Pitch.parse('B3'), Interval.M7);
      expect(Pitch.parse('C3') - Pitch.parse('B4'), Interval.M7);
    });
  });
}
