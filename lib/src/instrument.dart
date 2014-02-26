part of tonic;

class Instrument {
  final String name;

  static final Map _byName = <String, Instrument>{};

  Instrument({String this.name}) {
    _byName[name] = this;
  }

  static Instrument lookup(String name) {
    _initialize();
    var instrument = _byName[name];
    if (instrument == null) throw new Exception("No instrument named $name");
    return instrument;
  }

  bool get fretted => false;

  static final FrettedInstrument Guitar = Instrument.lookup('Guitar');

  static bool _initialized = false;

  static _initialize() {
    if (_initialized) return;
    _initialized = true;
    for (var spec in _INSTRUMENT_SPECS) {
      var stringPitches = spec['stringPitches'].split(new RegExp(r'\s+')).map(Pitch.parse).toList();
      new FrettedInstrument(name: spec['name'], stringPitches: stringPitches);
    }
  }
}

class FrettedInstrument extends Instrument {
  final List<Pitch> stringPitches;

  FrettedInstrument({String name, List<Pitch> this.stringPitches})
    : super(name: name);

  bool get fretted => true;

  Pitch pitchAt({int string, int fret}) =>
    stringPitches[string] + new Interval.fromSemitones(fret);

  // eachFingerPosition: (fn) ->
  //   for string in @stringNumbers
  //     for fret in [0 .. @fretCount]
  //       fn string: string, fret: fret
}

final _INSTRUMENT_SPECS = [
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
