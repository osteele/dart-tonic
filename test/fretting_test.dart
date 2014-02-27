part of tonic_test;

void defineFrettingTests() {
  group('Fingering', () {
    var chord = Chord.parse('E Major');
    var instrument = Instrument.Guitar;
    var fretting = bestFrettingFor(chord, instrument);

    test('should have a chord property', () {
      expect(fretting.chord, equals(chord));
    });

    test('should have an instrument property', () {
      expect(fretting.instrument, equals(instrument));
    });

    // test('should have an array of barres', () {
    //   fretting.barres.should.be.an.Array
    // });

    // test('should have a fretstring', () {
    //   fretting.fretstring.should.be.a.String
    //   fretting.fretstring.should.match /^[\dx]{6}$/
    // });

    test('should have an inversion', () {
      // fretting.positions.should.be.an.Array
    });

    test('should have an inversion letter', () {
      // fretting.positions.should.be.an.Array
    });

    // test('should have a properties dictioary', () {
    //   fretting.properties.should.be.an.Object
    // });

    // group('positions', () {
    //   test('should be an array', () {
    //     fretting.positions.should.be.an.Array
    //   });

    //   test('should have fret and string properties'), () {
    //     # fretting.positions[0].should.have.properties 'fret', 'string', 'intervalClass'
    //   });
    // });

  // group('bestFrettingFor', () {
  //   group('E Major', () {
  //     var fretting = bestFrettingFor(Chord.fromString('E Major'), Instruments.Guitar)

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
  //   });
  });
}
