part of tonic;

// final List<String> InversionNames = ['a', 'c', 'd'];

class NotFoundException implements Exception {
  String message;
  NotFoundException(String this.message);
  String toString() => "NotFoundException: $message";
}

// An instance of ChordPattern represents the intervals of the chord,
// without the root. For example, Dom7. It represents the quality, suspensions, and additions.
class ChordPattern {
  final String name;
  final String fullName;
  final List<String> abbrs;
  final List<Interval> intervals;

  static final Map<String, ChordPattern> _byName = <String, ChordPattern>{};
  static final Map<String, ChordPattern> _byIntervals =
      <String, ChordPattern>{};

  ChordPattern(
      {String this.name,
      String this.fullName,
      List<String> this.abbrs,
      List<Interval> this.intervals}) {
    _byName[name] = this;
    _byName[fullName] = this;
    for (var abbr in abbrs) {
      _byName[abbr] = this;
    }
    _byIntervals[_intervalSetKey(intervals)] = this;
  }

  static ChordPattern fromIntervals(Iterable<Interval> intervals) {
    _initializeChords();
    var chord = _byIntervals[_intervalSetKey(intervals)];
    if (chord == null)
      throw new NotFoundException(
          "unknown chord interval pattern ${intervals}");
    return chord;
  }

  static String _intervalSetKey(Iterable<Interval> intervals) {
    // TODO remove the % to recognize additions
    var key = intervals.map((interval) => interval.semitones % 12).toList();
    key.sort();
    return key.join(',');
  }

  static ChordPattern parse(String name) {
    _initializeChords();
    var chord = _byName[name];
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
    for (var spec in ChordPatternSpecs) {
      var fullName = spec['name'];
      var abbrs = spec['abbrs'];
      var intervals = spec['intervals'].split('').map((c) {
        var semitones = {'t': 10, 'e': 11}[c];
        if (semitones == null) {
          semitones = int.parse(c);
        }
        return new Interval.fromSemitones(semitones);
      }).toList();
      var name = fullName
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

class Chord {
  ChordPattern pattern;
  Pitch root;
  List<Pitch> _pitches;

  static final Pattern _CHORD_NAME_PATTERN =
      new RegExp(r"^([a-gA-G],*'*[#b♯♭𝄪𝄫]*(?:\d*))\s*(.*)$");

  Chord({ChordPattern this.pattern, Pitch this.root});

  static Chord parse(String chordName) {
    var match = _CHORD_NAME_PATTERN.matchAsPrefix(chordName);
    if (match == null)
      throw new FormatException("invalid Chord name: $chordName");
    var chordClass = ChordPattern.parse(match[2]);
    return chordClass.at(Pitch.parse(match[1]));
  }

  static Chord fromPitches(List<Pitch> pitches) {
    for (var root in pitches) {
      var intervals = pitches.map((pitch) => pitch - root).toSet();
      try {
        var chord = ChordPattern.fromIntervals(intervals).at(root);
        chord._pitches = pitches;
        return chord;
      } on NotFoundException {}
    }
    throw new NotFoundException("unknown chord pitch pattern ${pitches}");
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
    return _pitches;
  }
}

final List ChordPatternSpecs = [
  {
    "name": 'Major',
    "abbrs": ['', 'M'],
    "intervals": '047'
  },
  {
    "name": 'Minor',
    "abbrs": ['m'],
    "intervals": '037'
  },
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
    "name": 'Dominant 7th',
    "abbrs": ['7', 'dom7'],
    "intervals": '047t'
  },
  {
    "name": 'Augmented 7th',
    "abbrs": ['+7', '7aug'],
    "intervals": '048t'
  },
  {
    "name": 'Diminished 7th',
    "abbrs": ['°7', 'dim7'],
    "intervals": '0369'
  },
  {
    "name": 'Major 7th',
    "abbrs": ['maj7'],
    "intervals": '047e'
  },
  {
    "name": 'Minor 7th',
    "abbrs": ['min7'],
    "intervals": '037t'
  },
  {
    "name": 'Dominant 7♭5',
    "abbrs": ['7♭5'],
    "intervals": '046t'
  },
  // following is also half-diminished 7th
  {
    "name": 'Minor 7th ♭5',
    "abbrs": ['ø', 'Ø', 'm7♭5'],
    "intervals": '036t'
  },
  {
    "name": 'Diminished Maj 7th',
    "abbrs": ['°Maj7'],
    "intervals": '036e'
  },
  {
    "name": 'Minor-Major 7th',
    "abbrs": ['min/maj7', 'min(maj7)'],
    "intervals": '037e'
  },
  {
    "name": '6th',
    "abbrs": ['6', 'M6', 'M6', 'maj6'],
    "intervals": '0479'
  },
  {
    "name": 'Minor 6th',
    "abbrs": ['m6', 'min6'],
    "intervals": '0379'
  },
];
