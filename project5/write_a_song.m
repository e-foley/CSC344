% Creates a random song in MIDI format and deposits it in MATLAB folder
function write_a_song (seed)
clc;

% Seed picked at random if not specified
if (nargin < 1)
    seed = randi([0, intmax('uint32')], 'uint32')
end

rng(seed);

% Set basic parameters
tempo = 100.0 + 80.0 * rand()  % beats per minute
beatsPerRepeat = 2 ^ randi([2, 5])
repeats = 32 / beatsPerRepeat
beatsPerChordChange = 2 ^ randi([1, 3])
beatsPerBassPatternChange = 2 ^ randi([-1 2])
fundamental = randi([45 60])

% Consult scripts for constants so they don't bog down this file
define_scale_constants;
define_markov_constants;

% Set up all Markov chain matrices and correlation maps
randoContribs = rand(7,1);

keyTransitionMatrix = randoContribs(1) * CIRCLE_OF_FIFTHS ...
                    + randoContribs(2) * CHAOS ...
                    + randoContribs(3) * ONE_FOUR_FIVE ...
                    + randoContribs(4) * ASCENDING ...
                    + randoContribs(5) * DESCENDING ...
                    + randoContribs(6) * MAINTAIN ...
                    + randoContribs(7) * RESOLVE;

% (Increase odds of cicle of fifths move based on current number of
%  consecutive circle of fifths moves)
syms r;
keyTransitionMatrix = keyTransitionMatrix + 6 * r * CIRCLE_OF_FIFTHS;             
momTransMat = {(r + 1) * CIRCLE_OF_FIFTHS, 'r'};

keyMap = DEFAULT_KEY_MAP;
bassRhythmMatrix = DEFAULT_BASS_RHYTHM_MATRIX;
bassRhythmMap = DEFAULT_BASS_RHYTHM_MAP;                 
bassToneTransitionMatrix = DEFAULT_BASS_TONE_TRANSITION_MATRIX;         
bassToneMap = DEFAULT_BASS_TONE_MAP;                
pivotRhythmMatrix = DEFAULT_PIVOT_RHYTHM_MATRIX;
pivotRhythmMap = DEFAULT_PIVOT_RHYTHM_MAP;
melodyDegreeMatrix = DEFAULT_MELODY_DEGREE_MATRIX;
melodyDegreeMap = DEFAULT_MELODY_DEGREE_MAP;
melodyRateMatrix = DEFAULT_MELODY_RATE_MATRIX;
melodyRateMap = DEFAULT_MELODY_RATE_MAP;
sectionScaleMatrix = DEFAULT_SECTION_SCALE_MATRIX;              
sectionScaleMap = DEFAULT_SECTION_SCALE_MAP;
scaleSelections = DEFAULT_SCALE_SELECTIONS;

% Actually run the Markov models
phraseLength = beatsPerRepeat * repeats;
keyProgressionA = generateProgression(ceil(beatsPerRepeat/beatsPerChordChange), repeats, keyTransitionMatrix, keyMap, 1, 1, momTransMat);
keyProgressionB = generateProgression(ceil(beatsPerRepeat/beatsPerChordChange), repeats, keyTransitionMatrix, keyMap, 1, 1, momTransMat);
bassRhythm = generateRhythm(phraseLength, bassRhythmMatrix, bassRhythmMap, randi(2), 5);
bassToneProgressionA = generateProgression(phraseLength/beatsPerBassPatternChange, 1, bassToneTransitionMatrix, bassToneMap, 1, 1);
bassToneProgressionB = generateProgression(phraseLength/beatsPerBassPatternChange, 1, bassToneTransitionMatrix, bassToneMap, 1, 1);
melodyPivotRhythm = generateRhythm(phraseLength, pivotRhythmMatrix, pivotRhythmMap, randi(2), 1);
melodyDegreeProgressionA = generateProgression(size(melodyPivotRhythm,2)-1, 1, melodyDegreeMatrix, melodyDegreeMap, 1, 1);
melodyDegreeProgressionB = generateProgression(size(melodyPivotRhythm,2)-1, 1, melodyDegreeMatrix, melodyDegreeMap, 1, 1);
melodyRateProgressionA = generateProgression(size(melodyPivotRhythm,2)-1, 1, melodyRateMatrix, melodyRateMap, 1, 1);
melodyRateProgressionB = generateProgression(size(melodyPivotRhythm,2)-1, 1, melodyRateMatrix, melodyRateMap, 1, 1);
sectionScaleProgression = generateProgression(4, 1, sectionScaleMatrix, sectionScaleMap, randi([1 4]), 0);

% Prepare to generate MIDI
midiMatrix = zeros(0,6);
timingMap = beatsPerRepeat * repeats * [0.0; 1.0; 2.0; 3.0];
isFinal = 0;

% PART A
scale = scaleSelections(sectionScaleProgression(1, 1), :);
keyProgression = keyProgressionA;
bassToneProgression = bassToneProgressionA;
melodyDegreeProgression = melodyDegreeProgressionA;
melodyRateProgression = melodyRateProgressionA;
offset = timingMap(1);

addChordsToMidi;
addBassToMidi;
addMelodyToMidi;

%PART B
scale = scaleSelections(sectionScaleProgression(1, 2), :);
fundamental = fundamental + sectionScaleProgression(2, 2);
keyProgression = keyProgressionB;
bassToneProgression = bassToneProgressionB;
melodyDegreeProgression = melodyDegreeProgressionB;
melodyRateProgression = melodyRateProgressionB;
offset = timingMap(2);

addChordsToMidi;
addBassToMidi;
addMelodyToMidi;

%PART C (part A again)
scale = scaleSelections(sectionScaleProgression(1, 3), :);
fundamental = fundamental + sectionScaleProgression(2, 3);
keyProgression = keyProgressionA;
bassToneProgression = bassToneProgressionA;
melodyDegreeProgression = melodyDegreeProgressionA;
melodyRateProgression = melodyRateProgressionA;
offset = timingMap(3);

addChordsToMidi;
addBassToMidi;
addMelodyToMidi;

%PART D (part B again)
scale = scaleSelections(sectionScaleProgression(1, 4), :);
fundamental = fundamental + sectionScaleProgression(2, 4);
keyProgression = keyProgressionB;
bassToneProgression = bassToneProgressionB;
melodyDegreeProgression = melodyDegreeProgressionB;
melodyRateProgression = melodyRateProgressionB;
offset = timingMap(4);
isFinal = 1;

addChordsToMidi;
addBassToMidi;
addMelodyToMidi;
% End of song

formedMidi = matrix2midi(midiMatrix);
writemidi(formedMidi, [num2str(seed) '_t' num2str(tempo) '.mid']);