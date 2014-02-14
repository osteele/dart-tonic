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

String pitchClassToString(int pitch, {bool flat: false, bool sharp: false}) {
  int pitchClass = pitchToPitchClass(pitch);
  String flatName = FlatNoteNames[pitchClass];
  String sharpName = SharpNoteNames[pitchClass];
  String name = sharp ? sharpName : flatName;
  if (flat && sharp && flatName != sharpName) {
    name = "$flatName/\n$sharpName";
  }
  return name;
}

// The interval class (integer in [0...12]) between two pitch class numbers
int intervalClassDifference(pca, pcb) => normalizePitchClass(pcb - pca);

int normalizePitchClass(int pitchClass) => pitchClass % 12;

final pitchToPitchClass = normalizePitchClass;

int parseScientificNotation(String pitchName) {
  var re = new RegExp(r'^([A-Ga-g])([#♯b♭𝄪𝄫]*)(-?\d+)$');
  var match = re.matchAsPrefix(pitchName);
  if (match == null) {
    throw new ArgumentError("$pitchName is not in scientific notation");
  }
  String naturalName = match[1];
  String accidentals = match[2];
  String octaveName = match[3];
  int pitch = NoteNames.indexOf(naturalName.toUpperCase());
  pitch += parseAccidentals(accidentals);
  pitch += 12 * (int.parse(octaveName) + 1);
  return pitch;
}

int pitchFromHelmholtzNotation(String pitchName) {
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
  pitch += parseAccidentals(accidentals);
  int octave = 4 - commas.length + apostrophes.length;
  if (naturalName == naturalName.toUpperCase()) { octave -= 1; }
  pitch += 12 * octave;
  return pitch;
}

// toScientificNotation = (midiNumber) ->
//   octave = Math.floor(midiNumber / 12) - 1
//   return parsePitchClass(normalizePitchClass(midiNumber)) + octave

int parsePitchClass(String pitchClassName, {bool normal: true}) {
  var re = new RegExp(r'^([A-Ga-g])([#♯b♭𝄪𝄫]*)$');
  var match = re.matchAsPrefix(pitchClassName);
  if (match == null) {
    throw new ArgumentError("$pitchClassName is not a pitch class name");
  }
  String naturalName = match[1];
  String accidentals = match[2];
  int pitch = NoteNames.indexOf(naturalName.toUpperCase());
  pitch += parseAccidentals(accidentals);
  if (normal) { pitch = normalizePitchClass(pitch); }
  return pitch;
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
  int midiNumber;
  String name;

  static final Map<String, Interval> _cache = <String, Interval>{};

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

  Pitch._internal({int this.midiNumber, String this.name});

  static Pitch parse(String name) {
    int midiNumber = (new RegExp(r'\d').hasMatch(name) ? parseScientificNotation : pitchFromHelmholtzNotation)(name);
    return new Pitch(name: name, midiNumber: midiNumber);
  }

  Pitch.fromMidiNumber(int this.midiNumber) {
    name = midi2name(midiNumber);
  }

  bool operator ==(Pitch other) => other.name == name;

  Pitch operator + (Interval interval) =>
    new Pitch.fromMidiNumber(midiNumber + interval.semitones);

  String toString() => name;
}


class PitchClass {
  int semitones;
  String name;

  PitchClass({int this.semitones, String this.name}) {
    semitones = normalizePitchClass(semitones);
    if (name == null) { name = NoteNames[semitones]; }
  }

  String toString() => name;

  Pitch toPitch({int octave: 0}) =>
    new Pitch.fromMidiNumber(semitones + 12 * (octave + 1));

  PitchClass toPitchClass() => this;

  PitchClass.fromSemitones(int semitones): this(semitones: semitones);

  static PitchClass parse(string) => new PitchClass.fromSemitones(parsePitchClass(string));

  bool operator ==(PitchClass other) => other.semitones == semitones;

  PitchClass operator + (Interval interval) =>
    new PitchClass.fromSemitones(semitones + interval.semitones);
}
