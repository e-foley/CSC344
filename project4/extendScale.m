% Translate scale degrees beyond [1, 7] to proper relative note numbers
function [ midiNoteIntervals ] = extendScale( noteDegrees, scale )

scaleLength = size(scale, 2);
octaves = floor((noteDegrees-1) / scaleLength);
extra = mod(noteDegrees-1, scaleLength) + 1;

midiNoteIntervals = 12 * octaves + scale(extra);