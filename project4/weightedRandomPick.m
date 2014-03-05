% Get the index of the first value of an array less than a random number
function [ index ] = weightedRandomPick( normalizedArray  )
index = find(rand() <= normalizedArray, 1, 'first');