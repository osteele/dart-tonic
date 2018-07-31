part of tonic;

final List<String> intervalNames = [
  'P1',
  'm2',
  'M2',
  'm3',
  'M3',
  'P4',
  'TT',
  'P5',
  'm6',
  'M6',
  'm7',
  'M7',
  'P8'
];

final List<String> longIntervalNames = [
  'Unison',
  'Minor 2nd',
  'Major 2nd',
  'Minor 3rd',
  'Major 3rd',
  'Perfect 4th',
  'Tritone',
  'Perfect 5th',
  'Minor 6th',
  'Major 6th',
  'Minor 7th',
  'Major 7th',
  'Octave'
];

// The interval class (number in [0...12]) between two pitch class numbers
int intervalClassDifference(int pca, int pcb) => normalizePitchClass(pcb - pca);

// An Interval is the signed distance between two notes.
// Intervals that represent the same semitone span *and* accidental are interned.
// Thus, two instance of M3 are ===, but sharp P4 and flat P5 are distinct from
// each other and from TT.

// FIXME these are interval classes, not intervals
class Interval {
  final int number;
  // final int semitones;
  final String qualityName;
  final int qualitySemitones;
  Interval _augmented;
  Interval _diminished;

  static final Map<String, Interval> _cache = <String, Interval>{};

  static final List<int> _semitonesByNumber = [0, 2, 4, 5, 7, 9, 11, 12];
  static bool _numberIsPerfect(int number) => [1, 4, 5, 8].indexOf(number) >= 0;
  static String _defaultQualityForNumber(int number) =>
      _numberIsPerfect(number) ? 'P' : 'M';

  factory Interval({int number, String qualityName}) {
    assert(number != null);
    assert(1 <= number && number <= 8);
    var semitones = _semitonesByNumber[number - 1];
    if (semitones == null)
      throw new ArgumentError("invalid interval number: $number");
    if (qualityName == null) qualityName = intervalNames[semitones][0];
    var key = "$qualityName$number";
    if (_cache.containsKey(key)) return _cache[key];
    var qualitySemitones = _numberIsPerfect(number)
        ? "dPA".indexOf(qualityName) - 1
        : "dmMA".indexOf(qualityName) - 2;
    if (qualitySemitones == null)
      throw new ArgumentError("invalid interval quality: $qualityName");
    semitones += qualitySemitones;
    return _cache[key] =
        new Interval._internal(number, qualityName, qualitySemitones);
  }

  Interval._internal(this.number, this.qualityName, this.qualitySemitones);

  factory Interval.fromSemitones(semitones, {int number}) {
    if (semitones < 0 || 12 < semitones) semitones %= 12;
    var interval = Interval.parse(intervalNames[semitones]);
    if (number != null) {
      interval = new Interval(number: number);
      var qs = _numberIsPerfect(number) ? "dPA" : "dmMA";
      var i = semitones - interval.semitones + (qs.length ~/ 2);
      if (!(0 <= i && i < qs.length))
        throw new ArgumentError(
            "can't qualify $interval to $semitones semitone(s)");
      var q = qs[i];
      interval = new Interval(number: number, qualityName: q);
    }
    return interval;
  }

  int get diatonicSemitones => _semitonesByNumber[number - 1];
  int get semitones => diatonicSemitones + qualitySemitones;

  Interval get augmented => _augmented != null
      ? _augmented
      : "mMP".indexOf(qualityName) >= 0
          ? _augmented = new Interval(number: number, qualityName: 'A')
          : throw new ArgumentError("can't augment $this");

  // TODO error if quality is not mMP
  Interval get diminished => _diminished != null
      ? _diminished
      : _diminished = new Interval(number: number, qualityName: 'd');

  static final Pattern _intervalNamePattern =
      new RegExp(r'^(([dmMA][2367])|([dPA][1458])|TT)$');
  static final Pattern _intervalNameParsePattern =
      new RegExp(r'^([dmMPA])(\d)$');

  static parse(String name) {
    if (!name.startsWith(_intervalNamePattern))
      throw new FormatException("No interval named $name");
    if (name == "TT") {
      name = "d5";
    }
    var match = _intervalNameParsePattern.matchAsPrefix(name);
    assert(match != null);
    return new Interval(number: int.parse(match[2]), qualityName: match[1]);
  }

  String toString() => "$qualityName$number";

  String get inspect => {
        'number': number,
        'semitones': semitones,
        'quality': {'name': qualityName, 'value': qualitySemitones}
      }.toString();

  Interval inversion() =>
      new Interval.fromSemitones(12 - semitones, number: 9 - number % 12);

  Interval operator +(Interval other) =>
      new Interval.fromSemitones(semitones + other.semitones,
          number: number + other.number - 1);

  Interval operator -(Interval other) =>
      new Interval.fromSemitones(semitones - other.semitones % 12,
          number: (number - other.number) % 7 + 1);

  static final Interval iP1 = Interval.parse('P1');
  static final Interval im2 = Interval.parse('m2');
  static final Interval iM2 = Interval.parse('M2');
  static final Interval im3 = Interval.parse('m3');
  static final Interval iM3 = Interval.parse('M3');
  static final Interval iP4 = Interval.parse('P4');
  static final Interval iTT = Interval.parse('TT');
  static final Interval iP5 = Interval.parse('P5');
  static final Interval im6 = Interval.parse('m6');
  static final Interval iM6 = Interval.parse('M6');
  static final Interval im7 = Interval.parse('m7');
  static final Interval iM7 = Interval.parse('M7');
  static final Interval iP8 = Interval.parse('P8');

  static final Interval a1 = Interval.iP1.augmented;
  static final Interval a2 = Interval.iM2.augmented;
  static final Interval a3 = Interval.iM3.augmented;
  static final Interval a4 = Interval.iP4.augmented;
  static final Interval a5 = Interval.iP5.augmented;
  static final Interval a6 = Interval.iM6.augmented;
  static final Interval a7 = Interval.iM7.augmented;

  static final Interval d2 = Interval.im2.diminished;
  static final Interval d3 = Interval.im3.diminished;
  static final Interval d4 = Interval.iP4.diminished;
  static final Interval d5 = Interval.iP5.diminished;
  static final Interval d6 = Interval.im6.diminished;
  static final Interval d7 = Interval.im7.diminished;
  static final Interval d8 = Interval.iP8.diminished;
}

// final List Intervals = intervalNames.map((name, semitones) =>
//   new Interval.fromSemitones(semitones)) as List<Interval>;
