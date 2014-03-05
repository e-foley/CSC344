% This function attempts to interpolate between two given pitches and
% coordinate the intermediate notes' timing
function [ notes, beatStart, beatEnd ] = linearTransition( currentScaleDegree, targetScaleDegree, resolution, beatsToSpan, scale)
beatStart = 0;
beatEnd = 0;
notes = 0;

timeSlotsAvailable = beatsToSpan / resolution;
degreesSpanned = targetScaleDegree - currentScaleDegree;

% To cover more tones than we have room for, we have to skip some
if (abs(degreesSpanned) > timeSlotsAvailable)
    allDegrees = round(linspace(currentScaleDegree, targetScaleDegree, timeSlotsAvailable+1));
    
    for i=1:timeSlotsAvailable
        beatStart(i) = resolution*(i-1);
        beatEnd = beatStart + resolution;
    end  
else
    % sign function differentiates increasing series from decreasing series
    allDegrees = currentScaleDegree:sign(degreesSpanned):targetScaleDegree;
    
    % If we have extra room, squeeze all transition notes to period's end
    beatStart(1) = 0;
    beatEnd(1) = beatsToSpan - (abs(degreesSpanned)-1)*resolution;
    
    for i=1:abs(degreesSpanned)-1
        beatStart(abs(degreesSpanned)-i+1) = beatsToSpan - resolution*i;
        beatEnd(abs(degreesSpanned)-i+1) = beatStart(abs(degreesSpanned)-i+1)+resolution;
    end
end

if (degreesSpanned ~=  0 && resolution < beatsToSpan )
    notes = extendScale(allDegrees(1:size(allDegrees,2)-1), scale);  
else
    % In "transitioning" from one note to same note, just play the note!
    notes = extendScale(currentScaleDegree, scale);
    beatStart = 0;
    beatEnd = beatsToSpan;
end