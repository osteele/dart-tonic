part of tonic;

class ScalePattern {
  final String name;
  final List<Interval> intervals;
  final Map<String, Mode> modes = <String, Mode>{};

  static final Map<String, ScalePattern> _byName = <String, ScalePattern>{};
  static bool _builtinPatternsInitialized = false;

  ScalePattern({this.name, this.intervals}) {
    _byName[name] = this;
  }

  static ScalePattern findByName(String name) {
    _initializeBuiltinPatterns();
    var scalePattern = _byName[name];
    if (scalePattern == null)
      throw new FormatException("$name is not a ScalePattern name");
    return scalePattern;
  }

  static void _initializeBuiltinPatterns() {
    if (_builtinPatternsInitialized) return;
    _builtinPatternsInitialized = true;
    for (var spec in scalePatternSpecs) {
      var scaleName = spec['name'];
      var parentName = spec['parent'];
      var modeNames = spec['modeNames'];
      var intervals =
          spec['intervals'].map((n) => new Interval.fromSemitones(n)).toList();
      var scale = parentName != null
          ? new Mode(
              name: scaleName,
              parent: ScalePattern.findByName(parentName),
              intervals: intervals)
          : new ScalePattern(name: scaleName, intervals: intervals);
      if (modeNames == null) modeNames = [];
      eachWithIndex(modeNames, (modeName, index) {
        var modeIntervals = new List.from(intervals.skip(index));
        modeIntervals.addAll(intervals.take(index));
        var root = modeIntervals[0];
        modeIntervals =
            modeIntervals.map((interval) => interval - root).toList();
        new Mode(name: modeName, parent: scale, intervals: modeIntervals);
      });
    }
  }

  Scale at(PitchClass tonic) => new Scale(pattern: this, tonic: tonic);
}

class Mode extends ScalePattern {
  final ScalePattern parent;

  Mode({String name, this.parent, intervals})
      : super(name: name, intervals: intervals) {
    parent.modes[name] = this;
  }
}

class Scale {
  final ScalePattern pattern;
  final PitchClass tonic;

  Scale({this.pattern, this.tonic});

  List<Interval> get intervals => pattern.intervals;

  List<PitchClass> get pitchClasses =>
      intervals.map((interval) => tonic + interval).toList();

  // : intervals = (new Interval(semitones) for semitones in @pitchClasses)
  // @pitches = (@tonic.add(interval) for interval in @intervals) if @tonic?

//   chords: (options={}) ->
//     throw new Error("only implemented for scales with tonics") unless @tonic?
//     degrees = [0, 2, 4]
//     degrees.push 6 if options.sevenths
//     for i in [0 ... @pitches.length]
//       modePitches = @pitches[i..].concat(@pitches[...i])
//       chordPitches = (modePitches[degree] for degree in degrees)
//       Chord.fromPitches(chordPitches)

//   noteNames: ->
//     noteNames = SharpNoteNames
//     noteNames = FlatNoteNames if @tonicName not in noteNames or @tonicName == 'F'
//     return noteNames

//   @fromString: (name) ->
//     tonicName = null
//     scaleName = null
//     [tonicName, scaleName] = match[1...] if match = name.match(/^([a-gA-G][#b♯♭𝄪𝄫]*(?:\d*))\s*(.*)$/)
//     scaleName or= 'Diatonic Major'
//     throw new Error("No scale named #{scaleName}") unless scale = Scales[scaleName]
//     scale = scale.at(tonicName) if tonicName
//     return scale
}

final List scalePatternSpecs = [
  {
    'name': 'Diatonic Major',
    'intervals': [0, 2, 4, 5, 7, 9, 11],
    'modeNames': [
      'Ionian',
      'Dorian',
      'Phrygian',
      'Lydian',
      'Mixolydian',
      'Aeolian',
      'Locrian'
    ]
  },
  {
    'name': 'Natural Minor',
    'intervals': [0, 2, 3, 5, 7, 8, 10],
    // 'parent': 'Diatonic Major',
  },
  {
    'name': 'Major Pentatonic',
    'intervals': [0, 2, 4, 7, 9],
    'modeNames': [
      'Major Pentatonic',
      'Suspended Pentatonic',
      'Man Gong',
      'Ritusen',
      'Minor Pentatonic'
    ],
  },
  {
    'name': 'Minor Pentatonic',
    'intervals': [0, 3, 5, 7, 10],
    'parent': 'Major Pentatonic',
  },
  {
    'name': 'Melodic Minor',
    'intervals': [0, 2, 3, 5, 7, 9, 11],
    'modeNames': [
      'Jazz Minor',
      'Dorian ♭2',
      'Lydian Augmented',
      'Lydian Dominant',
      'Mixolydian ♭6',
      'Semilocrian',
      'Superlocrian'
    ]
  },
  {
    'name': 'Harmonic Minor',
    'intervals': [0, 2, 3, 5, 7, 8, 11],
    'modeNames': [
      'Harmonic Minor',
      'Locrian ♯6',
      'Ionian Augmented',
      'Romanian',
      'Phrygian Dominant',
      'Lydian ♯2',
      'Ultralocrian'
    ]
  },
  {
    'name': 'Blues',
    'intervals': [0, 3, 5, 6, 7, 10],
  },
  {
    'name': 'Freygish',
    'intervals': [0, 1, 4, 5, 7, 8, 10],
  },
  {
    'name': 'Whole Tone',
    'intervals': [0, 2, 4, 6, 8, 10],
  },
  {
    // 'Octatonic' is the classical name. It's the jazz 'Diminished' scale.
    'name': 'Octatonic',
    'intervals': [0, 2, 3, 5, 6, 8, 9, 11],
  }
];

// # Indexed by scale degree
// Functions = 'Tonic Supertonic Mediant Subdominant Dominant Submediant Subtonic Leading'.split(/\s/)

// parseChordNumeral = (name) ->
//   chord = {
//     degree: 'i ii iii iv v vi vii'.indexOf(name.match(/[iv+]/i)[1]) + 1
//     major: name == name.toUpperCase()
//     flat: name.match(/^b/)
//     diminished: name.match(/°/)
//     augmented: name.match(/\+/)
//   }
//   return chord

// # FunctionQualities =
// #   major: 'I ii iii IV V vi vii°'.split(/\s/).map parseChordNumeral
// #   minor: 'i ii° ♭III iv v ♭VI ♭VII'.split(/\s/).map parseChordNumeral

final List<String> scaleDegreeNames = [
  '1',
  '♭2',
  '2',
  '♭3',
  '3',
  '4',
  '♭5',
  '5',
  '♭6',
  '6',
  '♭7',
  '7'
];
