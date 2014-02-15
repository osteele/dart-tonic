part of tonic;

final List<String> IntervalNames = ['P1', 'm2', 'M2', 'm3', 'M3', 'P4', 'TT', 'P5', 'm6', 'M6', 'm7', 'M7', 'P8'];

final List<String>  LongIntervalNames = [
  'Unison', 'Minor 2nd', 'Major 2nd', 'Minor 3rd', 'Major 3rd', 'Perfect 4th',
  'Tritone', 'Perfect 5th', 'Minor 6th', 'Major 6th', 'Minor 7th', 'Major 7th', 'Octave'];

// The interval class (integer in [0...12]) between two pitch class numbers
int intervalClassDifference(int pca, int pcb) =>
  normalizePitchClass(pcb - pca);

// An Interval is the signed distance between two notes.
// Intervals that represent the same semitone span *and* accidental are interned.
// Thus, two instance of M3 are ===, but sharp P4 and flat P5 are distinct from
// each other and from TT.

// FIXME these are interval classes, not intervals
class Interval {
  int semitones;
  int accidentals;

  static final Map<String, Interval> _cache = <String, Interval>{};

  factory Interval(semitones, {accidentals: 0}) {
    var key = "$semitones:$accidentals";
    if (_cache.containsKey(key)) {
      return _cache[key];
    }
    var interval = new Interval._internal(semitones, accidentals: accidentals);
    _cache[key] = interval;
    return interval;
  }

  Interval._internal(this.semitones, {this.accidentals: 0});

  factory Interval.fromSemitones(semitones) => new Interval(semitones);

  static parse(String name) {
    var semitones = IntervalNames.indexOf(name);
    if (semitones < 0) {
      throw new ArgumentError("No interval named $name");
    }
    return new Interval(semitones);
  }

  String toString() {
    var s = IntervalNames[semitones];
    if (accidentals != 0) {
      s = accidentalsToString(accidentals) + s;
    }
    return s;
  }

  Interval operator + (Interval other) =>
    new Interval(semitones + other.semitones, accidentals: accidentals + other.accidentals);

  static Interval between(int pitch1, int pitch2) {
    var semitones = normalizePitchClass(pitch2 - pitch1);
    return new Interval.fromSemitones(semitones);
  }
}

// final List Intervals = IntervalNames.map((name, semitones) =>
//   new Interval.fromSemitones(semitones)) as List<Interval>;
