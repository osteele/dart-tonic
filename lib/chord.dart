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
          .replaceAll(new RegExp(r'Major(?!$)'), 'Maj')
          .replaceAll(new RegExp(r'Minor(?!$)'), 'Min')
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
  // Major / minor
  {
    "name": 'M',
    "abbrs": ['', 'M'],
    "intervals": '047'
  },
  {
    "name": 'm',
    "abbrs": ['m'],
    "intervals": '037'
  },
  {
    "name": 'M6',
    "abbrs": ['6', 'M6', 'maj6'],
    "intervals": '0479'
  },
  {
    "name": 'M6',
    "abbrs": ['6', 'M6', 'maj6'],
    "intervals": '049'
  },
  {
    "name": 'm6',
    "abbrs": ['m6', 'min6'],
    "intervals": '0379'
  },
  {
    "name": 'm6',
    "abbrs": ['m6', 'min6'],
    "intervals": '039'
  },
  {
    "name": 'M6(9)',
    "abbrs": ['M69', 'maj69'],
    "intervals": '02479'
  },
  {
    "name": 'M6(9)',
    "abbrs": ['M69', 'maj69'],
    "intervals": '0249'
  },
  {
    "name": 'm6(9)',
    "abbrs": ['m69', 'min69'],
    "intervals": '02379'
  },
  {
    "name": 'm6(9)',
    "abbrs": ['m69', 'min69'],
    "intervals": '0239'
  },
  {
    "name": 'M7',
    "abbrs": ['maj7'],
    "intervals": '047e'
  },
  {
    "name": 'M7',
    "abbrs": ['maj7'],
    "intervals": '04e'
  },
  {
    "name": 'M7(9)',
    "abbrs": ['M7(9)'],
    "intervals": '0247t'
  },
  {
    "name": 'M7(9)',
    "abbrs": ['M7(9)'],
    "intervals": '024t'
  },
  {
    "name": 'm7',
    "abbrs": ['min7'],
    "intervals": '037t'
  },
  {
    "name": 'm7',
    "abbrs": ['min7'],
    "intervals": '03t'
  },
  {
    "name": 'm7(♭5)',
    "abbrs": ['ø', 'Ø', 'm7♭5'],
    "intervals": '036t'
  },
  {
    "name": 'm7(♭9)',
    "abbrs": ['m7(b9)'],
    "intervals": '0137t'
  },
  {
    "name": 'm7(♭9)',
    "abbrs": ['m7(9b)'],
    "intervals": '013t'
  },
  {
    "name": 'm7(9)',
    "abbrs": ['m7(9)'],
    "intervals": '0237t'
  },
  {
    "name": 'm7(9)',
    "abbrs": ['m7(9)'],
    "intervals": '023t'
  },
  {
    "name": 'm7(11)',
    "abbrs": ['min7(11)'],
    "intervals": '0357t'
  },
  {
    "name": 'm7(11)',
    "abbrs": ['min7(11)'],
    "intervals": '035t'
  },
  // 5th
  {
    "name": 'Augmented',
    "abbrs": ['+', 'aug'],
    "intervals": '048'
  },
  {
    "name": 'Diminished',
    "abbrs": ['°', 'dim'],
    "intervals": '036'
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
    "name": '6Sus4',
    "abbrs": ['6sus4'],
    "intervals": '0579'
  },
  {
    "name": '6Sus4',
    "abbrs": ['6sus4'],
    "intervals": '059'
  },
  // Dominant 7th
  {
    "name": 'Dom7',
    "abbrs": ['7', 'dom7'],
    "intervals": '047t'
  },
  {
    "name": 'Dom7',
    "abbrs": ['7', 'dom7'],
    "intervals": '04t'
  },
  {
    "name": 'Dom7(♭5)',
    "abbrs": ['7♭5'],
    "intervals": '046t'
  },
  {
    "name": 'Dom7(♭9)',
    "abbrs": ['dom7(b9)', '7(b9)'],
    "intervals": '0147t'
  },
  {
    "name": 'Dom7(♭9)',
    "abbrs": ['dom7(b9)', '7(b9)'],
    "intervals": '014t'
  },
  {
    "name": 'Dom7(9)',
    "abbrs": ['dom7(9)', '7(9)'],
    "intervals": '0247t'
  },
  {
    "name": 'Dom7(9)',
    "abbrs": ['dom7(b)', '7(9)'],
    "intervals": '024t'
  },
  {
    "name": 'Dom7(#9)',
    "abbrs": ['7#9', 'dom7(#9)'],
    "intervals": '0347t'
  },
  {
    "name": 'Dom7(#9)',
    "abbrs": ['7#9', 'dom7#9'],
    "intervals": '034t'
  },
  {
    "name": 'Dom7(13)',
    "abbrs": ['7(13)'],
    "intervals": '047e'
  },
  {
    "name": 'Augmented 7',
    "abbrs": ['+7', '7aug'],
    "intervals": '048t'
  },
  {
    "name": 'Diminished 7',
    "abbrs": ['°7', 'dim7'],
    "intervals": '0369'
  },
  {
    "name": 'Diminished M7',
    "abbrs": ['°Maj7'],
    "intervals": '036e'
  },
  {
    "name": 'm(M7)',
    "abbrs": ['min/maj7', 'min(maj7)'],
    "intervals": '037e'
  },
  {
    "name": 'm(M7)',
    "abbrs": ['min/maj7', 'min(maj7)'],
    "intervals": '03e'
  },
];
