part of tonic;

/// A Fretting is a map of fingers to sets of frets, that voice a chord on a fretted
/// instrument.
///
/// These are "frettings" and not "voicings" because they also include barre
/// information.
class Fretting {
  final Chord chord;
  final List<FretPosition> positions; // sorted by string index
  final FrettedInstrument instrument;

  // caches:
  List<int> _stringFretList;
  String _fretString;

  Fretting({this.instrument, this.chord, Iterable<FretPosition> positions})
      : this.positions = List<FretPosition>.from(
            sortedBy(positions, (pos) => pos.stringIndex, reverse: true)) {
    assert(chord != null);
    assert(instrument != null);
    assert(positions.length ==
        positions.map((position) => position.stringIndex).toSet().length);
  }

  static Fretting fromFretString(String fretString,
      {FrettedInstrument instrument, Chord chord}) {
    if (fretString.length != instrument.stringIndices.length) {
      throw new FormatException(
          "fretString wrong length for $instrument: $fretString");
    }

    Iterable<String> _fretString = fretString.split('');
    Iterable<int> _stringIndices = instrument.stringIndices;

    var _positions = IterableZip([_fretString, _stringIndices]);

    Iterable<FretPosition> positions = _positions.map((item) {
      String char = item[0];
      int stringIndex = item[1];
      if (char == 'x') return null;
      var fretNumber = char.runes.first - 48;
      if (!(0 <= fretNumber && fretNumber <= 9)) {
        throw new FormatException(
            "Invalid character $char in fretString $fretString");
      }
      var semitones = instrument
          .pitchAt(stringIndex: stringIndex, fretNumber: fretNumber)
          .semitones;
      return new FretPosition(
          stringIndex: stringIndex,
          fretNumber: fretNumber,
          semitones: semitones);
    }).where((pos) => pos != null);
    return new Fretting(
        instrument: instrument, chord: chord, positions: positions);
  }

  String toString() => fretString;

  List<int> get stringFretList => _stringFretList != null
      ? _stringFretList
      : _stringFretList = instrument.stringIndices
          .map((int stringIndex) => positions.firstWhere(
              (pos) => pos.stringIndex == stringIndex,
              orElse: () => null))
          .map((pos) => pos == null ? null : pos.fretNumber)
          .toList();

  String get fretString => _fretString != null
      ? _fretString
      : _fretString = stringFretList
          .map((int fretNumber) => fretNumber == null
              ? 'x'
              : fretNumber < 10
                  ? fretNumber
                  : throw new UnimplementedError("fret >= 10"))
          .join();

  Iterable<Interval> get intervals => positions
      .map((pos) => new Interval.fromSemitones(
          (pos.semitones - chord.root.semitones) % 12))
      .toList();

  int get inversionIndex => [1, 3, 5, 7, 9].indexOf(intervals.first.number);
}

//
// Barres
//

// powerset = (array) ->
//   return [[]] unless array.length
//   [x, xs...] = array
//   tail = powerset(xs)
//   return tail.concat([x].concat(ys) for ys in tail)

// Returns an array of strings indexed by fret number. Each string
// has a character at each string position:
// '=' = fretted at this fret
// '>' = fretted at a higher fret
// '<' = fretted at a lower fret, or open
// 'x' = muted
// computeBarreCandidateStrings = (instrument, fretArray) ->
//   codeStrings = []
//   for referenceFret in fretArray
//     continue unless typeof(referenceFret) == 'number'
//     codeStrings[referenceFret] or= (for fret in fretArray
//       if fret < referenceFret
//         '<'
//       else if fret > referenceFret
//         '>'
//       else if fret == referenceFret
//         '='
//       else
//         'x').join('')
//   return codeStrings

// findBarres = (instrument, fretArray) ->
//   barres = []
//   for codeString, fret in computeBarreCandidateStrings(instrument, fretArray)
//     continue if fret == 0
//     continue unless codeString
//     match = codeString.match(/(=[>=]+)/)
//     continue unless match
//     run = match[1]
//     continue unless run.match(/\=/g).length > 1
//     barres.push
//       fret: fret
//       firstString: match.index
//       stringCount: run.length
//       fingerReplacementCount: run.match(/\=/g).length
//   return barres

// collectBarreSets = (instrument, fretArray) ->
//   barres = findBarres(instrument, fretArray)
//   return powerset(barres)

/// A FretPosition represents the a fret on a specific string of a fretted
/// instrument.
class FretPosition {
  final int stringIndex;
  final int fretNumber;
  final int semitones;

  FretPosition({this.stringIndex, this.fretNumber, this.semitones});
  // bool operator ==(FretPosition other) =>
  //     stringIndex == other.stringIndex && fretNumber == other.fretNumber;
  @override
  bool operator ==(dynamic other) {
    final FretPosition typedOther = other;
    return stringIndex == typedOther.stringIndex &&
        fretNumber == typedOther.fretNumber;
  }

