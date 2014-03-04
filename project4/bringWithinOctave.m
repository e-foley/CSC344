function [ adjusted ] = bringWithinOctave( note, range )

adjusted = note;

while (adjusted < range(1) - 12)
    adjusted = adjusted + 12;
end

while (adjusted > range(2) + 12)
    adjusted = adjusted - 12;
end

end

