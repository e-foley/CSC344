% Add given MIDI information in the format given in writemidi.m
function [ newMidiMatrix ] = appendMidiMatrix( midiMatrix, channel, instrument, notes, velocity, startTime, endTime)

% Colons allow any number of notes to be added at once
adding = zeros(size(notes,1),6);
adding(:, 1) = instrument;
adding(:, 2) = channel;
adding(:, 3) = notes;
adding(:, 4) = velocity;
adding(:, 5) = startTime;
adding(:, 6) = endTime;

newMidiMatrix = [midiMatrix; adding];