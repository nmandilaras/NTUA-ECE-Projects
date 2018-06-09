function somCreate4b(minMax,gridSize)

global neuronsPerRow neuronsPerColumn N IW distances dimensions positions;

neuronsPerRow = gridSize(1,1);
neuronsPerColumn = gridSize(1,2);
%Total Number of Neurons
N = neuronsPerRow*neuronsPerColumn;

minFeatureValues = minMax(:,1)';
maxFeatureValues = minMax(:,2)';
dimensions = size(minMax,1);

%Weights of SOM
IW = zeros(N,dimensions);

%Randomly initialize weights
for i = 1:N,
    IW(i,:) = rand(1,dimensions).*(maxFeatureValues-minFeatureValues)+minFeatureValues;
end

%positions for neurons arranged in a 2D hexagonal pattern
positions = hexagonalTopology(neuronsPerRow,neuronsPerColumn);

%Distance between neurons (adj matrix), symmetric
distances = dist(positions);
%%%%%%%%%%%%
%distances = ring_distances(N);