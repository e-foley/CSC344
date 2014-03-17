% Generate a Markov chain whose results are mapped to meaningful values
function [ progression ] = generateProgression(lengthPerRepeat, repeats, markovIn, toneMap, startIndex, endIndex, momTransMat)

momentum = cell(0,0);

% Exclude the more time-intensive operations if we don't need them
if (nargin < 7)
    handleMomentum = 0;
    markov = cumNormByRows(markovIn);
else
    handleMomentum = 1;
    momentum = cell(size(momTransMat,1),1);
    momentum{:} = 0;
end

tempProgression = zeros(size(toneMap,2),1);
tempProgression(:,1) = toneMap(startIndex,:);
index = startIndex;
nextIndex = index;

for j=2:lengthPerRepeat
    if (handleMomentum == 1)
        % Sub variables as necessary and evaluate resulting expressions
        for i = 1 : size(momTransMat, 1)
            markov = eval(subs(markovIn, momTransMat{i,2}, momentum{i}));
        end
        markov = cumNormByRows(markov);
    end
    
    % Get next state from current--Markov magic happens here!
    nextIndex = weightedRandomPick(markov(index,:));
    
    if (handleMomentum == 1)
        % Recalculate momentum variables
        for i = 1 : size(momTransMat, 1)
            momentum{i} = eval(subs(momTransMat{i,1}(index, nextIndex), momTransMat{i,2}, momentum{i}));
        end
    end
    
    index = nextIndex;    
    tempProgression(:,j) = toneMap(index,:);
end

progression = zeros(0,0);
for r=1:repeats
    progression = cat(2, progression, tempProgression);
end

% Add additional finishing value if specified
if (endIndex > 0)
    progression(:,lengthPerRepeat*repeats+1) = toneMap(endIndex,:);
end