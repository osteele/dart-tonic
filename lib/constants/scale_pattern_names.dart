part of tonic;

class ScalePatternNames {
  //////////
  //scales//
  //////////
  static const String diatonicMajor = 'Diatonic Major';
  static const String naturalMinor = 'Natural Minor';
  static const String majorPentatonic = 'Major Pentatonic';
  static const String melodicMinor = 'Melodic Minor';
  static const String harmonicMinor = 'Harmonic Minor';
  static const String blues = 'Blues';
  static const String freygish = 'Freygish';
  static const String wholeTone = 'Whole Tone';
  static const String octatonic = 'Octatonic';

  /////////
  //modes//
  /////////
  //diatonic major
  static const String ionian = 'Ionian';
  static const String dorian = 'Dorian';
  static const String phrygian = 'Phrygian';
  static const String lydian = 'Lydian';
  static const String mixolydian = 'Mixolydian';
  static const String aeolian = 'Aeolian';
  static const String locrian = 'Locrian';

  //major pentatonic
  static const String majorPentatonicMode = majorPentatonic;
  static const String suspendedPentatonic = 'Suspended Pentatonic';
  static const String manGong = 'Man Gong';
  static const String ritusen = 'Ritusen';
  static const String minorPentatonic = 'Minor Pentatonic';

  //melodic minor
  static const String jazzMinor = 'Jazz Minor';
  static const String dorianFlat2 = 'Dorian ♭2';
  static const String lydianAugmented = 'Lydian Augmented';
  static const String lydianDominant = 'Lydian Dominant';
  static const String mixolydianFlat6 = 'Mixolydian ♭6';
  static const String semilocrian = 'Semilocrian';
  static const String superlocrian = 'Superlocrian';

  //harmonic minor
  static const String harmonicMinorMode = harmonicMinor;
  static const String locrianSharp6 = 'Locrian ♯6';
  static const String ionianAugmented = 'Ionian Augmented';
  static const String romanian = 'Romanian';
  static const String phrygianDominant = 'Phrygian Dominant';
  static const String lydianSharp2 = 'Lydian ♯2';
  static const String ultralocrian = 'Ultralocrian';

  static List<String> scaleNames() => [
        diatonicMajor,
        naturalMinor,
        majorPentatonic,
        melodicMinor,
        harmonicMinor,
        blues,
        freygish,
        wholeTone,
        octatonic,
      ];

  static List<String> diatonicMajorModes() => [
        ionian,
        dorian,
        phrygian,
        lydian,
        mixolydian,
        aeolian,
        locrian,
      ];

  static List<String> majorPentatonicModes() => [
        majorPentatonicMode,
        suspendedPentatonic,
        manGong,
        ritusen,
        minorPentatonic,
      ];

  static List<String> melodicMinorModes() => [
        jazzMinor,
        dorianFlat2,
        lydianAugmented,
        lydianDominant,
        mixolydianFlat6,
        semilocrian,
        superlocrian,
      ];

  static List<String> harmonicMinorModes() => [
        harmonicMinorMode,
        locrianSharp6,
        ionianAugmented,
        romanian,
        phrygianDominant,
        lydianSharp2,
        ultralocrian,
      ];
}
