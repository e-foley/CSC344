function [ notes, beatStart, beatEnd ] = linearTransition( currentScaleDegree, targetScaleDegree, resolution, beatsToSpan, scale)
% This function does its best to interpolate between two given pitches but
% does not offer control over which notes are passed through.

beatStart = 0;
beatEnd = 0;
notes = 0;

timeSlotsAvailable = beatsToSpan / resolution;
degreesSpanned = targetScaleDegree - currentScaleDegree;

if (abs(degreesSpanned) > timeSlotsAvailable)
    allDegrees = round(linspace(currentScaleDegree, targetScaleDegree, timeSlotsAvailable+1));
    
    for i=1:timeSlotsAvailable
        beatStart(i) = resolution*(i-1);
        beatEnd = beatStart + resolution;
    end  
else
    allDegrees = currentScaleDegree:sign(degreesSpanned):targetScaleDegree;
    
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
    notes = extendScale(currentScaleDegree, scale);
    beatStart = 0;
    beatEnd = beatsToSpan;
end


end