  int get hashCode => 37 * stringIndex + fretNumber;
  String toString() => "$stringIndex.$fretNumber($semitones)";
  String get inspect => {
        'string': stringIndex,
        'fret': fretNumber,
        'semitones': semitones
      }.toString();
}

Set<FretPosition> chordFrets(
    Chord chord, FrettedInstrument instrument, int highestFret) {
  var positions = new Set<FretPosition>();
  var semitoneSet = chord.pitches.map((pitch) => pitch.semitones % 12).toSet();
  eachWithIndex(instrument.stringPitches, (Pitch pitch, int stringIndex) {
    for (var fretNumber = 0; fretNumber <= highestFret; fretNumber++) {
      var semitones = instrument
          .pitchAt(stringIndex: stringIndex, fretNumber: fretNumber)
          .semitones;
      if (semitoneSet.contains(semitones % 12)) {
        var position = new FretPosition(
            stringIndex: stringIndex,
            fretNumber: fretNumber,
            semitones: semitones);
        positions.add(position);
      }
    }
  });
  return positions;
}

List<Fretting> chordFrettings(Chord chord, FrettedInstrument instrument,
    {highestFret: 4}) {
  int minPitchClasses = chord.intervals.length;
  Map<int, Set<FretPosition>> partitionFretsByString() {
    Set<FretPosition> positions = chordFrets(chord, instrument, highestFret);
    Map<int, Set<FretPosition>> partitions = new Map.fromIterable(
        instrument.stringIndices,
        key: (index) => index,
        value: (_) => new Set<FretPosition>());
    for (var position in positions) {
      partitions[position.stringIndex].add(position);
    }
    return partitions;
  }

  // collectFrettingPositions(fretCandidatesPerString) {
  //   var stringCount = fretCandidatesPerString.length;
  //   var positionSet = [];
  //   var fretArray = [];
  //   void fill(s) {
  //     if (s == stringCount) {
  //       positionSet.push fretArray.slice()
  //     } else {
  //       for fret in fretCandidatesPerString[s]
  //         fretArray[s] = fret
  //         fill s + 1;
  //     }
  //   }
  //   fill(0);
  //   return positionSet;
  // }

  // // actually tests pitch classes, not pitches
  // containsAllChordPitches(fretArray) {
  //   var trace = fretArray.join('') == '022100'
  //   var pitchClasses = []
  //   for fret, string in fretArray
  //     continue unless typeof(fret) is 'number'
  //     pitchClass = instrument.pitchAt({fret, string}).toPitchClass().semitones
  //     pitchClasses.push pitchClass unless pitchClass in pitchClasses
  //   return pitchClasses.length == chord.pitches.length
  // }

  // maximumFretDistance(fretArray) {
  //   frets = (fret for fret in fretArray when typeof(fret) is 'number')
  //   // fretArray = (fret for fret in fretArray when fret > 0)
  //   return Math.max(frets...) - Math.min(frets...) <= 3
  // }

  Set<Fretting> generateFrettings() {
    var frettings = new Set<Fretting>();
    var stringFrets = partitionFretsByString();

    void collect(Iterable<int> unprocessedStringIndices,
        Set<FretPosition> collectedPositions) {
      if (unprocessedStringIndices.isEmpty) {
        int pitchClassCount = collectedPositions
            .map((position) => position.semitones % 12)
            .toSet()
            .length;
        if (pitchClassCount >= minPitchClasses) {
          frettings.add(new Fretting(
              chord: chord,
              instrument: instrument,
              positions: collectedPositions));
        }
      } else {
        int stringIndex = unprocessedStringIndices.first;
        Iterable<int> futureStringIndices = unprocessedStringIndices.skip(1);
        collect(futureStringIndices, collectedPositions);
        for (var position in stringFrets[stringIndex]) {
          Set<FretPosition> clone = new Set.from(collectedPositions);
          clone.add(position);
          collect(futureStringIndices, clone);
        }
      }
    }

    collect(instrument.stringIndices, new Set<FretPosition>());

    //   var fretArrays = collectFrettingPositions(fretsPerString());
    //   fretArrays = fretArrays.filter(containsAllChordPitches);
    //   fretArrays = fretArrays.filter(maximumFretDistance);
    //   for fretArray in fretArrays
    //     positions = ({fret, string} for fret, string in fretArray when typeof(fret) is 'number')
    //     for pos in positions
    //       pos.intervalClass = Interval.between(chord.root, instrument.pitchAt(pos))
    //       pos.degreeIndex = chord.intervals.indexOf(pos.intervalClass)
    //     sets = [[]]
    //     sets = collectBarreSets(instrument, fretArray) if positions.length > 4
    //     for barres in sets
    //       frettings.push new Fretting {positions, chord, barres, instrument}
    return frettings;
  }

  // var chordNoteCount = chord.pitches.length;

  //
  // Filters
  //

  // // really counts distinct pitch classes, not distinct pitches
  // countDistinctNotes(fingering) {
  //   // _.chain(fingering.positions).pluck('intervalClass').uniq().value().length
  //   var intervalClasses = []
  //   for {intervalClass} in fingering.positions
  //     intervalClasses.push intervalClass unless intervalClass in intervalClasses
  //   return intervalClasses.length;
  // }

  // hasAllNotes(fingering) =>
  //   countDistinctNotes(fingering) == chordNoteCount;

  // mutedMedialStrings(fingering) =>
  //   fingering.fretstring.match(/\dx+\d/);

  // mutedTrebleStrings(fingering) =>
  //   fingering.fretstring.match(/x$/);

  // getFingerCount(fingering) {
  //   var n = (pos for pos in fingering.positions when pos.fret > 0).length;
  //   n -= barre.fingerReplacementCount - 1 for barre in fingering.barres;
  //   return n;
  // }

  // fourFingersOrFewer(fingering) =>
  //   getFingerCount(fingering) <= 4;

  // // Construct the filter set

  // var filters = [];
  // // filters.push name: 'has all chord notes', select: hasAllNotes

  // if (options.filter) {
  //   filters.push name: 'four fingers or fewer', select: fourFingersOrFewer
  // }

  // if (!options.fingerpicking) {
  //   filters.push name: 'no muted medial strings', reject: mutedMedialStrings
  //   filters.push name: 'no muted treble strings', reject: mutedTrebleStrings
  // }

  // // filter by all the filters in the list, except ignore those that wouldn't pass anything
  // filterFrettings(frettings) {
  //   for {name, select, reject} in filters
  //     filtered = frettings
  //     select = ((x) -> not reject(x)) if reject
  //     filtered = filtered.filter(select) if select
  //     unless filtered.length
  //       console.warn "#{chord.name}: no frettings pass filter \"#{name}\"" if warn
  //       filtered = frettings
  //     frettings = filtered
  //   return frettings;
  // }

  //
  // Sort
  //

  // // FIXME count pitch classes, not sounded strings
  // highNoteCount(fingering) =>
  //   fingering.positions.length;

  // isRootPosition(fingering) =>
  //   _(fingering.positions).sortBy((pos) -> pos.string)[0].degreeIndex == 0;

  // reverseSortKey = (fn) -> (a) -> -fn(a)

  // // ordered list of preferences, from most to least important
  // var preferences = [
  //   {name: 'root position', key: isRootPosition}
  //   {name: 'high note count', key: highNoteCount}
  //   {name: 'avoid barres', key: reverseSortKey((fingering) -> fingering.barres.length)}
  //   {name: 'low finger count', key: reverseSortKey(getFingerCount)}
  // ];

  Function compareBy<T>(int Function(T) f, {bool reverse: false}) =>
      reverse ? (a, b) => f(a) - f(b) : (a, b) => f(b) - f(a);

  List<Fretting> sortFrettings(Iterable<Fretting> frettingSet) {
    List<Fretting> frettingList = frettingSet.toList();
    // number of open strings:
    insertionSort(frettingList,
        compare: compareBy(
            (f) => f.positions.where((pos) => pos.fretNumber == 0).length));
    // number of sounded strings:
    insertionSort(frettingList, compare: compareBy((f) => f.positions.length));
    // root position:
    insertionSort(frettingList,
        compare: compareBy((f) => f.inversionIndex, reverse: true));
    return frettingList;
  }

  //
  // Generate, filter, and sort
  //

  var frettings = generateFrettings();
  // frettings = filterFrettings(frettings);
  var orderedFrettings = sortFrettings(frettings);

  // var properties = {
  //   'root': isRootPosition
  //   'barres': (f) -> f.barres.length
  //   'fingers': getFingerCount
  //   'inversion': (f) -> f.inversionLetter or ''
  //   // 'bass': /^\d{3}x*$/
  //   // 'treble': /^x*\d{3}$/
  //   'skipping': /\dx+\d/
  //   'muting': /\dx/
  //   'open': /0/
  //   'triad': ({positions}) -> positions.length == 3
  //   'position': ({positions}) -> Math.max(_.min(_.pluck(positions, 'fret')) - 1, 0)
  //   'strings': ({positions}) -> positions.length
  // };

  // for name, fn of properties
  //   for fingering in orderedFrettings
  //     value = if fn instanceof RegExp then fn.test(fingering.fretstring) else fn(fingering)
  //     fingering.properties[name] = value

  return orderedFrettings;
}

Fretting bestFrettingFor(Chord chord, FrettedInstrument instrument) =>
    chordFrettings(chord, instrument)[0];
