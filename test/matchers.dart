// part of tonic_test;
import 'package:test/test.dart';
import 'tonic_test.dart';
import 'package:tonic/tonic.dart';

class _IsList extends TypeMatcher {
  const _IsList() : super('List');
  bool matches(item, Map matchState) => item is List;
}

const isList = const _IsList();

class _IsChord extends TypeMatcher {
  const _IsChord() : super('Chord');
  bool matches(item, Map matchState) => item is Chord;
}

const isChord = const _IsChord();

class _IsChordPattern extends TypeMatcher {
  const _IsChordPattern() : super('ChordPattern');
  bool matches(item, Map matchState) => item is ChordPattern;
}

const isChordPattern = const _IsChordPattern();

class _IsInstrument extends TypeMatcher {
  const _IsInstrument() : super('Instrument');
  bool matches(item, Map matchState) => item is Instrument;
}

const isInstrument = const _IsInstrument();

class _IsFrettedInstrument extends TypeMatcher {
  const _IsFrettedInstrument() : super('FrettedInstrument');
  bool matches(item, Map matchState) => item is FrettedInstrument;
}

const isFrettedInstrument = const _IsFrettedInstrument();

class _IsMode extends TypeMatcher {
  const _IsMode() : super('Mode');
  bool matches(item, Map matchState) => item is Mode;
}

const isMode = const _IsMode();
