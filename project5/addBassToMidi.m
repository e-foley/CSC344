% Add to the MIDI matrix bass notes played at bass rhythm
localBeat = 0.0;
for i=1:(size(bassRhythm,2)-1+isFinal)
    localBeatEnd = localBeat + bassRhythm(i);
    
    % Find the indices of the most recent rhythm and chord change
    currentPatternIndex = floor(localBeat/beatsPerBassPatternChange)+1;
    currentKeyIndex = floor(localBeat/beatsPerChordChange)+1;
    
    nextBassNote = fundamental ...
        + extendScale(keyProgression(currentKeyIndex) + bassToneProgression(1, currentPatternIndex) - 1, scale) ...
        + 12 * bassToneProgression(2, currentPatternIndex);
    
    % Clamp bass notes so that voices appear somewhat independent
    nextBassNote = bringWithinRange(nextBassNote, [33 48]);
    midiMatrix = appendMidiMatrix(midiMatrix, 2, 2, nextBassNote, 90, (localBeat+offset)*60.0/tempo, (localBeatEnd+offset)*60.0/tempo);
    localBeat = localBeatEnd;
end