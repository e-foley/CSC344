% Find the relative pitches of a chord given a scale and a scale degree
function [ chord ] = formTriChord( index, scale, targetInversion )

offset = zeros(3,1);

switch (targetInversion)
    case 0
        offset = [0 2 4];
    case 1
        offset = [2 4 7];
    case 2
        offset = [-3 0 2];
end

% Wrap chord to bounds of scale (target inversion may be overruled here)
offset = mod(index + offset - 1, size(scale, 2)) + 1;
chord = scale(offset);