import 'package:test/test.dart';
import 'package:tonic/tonic.dart';

void main() {
  group('Note Names', () {
    group('flatNoteNames', () {
      test('should contain 12 pitches', () {
        expect(NoteNames.flatNoteNames(), hasLength(12));
      });

      test('should contain seven regular notes', () {
        expect(NoteNames.flatNoteNames()[0], equals('C'));
        expect(NoteNames.flatNoteNames()[2], equals('D'));
        expect(NoteNames.flatNoteNames()[4], equals('E'));
        expect(NoteNames.flatNoteNames()[5], equals('F'));
        expect(NoteNames.flatNoteNames()[7], equals('G'));
        expect(NoteNames.flatNoteNames()[9], equals('A'));
        expect(NoteNames.flatNoteNames()[11], equals('B'));
      });
      test('should contain five flats', () {
        expect(NoteNames.flatNoteNames()[1], equals('D♭'));
        expect(NoteNames.flatNoteNames()[3], equals('E♭'));
        expect(NoteNames.flatNoteNames()[6], equals('G♭'));
        expect(NoteNames.flatNoteNames()[8], equals('A♭'));
        expect(NoteNames.flatNoteNames()[10], equals('B♭'));
      });
    });

    group('sharpNoteNames', () {
      test('should contain 12 pitches', () {
        expect(NoteNames.sharpNoteNames(), hasLength(12));
      });

      test('should contain seven regular notes', () {
        expect(NoteNames.sharpNoteNames()[0], equals('C'));
        expect(NoteNames.sharpNoteNames()[2], equals('D'));
        expect(NoteNames.sharpNoteNames()[4], equals('E'));
        expect(NoteNames.sharpNoteNames()[5], equals('F'));
        expect(NoteNames.sharpNoteNames()[7], equals('G'));
        expect(NoteNames.sharpNoteNames()[9], equals('A'));
        expect(NoteNames.sharpNoteNames()[11], equals('B'));
      });
      test('should contain five flats', () {
        expect(NoteNames.sharpNoteNames()[1], equals('C♯'));
        expect(NoteNames.sharpNoteNames()[3], equals('D♯'));
        expect(NoteNames.sharpNoteNames()[6], equals('F♯'));
        expect(NoteNames.sharpNoteNames()[8], equals('G♯'));
        expect(NoteNames.sharpNoteNames()[10], equals('A♯'));
      });
    });
  });
}
