% Add to the MIDI matrix the chords specified by the key progression
localBeat = 0;
for i=1:(size(keyProgression,2) - 1 + isFinal)
    localBeatEnd = localBeat + beatsPerChordChange;
    chordAdding = fundamental + formTriChord(keyProgression(i), scale, 0)';
    midiMatrix = appendMidiMatrix(midiMatrix, 1, 1, chordAdding, 90, (localBeat+offset)*60.0/tempo, (localBeatEnd+offset)*60.0/tempo);
    localBeat = localBeatEnd;
end