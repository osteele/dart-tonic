part of tonic;

/// A musical instrument. This is the superclass for FrettedInstrument,
/// and is used as a factory/dictionary of instruments.
class Instrument {
  final String name;

  static final Map _byName = <String, Instrument>{};

  Instrument({required this.name}) {
    _byName[name] = this;
  }

  static Instrument lookup(String name) {
    _initialize();
    final instrument = _byName[name];
    if (instrument == null) throw new Exception("No instrument named $name");
    return instrument;
  }

  bool get fretted => false;

  static final FrettedInstrument guitar = 
    Instrument.lookup('Guitar') as FrettedInstrument;

  static bool _initialized = false;

  static _initialize() {
    if (_initialized) return;
    _initialized = true;
    for (final spec in _instrumentSpecs) {
      final stringPitches = (spec['stringPitches'] as String)
          .split(new RegExp(r'\s+'))
          .map(Pitch.parse)
          .toList();
      new FrettedInstrument(
        name: spec['name'] as String, 
        stringPitches: stringPitches,
      );
    }
  }
}

/// A fretted instrument. Instances of this are used to compute chord frettings.
class FrettedInstrument extends Instrument {
  final List<Pitch> stringPitches;

  FrettedInstrument({required String name, required this.stringPitches}) : super(name: name);

  bool get fretted => true;

  /// The indices, starting at 0, of the strings.
  Iterable<int> get stringIndices =>
      new Iterable<int>.generate(stringPitches.length, (i) => i);

  /// The pitch of a given fret on a give (0-based) string.
  Pitch pitchAt({required int stringIndex, required int fretNumber}) =>
      stringPitches[stringIndex] + new Interval.fromSemitones(fretNumber);

  // eachFingerPosition: (fn) ->
  //   for string in @stringNumbers
  //     for fret in [0 .. @fretCount]
  //       fn string: string, fret: fret
}

/// This is used internal to create fretted instruments.
final _instrumentSpecs = [
  {
    'name': 'Guitar',
    // TODO: factor into Tuning model http://en.wikipedia.org/wiki/Stringed_instrument_tunings
    'stringPitches': 'E2 A2 D3 G3 B3 E4',
    'fretted': true,
    'fretCount': 12,
  },
  {
    'name': 'Violin',
    'stringPitches': 'G3 D4 A4 E5',
  },
  {
    'name': 'Viola',
    'stringPitches': 'C3 G3 D4 A4',
  },
  {
    'name': 'Cello',
    'stringPitches': 'C2 G2 D3 A3',
  }
];

// FretNumbers = [0..4]  # includes nut
// FretCount = FretNumbers.length - 1  # doesn't include nut

// intervalPositionsFromRoot = (instrument, rootPosition, semitones) ->
//   rootPitch = instrument.pitchAt(rootPosition)
//   positions = []
//   fretboard_positions_each (fingerPosition) ->
//     return unless intervalClassDifference(rootPitch, instrument.pitchAt(fingerPosition)) == semitones
//     positions.push fingerPosition
//   return positions
