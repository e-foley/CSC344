% Add the melody to the MIDI matrix
localBeat = 0.0;
for i=1:(size(melodyPivotRhythm,2)-1+isFinal)
    localBeatEnd = localBeat + melodyPivotRhythm(i);
    
    % Find indices of chords now and when this beat ends so we can locate
    % tonal bounds for our transition flourishes (if any)
    currKeyIndex = floor(localBeat / beatsPerChordChange) + 1;
    nextKeyIndex = floor(localBeatEnd / beatsPerChordChange) + 1;
    
    % Minus one accounts for musical interval mathematics (a fifth plus a
    % fourth is an octave, not a ninth)
    currMelodyDegree = 7 + keyProgression(currKeyIndex) + melodyDegreeProgression(i) - 1;
    
    if (nextKeyIndex < size(keyProgression, 2) && i < size(melodyDegreeProgression, 2))
        nextMelodyDegree = 7 + keyProgression(nextKeyIndex) + melodyDegreeProgression(i+1) - 1;
    else
        % If we're at the end of the song, don't try transitioning
        nextMelodyDegree = currMelodyDegree;
    end
    
    % Form the flourish itself
    [notes, beatsStart, beatsEnd] = linearTransition(currMelodyDegree, nextMelodyDegree, melodyRateProgression(i), melodyPivotRhythm(i), scale);
   
    for j=1:size(notes,2);        
        midiMatrix = appendMidiMatrix(midiMatrix, 3, 3, fundamental+notes(j), 90, (beatsStart(j)+localBeat+offset)*60.0/tempo, (beatsEnd(j)+localBeat+offset)*60.0/tempo);
    end
    
    localBeat = localBeatEnd;
end