% Shifts a note by octaves to fall within given range
function [ adjusted ] = bringWithinRange( note, range )

adjusted = note;

while (adjusted < range(1))
    adjusted = adjusted + 12;
end

while (adjusted > range(2))
    adjusted = adjusted - 12;
end