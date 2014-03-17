% Get the cumulative normalized row sum of every element in a matrix
function [ outMatrix ] = cumNormByRows( inMatrix )

outMatrix = zeros(size(inMatrix));

for i=1:size(outMatrix,1)
    outMatrix(i,:) = inMatrix(i,:)/sum(inMatrix(i,:));
end

outMatrix = cumsum(outMatrix,2);