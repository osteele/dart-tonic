part of tonic;

/// Note names (e.g. C, C♯), indexed by half-steps above C. Notes that require
/// accidentals use sharps (♯).
final List<String> sharpNoteNames = [
  'C',
  'C♯',
  'D',
  'D♯',
  'E',
  'F',
  'F♯',
  'G',
  'G♯',
  'A',
  'A♯',
  'B'
];

/// Note names (e.g. C, D♭), indexed by half-steps above C. Notes that require
/// accidentals use flats (♭).
final List<String> flatNoteNames = [
  'C',
  'D♭',
  'D',
  'E♭',
  'E',
  'F',
  'G♭',
  'G',
  'A♭',
  'A',
  'B♭',
  'B'
];

/// Note names (e.g. C, C♯), indexed by half-steps above C. This has the same
/// value as sharpNoteNames.
final List<String> noteNames = sharpNoteNames;

/// A map from the string representation of an accidental (♯, ♭, 𝄪, 𝄫) to
/// the number of half-steps that the accidental adds to a pitch.
final Map<String, int> accidentalValues = {
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
    final glyph = new String.fromCharCode(rune);
    final int? value = accidentalValues[glyph];
    if (value == null)
      throw new ArgumentError("not an accidental: $glyph in $accidentals");
    semitones += value;
  });
  return semitones;
}

String accidentalsToString(int semitones) {
  if (semitones <= -2) return accidentalsToString(semitones + 2) + '𝄫';
  if (semitones >= 2) return accidentalsToString(semitones - 2) + '𝄪';
  return ['𝄫', '♭', '', '♯', '𝄪'][semitones + 2];
}

int diatonicFloor(int semitones) {
  final int pitchClassNumber = semitones % 12;
  if (flatNoteNames[pitchClassNumber].length > 1) {
    semitones += 1;
  }
  return semitones;
}

String midi2name(int number) => "${noteNames[number % 12]}${number ~/ 12 - 1}";

final midiNamePattern = new RegExp(r'^([A-Ga-g])([♯#♭b𝄪𝄫]*)(-?\d+)');

int name2midi(String midiNoteName) {
  final match = midiNamePattern.matchAsPrefix(midiNoteName);
  if (match == null)
    throw new FormatException("$midiNoteName is not a midi note name");
  final String naturalName = match[1]!;
  final String accidentals = match[2]!;
  final String octaveName = match[3]!;
  int pitch = noteNames.indexOf(naturalName.toUpperCase());
  pitch += parseAccidentals(accidentals);
  pitch += 12 * (int.parse(octaveName) + 1);
  return pitch;
}

final Pattern _helmholtzPitchNamePattern =
    new RegExp(r"^([A-Ga-g])([#♯b♭𝄪𝄫]*)(,*)('*)$");
final RegExp _scientificPitchNamePattern =
    new RegExp(r"^([A-Ga-g])([#♯b♭𝄪𝄫]*)(-?\d+)$");

/// A musical pitch, represented as a pair of the number of diatonic semitones
/// C, and the number of accidental semitones above this diatonic value.
class Pitch {
  final int diatonicSemitones;
  final int accidentalSemitones;

  static final Map<String, Pitch> _interned = <String, Pitch>{};

  int get semitones => diatonicSemitones + accidentalSemitones;

  int get octave => diatonicSemitones ~/ 12;

  /// a String in ['A'..'G']
  String get letterName => noteNames[diatonicSemitones % 12];

  /// an int in [0...7], where 0 represents 'C'
  int get letterIndex => (letterName.codeUnitAt(0) - 67) % 7;

  // both Pitch and PitchClass respond to toPitch
  Pitch toPitch() => this;

  // both Pitch and PitchClass respond to toPitchClass
  PitchClass toPitchClass() => new PitchClass(integer: midiNumber % 12);

  PitchClass get pitchClass => toPitchClass();

  // chromaticIndex is in semitones but must index a diatonic pitch
  factory Pitch(
      {required int chromaticIndex,
      int accidentalSemitones: 0,
      int octave: -1}) {
    octave += chromaticIndex ~/ 12;
    chromaticIndex = chromaticIndex % 12;
    if (noteNames[chromaticIndex].length > 1) {
      accidentalSemitones += 1;
      chromaticIndex -= 1;
    }
    final key = "$octave:$chromaticIndex:$accidentalSemitones";
    if (_interned.containsKey(key)) return _interned[key]!;
    return _interned[key] = new Pitch._internal(
        chromaticIndex: chromaticIndex,
        accidentalSemitones: accidentalSemitones,
        octave: octave);
  }

