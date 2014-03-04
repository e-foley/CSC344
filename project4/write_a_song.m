clc;
clear;

tempo = 136.0;  % beats per minute
beatsPerRepeat = 32;
repeats = 4;

beatsPerChordChange = 4;
beatsPerBassPatternChange = 0.5;

fundamental = randi([45 65])

BEAT_FRACTIONS = [1 1 2 2 2 4 4 4 4 4 4 5 6 6 7 8 8 8 8 8 8 8 8 12 12 16 16 16 16 16 16];
%BEAT_FRACTIONS = [64];

define_scale_constants;

scaleSelections = [MAJOR_SCALE; MINOR_SCALE; HARMONIC_MINOR_SCALE];
scale = scaleSelections(randi([1 3]),:)

define_markov_constants;

% Written like this so that we can see what the random values are
randoContribs = rand(7,1);
keyTransitionMatrix = randoContribs(1) * CIRCLE_OF_FIFTHS ...
                    + randoContribs(2) * CHAOS ...
                    + randoContribs(3) * ONE_FOUR_FIVE ...
                    + randoContribs(4) * ASCENDING ...
                    + randoContribs(5) * DESCENDING ...
                    + randoContribs(6) * MAINTAIN ...
                    + randoContribs(7) * RESOLVE;

keyMap = (1:7)';                
                
bassRhythmMatrix = [75 25  0  0 0;
                     0  0 90 10 0;
                    75 25  0  0 0;
                     0  0 60 40 0;
                     0  0  0  0 1];
                 
bassRhythmMap = [1; 0.5; 0.5; 1; 4];
                 
                        
bassToneTransitionMatrix = [2 1 1 0;
                            1 1 1 1;
                            2 1 1 2;
                            0 1 2 1];
                        
bassToneMap = [1 -1; 3 -1; 5 -1; 1 0];
                 
pivotRhythmMatrix = [1 1 0 1 0 0 0; % whole "1"
                     0 0 1 0 0 0 0; % half "1"
                     1 1 0 1 0 0 0; % half "2"
                     0 0 0 0 1 0 0; % quarter "1"
                     0 0 0 0 0 1 0; % quarter "2"
                     0 0 0 0 0 0 1; % quarter "3"
                     1 1 0 1 0 0 0];% quarter "4"
                 
pivotRhythmMap = [4; 2; 2; 1; 1; 1; 1];

% melodyDegreeMatrix = [8 1 4 2 4 4 1;
%                       8 1 4 2 4 4 1;
%                       8 1 4 2 4 4 1;
%                       8 1 4 2 4 4 1;
%                       8 1 4 2 4 4 1;
%                       8 1 4 2 4 4 1;
%                       8 1 4 2 4 4 1];

melodyDegreeMatrix = [50 4 10 3 15 5 1;
                      50 4 10 3 15 5 1;
                      50 4 10 3 15 5 1;
                      50 4 10 3 15 5 1;
                      50 4 10 3 15 5 1;
                      50 4 10 3 15 5 1;
                      50 4 10 3 15 5 1];

melodyDegreeMap = (1:7)';
              
              

keyProgression = generateProgression(ceil(beatsPerRepeat/beatsPerChordChange), repeats, keyTransitionMatrix, keyMap, 1, 1)
bassRhythm = generateRhythm(beatsPerRepeat*repeats, bassRhythmMatrix, bassRhythmMap, randi(2), 5);
bassToneProgression = generateProgression(beatsPerRepeat*repeats/beatsPerBassPatternChange, 1, bassToneTransitionMatrix, bassToneMap, 1, 1)
melodyPivotRhythm = generateRhythm(beatsPerRepeat*repeats, pivotRhythmMatrix, pivotRhythmMap, randi(2), 1)
melodyDegreeProgression = generateProgression(size(melodyPivotRhythm,2)-1, 1, melodyDegreeMatrix, melodyDegreeMap, 1, 1)


midiMatrix = zeros(0,6);
beat = 0.0;

% Add chords to song
for i=1:size(keyProgression,2)
    beatEnd = beat + beatsPerChordChange;
    chordAdding = fundamental + formTriChord(keyProgression(i), scale, 0)';
    midiMatrix = appendMidiMatrix(midiMatrix, 1, 1, chordAdding, 90, beat*60.0/tempo+0.02, beatEnd*60.0/tempo);
    beat = beatEnd;
end

% Add bass to song
beat = 0.0;
for i=1:size(bassRhythm,2)
    beatEnd = beat + bassRhythm(i);
    currentPatternIndex = floor(beat/beatsPerBassPatternChange)+1;
    currentKeyIndex = floor(beat/beatsPerChordChange)+1;
    
    nextBassNote = fundamental ...
        + extendScale(keyProgression(currentKeyIndex) + bassToneProgression(1, currentPatternIndex) - 1, scale) ...
        + 12 * bassToneProgression(2, currentPatternIndex);
    
    % Clamp bass notes so that voices appear somewhat independent
    nextBassNote = bringWithinOctave(nextBassNote, [45 36]);
    midiMatrix = appendMidiMatrix(midiMatrix, 2, 2, nextBassNote, 90, beat*60.0/tempo+0.02, beatEnd*60.0/tempo);
    beat = beatEnd;
end

% Add melody to song
beat = 0.0;
for i=1:size(melodyPivotRhythm,2)
    beatEnd = beat + melodyPivotRhythm(i);
    
    currKeyIndex = floor(beat / beatsPerChordChange) + 1;
    nextKeyIndex = floor(beatEnd / beatsPerChordChange) + 1;
    
    currMelodyDegree = 8 + keyProgression(currKeyIndex) + melodyDegreeProgression(i) - 2;
    
    if (nextKeyIndex < size(keyProgression, 2))
        nextMelodyDegree = 8 + keyProgression(nextKeyIndex) + melodyDegreeProgression(i+1) - 2;
    else
        nextMelodyDegree = currMelodyDegree;
    end
    
    lengths = beatsPerChordChange ./ BEAT_FRACTIONS;
    speed = lengths(randi(size(lengths,2)));
    
    [notes, beatsStart, beatsEnd] = linearTransition(currMelodyDegree, nextMelodyDegree, speed, melodyPivotRhythm(i), scale);
   
    for j=1:size(notes,2);
        
        notes(j) = notes(j) + (rand() > 0.95)*randi([-1, 1]);
        
        midiMatrix = appendMidiMatrix(midiMatrix, 3, 3, fundamental+notes(j), 90, (beatsStart(j)+beat)*60.0/tempo+0.02, (beatsEnd(j)+beat)*60.0/tempo);
    end
    
    beat = beatEnd;
end

formedMidi = matrix2midi(midiMatrix);
writemidi(formedMidi, ['new_' num2str(now) '.mid']);