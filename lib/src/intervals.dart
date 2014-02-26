part of tonic;

final List<String> IntervalNames = ['P1', 'm2', 'M2', 'm3', 'M3', 'P4', 'TT', 'P5', 'm6', 'M6', 'm7', 'M7', 'P8'];

final List<String>  LongIntervalNames = [
  'Unison', 'Minor 2nd', 'Major 2nd', 'Minor 3rd', 'Major 3rd', 'Perfect 4th',
  'Tritone', 'Perfect 5th', 'Minor 6th', 'Major 6th', 'Minor 7th', 'Major 7th', 'Octave'];

// The interval class (number in [0...12]) between two pitch class numbers
int intervalClassDifference(int pca, int pcb) =>
  normalizePitchClass(pcb - pca);

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
  Interval _augmented = null;
  Interval _diminished = null;

  static final Map<String, Interval> _cache = <String, Interval>{};

  static final List<int> _semitonesByNumber = [0, 2, 4, 5, 7, 9, 11, 12];
  static bool _numberIsPerfect(int number) => [1, 4, 5, 8].indexOf(number) >= 0;
  static String _defaultQualityForNumber(int number) => _numberIsPerfect(number) ? 'P' : 'M';

  factory Interval({int number, String qualityName}) {
    assert(number != null);
    assert(1 <= number && number <= 8);
    var semitones = _semitonesByNumber[number - 1];
    if (semitones == null) { throw new ArgumentError("invalid interval number: $number"); }
    if (qualityName == null) { qualityName = IntervalNames[semitones][0]; }
    final key = "$qualityName$number";
    if (_cache.containsKey(key)) {return _cache[key]; }
    var qualitySemitones = _numberIsPerfect(number)
      ? "dPA".indexOf(qualityName) - 1
      : "dmMA".indexOf(qualityName) - 2;
    if (qualitySemitones == null) { throw new ArgumentError("invalid interval quality: $qualityName"); }
    semitones += qualitySemitones;
    return _cache[key] = new Interval._internal(number, qualityName, qualitySemitones);
  }

  Interval._internal(int this.number, String this.qualityName, int this.qualitySemitones);

  factory Interval.fromSemitones(semitones, {int number}) {
    if (semitones < 0 || 12 < semitones) { semitones %= 12; }
    var interval = Interval.parse(IntervalNames[semitones]);
    if (number != null) {
      interval = new Interval(number: number);
      var qs = _numberIsPerfect(number) ? "dPA" : "dmMA";
      var i = semitones - interval.semitones + (qs.length ~/ 2);
      if (!(0 <= i && i < qs.length)) { throw new ArgumentError("can't qualify $interval to $semitones semitone(s)"); }
      var q = qs[i];
      interval = new Interval(number: number, qualityName: q);
    }
    return interval;
  }

  int get diatonicSemitones => _semitonesByNumber[number - 1];
  int get semitones => diatonicSemitones + qualitySemitones;

  Interval get augmented =>
    _augmented != null ? _augmented
    : "mMP".indexOf(qualityName) >= 0 ? _augmented = new Interval(number: number, qualityName: 'A')
    : throw new ArgumentError("can't augment $this");

  // TODO error if quality is not mMP
  Interval get diminished =>
    _diminished != null ? _diminished : _diminished = new Interval(number: number, qualityName: 'd');

  static final Pattern _IntervalNamePattern = new RegExp(r'^(([dmMA][2367])|([dPA][1458])|TT)$');
  static final Pattern _IntervalNameParsePattern = new RegExp(r'^([dmMPA])(\d)$');

  static parse(String name) {
    // print(name);
    // print(name.startsWith(_IntervalNamePattern));
    if (!name.startsWith(_IntervalNamePattern)) { throw new FormatException("No interval named $name"); }
    if (name == "TT") { name = "d5"; }
    var match = _IntervalNameParsePattern.matchAsPrefix(name);
    assert(match != null);
    return new Interval(number: int.parse(match[2]), qualityName: match[1]);
  }

  String toString() => "$qualityName$number";

  String get inspect =>
    {'number': number, 'semitones': semitones, 'quality': {'name': qualityName, 'value': qualitySemitones}}.toString();

  Interval inversion() => new Interval.fromSemitones(12 - semitones, number: 9 - number % 12);

  Interval operator + (Interval other) =>
    new Interval.fromSemitones(semitones + other.semitones, number: number + other.number - 1);

  Interval operator - (Interval other) =>
    new Interval.fromSemitones(semitones - other.semitones % 12, number: (number - other.number) % 7 + 1);

  static final Interval P1 = Interval.parse('P1');
  static final Interval m2 = Interval.parse('m2');
  static final Interval M2 = Interval.parse('M2');
  static final Interval m3 = Interval.parse('m3');
  static final Interval M3 = Interval.parse('M3');
  static final Interval P4 = Interval.parse('P4');
  static final Interval TT = Interval.parse('TT');
  static final Interval P5 = Interval.parse('P5');
  static final Interval m6 = Interval.parse('m6');
  static final Interval M6 = Interval.parse('M6');
  static final Interval m7 = Interval.parse('m7');
  static final Interval M7 = Interval.parse('M7');
  static final Interval P8 = Interval.parse('P8');

  static final Interval A1 = Interval.P1.augmented;
  static final Interval A2 = Interval.M2.augmented;
  static final Interval A3 = Interval.M3.augmented;
  static final Interval A4 = Interval.P4.augmented;
  static final Interval A5 = Interval.P5.augmented;
  static final Interval A6 = Interval.M6.augmented;
  static final Interval A7 = Interval.M7.augmented;

  static final Interval d2 = Interval.m2.diminished;
  static final Interval d3 = Interval.m3.diminished;
  static final Interval d4 = Interval.P4.diminished;
  static final Interval d5 = Interval.P5.diminished;
  static final Interval d6 = Interval.m6.diminished;
  static final Interval d7 = Interval.m7.diminished;
  static final Interval d8 = Interval.P8.diminished;
}

// final List Intervals = IntervalNames.map((name, semitones) =>
//   new Interval.fromSemitones(semitones)) as List<Interval>;
