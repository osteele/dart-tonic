import 'package:test/test.dart';
import 'package:tonic/tonic.dart';

void main() {
  group('Scale Pattern Names', () {
    group('scales', () {
      test('should contain 9 scales', () {
        expect(ScalePatternNames.scaleNames(), hasLength(9));
      });

      test('should contain 9 scales', () {
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.diatonicMajor), equals(true));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.naturalMinor), equals(true));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.majorPentatonic), equals(true));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.melodicMinor), equals(true));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.harmonicMinor), equals(true));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.blues), equals(true));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.freygish), equals(true));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.wholeTone), equals(true));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.octatonic), equals(true));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.aeolian), equals(false));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.mixolydian), equals(false));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.suspendedPentatonic), equals(false));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.mixolydianFlat6), equals(false));
        expect(ScalePatternNames.scaleNames().contains(ScalePatternNames.phrygianDominant), equals(false));
      });
    });

    group('modes', () {
      test('diatonic major should contain 7 modes', () {
        expect(ScalePatternNames.diatonicMajorModes(), hasLength(7));
      });
      test('diatonic major should contain these 7 modes', () {
        expect(ScalePatternNames.diatonicMajorModes()[0], equals(ScalePatternNames.ionian));
        expect(ScalePatternNames.diatonicMajorModes()[1], equals(ScalePatternNames.dorian));
        expect(ScalePatternNames.diatonicMajorModes()[2], equals(ScalePatternNames.phrygian));
        expect(ScalePatternNames.diatonicMajorModes()[3], equals(ScalePatternNames.lydian));
        expect(ScalePatternNames.diatonicMajorModes()[4], equals(ScalePatternNames.mixolydian));
        expect(ScalePatternNames.diatonicMajorModes()[5], equals(ScalePatternNames.aeolian));
        expect(ScalePatternNames.diatonicMajorModes()[6], equals(ScalePatternNames.locrian));
        expect(ScalePatternNames.diatonicMajorModes().contains(ScalePatternNames.majorPentatonic), equals(false));
        expect(ScalePatternNames.diatonicMajorModes().contains(ScalePatternNames.ritusen), equals(false));
        expect(ScalePatternNames.diatonicMajorModes().contains(ScalePatternNames.jazzMinor), equals(false));
        expect(ScalePatternNames.diatonicMajorModes().contains(ScalePatternNames.locrianSharp6), equals(false));
      });

      test('major pentatonic should contain 5 modes', () {
        expect(ScalePatternNames.majorPentatonicModes(), hasLength(5));
      });

      test('major pentatonic should contain these 5 modes', () {
        expect(ScalePatternNames.majorPentatonicModes()[0], equals(ScalePatternNames.majorPentatonicMode));
        expect(ScalePatternNames.majorPentatonicModes()[1], equals(ScalePatternNames.suspendedPentatonic));
        expect(ScalePatternNames.majorPentatonicModes()[2], equals(ScalePatternNames.manGong));
        expect(ScalePatternNames.majorPentatonicModes()[3], equals(ScalePatternNames.ritusen));
        expect(ScalePatternNames.majorPentatonicModes()[4], equals(ScalePatternNames.minorPentatonic));
        expect(ScalePatternNames.majorPentatonicModes().contains(ScalePatternNames.lydian), equals(false));
        expect(ScalePatternNames.majorPentatonicModes().contains(ScalePatternNames.lydianDominant), equals(false));
        expect(ScalePatternNames.majorPentatonicModes().contains(ScalePatternNames.lydianSharp2), equals(false));
        expect(ScalePatternNames.majorPentatonicModes().contains(ScalePatternNames.melodicMinor), equals(false));
      });

      test('melodic minor should contain 7 modes', () {
        expect(ScalePatternNames.melodicMinorModes(), hasLength(7));
      });
      test('melodic minor should contain these 7 modes', () {
        expect(ScalePatternNames.melodicMinorModes()[0], equals(ScalePatternNames.jazzMinor));
        expect(ScalePatternNames.melodicMinorModes()[1], equals(ScalePatternNames.dorianFlat2));
        expect(ScalePatternNames.melodicMinorModes()[2], equals(ScalePatternNames.lydianAugmented));
        expect(ScalePatternNames.melodicMinorModes()[3], equals(ScalePatternNames.lydianDominant));
        expect(ScalePatternNames.melodicMinorModes()[4], equals(ScalePatternNames.mixolydianFlat6));
        expect(ScalePatternNames.melodicMinorModes()[5], equals(ScalePatternNames.semilocrian));
        expect(ScalePatternNames.melodicMinorModes()[6], equals(ScalePatternNames.superlocrian));
        expect(ScalePatternNames.melodicMinorModes().contains(ScalePatternNames.harmonicMinor), equals(false));
        expect(ScalePatternNames.melodicMinorModes().contains(ScalePatternNames.mixolydian), equals(false));
        expect(ScalePatternNames.melodicMinorModes().contains(ScalePatternNames.minorPentatonic), equals(false));
        expect(ScalePatternNames.melodicMinorModes().contains(ScalePatternNames.ionianAugmented), equals(false));
      });

      test('harmonic minor should contain 7 modes', () {
        expect(ScalePatternNames.harmonicMinorModes(), hasLength(7));
      });
      test('harmonic minor should contain these 7 modes', () {
        expect(ScalePatternNames.harmonicMinorModes()[0], equals(ScalePatternNames.harmonicMinorMode));
        expect(ScalePatternNames.harmonicMinorModes()[1], equals(ScalePatternNames.locrianSharp6));
        expect(ScalePatternNames.harmonicMinorModes()[2], equals(ScalePatternNames.ionianAugmented));
        expect(ScalePatternNames.harmonicMinorModes()[3], equals(ScalePatternNames.romanian));
        expect(ScalePatternNames.harmonicMinorModes()[4], equals(ScalePatternNames.phrygianDominant));
        expect(ScalePatternNames.harmonicMinorModes()[5], equals(ScalePatternNames.lydianSharp2));
        expect(ScalePatternNames.harmonicMinorModes()[6], equals(ScalePatternNames.ultralocrian));
        expect(ScalePatternNames.harmonicMinorModes().contains(ScalePatternNames.melodicMinor), equals(false));
        expect(ScalePatternNames.harmonicMinorModes().contains(ScalePatternNames.dorian), equals(false));
        expect(ScalePatternNames.harmonicMinorModes().contains(ScalePatternNames.minorPentatonic), equals(false));
        expect(ScalePatternNames.harmonicMinorModes().contains(ScalePatternNames.jazzMinor), equals(false));
      });
    });
  });
}
