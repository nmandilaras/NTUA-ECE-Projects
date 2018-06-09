clear all
global IW dX dY N distances ;
GroupData;
data = GroupPatterns;
%data = data(1:2,:)
[dX, dY] = size(data);
minMax = zeros(dX,2);
for i = 1:dX
    minMax(i,1) = min(data(i,:));
    minMax(i,2) = max(data(i,:));
end

gridSize = [10 10]; 
somCreateCustom(minMax, gridSize,1,1);
setOrderLR = 0.9;
setOrderSteps = 600;
setTuneLR = 0.01;

somTrainParameters(setOrderLR, setOrderSteps, setTuneLR);
somTrain(data);

%Draw the results
figure(1);
plot2DSomData(IW, distances, data);
figure(2);
somShow(IW, gridSize);
% print ('-f1','-dpng' ,'Group-U-Matrix-Rand-Man');
patternCount = zeros(2, 1);

for i=1:dY
    if (data(3,i) == 0)
        patternCount(1) = patternCount(1) + 1;
    elseif (data(3,i) == 1)
        patternCount(2) = patternCount(2) + 1;     
    end
end
% 
neuronCount = zeros(2,1);
for i=1:100
    if (round(IW(i,3)) == 0)
        neuronCount(1) = neuronCount(1) + 1;
    elseif (round(IW(i,3)) == 1)
        neuronCount(2) = neuronCount(2) + 1;    
    end
end
patternCount()
neuronCount()