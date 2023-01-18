import 'package:test/test.dart';
import 'package:tonic/tonic.dart';
import 'matchers.dart';

void main() {
  group('ChordPattern', () {
    group('parse', () {
      test('should recognize chord names', () {
        expect(ChordPattern.parse('Major'), isChordPattern);
        expect(ChordPattern.parse('Major 6'), isChordPattern);
        expect(ChordPattern.parse('Major 6(9)'), isChordPattern);
        expect(ChordPattern.parse('Major 6(11)'), isChordPattern);
        expect(ChordPattern.parse('Major 7'), isChordPattern);
        expect(ChordPattern.parse('Major 7(9)'), isChordPattern);
        expect(ChordPattern.parse('Major 7(9)(#11)'), isChordPattern);
        expect(ChordPattern.parse('Major 7(#9)'), isChordPattern);
        expect(ChordPattern.parse('Major 7(#11)'), isChordPattern);

        expect(ChordPattern.parse('minor'), isChordPattern);
        expect(ChordPattern.parse('minor ♭6'), isChordPattern);
        expect(ChordPattern.parse('minor 6'), isChordPattern);
        expect(ChordPattern.parse('minor 6(9)'), isChordPattern);
        expect(ChordPattern.parse('minor 6(11)'), isChordPattern);
        expect(ChordPattern.parse('minor 7'), isChordPattern);
        expect(ChordPattern.parse('minor 7(♭5)'), isChordPattern);
        expect(ChordPattern.parse('minor 7(♭9)'), isChordPattern);
        expect(ChordPattern.parse('minor 7(9)'), isChordPattern);
        expect(ChordPattern.parse('minor 7(11)'), isChordPattern);

        expect(ChordPattern.parse('Augmented'), isChordPattern);
        expect(ChordPattern.parse('Augmented 7'), isChordPattern);
        expect(ChordPattern.parse('Diminished'), isChordPattern);
        expect(ChordPattern.parse('Diminished 7'), isChordPattern);
        expect(ChordPattern.parse('Diminished 7(♭13)'), isChordPattern);

        expect(ChordPattern.parse('Sus2'), isChordPattern);
        expect(ChordPattern.parse('Sus4'), isChordPattern);
        expect(ChordPattern.parse('6Sus2'), isChordPattern);
        expect(ChordPattern.parse('6Sus4'), isChordPattern);
        expect(ChordPattern.parse('7Sus4'), isChordPattern);
        expect(ChordPattern.parse('Dominant 7(9)Sus4'), isChordPattern);

        expect(ChordPattern.parse('Dominant 7'), isChordPattern);
        expect(ChordPattern.parse('Dominant 7(♭9)'), isChordPattern);
        expect(ChordPattern.parse('Dominant 7(9)'), isChordPattern);
        expect(ChordPattern.parse('Dominant 7(9)(13)'), isChordPattern);
        expect(ChordPattern.parse('Dominant 7(#9)'), isChordPattern);
        expect(ChordPattern.parse('Dominant 7(#11)'), isChordPattern);
        expect(ChordPattern.parse('Dominant 7(♭13)'), isChordPattern);
        expect(ChordPattern.parse('Dominant 7(13)'), isChordPattern);

        expect(ChordPattern.parse('minor Major 7(#11)'), isChordPattern);
        expect(ChordPattern.parse('minor Major 7'), isChordPattern);
      });

      test('should recognize chord abbreviations', () {
        expect(ChordPattern.parse('M'), isChordPattern);
        expect(ChordPattern.parse('aug'), isChordPattern);
        expect(ChordPattern.parse('°'), isChordPattern);
      });

      test('should throw FormatException', () {
        expect(() => ChordPattern.parse('X'), throwsFormatException);
        expect(() => ChordPattern.parse('E Major'), throwsFormatException);
        expect(() => ChordPattern.parse('Major E'), throwsFormatException);
      });
    });

    test('toString', () {
      expect(ChordPattern.parse('Major').fullName, equals('Major'));
      expect(ChordPattern.parse('minor').fullName, equals('minor'));
      expect(ChordPattern.parse('Augmented').fullName, equals('Augmented'));
      expect(ChordPattern.parse('Diminished').fullName, equals('Diminished'));
    });

    group('fromIntervals', () {
      test('should index chord classes by interval sequence', () {
        expect(
            ChordPattern.fromIntervals([Interval.P1, Interval.M3, Interval.P5])
                .name,
            equals(ChordPattern.parse('Major').name));
        expect(
            ChordPattern.fromIntervals([Interval.P1, Interval.m3, Interval.P5])
                .name,
            equals(ChordPattern.parse('minor').name));
        expect(
            ChordPattern.fromIntervals(
                [Interval.P1, Interval.m3, Interval.P5, Interval.m7]).name,
            equals(ChordPattern.parse('minor 7').name));
        expect(
            ChordPattern.fromIntervals(
                [Interval.P1, Interval.m3, Interval.P5, Interval.M7]).name,
            equals(ChordPattern.parse('minor Major 7').name));
        expect(
            ChordPattern.fromIntervals(
                [Interval.P1, Interval.M3, Interval.P5, Interval.m7]).name,
            equals(ChordPattern.parse('Dominant 7').name));
        expect(
            ChordPattern.fromIntervals(
                [Interval.P1, Interval.M3, Interval.P5, Interval.M7]).name,
            equals(ChordPattern.parse('Major 7').name));
      });

      test('should recognize inversions', () {
        expect(
            ChordPattern.fromIntervals([Interval.m3, Interval.P1, Interval.P5]),
            equals(ChordPattern.parse('minor')));
        expect(
            ChordPattern.fromIntervals([Interval.m3, Interval.P5, Interval.P1]),
            equals(ChordPattern.parse('minor')));
      });
    });
  });

  group('Chord', () {
    group('parse', () {
      test('should convert from scientific pitch chord names', () {
        expect(Chord.parse('E4'), isChord);
        expect(Chord.parse('E4').pattern, equals(ChordPattern.parse('Major')));
        expect(Chord.parse('E4').root, equals(Pitch.parse('E4')));

        expect(Chord.parse('E4 Major').pattern,
            equals(ChordPattern.parse('Major')));
        expect(Chord.parse('E4Major').pattern,
            equals(ChordPattern.parse('Major')));
        expect(Chord.parse('E4 minor').pattern,
            equals(ChordPattern.parse('minor')));
      });

      test('should convert from Helmoltz pitch names', () {
        expect(Chord.parse('E'), isChord);
        expect(Chord.parse('E').pattern, equals(ChordPattern.parse('Major')));
        expect(Chord.parse('E').root, equals(Pitch.parse('E2')));

        expect(Chord.parse("E'").root, equals(Pitch.parse('E3')));
        expect(Chord.parse("c'").root, equals(Pitch.parse('C4')));
      });

      test('should throw FormatException', () {
        expect(() => Chord.parse('X'), throwsFormatException);
        expect(() => Chord.parse('Major'), throwsFormatException);
        expect(() => Chord.parse('X Major'), throwsFormatException);
        expect(() => Chord.parse('Major E'), throwsFormatException);
      });
    });

    group('fromPitches', () {
      test('should find the chord from an array of pitches', () {
        expect(
            Chord.fromPitches(
                    [Pitch.parse('A3'), Pitch.parse('C♯4'), Pitch.parse('E4')])
                .pattern,
            equals(ChordPattern.parse('Major')));
        expect(
            Chord.fromPitches(
                    [Pitch.parse('A3'), Pitch.parse('C4'), Pitch.parse('E4')])
                .pattern,
            equals(ChordPattern.parse('minor')));
      });

      test('should recognize pitches spread across multiple otaves', () {
        expect(
            Chord.fromPitches(
                    [Pitch.parse('A3'), Pitch.parse('C♯4'), Pitch.parse('E4')])
                .pattern,
            equals(ChordPattern.parse('Major')));
        expect(
            Chord.fromPitches(
                    [Pitch.parse('A3'), Pitch.parse('C♯5'), Pitch.parse('E4')])
                .pattern,
            equals(ChordPattern.parse('Major')));
        expect(
            Chord.fromPitches(
                    [Pitch.parse('A3'), Pitch.parse('C♯4'), Pitch.parse('E5')])
                .pattern,
            equals(ChordPattern.parse('Major')));
        expect(
            Chord.fromPitches(
                    [Pitch.parse('A3'), Pitch.parse('C4'), Pitch.parse('E4')])
                .pattern,
            equals(ChordPattern.parse('minor')));
        expect(
            Chord.fromPitches(
                    [Pitch.parse('A3'), Pitch.parse('C5'), Pitch.parse('E4')])
                .pattern,
            equals(ChordPattern.parse('minor')));
        expect(
            Chord.fromPitches(
                    [Pitch.parse('A3'), Pitch.parse('C4'), Pitch.parse('E5')])
                .pattern,
            equals(ChordPattern.parse('minor')));
      });

      test('should recognize inversions', () {
        expect(
            Chord.fromPitches(
                    [Pitch.parse('A3'), Pitch.parse('C♯4'), Pitch.parse('E4')])
                .pattern,
            equals(ChordPattern.parse('Major')));
        expect(
            Chord.fromPitches(
                    [Pitch.parse('C♯4'), Pitch.parse('A3'), Pitch.parse('E4')])
                .pattern,
            equals(ChordPattern.parse('min ♭6')));
        expect(
            Chord.fromPitches(
                    [Pitch.parse('E4'), Pitch.parse('A3'), Pitch.parse('C♯4')])
                .pattern,
            equals(ChordPattern.parse('6Sus4')));
      });
    });
  });

  group('Major Chord Pattern', () {
    final chordPattern = ChordPattern.parse('Major');

    test('should be a ChordPattern', () {
      expect(chordPattern, isChordPattern);
    });

    test('should have a name', () {
      expect(chordPattern.name, equals('Maj'));
    });

    test('should have a fullName', () {
      expect(chordPattern.fullName, equals('Major'));
    });

    test('should have a set of abbreviations', () {
      expect(chordPattern.abbrs, equals(['', 'M']));
    });

    test('should have a default abbreviation', () {
      expect(chordPattern.abbr, equals(''));
    });

    test('should contain three intervals', () {
      expect(chordPattern.intervals,
          equals([Interval.P1, Interval.M3, Interval.P5]));
    });

    group('at E4', () {
      final chord = chordPattern.at(Pitch.parse('E4'));

      test('should have a root', () {
        expect(chord.root, equals(Pitch.parse('E4')));
      });

      test('should have a name', () {
        expect(chord.name, equals('E4 Maj'));
      });

      test('should have a fullName', () {
        expect(chord.fullName, equals('E4 Major'));
      });

      test('should have an abbreviated name', () {
        expect(chord.abbr, equals('E4'));
      });

      test('should contain three intervals', () {
        expect(
            chord.intervals, equals([Interval.P1, Interval.M3, Interval.P5]));
      });

      test('should contain three pitches', () {
        expect(chord.pitches,
            equals([Pitch.parse('E4'), Pitch.parse('G♯4'), Pitch.parse('B4')]));
      });
    });

    group('at C4', () {
      final chord = chordPattern.at(Pitch.parse('C4'));

      test('should have a root', () {
        expect(chord.root, equals(Pitch.parse('C4')));
      });

      test('should have a name', () {
        expect(chord.name, equals('C4 Maj'));
      });

      test('should have a fullName', () {
        expect(chord.fullName, equals('C4 Major'));
      });

      test('should have an abbreviated name', () {
        expect(chord.abbr, equals('C4'));
      });

      test('should contain three intervals', () {
        expect(
            chord.intervals, equals([Interval.P1, Interval.M3, Interval.P5]));
      });

      test('should contain three pitches', () {
        expect(chord.pitches,
            equals([Pitch.parse('C4'), Pitch.parse('E4'), Pitch.parse('G4')]));
      });
    });
  });

  group('minor Chord', () {
    final chordPattern = ChordPattern.parse('minor');

    group('at C4', () {
      final chord = chordPattern.at(Pitch.parse('C4'));

      test('should have a root', () {
        expect(chord.root, equals(Pitch.parse('C4')));
      });

      test('should have a name', () {
        expect(chord.name, equals('C4 min'));
      });

      test('should contain three intervals', () {
        expect(
            chord.intervals, equals([Interval.P1, Interval.m3, Interval.P5]));
      });

      test('should contain three pitches', () {
        expect(chord.pitches,
            equals([Pitch.parse('C4'), Pitch.parse('E♭4'), Pitch.parse('G4')]));
      });
    });
  });
}
