% Generate a Markov chain whose results are mapped to meaningful values
function [ progression ] = generateMomProg(lengthPerRepeat, repeats, markov, toneMap, startIndex, endIndex)

markov = cumNormByRows(markov);
tempProgression = zeros(size(toneMap,2),1);
tempProgression(:,1) = toneMap(startIndex,:);
index = startIndex;

for j=2:lengthPerRepeat
    % Get next state from current--Markov magic happens here!
    index = weightedRandomPick(markov(index,:));
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