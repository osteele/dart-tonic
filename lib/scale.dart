part of tonic;

/// A scale pattern is a named set of intervals (or scale degrees) independent
/// of root (or tonic). For example, there is a Major scale pattern, that is
/// realized at particular roots as C Major, D Major, etc.
class ScalePattern {
  final String name;
  final List<Interval> intervals;
  final Map<String, Mode> modes = <String, Mode>{};

  static final Map<String, ScalePattern> _byName = <String, ScalePattern>{};
  static bool _builtinPatternsInitialized = false;

  ScalePattern({required this.name, required this.intervals}) {
    _byName['$name ${this.runtimeType}'] = this;
  }

  static ScalePattern findByName(String name, {Type? type}) {
    _initializeBuiltinPatterns();
    ScalePattern? scalePattern;

    //if no type is specified, search for ScalePattern first, then Mode if nothing found
    if (type == null) {
      scalePattern = _byName['$name $ScalePattern'];
      if (scalePattern == null) scalePattern = _byName['$name $Mode'];
      if (scalePattern == null)
        throw new FormatException('$name is not a ScalePattern name');
    } else {
      //user has specified a type, if wrong type used or no scale pattern found, throw an exception
      assert(['$Mode', '$ScalePattern'].contains('$type'));
      scalePattern = _byName['$name $type'];
      if (scalePattern == null)
        throw new FormatException(
            '$name is not a ScalePattern name with specific type $type');
    }

    return scalePattern;
  }

  static void _initializeBuiltinPatterns() {
    if (_builtinPatternsInitialized) return;
    _builtinPatternsInitialized = true;
    for (final spec in _scalePatternSpecs) {
      final scaleName = spec[Keywords.name];
      final parentName = spec[Keywords.parent];
      List<String>? modeNames = spec[Keywords.modeNames];
      final List<int> intervalValues = spec[Keywords.intervals];
      final intervals =
          intervalValues.map((n) => new Interval.fromSemitones(n)).toList();
      final scale = parentName != null
          ? new Mode(
              name: scaleName,
              parent: ScalePattern.findByName(parentName),
              intervals: intervals)
          : new ScalePattern(name: scaleName, intervals: intervals);
      if (modeNames == null) modeNames = [];
      eachWithIndex(modeNames, (String modeName, index) {
        List<Interval> modeIntervals = new List.from(intervals.skip(index));
        modeIntervals.addAll(intervals.take(index));
        final root = modeIntervals[0];
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

  Mode({
    required String name,
    required this.parent,
    required List<Interval> intervals,
  }) : super(name: name, intervals: intervals) {
    parent.modes[name] = this;
  }
}

/// A scale is a set of musical notes. Equivalently, it is a scale pattern
/// and a tonic.
class Scale {
  final ScalePattern pattern;
  final PitchClass tonic;

  Scale({required this.pattern, required this.tonic});

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

final List _scalePatternSpecs = [
  {
    Keywords.name: ScalePatternNames.diatonicMajor,
    Keywords.intervals: [0, 2, 4, 5, 7, 9, 11],
    Keywords.modeNames: ScalePatternNames.diatonicMajorModes(),
  },
  {
    Keywords.name: ScalePatternNames.naturalMinor,
    Keywords.intervals: [0, 2, 3, 5, 7, 8, 10],
    // Keywords.parent: ScalePatternNames.diatonicMajor,
  },
  {
    Keywords.name: ScalePatternNames.majorPentatonic,
    Keywords.intervals: [0, 2, 4, 7, 9],
    Keywords.modeNames: ScalePatternNames.majorPentatonicModes(),
  },
  {
    Keywords.name: ScalePatternNames.minorPentatonic,
    Keywords.intervals: [0, 3, 5, 7, 10],
    Keywords.parent: ScalePatternNames.majorPentatonic,
  },
  {
    Keywords.name: ScalePatternNames.melodicMinor,
    Keywords.intervals: [0, 2, 3, 5, 7, 9, 11],
    Keywords.modeNames: ScalePatternNames.melodicMinorModes(),
  },
  {
    Keywords.name: ScalePatternNames.harmonicMinor,
    Keywords.intervals: [0, 2, 3, 5, 7, 8, 11],
    Keywords.modeNames: ScalePatternNames.harmonicMinorModes(),
  },
  {
    Keywords.name: ScalePatternNames.blues,
    Keywords.intervals: [0, 3, 5, 6, 7, 10],
  },
  {
    Keywords.name: ScalePatternNames.freygish,
    Keywords.intervals: [0, 1, 4, 5, 7, 8, 10],
  },
  {
    Keywords.name: ScalePatternNames.wholeTone,
    Keywords.intervals: [0, 2, 4, 6, 8, 10],
  },
  {
    // 'Octatonic' is the classical name. It's the jazz 'Diminished' scale.
    Keywords.name: ScalePatternNames.octatonic,
    Keywords.intervals: [0, 2, 3, 5, 6, 8, 9, 11],
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
  '7',
];
