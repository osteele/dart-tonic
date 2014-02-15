part of tonic;

final List<String> SharpNoteNames = ['C', 'C♯', 'D', 'D♯', 'E', 'F', 'F♯', 'G', 'G♯', 'A', 'A♯', 'B'];

final List<String> FlatNoteNames = ['C', 'D♭', 'D', 'E♭', 'E', 'F', 'G♭', 'G', 'A♭', 'A', 'B♭', 'B'];

final List<string> NoteNames = SharpNoteNames;

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
  int _naturalNumber;
  int _sharps;

  static final Map<String, Interval> _cache = <String, Interval>{};

  int get midiNumber => _naturalNumber + _sharps;
  PitchClass get pitchClass => toPitchClass();
  int get octave => _naturalNumber ~/ 12;

  Pitch toPitch() => this;

  PitchClass toPitchClass() =>
    new PitchClass.fromSemitones(pitchToPitchClass(midiNumber));

  factory Pitch({String name, int midiNumber}) {
    var key = name;
    if (_cache.containsKey(key)) {
      return _cache[key];
    }
    var pitch = new Pitch._internal(name: name, midiNumber: midiNumber);
    _cache[key] = pitch;
    return pitch;
  }

  Pitch._internal({int number, int octave: 0, int sharps: 0})
    : _naturalNumber = number + 12 * octave
    , _sharps = sharps;

  static Pitch parse(String pitchName) {
    return new RegExp(r'\d').hasMatch(pitchName)
      ? parseScientificNotation(pitchName)
      : parseHelmholtzNotation(pitchName);
  }

  static Pitch parseScientificNotation(String pitchName) {
    var re = new RegExp(r'^([A-Ga-g])([#♯b♭𝄪𝄫]*)(-?\d+)$');
    var match = re.matchAsPrefix(pitchName);
    if (match == null) {
      throw new ArgumentError("$pitchName is not in scientific notation");
    }
    String naturalName = match[1];
    String accidentals = match[2];
    String octaveName = match[3];
    int pitch = NoteNames.indexOf(naturalName.toUpperCase());
    int sharps = parseAccidentals(accidentals);
    int octave = int.parse(octaveName) + 1;
    return new Pitch._internal(number: pitch, octave: octave, sharps: sharps);
  }

  static Pitch parseHelmholtzNotation(String pitchName) {
    var re = new RegExp(r"^([A-Ga-g])([#♯b♭𝄪𝄫]*)(,*)('*)$");
    var match = re.matchAsPrefix(pitchName);
    if (match == null) {
      throw new ArgumentError("$pitchName is not in Helmholtz notation");
    }
    String naturalName = match[1];
    String accidentals = match[2];
    String commas = match[3];
    String apostrophes = match[4];
    int pitch = NoteNames.indexOf(naturalName.toUpperCase());
    int sharps = parseAccidentals(accidentals);
    int octave = 4 - commas.length + apostrophes.length;
    if (naturalName == naturalName.toUpperCase()) { octave -= 1; }
    return new Pitch._internal(number: pitch, octave: octave, sharps: sharps);
  }

  Pitch.fromMidiNumber(int midiNumber): this._internal(number: midiNumber);

  bool operator ==(Pitch other) =>
    _naturalNumber == other._naturalNumber && _sharps == other._sharps;

  Pitch operator + (Interval interval) =>
    new Pitch._internal(number: _naturalNumber + interval.semitones, sharps: _sharps);

  String toString() => "$pitchClass${octave-1}";
}
