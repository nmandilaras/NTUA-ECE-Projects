clear all;
global IW distances dX dY;
% EightData;
% data = EightPatterns;
QuestionData;
data = QuestionPatterns;
[dX, dY] = size(data); % dx = 2 dy = 300 
minMax = zeros(dX,2); % in first column there are the min numbers in second the max, first line for one coordinate second for the other 
for i = 1:dX
    minMax(i,1) = min(data(i,:)); % min for one coordinate
    minMax(i,2) = max(data(i,:)); % max for one coordinate (for one whole line)
end

for m = 1:4
    for n = 1:4
    f1 = figure(m); %clf;
        gridSize = [20 1];
        somCreateCustom(minMax, gridSize,m,n);
        setOrderLR = 0.9;
        setOrderSteps = 600; % prepei na janallajei
        setTuneLR = 0.01;

        somTrainParameters(setOrderLR, setOrderSteps, setTuneLR);
        somTrain(data);

        subplot(2,2,n); axis([-6 6 -6 6]);
        plot2DSomData(IW, distances, data);
    end
end