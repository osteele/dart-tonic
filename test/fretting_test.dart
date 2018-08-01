import 'package:test/test.dart';
import 'package:tonic/tonic.dart';

void main() {
  group('Fretting', () {
    var chord = Chord.parse('E Major');
    var instrument = Instrument.guitar;
    var fretting =
        Fretting.fromFretString('0221x0', chord: chord, instrument: instrument);

    test('chord', () {
      expect(fretting.chord, equals(chord));
    });

    test('instrument', () {
      expect(fretting.instrument, equals(instrument));
    });

    test('positions', () {
      expect(fretting.positions, hasLength(5));
      expect(fretting.positions.map((pos) => pos.stringIndex),
          equals([0, 1, 2, 3, 5]));
      expect(fretting.positions.map((pos) => pos.fretNumber),
          equals([0, 2, 2, 1, 0]));
    });

    group('parse', () {
      test('throws FormatException', () {
        expect(
            () => Fretting.fromFretString('xxx',
                chord: chord, instrument: instrument),
            throwsFormatException);
        expect(
            () => Fretting.fromFretString('xxxxxxx',
                chord: chord, instrument: instrument),
            throwsFormatException);
        expect(
            () => Fretting.fromFretString('132e56',
                chord: chord, instrument: instrument),
            throwsFormatException);
      });
    });

    test('fretstring', () {
      expect(
          Fretting.fromFretString('0221x0',
                  chord: chord, instrument: instrument)
              .fretString,
          equals('0221x0'));
      expect(
          Fretting.fromFretString('x221x0',
                  chord: chord, instrument: instrument)
              .fretString,
          equals('x221x0'));
      expect(
          Fretting.fromFretString('0221xx',
                  chord: chord, instrument: instrument)
              .fretString,
          equals('0221xx'));
    });

    test('inversionIndex', () {
      expect(
          Fretting.fromFretString('022100',
                  chord: chord, instrument: instrument)
              .inversionIndex,
          0);
      expect(
          Fretting.fromFretString('422100',
                  chord: chord, instrument: instrument)
              .inversionIndex,
          1);
      expect(
          Fretting.fromFretString('722100',
                  chord: chord, instrument: instrument)
              .inversionIndex,
          2);
    });

    // test('should have an inversion letter', () {
    // fretting.positions.should.be.an.Array
    // });
  });

  test('chordFrettings', () {
    var chord = Chord.parse('E Major');
    var instrument = Instrument.guitar;
    var frettings = chordFrettings(chord, instrument);
    // print(orderedFrettings);

    expect(frettings.length, inInclusiveRange(10, 250));
    expect(frettings[0].fretString, equals('022100'));
    expect(frettings.map((f) => f.fretString), contains('022104'));
    expect(frettings.map((f) => f.fretString), contains('x22100'));
    expect(frettings.map((f) => f.fretString), contains('x2210x'));
    expect(frettings.map((f) => f.fretString), contains('422100'));
  });

  test('bestFrettingFor', () {
    var chord = Chord.parse('E Major');
    var instrument = Instrument.guitar;
    var fretting = bestFrettingFor(chord, instrument);

    expect(fretting, isNotNull);
    expect(fretting.fretString, equals('022100'));

    // test('should have an array of barres', () {
    //   fretting.barres.should.be.an.Array
    // });

//     test('should have fingers at 022100', () {
//       expect(fretting.positions, hasLength(6));
//       expect(fretting.positions[0].string, equals(0)); // 'finger #1 string'
//       expect(fretting.positions[0].fret, equals(0)); // 'finger #1 fret'
//       expect(fretting.positions[0].intervalClass, equals(Interval.P1))); // 'finger #1 intervalClass'

//       expect(fretting.positions[1].string, equals(1)); // 'finger #2 string'
//       expect(fretting.positions[1].fret, equals(2)); // 'finger #2 fret'
//       expect(fretting.positions[1].intervalClass, equals(Interval.P5))); // 'finger #2 intervalClass'

//       expect(fretting.positions[2].string, equals(2)); // 'finger #3 string'
//       expect(fretting.positions[2].fret, equals(2)); // 'finger #3 fret'
//       expect(fretting.positions[2].intervalClass, equals(Interval.P1))); // 'finger #3 intervalClass'

//       expect(fretting.positions[3].string, equals(3)); // 'finger #4 string'
//       expect(fretting.positions[3].fret, equals(1)); // 'finger #4 fret'
//       expect(fretting.positions[3].intervalClass, equals(Interval.M3))); // 'finger #4 intervalClass'

//       expect(fretting.positions[4].string, equals(4)); // 'finger #5 string'
//       expect(fretting.positions[4].fret, equals(0)); // 'finger #5 fret'
//       expect(fretting.positions[4].intervalClass, equals(Interval.P5))); // 'finger #5 intervalClass'

//       expect(fretting.positions[5].string, equals(5)); // 'finger #6 string'
//       expect(fretting.positions[5].fret, equals(0)); // 'finger #6 fret'
//       expect(fretting.positions[5].intervalClass, equals(Interval.P1))); // 'finger #6 intervalClass'
//     });

//     test('should have no barres', () {
//       expect(fretting.barres, hasLength(0));
//     });

//     test('properties', () {
//       expect(fretting.properties.root, equals(true));
//       expect(fretting.properties.barres, equals(0));
//       expect(fretting.properties.fingers, equals(3));
//       expect(fretting.properties.skipping, equals(false));
//       expect(fretting.properties.muting, equals(false));
//       expect(fretting.properties.open, equals(true));
//       expect(fretting.properties.triad, equals(false));
//       expect(fretting.properties.position, equals(0));
//       expect(fretting.properties.strings, equals(6));
//     });
  });
}
