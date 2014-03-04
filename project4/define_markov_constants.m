%% DEFINITIONS FOR TONAL TRANSITIONS
% Relate one tone to the next
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
    
RESOLVE = [0 0 0 0 0 0 0;
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

% Reminder for non-MATLAB people: apostophe is the transpose operation
DESCENDING = ASCENDING';

CHAOS = ones(7) - eye(7);

MAINTAIN = eye(7);

%%DEFINITIONS FOR BASS
% Relate one tone to the next
