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

offset = mod(index + offset - 1, size(scale, 2)) + 1;
chord = scale(offset);

end