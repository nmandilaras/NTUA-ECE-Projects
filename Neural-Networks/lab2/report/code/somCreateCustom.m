function somCreateCustom(minMax,gridSize,n1,n2)
gridArray = { 'gridtop', 'hextop', 'randtop', 'hexagonalTopology'};
distArray = {'boxdist', 'dist', 'linkdist', 'mandist'};
global neuronsPerRow neuronsPerColumn N IW distances dimensions positions;
% gridSize is an array with just two places 
neuronsPerRow = gridSize(1,1); 
neuronsPerColumn = gridSize(1,2);
N = neuronsPerRow*neuronsPerColumn; % total number of nodes

minFeatureValues = minMax(:,1)';
maxFeatureValues = minMax(:,2)';
dimensions = size(minMax,1);

IW = zeros(N,dimensions);

for i = 1:N
    IW(i,:) = rand(1,dimensions).*(maxFeatureValues-minFeatureValues)+minFeatureValues;
end

%positions = hexagonalTopology(neuronsPerRow,neuronsPerColumn);
%distances = dist(positions);
positions = eval(char(strcat(gridArray(n1),'(neuronsPerRow,neuronsPerColumn);')));
distances = eval(char(strcat(distArray(n2),'(positions);')));
end