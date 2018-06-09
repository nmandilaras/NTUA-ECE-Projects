clear all
global IW dX dY N distances ;
GroupData;
data = GroupPatterns;
data = data(:,data(3,:)==0);
[dX, dY] = size(data);
minMax = zeros(dX,2);
for i = 1:dX
    minMax(i,1) = min(data(i,:));
    minMax(i,2) = max(data(i,:));
end

gridSize = [10 10]; %20
somCreateCustom(minMax, gridSize,3,3);
setOrderLR = 0.9;
setOrderSteps = 10;
setTuneLR = 0.01;

somTrainParameters(setOrderLR, setOrderSteps, setTuneLR);
somTrain(data);

figure(1);
plot2DSomData(IW, distances, data);