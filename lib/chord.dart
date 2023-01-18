part of tonic;

// final List<String> InversionNames = ['a', 'c', 'd'];

class NotFoundException implements Exception {
  String message;
  NotFoundException(this.message);
  String toString() => "NotFoundException: $message";
}

/// An instance of ChordPattern represents the intervals of the chord,
/// without the root; for example, Dom7. A ChordPattern represents the quality,
/// suspensions, and additions.
class ChordPattern {
  final String name;
  final String fullName;
  final List<String> abbrs;
  final List<Interval> intervals;

  static final Map<String, ChordPattern> _byName = <String, ChordPattern>{};
  static final Map<String, ChordPattern> _byIntervals =
      <String, ChordPattern>{};

  ChordPattern({
    required this.name,
    required this.fullName,
    required this.abbrs,
    required this.intervals,
  }) {
    _byName[name] = this;
    _byName[fullName] = this;
    for (final abbr in abbrs) {
      _byName[abbr] = this;
    }
    _byIntervals[_intervalSetKey(intervals)] = this;
  }

  static ChordPattern fromIntervals(Iterable<Interval> intervals) {
    _initializeChords();
    final chord = _byIntervals[_intervalSetKey(intervals)];
    if (chord == null)
      throw new NotFoundException("unknown chord interval pattern $intervals");
    return chord;
  }

  static String _intervalSetKey(Iterable<Interval> intervals) {
    // TODO remove the % to recognize additions
    final key = intervals.map((interval) => interval.semitones % 12).toList();
    key.sort();
    return key.join(',');
  }

  static ChordPattern parse(String name) {
    _initializeChords();
    final chord = _byName[name];
    if (chord == null)
      throw new FormatException("$name is not a ChordPattern name");
    return chord;
  }

  String get abbr => abbrs[0];
  String toString() => name;

  String get inspect => {
        'name': name,
        'fullName': fullName,
        'abbrs': abbrs,
        'intervals': intervals
      }.toString();

  static bool _chordsInitialized = false;

  static void _initializeChords() {
    if (_chordsInitialized) return;
    _chordsInitialized = true;
    for (final spec in _chordPatternSpecs) {
      final fullName = spec['name'];
      final abbrs = spec['abbrs'];
      final intervals =
          List<Interval>.from(spec['intervals'].split('').map((c) {
        var semitones = {'t': 10, 'e': 11}[c];
        if (semitones == null) {
          semitones = int.parse(c);
        }
        return new Interval.fromSemitones(semitones);
      }));
      final name = fullName
          .replaceAll(new RegExp(r'Major'), 'Maj')
          .replaceAll(new RegExp(r'minor'), 'min')
          .replaceAll(new RegExp(r'Dominant'), 'Dom')
          .replaceAll(new RegExp(r'Augmented'), 'Aug')
          .replaceAll(new RegExp(r'Diminished'), 'Dim');
      new ChordPattern(
          name: name, fullName: fullName, abbrs: abbrs, intervals: intervals);
    }
  }

  Chord at(Pitch root) => new Chord(pattern: this, root: root);
}

/// A Chord is a set of pitches. It can also be considered as a root, and a set
/// of intervals.
class Chord {
  ChordPattern pattern;
  Pitch root;
  List<Pitch>? _pitches;

  static final Pattern _cordNamePattern =
      new RegExp(r"^([a-gA-G],*'*[#b♯♭𝄪𝄫]*(?:\d*))\s*(.*)$");

  Chord({required this.pattern, required this.root});

  static Chord parse(String chordName) {
    final match = _cordNamePattern.matchAsPrefix(chordName);
    if (match == null)
      throw new FormatException("invalid Chord name: $chordName");
    final chordClass = ChordPattern.parse(match[2]!);
    return chordClass.at(Pitch.parse(match[1]!));
  }

