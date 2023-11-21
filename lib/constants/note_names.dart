part of tonic;

class NoteNames {
  static const String aFlat = 'A♭';
  static const String a = 'A';
  static const String aSharp = 'A♯';
  static const String bFlat = 'B♭';
  static const String b = 'B';
  static const String c = 'C';
  static const String cSharp = 'C♯';
  static const String dFlat = 'D♭';
  static const String d = 'D';
  static const String dSharp = 'D♯';
  static const String eFlat = 'E♭';
  static const String e = 'E';
  static const String f = 'F';
  static const String fSharp = 'F♯';
  static const String gFlat = 'G♭';
  static const String g = 'G';
  static const String gSharp = 'G♯';

  static List<String> sharpNoteNames() => [
        c,
        cSharp,
        d,
        dSharp,
        e,
        f,
        fSharp,
        g,
        gSharp,
        a,
        aSharp,
        b,
      ];

  static List<String> flatNoteNames() => [
        c,
        dFlat,
        d,
        eFlat,
        e,
        f,
        gFlat,
        g,
        aFlat,
        a,
        bFlat,
        b,
      ];
}
