% Scales defined as half-steps relative to fundamental
MODE_MATRIX = [0 2 4 5 7 9 11;  % IONIAN
               0 2 3 5 7 9 10;  % DORIAN
               0 1 3 5 7 8 10;  % PHRYGIAN
               0 2 4 6 7 9 11;  % LYDIAN
               0 2 4 5 7 9 10;  % MIXOLYDIAN
               0 2 3 5 7 8 10;  % AEOLIAN
               0 1 3 5 6 8 10]; % LOCRIAN
MAJOR_SCALE = MODE_MATRIX(1,:);
MINOR_SCALE = MODE_MATRIX(6,:);
HARMONIC_MINOR_SCALE = [0 2 3 5 7 8 11];
PENTATONIC_SCALE = [0 2 4 6 8 10];