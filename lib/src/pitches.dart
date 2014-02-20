part of tonic;

final List<String> SharpNoteNames = ['C', 'C♯', 'D', 'D♯', 'E', 'F', 'F♯', 'G', 'G♯', 'A', 'A♯', 'B'];

final List<String> FlatNoteNames = ['C', 'D♭', 'D', 'E♭', 'E', 'F', 'G♭', 'G', 'A♭', 'A', 'B♭', 'B'];

final List<String> NoteNames = SharpNoteNames;

final Map<String,int> AccidentalValues = {
  '#': 1,
  '♯': 1,
  'b': -1,
  '♭': -1,
  '𝄪': 2,
  '𝄫': -2,
};

int parseAccidentals(String accidentals) {
  int semitones = 0;
  accidentals.runes.forEach((int rune) {
    var glyph = new String.fromCharCode(rune);
    int value = AccidentalValues[glyph];
    if (value == null) {
      throw new ArgumentError("not an accidental: $glyph in $accidentals");
    }
    semitones += value;
  });
  return semitones;
}

String accidentalsToString(int semitones) {
  if (semitones <= -2) { return accidentalsToString(semitones + 2) + '𝄫'; }
  if (semitones >=  2) { return accidentalsToString(semitones - 2) + '𝄪'; }
  return ['𝄫', '♭', '', '♯', '𝄪'][semitones + 2];
}

int roundToNatural(int pitchNumber) {
  int pitchClassNumber = pitchNumber % 12;
  if (FlatNoteNames[pitchClassNumber].length > 1) { pitchNumber += 1; }
  return pitchNumber;
}

String midi2name(int number) =>
  "${NoteNames[number % 12]}${number ~/ 12 - 1}";

int name2midi(String midiNoteName) {
  var match = new RegExp(r'^([A-Ga-g])([♯#♭b𝄪𝄫]*)(-?\d+)').matchAsPrefix(midiNoteName);
  if (match == null) {
    throw new ArgumentError("$midiNoteName is not a midi note name");
  }
  String naturalName = match[1];
  String accidentals = match[2];
  String octaveName = match[3];
  int pitch = NoteNames.indexOf(naturalName.toUpperCase());
  pitch += parseAccidentals(accidentals);
  pitch += 12 * (int.parse(octaveName) + 1);
  return pitch;
}

class Pitch {
  final int _naturalNumber;
  final int _sharps;

  static final Map<String, Pitch> _cache = <String, Pitch>{};
  static final Pattern _helmholtzPitchNamePattern = new RegExp(r"^([A-Ga-g])([#♯b♭𝄪𝄫]*)(,*)('*)$");
  static final Pattern _scientificPitchNamePattern = new RegExp(r"^([A-Ga-g])([#♯b♭𝄪𝄫]*)(-?\d+)$");

  PitchClass get pitchClass => toPitchClass();
  int get octave => _naturalNumber ~/ 12;

  Pitch toPitch() => this;

  PitchClass toPitchClass() =>
    new PitchClass.fromSemitones(pitchToPitchClass(midiNumber));

  factory Pitch({int number, int sharps: 0, int octave: -1}) {
    int natural = roundToNatural(number);
    sharps += number - natural;
    octave += natural ~/ 12;
    int pitchClassNumber = natural % 12;
    var key = "$pitchClassNumber:$sharps:$octave";
    if (_cache.containsKey(key)) { return _cache[key]; }
    return _cache[key] = new Pitch._internal(number: pitchClassNumber, sharps: sharps, octave: octave);
  }

  Pitch._internal({int number, int sharps: 0, int octave: -1})
    : _naturalNumber = number + 12 * (octave + 1)
    , _sharps = sharps;

  static Pitch parse(String pitchName) {
    return new RegExp(r'\d').hasMatch(pitchName)
      ? parseScientificNotation(pitchName)
      : parseHelmholtzNotation(pitchName);
  }

  static Pitch parseScientificNotation(String pitchName) {
    var match = _scientificPitchNamePattern.matchAsPrefix(pitchName);
    if (match == null) { throw new ArgumentError("$pitchName is not in scientific notation"); }
    String naturalName = match[1];
    String accidentals = match[2];
    String octaveName = match[3];
    int pitch = NoteNames.indexOf(naturalName.toUpperCase());
    int sharps = parseAccidentals(accidentals);
    int octave = int.parse(octaveName);
    return new Pitch(number: pitch, sharps: sharps, octave: octave);
  }

  static Pitch parseHelmholtzNotation(String pitchName) {
    var match = _helmholtzPitchNamePattern.matchAsPrefix(pitchName);
    if (match == null) { throw new ArgumentError("$pitchName is not in Helmholtz notation"); }
    String naturalName = match[1];
    String accidentals = match[2];
    String commas = match[3];
    String apostrophes = match[4];
    int pitch = NoteNames.indexOf(naturalName.toUpperCase());
    int sharps = parseAccidentals(accidentals);
    int octave = 3 + apostrophes.length - commas.length;
    if (naturalName == naturalName.toUpperCase()) { octave -= 1; }
    return new Pitch(number: pitch, sharps: sharps, octave: octave);
  }

  factory Pitch.fromMidiNumber(int midiNumber) =>
    new Pitch(number: midiNumber % 12, octave: midiNumber ~/ 12 - 1);

  int get midiNumber => _naturalNumber + _sharps;

  bool operator ==(Pitch other) =>
    _naturalNumber == other._naturalNumber && _sharps == other._sharps;

  int get hashCode => 37 * _naturalNumber + _sharps;

  Pitch operator + (Interval interval) =>
    new Pitch(number: _naturalNumber + interval.semitones, sharps: _sharps);

  int operator - (Pitch other) =>
    midiNumber - other.midiNumber;

  String toString() => "$pitchClass${octave-1}";

  String get inspect => {'number': _naturalNumber, 'sharps': _sharps}.toString();
}
