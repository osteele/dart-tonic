part of tonic_test;

void defineInstrumentTests() {
  group('Instrument', () {
    test('lookup should define a guitar', () {
      expect(Instrument.lookup('Guitar'), isInstrument);
    });
  });

  group('Guitar', () {
    var guitar = Instrument.Guitar;

    test('is an Instrument', () {
      expect(guitar, isInstrument);
    });

    test('is a FrettedInstrument', () {
      expect(guitar, isFrettedInstrument);
    });

    // test('should have a string count', () {
    //   expect(guitar.stringCount, equals(6));
    // });

    // test('should have an array of strings', () {
    //   expect(guitar.strings, equals(6));
    // });

    // test('should have a fret count', () {
    //   expect(guitar.fretCount, equals(12));
    // });

    // test('should have an array of strings', () {
      // guitar.stringNumbers.should.eql [0 .. 5]
    // });

    test('stringPitches should be a List of pitches', () {
      expect(guitar.stringPitches, isList);
      expect(guitar.stringPitches, hasLength(6));
      expect(guitar.stringPitches[0], equals(Pitch.parse('E2')));
      expect(guitar.stringPitches[5], equals(Pitch.parse('E4')));
    });

    test('pitchAt should return a Pitch', () {
      expect(guitar.pitchAt(string: 0, fret: 0), equals(Pitch.parse('E2')));
      expect(guitar.pitchAt(string: 0, fret: 1), equals(Pitch.parse('F2')));
      expect(guitar.pitchAt(string: 0, fret: 2), equals(Pitch.parse('F♯2')));
      expect(guitar.pitchAt(string: 0, fret: 5), equals(Pitch.parse('A2')));
      expect(guitar.pitchAt(string: 0, fret: 7), equals(Pitch.parse('B2')));
      expect(guitar.pitchAt(string: 0, fret: 12), equals(Pitch.parse('E3')));

      expect(guitar.pitchAt(string: 1, fret: 0), equals(Pitch.parse('A2')));
      expect(guitar.pitchAt(string: 1, fret: 1), equals(Pitch.parse('B♭2')));
      expect(guitar.pitchAt(string: 1, fret: 2), equals(Pitch.parse('B2')));
      expect(guitar.pitchAt(string: 1, fret: 5), equals(Pitch.parse('D3')));
      expect(guitar.pitchAt(string: 1, fret: 7), equals(Pitch.parse('E3')));
      expect(guitar.pitchAt(string: 1, fret: 12), equals(Pitch.parse('A3')));

      expect(guitar.pitchAt(string: 2, fret: 0), equals(Pitch.parse('D3')));
      expect(guitar.pitchAt(string: 2, fret: 1), equals(Pitch.parse('E♭3')));
      expect(guitar.pitchAt(string: 2, fret: 2), equals(Pitch.parse('E3')));
      expect(guitar.pitchAt(string: 2, fret: 5), equals(Pitch.parse('G3')));
      expect(guitar.pitchAt(string: 2, fret: 7), equals(Pitch.parse('A3')));
      expect(guitar.pitchAt(string: 2, fret: 12), equals(Pitch.parse('D4')));

      expect(guitar.pitchAt(string: 3, fret: 0), equals(Pitch.parse('G3')));
      expect(guitar.pitchAt(string: 3, fret: 1), equals(Pitch.parse('A♭3')));
      expect(guitar.pitchAt(string: 3, fret: 2), equals(Pitch.parse('A3')));
      expect(guitar.pitchAt(string: 3, fret: 5), equals(Pitch.parse('C4')));
      expect(guitar.pitchAt(string: 3, fret: 7), equals(Pitch.parse('D4')));
      expect(guitar.pitchAt(string: 3, fret: 12), equals(Pitch.parse('G4')));

      expect(guitar.pitchAt(string: 4, fret: 0), equals(Pitch.parse('B3')));
      expect(guitar.pitchAt(string: 4, fret: 1), equals(Pitch.parse('C4')));
      expect(guitar.pitchAt(string: 4, fret: 2), equals(Pitch.parse('C♯4')));
      expect(guitar.pitchAt(string: 4, fret: 5), equals(Pitch.parse('E4')));
      expect(guitar.pitchAt(string: 4, fret: 7), equals(Pitch.parse('F♯4')));
      expect(guitar.pitchAt(string: 4, fret: 12), equals(Pitch.parse('B4')));

      expect(guitar.pitchAt(string: 5, fret: 0), equals(Pitch.parse('E4')));
      expect(guitar.pitchAt(string: 5, fret: 1), equals(Pitch.parse('F4')));
      expect(guitar.pitchAt(string: 5, fret: 2), equals(Pitch.parse('F♯4')));
      expect(guitar.pitchAt(string: 5, fret: 5), equals(Pitch.parse('A4')));
      expect(guitar.pitchAt(string: 5, fret: 7), equals(Pitch.parse('B4')));
      expect(guitar.pitchAt(string: 5, fret: 12), equals(Pitch.parse('E5')));
    });

    // group('eachFingerPosition', () {
      // test('should iterate over each finger position', () {
        // count = 0
        // found = false
        // strings = []
        // frets = []
        // guitar.eachFingerPosition ({string, fret}) ->
        //   string.should.be.within 0, 5
        //   fret.should.be.within 0, 12
        //   strings[string] = true
        //   frets[fret] = true
        //   count += 1
        //   found or= string == 2 and fret == 3
        // count.should.equal 6 * 13
        // strings.should.have.length 6
        // frets.should.have.length 13
        // frets[0].should.be.true
        // frets[12].should.be.true
        // should.not.exist frets[13]
        // found.should.be.true
      // });
    // });
  });
}

class _IsInstrument extends TypeMatcher {
  const _IsInstrument() : super('Instrument');
  bool matches(item, Map matchState) => item is Instrument;
}
const isInstrument = const _IsInstrument();

class _IsFrettedInstrument extends TypeMatcher {
  const _IsFrettedInstrument() : super('FrettedInstrument');
  bool matches(item, Map matchState) => item is FrettedInstrument;
}
const isFrettedInstrument = const _IsFrettedInstrument();

class _IsList extends TypeMatcher {
  const _IsList() : super('List');
  bool matches(item, Map matchState) => item is List;
}
const isList = const _IsList();
