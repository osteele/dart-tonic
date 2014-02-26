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
    if (value == null) throw new ArgumentError("not an accidental: $glyph in $accidentals");
    semitones += value;
  });
  return semitones;
}

String accidentalsToString(int semitones) {
  if (semitones <= -2) return accidentalsToString(semitones + 2) + '𝄫';
  if (semitones >=  2) return accidentalsToString(semitones - 2) + '𝄪';
  return ['𝄫', '♭', '', '♯', '𝄪'][semitones + 2];
}

int diatonicFloor(int semitones) {
  int pitchClassNumber = semitones % 12;
  if (FlatNoteNames[pitchClassNumber].length > 1) { semitones += 1; }
  return semitones;
}

String midi2name(int number) =>
  "${NoteNames[number % 12]}${number ~/ 12 - 1}";

final _MIDI_NAME_PATTERN = new RegExp(r'^([A-Ga-g])([♯#♭b𝄪𝄫]*)(-?\d+)');

int name2midi(String midiNoteName) {
  final match = _MIDI_NAME_PATTERN.matchAsPrefix(midiNoteName);
  if (match == null) throw new FormatException("$midiNoteName is not a midi note name");
  String naturalName = match[1];
  String accidentals = match[2];
  String octaveName = match[3];
  int pitch = NoteNames.indexOf(naturalName.toUpperCase());
  pitch += parseAccidentals(accidentals);
  pitch += 12 * (int.parse(octaveName) + 1);
  return pitch;
}

final Pattern _HELMHOLTZ_PITCH_NAME_PATTERN = new RegExp(r"^([A-Ga-g])([#♯b♭𝄪𝄫]*)(,*)('*)$");
final RegExp _SCIENTIFIC_PITCH_NAME_PATTERN = new RegExp(r"^([A-Ga-g])([#♯b♭𝄪𝄫]*)(-?\d+)$");

class Pitch {
  final int diatonicSemitones;
  final int accidentalSemitones;

  static final Map<String, Pitch> _interned = <String, Pitch>{};

  PitchClass get pitchClass => toPitchClass();
  int get octave => diatonicSemitones ~/ 12;

  /// a String in ['A'..'G']
  String get letterName => NoteNames[diatonicSemitones % 12];

  /// an int in [0...7], where 0 represents 'C'
  int get letterIndex => (letterName.codeUnitAt(0) - 67) % 7;

  // both Pitch and PitchClass respond to toPitch
  Pitch toPitch() => this;

  // both Pitch and PitchClass respond to toPitchClass
  PitchClass toPitchClass() =>
    new PitchClass(integer: midiNumber % 12);

  // chromaticIndex is in semitones but must index a diatonic pitch
  factory Pitch({int chromaticIndex, int accidentalSemitones: 0, int octave: -1}) {
    octave += chromaticIndex ~/ 12;
    chromaticIndex = chromaticIndex % 12;
    if (NoteNames[chromaticIndex].length > 1) {
      accidentalSemitones += 1;
      chromaticIndex -= 1;
    }
    var key = "$octave:$chromaticIndex:$accidentalSemitones";
    if (_interned.containsKey(key)) return _interned[key];
    return _interned[key] = new Pitch._internal(chromaticIndex: chromaticIndex, accidentalSemitones: accidentalSemitones, octave: octave);
  }

  Pitch._internal({int chromaticIndex, int this.accidentalSemitones: 0, int octave: -1})
    : diatonicSemitones = chromaticIndex + 12 * (octave + 1);

  static Pitch parse(String pitchName) =>
    _SCIENTIFIC_PITCH_NAME_PATTERN.hasMatch(pitchName)
      ? parseScientificNotation(pitchName)
      : parseHelmholtzNotation(pitchName);

  static Pitch parseScientificNotation(String pitchName) {
    var match = _SCIENTIFIC_PITCH_NAME_PATTERN.matchAsPrefix(pitchName);
    if (match == null) throw new FormatException("not in scientific notation: $pitchName");
    String naturalName = match[1];
    String accidentals = match[2];
    String octaveName = match[3];
    int pitch = NoteNames.indexOf(naturalName.toUpperCase());
    int accidentalSemitones = parseAccidentals(accidentals);
    int octave = int.parse(octaveName);
    return new Pitch(chromaticIndex: pitch, accidentalSemitones: accidentalSemitones, octave: octave);
  }

  static Pitch parseHelmholtzNotation(String pitchName) {
    var match = _HELMHOLTZ_PITCH_NAME_PATTERN.matchAsPrefix(pitchName);
    if (match == null) throw new FormatException("not in Helmholtz notation: $pitchName");
    String naturalName = match[1];
    String accidentals = match[2];
    String commas = match[3];
    String apostrophes = match[4];
    int pitch = NoteNames.indexOf(naturalName.toUpperCase());
    int accidentalSemitones = parseAccidentals(accidentals);
    int octave = 3 + apostrophes.length - commas.length;
    if (naturalName == naturalName.toUpperCase()) { octave -= 1; }
    return new Pitch(chromaticIndex: pitch, accidentalSemitones: accidentalSemitones, octave: octave);
  }

  factory Pitch.fromMidiNumber(int midiNumber) =>
    new Pitch(chromaticIndex: midiNumber % 12, octave: midiNumber ~/ 12 - 1);

  int get midiNumber => diatonicSemitones + accidentalSemitones;

  bool operator ==(Pitch other) =>
    diatonicSemitones == other.diatonicSemitones && accidentalSemitones == other.accidentalSemitones;

  int get hashCode => 37 * diatonicSemitones + accidentalSemitones;

  Pitch operator +(Interval interval) {
    var diatonicIndex = letterIndex + interval.number - 1;
    var octave = this.octave + diatonicIndex ~/ 7;
    diatonicIndex %= 7;
    var semitones = [0, 2, 4, 5, 7, 9, 11][diatonicIndex] + 12 * octave;
    var accidentals = midiNumber + interval.semitones - semitones;
    return new Pitch(chromaticIndex: semitones, accidentalSemitones: accidentals);
  }

  // TODO subtract an Interval to produce a Pitch; subtract a Pitch to product an Interval?
  Interval operator -(other) =>
    new Interval.fromSemitones(midiNumber - other.midiNumber,
                               number: 1 + letterIndex + 7 * octave - other.letterIndex - 7 * other.octave);

  String get accidentalsString => accidentalsToString(accidentalSemitones);

  String toString() => "$letterName$accidentalsString${octave-1}";

  String get inspect =>
    {'letter': letterName, 'diatonicSemitones': diatonicSemitones, 'accidentals': accidentalSemitones}.toString();
}
