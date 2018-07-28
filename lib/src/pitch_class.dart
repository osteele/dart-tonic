part of tonic;

int normalizePitchClass(int pitchClass) => pitchClass % 12;

final pitchToPitchClass = normalizePitchClass;

String pitchClassToString(int pitch, {bool flat: false, bool sharp: false}) {
  int pitchClass = pitchToPitchClass(pitch);
  String flatName = FlatNoteNames[pitchClass];
  String sharpName = SharpNoteNames[pitchClass];
  String name = sharp ? sharpName : flatName;
  if (flat && sharp && flatName != sharpName) name = "$flatName/\n$sharpName";
  return name;
}

class PitchClass {
  final int integer;

  static final Map<int, PitchClass> _interned = <int, PitchClass>{};

  factory PitchClass({int integer}) {
    integer %= 12;
    var key = integer;
    if (_interned.containsKey(key)) return _interned[key];
    return _interned[key] = new PitchClass._internal(integer);
  }

  PitchClass._internal(int this.integer);

  String toString() => NoteNames[integer];

  String get inspect => {'integer': integer}.toString();

  Pitch toPitch({int octave: 0}) =>
      new Pitch(chromaticIndex: integer, octave: octave);

  PitchClass toPitchClass() => this;

  factory PitchClass.fromSemitones(int integer) =>
      new PitchClass(integer: integer);

  static final _PITCH_CLASS_PATTERN = new RegExp(r'^([A-Ga-g])([#♯b♭𝄪𝄫]*)$');

  static PitchClass parse(String pitchClassName) {
    final match = _PITCH_CLASS_PATTERN.matchAsPrefix(pitchClassName);
    if (match == null)
      throw new FormatException("$pitchClassName is not a pitch class name");
    String naturalName = match[1];
    String accidentals = match[2];
    int integer = NoteNames.indexOf(naturalName.toUpperCase());
    integer += parseAccidentals(accidentals);
    return new PitchClass(integer: integer);
  }

  // bool operator ==(PitchClass other) => integer == other.integer;

  // bool operator ==(PitchClass o) => identical(integer, o.integer);

  @override
  bool operator ==(dynamic other) {
    final PitchClass typedOther = other;
    return integer == typedOther.integer;
  }

  int get hashCode => integer;

  PitchClass operator +(Interval interval) =>
      new PitchClass(integer: integer + interval.semitones);
}
