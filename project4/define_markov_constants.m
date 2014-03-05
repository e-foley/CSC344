%% DEFINITIONS FOR CHORD TRANSITIONS
% Relate one chord degree to the next; e.g., row 5, column 2 by default
% represents relative likelihood of V->II chord transition
CIRCLE_OF_FIFTHS = [0 0 0 0 1 0 0;
                    0 0 0 0 0 1 0;
                    0 0 0 0 0 0 1;
                    1 0 0 0 0 0 0;
                    0 1 0 0 0 0 0;
                    0 0 1 0 0 0 0;
                    0 0 0 1 0 0 0];

ONE_FOUR_FIVE = [0 0 0 1 1 0 0;
                 1 0 0 1 1 0 0;
                 1 0 0 1 1 0 0;
                 1 0 0 0 1 0 0;
                 1 0 0 1 0 0 0;
                 1 0 0 1 1 0 0;
                 1 0 0 1 1 0 0];

RESOLVE = [1 0 0 0 0 0 0;
           0 0 0 0 0 0 0;
           0 0 0 0 0 0 0;
           0 0 0 0 0 0 0;
           1 0 0 0 0 0 0;
           0 0 0 0 0 0 0;
           1 0 0 0 0 0 0;];           
           
ASCENDING = [0 1 0 0 0 0 0;
             0 0 1 0 0 0 0;
             0 0 0 1 0 0 0;
             0 0 0 0 1 0 0;
             0 0 0 0 0 1 0;
             0 0 0 0 0 0 1;
             1 0 0 0 0 0 0];

DESCENDING = ASCENDING';

CHAOS = ones(7) - eye(7);

MAINTAIN = eye(7);

DEFAULT_KEY_TRANSITION_MATRIX = CIRCLE_OF_FIFTHS + ONE_FOUR_FIVE;

DEFAULT_KEY_MAP = (1:7)';

%% DEFINITIONS FOR BASS RHYTHM TRANSITIONS
% Relate one bass note duration to the next
DEFAULT_BASS_RHYTHM_MATRIX = [75 25  0  0 0;  % quarter on beat
                               0  0 90 10 0;  % eighth on beat
                              75 25  0  0 0;  % eighth off beat
                               0  0 60 40 0;  % quarter off beat
                               0  0  0  0 1]; % whole on beat
                           
DEFAULT_BASS_RHYTHM_MAP = [1; 0.5; 0.5; 1; 4];

%% DEFINITIONS FOR BASS TONE TRANSITIONS
% Relate one bass scale degree to the next
DEFAULT_BASS_TONE_TRANSITION_MATRIX = [2 1 1 0;  % octave below fundamental
                                       1 1 1 1;  % sixth below fundamental
                                       2 1 1 2;  % fourth below fundamental
                                       0 1 2 1]; % fundamental itself
                                     
DEFAULT_BASS_TONE_MAP = [1 -1; 3 -1; 5 -1; 1 0];

%% DEFINITIONS FOR PIVOT RHYTHM TRANSITIONS
% Relate one melody pivot timing to the next
DEFAULT_PIVOT_RHYTHM_MATRIX = [1 1 0 1 0 0 0;  % whole "1"
                               0 0 1 0 0 0 0;  % half "1"
                               1 1 0 1 0 0 0;  % half "3"
                               0 0 0 0 1 0 0;  % quarter "1"
                               0 0 0 0 0 1 0;  % quarter "2"
                               0 0 0 0 0 0 1;  % quarter "3"
                               1 1 0 1 0 0 0]; % quarter "4"

DEFAULT_PIVOT_RHYTHM_MAP = [4; 2; 2; 1; 1; 1; 1; 3];

%% DEFINITIONS FOR MELODY DEGREE TRANSITIONS
% Relate one interval of melody (relative to the fundamental) to the next
% All rows are the same; no state dependence as written
DEFAULT_MELODY_DEGREE_MATRIX = kron(ones(7,1),[50 4 10 3 15 5 1]);
DEFAULT_MELODY_DEGREE_MAP = (1:7)';

%% DEFINITIONS FOR MELODY RATE TRANSITIONS
% Relate one melody transition rate to the next
% All rows are the same; no state dependence as written
% EX: By default, there will be 20 eighth-note transitions per 16 quarters 
DEFAULT_MELODY_RATE_MATRIX = kron(ones(10,1),[4 8 0 16 1 2 1 20 3 10]);
DEFAULT_MELODY_RATE_MAP = 4.0 ./ [(1:8)'; 12; 16];

%% DEFINITIONS FOR SECTION SCALE TRANSITIONS
% Relate the scale of one section to the next
DEFAULT_SECTION_SCALE_MATRIX = [0 0 1 0;
                                0 0 0 1;
                                1 0 0 0;
                                0 1 0 0];
                            
% Right column holds fundamental deltas upon a transition to that state
DEFAULT_SECTION_SCALE_MAP = [1 3; 1 3; 2 -3; 3 -3];
DEFAULT_SCALE_SELECTIONS = [MAJOR_SCALE; MINOR_SCALE; HARMONIC_MINOR_SCALE];