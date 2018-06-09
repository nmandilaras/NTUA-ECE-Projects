%% TSP
clear all;
global IW distances dX dY;
%Coordinates of cities are in CityCoordinates
Cities;
data = CityCoordinates;
[dX, dY] = size(data);
minMax = zeros(dX,2);
for i = 1:dX
    minMax(i,1) = min(data(i,:));
    minMax(i,2) = max(data(i,:));
end
%Try this for different size of grid
for n = 20:20:80
    f1 = figure(1);    
        %Specify number of neurons & create SOM
        gridSize = [n 1];
        somCreateTSP(minMax, gridSize);
        setOrderLR = 0.9;
        setOrderSteps = 600;
        setTuneLR = 0.01;
        %Train SOM
        somTrainParameters(setOrderLR, setOrderSteps, setTuneLR);
        somTrain(data);
        
        subplot(2,2,n/20); axis([-6 6 -6 6]);
        plot2DSomData(IW, distances, data);
end