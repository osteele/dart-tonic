// part of tonic_test;
import 'package:test/test.dart';
import 'package:tonic/tonic.dart';

void defineScaleTests() {
  group('ScalePattern', () {
    test('should contains various blues and diatonic scales', () {
      expect(ScalePattern.findByName('Diatonic Major'), isNotNull);
      expect(ScalePattern.findByName('Natural Minor'), isNotNull);
      expect(ScalePattern.findByName('Major Pentatonic'), isNotNull);
      expect(ScalePattern.findByName('Diatonic Major'), isNotNull);
      expect(ScalePattern.findByName('Minor Pentatonic'), isNotNull);
      expect(ScalePattern.findByName('Melodic Minor'), isNotNull);
      expect(ScalePattern.findByName('Harmonic Minor'), isNotNull);
      expect(ScalePattern.findByName('Blues'), isNotNull);
      expect(ScalePattern.findByName('Freygish'), isNotNull);
      expect(ScalePattern.findByName('Whole Tone'), isNotNull);
      expect(ScalePattern.findByName('Octatonic'), isNotNull);
    });
  });

  group('Diatonic Major Scale', () {
    var scalePattern = ScalePattern.findByName('Diatonic Major');

    test('should exist', () {
      expect(scalePattern, isNotNull);
    });

    test('should contain seven intervals', () {
      expect(scalePattern.intervals, hasLength(7));
      expect(scalePattern.intervals, contains(Interval.parse('P1')));
      expect(scalePattern.intervals, contains(Interval.parse('M2')));
      expect(scalePattern.intervals, contains(Interval.parse('M3')));
      expect(scalePattern.intervals, contains(Interval.parse('P4')));
      expect(scalePattern.intervals, contains(Interval.parse('P5')));
      expect(scalePattern.intervals, contains(Interval.parse('M6')));
      expect(scalePattern.intervals, contains(Interval.parse('M7')));
    });

    test('should contain the modern modes', () {
      expect(scalePattern.modes, hasLength(7));
      expect(scalePattern.modes, contains('Ionian'));
      expect(scalePattern.modes, contains('Dorian'));
      expect(scalePattern.modes, contains('Phrygian'));
      expect(scalePattern.modes, contains('Lydian'));
      expect(scalePattern.modes, contains('Mixolydian'));
      expect(scalePattern.modes, contains('Aeolian'));
      expect(scalePattern.modes, contains('Locrian'));

      expect(
          scalePattern.modes['Ionian'].intervals,
          equals([
            Interval.P1,
            Interval.M2,
            Interval.M3,
            Interval.P4,
            Interval.P5,
            Interval.M6,
            Interval.M7
          ]));
      expect(
          scalePattern.modes['Dorian'].intervals,
          equals([
            Interval.P1,
            Interval.M2,
            Interval.m3,
            Interval.P4,
            Interval.P5,
            Interval.M6,
            Interval.m7
          ]));
      expect(
          scalePattern.modes['Phrygian'].intervals,
          equals([
            Interval.P1,
            Interval.m2,
            Interval.m3,
            Interval.P4,
            Interval.P5,
            Interval.m6,
            Interval.m7
          ]));
      expect(
          scalePattern.modes['Lydian'].intervals,
          equals([
            Interval.P1,
            Interval.M2,
            Interval.M3,
            Interval.A4,
            Interval.P5,
            Interval.M6,
            Interval.M7
          ]));
      expect(
          scalePattern.modes['Mixolydian'].intervals,
          equals([
            Interval.P1,
            Interval.M2,
            Interval.M3,
            Interval.P4,
            Interval.P5,
            Interval.M6,
            Interval.m7
          ]));
      expect(
          scalePattern.modes['Aeolian'].intervals,
          equals([
            Interval.P1,
            Interval.M2,
            Interval.m3,
            Interval.P4,
            Interval.P5,
            Interval.m6,
            Interval.m7
          ]));
      expect(
          scalePattern.modes['Locrian'].intervals,
          equals([
            Interval.P1,
            Interval.m2,
            Interval.m3,
            Interval.P4,
            Interval.d5,
            Interval.m6,
            Interval.m7
          ]));
    });

    group('at E', () {
      var scale = scalePattern.at(PitchClass.parse('E'));
      // chords = scale.chords()

      test('should contain a tonic pitch', () {
        expect(scale.tonic.toString(), equals('E'));
      });

      test('should contain seven pitch classes', () {
        expect(scale.pitchClasses, hasLength(7));
        expect(scale.pitchClasses, contains(PitchClass.parse('E')));
        expect(scale.pitchClasses, contains(PitchClass.parse('F♯')));
        expect(scale.pitchClasses, contains(PitchClass.parse('G♯')));
        expect(scale.pitchClasses, contains(PitchClass.parse('A')));
        expect(scale.pitchClasses, contains(PitchClass.parse('B')));
        expect(scale.pitchClasses, contains(PitchClass.parse('C♯')));
        expect(scale.pitchClasses, contains(PitchClass.parse('D♯')));
      });

      //     test('should contain seven chords', () {
      //       expect(chords, hasLength(7));
      //       chords[0].should.be.an.instanceOf Chord
      //     });

      //     test('should contain the correct chord sequence', () {
      //       chords[0].name.should.equal 'E Major'
      //       chords[1].name.should.equal 'F♯ Minor'
      //       chords[2].name.should.equal 'G♯ Minor'
      //       chords[3].name.should.equal 'A Major'
      //       chords[4].name.should.equal 'B Major'
      //       chords[5].name.should.equal 'C♯ Minor'
      //       chords[6].name.should.equal 'D♯ Dim'
      //     });
    });
  });

  // group('Natural Minor scale pattern', () {
  //   test('is a mode of the Major Pentatonic', () {
  //     var scale = ScalePattern.findByName('Natural Minor');
  //     expect(scale, isMode);
  //   });
  // });

  // group('Scale.fromRomanNumeral', () {
  //   scale = Scales.DiatonicMajor.at('E4')

  //   test('should create major chords', () {
  //     # Chord.fromRomanNumeral('I', scale)
  //     Chord.fromRomanNumeral('I', scale).should.eql Chord.fromString('E4 Major'), 'I'
  //     Chord.fromRomanNumeral('II', scale).should.eql Chord.fromString('F♯4 Major'), 'II'
  //     Chord.fromRomanNumeral('IV', scale).should.eql Chord.fromString('A4 Major'), 'IV'
  //     Chord.fromRomanNumeral('V', scale).should.eql Chord.fromString('B4 Major'), 'V'
  //     Chord.fromRomanNumeral('VI', scale).should.eql Chord.fromString('C♯5 Major'), 'VI'
  //   });

  //   test('should create minor chords', () {
  //     Chord.fromRomanNumeral('i', scale).should.eql Chord.fromString('E4 Minor'), 'i'
  //     Chord.fromRomanNumeral('ii', scale).should.eql Chord.fromString('F♯4 Minor'), 'ii'
  //     Chord.fromRomanNumeral('vi', scale).should.eql Chord.fromString('C♯5 Minor'), 'vi'
  //   });

  //   test('should create diminished chords', () {
  //     Chord.fromRomanNumeral('vii°', scale).should.eql Chord.fromString('D♯5°'), 'vi°'
  //     Chord.fromRomanNumeral('iv°', scale).should.eql Chord.fromString('A4°'), 'iv°'
  //   });

  //   // test('should create inversions', () {
  //   //   # Chord.fromRomanNumeral('ib', scale).should.eql Chord.fromString('E4 Minor'), 'i'
  //   //   # Chord.fromRomanNumeral('ic', scale).should.eql Chord.fromString('F♯4 Minor'), 'ii'
  //   //   # Chord.fromRomanNumeral('id', scale).should.eql Chord.fromString('C♯5 Minor'), 'vi'
  // });

  // group('Chord.progression', () {
  //   test('should do its stuff', () {
  //     chords = Chord.progression('I ii iii IV', Scales.DiatonicMajor.at('E4'))
  //     expect(chords, hasLength(4));
  //     # chords.should.eql 'E4 F♯4m G4m A'.split(/\s/).map(Chord.fromString)
  //   });
  // });
}
