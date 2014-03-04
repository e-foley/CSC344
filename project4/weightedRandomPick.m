function [ index ] = weightedRandomPick( normalizedArray  )

index = find(rand() <= normalizedArray, 1, 'first');

end

