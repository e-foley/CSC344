function [ outMatrix ] = cumNormByRows( inMatrix )

outMatrix = zeros(size(inMatrix));

for i=1:size(outMatrix,1)
    outMatrix(i,:) = inMatrix(i,:)/sum(inMatrix(i,:));
end

outMatrix = cumsum(outMatrix,2);

end