part of tonic;

int normalizePitchClass(int pitchClass) => pitchClass % 12;

final pitchToPitchClass = normalizePitchClass;

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

class PitchClass {
  final int number;
  final String name;

  PitchClass({int number, String name})
    : number = normalizePitchClass(number)
    , name = name != null ? name : NoteNames[normalizePitchClass(number)];

  String toString() => name;

  Pitch toPitch({int octave: 0}) =>
    new Pitch(number: number, octave: octave);

  PitchClass toPitchClass() => this;

  PitchClass.fromSemitones(int number): this(number: number);

  static PitchClass parse(string) =>
    new PitchClass.fromSemitones(parsePitchClass(string));

  bool operator ==(PitchClass other) => other.number == number;

  PitchClass operator + (Interval interval) =>
    new PitchClass.fromSemitones(number + interval.semitones);
}