  Pitch._internal({
    required int chromaticIndex,
    this.accidentalSemitones: 0,
    int octave: -1,
  }) : diatonicSemitones = chromaticIndex + 12 * (octave + 1);

  static Pitch parse(String pitchName) =>
      _scientificPitchNamePattern.hasMatch(pitchName)
          ? parseScientificNotation(pitchName)
          : parseHelmholtzNotation(pitchName);

  static Pitch parseScientificNotation(String pitchName) {
    final match = _scientificPitchNamePattern.matchAsPrefix(pitchName);
    if (match == null)
      throw new FormatException("not in scientific notation: $pitchName");
    final String naturalName = match[1]!;
    final String accidentals = match[2]!;
    final String octaveName = match[3]!;
    final int pitch = noteNames.indexOf(naturalName.toUpperCase());
    final int accidentalSemitones = parseAccidentals(accidentals);
    final int octave = int.parse(octaveName);
    return new Pitch(
        chromaticIndex: pitch,
        accidentalSemitones: accidentalSemitones,
        octave: octave);
  }

  static Pitch parseHelmholtzNotation(String pitchName) {
    final match = _helmholtzPitchNamePattern.matchAsPrefix(pitchName);
    if (match == null)
      throw new FormatException("not in Helmholtz notation: $pitchName");
    final String naturalName = match[1]!;
    final String accidentals = match[2]!;
    final String commas = match[3]!;
    final String apostrophes = match[4]!;
    final int pitch = noteNames.indexOf(naturalName.toUpperCase());
    final int accidentalSemitones = parseAccidentals(accidentals);
    int octave = 3 + apostrophes.length - commas.length;
    if (naturalName == naturalName.toUpperCase()) {
      octave -= 1;
    }
    return new Pitch(
        chromaticIndex: pitch,
        accidentalSemitones: accidentalSemitones,
        octave: octave);
  }

  factory Pitch.fromMidiNumber(int midiNumber) =>
      new Pitch(chromaticIndex: midiNumber % 12, octave: midiNumber ~/ 12 - 1);

  int get midiNumber => diatonicSemitones + accidentalSemitones;

  // bool operator ==(Pitch other) =>
  //     diatonicSemitones == other.diatonicSemitones &&
  //     accidentalSemitones == other.accidentalSemitones;
  @override
  bool operator ==(dynamic other) {
    final Pitch typedOther = other;
    return diatonicSemitones == typedOther.diatonicSemitones &&
        accidentalSemitones == typedOther.accidentalSemitones;
  }

  int get hashCode => 37 * diatonicSemitones + accidentalSemitones;

  Pitch operator +(Interval interval) {
    var diatonicIndex = letterIndex + interval.number - 1;
    final octave = this.octave + diatonicIndex ~/ 7;
    diatonicIndex %= 7;
    final semitones = [0, 2, 4, 5, 7, 9, 11][diatonicIndex] + 12 * octave;
    final accidentals = midiNumber + interval.semitones - semitones;
    return new Pitch(
        chromaticIndex: semitones, accidentalSemitones: accidentals);
  }

  // TODO subtract an Interval to produce a Pitch; subtract a Pitch to product an Interval?
  Interval operator -(dynamic other) {
    if (other is Pitch) {
      var semitones = this.semitones - other.semitones;
      var number =
          1 + letterIndex + 7 * octave - other.letterIndex - 7 * other.octave;
      // TODO enhance Interval to represent intervals greater than an octave
      while (number < 1) {
        number += 7;
        semitones += 12;
      }
      while (number > 8) {
        number -= 7;
        semitones -= 12;
      }
      return new Interval.fromSemitones(semitones, number: number);
    }
    throw new ArgumentError("can't subtract $other from $this");
  }

  String get accidentalsString => accidentalsToString(accidentalSemitones);

  String toString() => "$letterName$accidentalsString${octave - 1}";

  String get helmholtzName {
    String helmholtzLetter = '';
    String helmholtzCommas = '';
    String helmholtzApostrophes = '';

    switch (octave - 1) {
      case 0:
      case 1:
      case 2:
        helmholtzLetter = letterName;
        helmholtzCommas = "," * (3 - octave);
        break;
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
        helmholtzLetter = letterName.toLowerCase();
        helmholtzApostrophes = "'" * (octave - 4);
        break;
    }
    return "$helmholtzLetter$accidentalsString$helmholtzCommas$helmholtzApostrophes";
  }

  String get inspect => {
        'letter': letterName,
        'diatonicSemitones': diatonicSemitones,
        'accidentals': accidentalSemitones
      }.toString();
}