  static Chord fromPitches(List<Pitch> pitches) {
    for (final root in pitches) {
      final intervals = pitches.map((pitch) => pitch - root).toSet();
      try {
        final chord = ChordPattern.fromIntervals(intervals).at(root);
        chord._pitches = pitches;
        return chord;
      } on NotFoundException {}
    }
    throw new NotFoundException("unknown chord pitch pattern $pitches");
  }

  String get name => "$root $pattern";
  String get fullName => "$root ${pattern.fullName}";
  String get abbr => pattern.abbr == "" ? "$root" : "$root ${pattern.abbr}";
  List<Interval> get intervals => pattern.intervals;

  String toString() => name;

  List<Pitch> get pitches {
    if (_pitches == null) {
      _pitches = intervals.map((interval) => root + interval).toList();
    }
    return _pitches!;
  }
}

final List _chordPatternSpecs = [
  // Major
  {
    "name": 'Major',
    "abbrs": ['', 'M'],
    "intervals": '047'
  },
  {
    "name": 'Major 6',
    "abbrs": ['6', 'M6', 'maj6'],
    "intervals": '0479'
  },
  {
    "name": 'Major 6',
    "abbrs": ['6', 'M6', 'maj6'],
    "intervals": '049'
  },
  {
    "name": 'Major 6(9)',
    "abbrs": ['M69', 'maj69'],
    "intervals": '02479'
  },
  {
    "name": 'Major 6(9)',
    "abbrs": ['M69', 'maj69'],
    "intervals": '0249'
  },
  {
    "name": 'Major 6(11)',
    "abbrs": ['maj6(11)'],
    "intervals": '04579'
  },
  {
    "name": 'Major 6(11)',
    "abbrs": ['M6(11)', 'maj6(11)'],
    "intervals": '0459'
  },
  {
    "name": 'Major 7',
    "abbrs": ['maj7'],
    "intervals": '047e'
  },
  {
    "name": 'Major 7',
    "abbrs": ['maj7'],
    "intervals": '04e'
  },
  {
    "name": 'Major 7(9)',
    "abbrs": ['M7(9)'],
    "intervals": '0247e'
  },
  {
    "name": 'Major 7(9)',
    "abbrs": ['M7(9)'],
    "intervals": '024e'
  },
  {
    "name": 'Major 7(#9)',
    "abbrs": ['M7(#9)'],
    "intervals": '0347e'
  },
  {
    "name": 'Major 7(#9)',
    "abbrs": ['M7(#9)'],
    "intervals": '034e'
  },
  {
    "name": 'Major 7(9)(#11)',
    "abbrs": ['M7(9)(#11)'],
    "intervals": '02467e'
  },
  {
    "name": 'Major 7(9)(#11)',
    "abbrs": ['M7(9)(#11)'],
    "intervals": '0246e'
  },
  {
    "name": 'Major 7(#11)',
    "abbrs": ['M7(#11)'],
    "intervals": '0467e'
  },
  {
    "name": 'Major 7(#11)',
    "abbrs": ['M7(#11)'],
    "intervals": '046e'
  },
  // Minor
  {
    "name": 'minor',
    "abbrs": ['m'],
    "intervals": '037'
  },
  {
    "name": 'minor ♭6',
    "abbrs": ['m♭6', 'min♭6'],
    "intervals": '038'
  },
  {
    "name": 'minor 6',
    "abbrs": ['m6', 'min6'],
    "intervals": '0379'
  },
  {
    "name": 'minor 6',
    "abbrs": ['m6', 'min6'],
    "intervals": '039'
  },
  {
    "name": 'minor 6(9)',
    "abbrs": ['m69', 'min69'],
    "intervals": '02379'
  },
  {
    "name": 'minor 6(9)',
    "abbrs": ['m69', 'min69'],
    "intervals": '0239'
  },
  {
    "name": 'minor 6(11)',
    "abbrs": ['m6(11)', 'min6(11)'],
    "intervals": '03579'
  },
  {
    "name": 'minor 6(11)',
    "abbrs": ['m6(11)', 'min6(11)'],
    "intervals": '0359'
  },
  {
    "name": 'minor 7',
    "abbrs": ['min7'],
    "intervals": '037t'
  },
  {
    "name": 'minor 7',
    "abbrs": ['min7'],
    "intervals": '03t'
  },
  {
    "name": 'minor 7(♭5)',
    "abbrs": ['ø', 'Ø', 'm7♭5'],
    "intervals": '036t'
  },
  {
    "name": 'minor 7(♭9)',
    "abbrs": ['m7(b9)'],
    "intervals": '0137t'
  },
  {
    "name": 'minor 7(♭9)',
    "abbrs": ['m7(9b)'],
    "intervals": '013t'
  },
  {
    "name": 'minor 7(9)',
    "abbrs": ['m7(9)'],
    "intervals": '0237t'
  },
  {
    "name": 'minor 7(9)',
    "abbrs": ['m7(9)'],
    "intervals": '023t'
  },
  {
    "name": 'minor 7(11)',
    "abbrs": ['min7(11)'],
    "intervals": '0357t'
  },
  {
    "name": 'minor 7(11)',
    "abbrs": ['min7(11)'],
    "intervals": '035t'
  },
  {
    "name": 'minor add9',
    "abbrs": ['m9'],
    "intervals": '0237'
  },
  {
    "name": 'minor add9',
    "abbrs": ['m9'],
    "intervals": '023'
  },

  // 5th
  {
    "name": 'Augmented',
    "abbrs": ['+', 'aug'],
    "intervals": '048'
  },
  {
    "name": 'Augmented 7',
    "abbrs": ['+7', 'aug7'],
    "intervals": '048t'
  },
  {
    "name": 'Diminished',
    "abbrs": ['°', 'dim'],
    "intervals": '036'
  },
  {
    "name": 'Diminished 7',
    "abbrs": ['°7', 'dim7'],
    "intervals": '0369'
  },
  {
    "name": 'Diminished 7(♭13)',
    "abbrs": ['°7(♭13)', 'dim7(♭13)'],
    "intervals": '03689'
  },
  {
    "name": 'Diminished 7(♭13)',
    "abbrs": ['°7(♭13)', 'dim7(♭13)'],
    "intervals": '0389'
  },
  {
    "name": 'Diminished 7(9)',
    "abbrs": ['°7(9)', 'dim7(9)'],
    "intervals": '02369'
  },

  // 2nd / 4th
  {
    "name": 'Sus2',
    "abbrs": ['sus2'],
    "intervals": '027'
  },
  {
    "name": 'Sus4',
    "abbrs": ['sus4'],
    "intervals": '057'
  },
  {
    "name": '6Sus2',
    "abbrs": ['6sus2'],
    "intervals": '0279'
  },
  {
    "name": '6Sus2',
    "abbrs": ['6sus2'],
    "intervals": '029'
  },
  {
    "name": '6(#11)Sus2',
    "abbrs": ['6sus2(#11)'],
    "intervals": '0269'
  },
  {
    "name": '6Sus4',
    "abbrs": ['6sus4'],
    "intervals": '0579'
  },
  {
    "name": '6Sus4',
    "abbrs": ['6sus4'],
    "intervals": '059'
  },
  {
    "name": '7Sus4',
    "abbrs": ['7sus4'],
    "intervals": '057t'
  },
  {
    "name": '7Sus4',
    "abbrs": ['7sus4'],
    "intervals": '05t'
  },
  {
    "name": 'Dominant 7(9)Sus4',
    "abbrs": ['9sus4', '7(9)sus4'],
    "intervals": '0257t'
  },
  {
    "name": 'Dominant 7(9)Sus4',
    "abbrs": ['9sus4', '7(9)sus4'],
    "intervals": '025t'
  },

  // Dominant 7th
  {
    "name": 'Dominant 7',
    "abbrs": ['7', 'dom7'],
    "intervals": '047t'
  },
  {
    "name": 'Dominant 7',
    "abbrs": ['7', 'dom7'],
    "intervals": '04t'
  },
  {
    "name": 'Dominant 7(♭9)',
    "abbrs": ['dom7(♭9)', '7(b9)'],
    "intervals": '0147t'
  },
  {
    "name": 'Dominant 7(♭9)',
    "abbrs": ['dom7(♭9)', '7(b9)'],
    "intervals": '014t'
  },
  {
    "name": 'Dominant 7(♭9)(#11)',
    "abbrs": ['dom7(♭9)(#11)', '7(b9)(#11)'],
    "intervals": '01467t'
  },
  {
    "name": 'Dominant 7(♭9)(#11)',
    "abbrs": ['dom7(b9)(#11)', '7(b9)(#11)'],
    "intervals": '0146t'
  },
  {
    "name": 'Dominant 7(♭9)(♭13)',
    "abbrs": ['dom7(b9)(♭13)', '7(b9)(b13)'],
    "intervals": '01478t'
  },
  {
    "name": 'Dominant 7(♭9)(♭13)',
    "abbrs": ['dom7(b9)(♭13)', '7(b9)(b13)'],
    "intervals": '0148t'
  },
  {
    "name": 'Dominant 7(9)',
    "abbrs": ['dom7(9)', '7(9)'],
    "intervals": '0247t'
  },
  {
    "name": 'Dominant 7(9)',
    "abbrs": ['dom7(9)', '7(9)'],
    "intervals": '024t'
  },
  {
    "name": 'Dominant 7(9)(13)',
    "abbrs": ['7(9)(13)'],
    "intervals": '02479t'
  },
  {
    "name": 'Dominant 7(9)(13)',
    "abbrs": ['7(9)(13)'],
    "intervals": '0249t'
  },
  {
    "name": 'Dominant 7(#9)',
    "abbrs": ['7#9', 'dom7(#9)'],
    "intervals": '0347t'
  },
  {
    "name": 'Dominant 7(#9)',
    "abbrs": ['7#9', 'dom7#9'],
    "intervals": '034t'
  },
  {
    "name": 'Dominant 7(#9)(#11)',
    "abbrs": ['dom7(#9)(#11)', '7(#9)(#11)'],
    "intervals": '03467t'
  },
  {
    "name": 'Dominant 7(#9)(#11)',
    "abbrs": ['dom7(#9)(#11)', '7(#9)(#11)'],
    "intervals": '0346t'
  },
  {
    "name": 'Dominant 7(#9)(♭13)',
    "abbrs": ['dom7(#9)(♭13)', '7(#9)(b13)'],
    "intervals": '03478t'
  },
  {
    "name": 'Dominant 7(#9)(♭13)',
    "abbrs": ['dom7(#9)(♭13)', '7(#9)(b13)'],
    "intervals": '0348t'
  },
  {
    "name": 'Dominant 7(#11)',
    "abbrs": ['7♭5', '7#11'],
    "intervals": '046t'
  },
  {
    "name": 'Dominant 7(♭13)',
    "abbrs": ['7(♭13)', '7(b13)'],
    "intervals": '0478t'
  },
  {
    "name": 'Dominant 7(♭13)',
    "abbrs": ['7(♭13)', '7(b13)'],
    "intervals": '048t'
  },
  {
    "name": 'Dominant 7(13)',
    "abbrs": ['7(13)'],
    "intervals": '0479t'
  },
  {
    "name": 'Dominant 7(13)',
    "abbrs": ['7(13)'],
    "intervals": '049t'
  },

  {
    "name": 'minor Major 7',
    "abbrs": ['min/maj7', 'min(maj7)'],
    "intervals": '037e'
  },
  {
    "name": 'minor Major 7',
    "abbrs": ['min/maj7', 'min(maj7)'],
    "intervals": '03e'
  },
  {
    "name": 'minor Major 7(#11)',
    "abbrs": ['min/maj7(#11)', 'min(maj7)(#11)'],
    "intervals": '036e'
  },
];
