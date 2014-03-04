function [ midiNoteIntervals ] = extendScale( noteDegrees, scale )

octaves = floor((noteDegrees-1) / 7);
extra = mod(noteDegrees-1, 7) + 1;

midiNoteIntervals = 12 * octaves + scale(extra);

end

