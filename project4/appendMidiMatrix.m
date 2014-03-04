function [ newMidiMatrix ] = appendMidiMatrix( midiMatrix, channel, instrument, notes, velocity, startTime, endTime)

adding = zeros(size(notes,1),6);
adding(:, 1) = instrument;
adding(:, 2) = channel;
adding(:, 3) = notes;
adding(:, 4) = velocity;
adding(:, 5) = startTime;
adding(:, 6) = endTime;

newMidiMatrix = [midiMatrix; adding];

if (startTime > endTime)
    fprintf('WHOA!!!');
end

end

