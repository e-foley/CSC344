% initialize matrix:
numChords = 16;
repeat = 2;
tempo = 120.0;

range = [50 70];
scale = [0 2 4 5 7 9 11];

midiMatrix = zeros(0, 6);

fundamental = randi(range)
proposedChord = fundamental + scale(1:2:5);
tone = 1;


circleOfFifths = [ 0   0   0   0   1   0   0; ...
                   0   0   0   0   0   1   0; ...
                   0   0   0   0   0   0   1; ...
                   1   0   0   0   0   0   0; ...
                   0   1   0   0   0   0   0; ...
                   0   0   1   0   0   0   0; ...
                   0   0   0   1   0   0   0];
               
chaos = 1 - eye(7);

oneFourFive = [0 0 0 1 1 0 0; ...
               1 0 0 1 1 0 0; ...
               1 0 0 1 1 0 0; ...
               1 0 0 0 1 0 0; ...
               1 0 0 1 0 0 0; ...
               1 0 0 1 1 0 0; ...
               1 0 0 1 1 0 0];

niceSound = [ 0   2   2  10  10   2   1; ...
                        2   0   3   5   5   3   1; ...
                        4   2   0   7   7   4   1; ...
                       10   1   1   0  10   2   1; ...
                       10   3   2  10   0   2   1; ...
                        5   2   1   2   2   0   1; ...
                       20   0   0   0   0   0   0];
                   
ascending = [0 1 0 0 0 0 0; ...
             0 0 1 0 0 0 0; ...
             0 0 0 1 0 0 0; ...
             0 0 0 0 1 0 0; ...
             0 0 0 0 0 1 0; ...
             0 0 0 0 0 0 1; ...
             1 0 0 0 0 0 0];
         
 resolve = [0 0 0 0 0 0 0;
            0 0 0 0 0 0 0;
            0 0 0 0 0 0 0;
            0 0 0 0 0 0 0;
            1 0 0 0 0 0 0;
            0 0 0 0 0 0 0;
            1 0 0 0 0 0 0;]
         
descending = ascending';

maintain = eye(7);
                
keyTransitionMatrix = 0.8 * circleOfFifths ...
                    + 0.3 * chaos ...
                    + 1.0 * oneFourFive ...
                    + 0.4 * ascending ...
                    + 0.3 * descending ...
                    + 0.2 * maintain ...
                    + 0.5 * resolve;
                  
% normalize rows such that total probability is 1.0 for each
for i=1:size(keyTransitionMatrix,1)
    keyTransitionMatrix(i,:) = keyTransitionMatrix(i,:)/sum(keyTransitionMatrix(i,:));
end
keyTransitionMatrix
% each element is cumulative sum of it and all elements to its left
cumTransitionMatrix = cumsum(keyTransitionMatrix,2);

time = 0.0;
length = 60.0/tempo;

toneCollection = [];
chordCollection = [];

%for j=1:repeat


% GENERATE CHORD COLLECTION
for i=1:3:numChords*3
    toneCollection = [toneCollection, tone];
    chordCollection = [chordCollection, proposedChord'];
    randoPickNote = rand();
    tone = find(randoPickNote <= cumTransitionMatrix(tone,:), 1, 'first');
    proposedChord = fundamental + formTriChord(tone,scale,0);
end

% FORM ACTUAL SONG
for j=1:repeat
    adding = zeros(numChords*3,6);
    adding(:,1) = 1;
    adding(:,2) = 1;
    adding(:,3) = reshape(chordCollection,1,numChords*3)';
    adding(:,4) = 90;
    
    for i=1:3:numChords*3;
        adding(i:i+2,5:6) = kron(ones(3,1),[time time+length]);
        time = time+length;
    end

    midiMatrix = [midiMatrix; adding];

end

toneCollection
chordCollection
midiMatrix
midi_new = matrix2midi(midiMatrix);
writemidi(midi_new, ['testout2' num2str(now) '.mid']);