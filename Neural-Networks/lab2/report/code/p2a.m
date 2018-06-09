clear all;
global IW distances dX dY;
% EightData;
% data = EightPatterns;
QuestionData;
data = QuestionPatterns;
[dX, dY] = size(data);
minMax = zeros(dX,2);
for i = 1:dX
    minMax(i,1) = min(data(i,:));
    minMax(i,2) = max(data(i,:));
end
m=3; n=3;
j=25;
%for j = 25:25:100
    h = figure(1); %clf;
        gridSize = [j 1];
        somCreateCustom(minMax, gridSize,m,n);
        setOrderLR = 0.9;
        setOrderSteps = 200; % prepei na janallajei
        setTuneLR = 0.01;

        somTrainParameters(setOrderLR, setOrderSteps, setTuneLR);
        somTrain(data);

        subplot(2,2,j/25); axis([-6 6 -6 6]);
   %     plot2DSomData(IW, distances, data);
%end