% Generate rhythm to fill specified time period, governed by Markov
function [ rhythm ] = generateRhythm( totalDuration, markov, durationMap, startIndex, endIndex )

markov = cumNormByRows(markov);
rhythm = durationMap(startIndex);
elapsed = durationMap(startIndex);
index = startIndex;

while (elapsed < totalDuration)
    index = weightedRandomPick(markov(index,:));
    if (elapsed + durationMap(index) > totalDuration)
        % If we go over time, shorten last duration to fit
        rhythm = [rhythm, totalDuration - elapsed];
        elapsed = totalDuration;
    else
        rhythm = [rhythm, durationMap(index)];
        elapsed = elapsed + durationMap(index);
    end
end

% If specified, add final duration value after everything else
if (endIndex > 0)
    rhythm = [rhythm, durationMap(endIndex)];
end