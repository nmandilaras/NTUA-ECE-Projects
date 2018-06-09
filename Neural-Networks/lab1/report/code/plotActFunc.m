%%%%%%%% plotActFunc %%%%%%%%%%%%%%%%%%
%%% Plots bar diagram for given lvl 1 and 2
%%% parameters for different activation functions
%%% Arguments: 
%%% lvl1Neurons: number of Level 1 Neurons
%%% lvl2Neurons: number of Level 2 Neurons
%%% finalTestDataTargets: test data and expected output
%%% finalTrainData, finalTrainDataTargets: train data and expected output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function []= plotActFunc(lvl1Neurons, lvl2Neurons, trainFunction,...
    finalTrainData, finalTrainDataTargets, finalTestData, finalTestDataTargets)
    
%actFunctions = {'harldim', 'tansig', 'logsig', 'purelin' };
actFunctions(1,:) = 'hardlim';
actFunctions(2,:) = 'tansig ';
actFunctions(3,:) = 'logsig ';
actFunctions(4,:) = 'purelin';
for i=1:4
    %Create new neural network
    if lvl2Neurons == 0  %No second hidden level of neurons
        net = newff(finalTrainData, finalTrainDataTargets, [ lvl1Neurons ], ...
            {'tansig' deblank(actFunctions(i,:))},trainFunction); 
    else %create 2nd level with secondLevelNeurons number of neurons
        net = newff(finalTrainData, finalTrainDataTargets,[lvl1Neurons lvl2Neurons], ...
            {'tansig' 'tansig' deblank(actFunctions(i,:))},deblank(trainFunction));             
    end
    %Set Early Stoping parameters
    net.divideParam.trainRatio=0.8;
    net.divideParam.valRatio=0.2;
    net.divideParam.testRatio=0;
    %Train the NN
    net = train(net,finalTrainData,finalTrainDataTargets);
    %Find output of NN using TestData as input
    output = sim(net,finalTestData);  
    %Evaluate the NN using these 3 metrics:
    [accuracy(i) precision recall]= ...
          eval_Accuracy_Precision_Recall(output,finalTestDataTargets);
end
y=figure;
bar(accuracy);
axis([0,5,0,1.1]); %set upper limits on x,y axis
ylabel('Accuracy');
xlabel('Activation function');
set(gca,'XTickLabel',['hardlim';'tansig ' ; 'logsig ' ; 'purelin']);
title([ 'Accuracy for different activation functions']);
saveas(y,'actFunc.png');
end