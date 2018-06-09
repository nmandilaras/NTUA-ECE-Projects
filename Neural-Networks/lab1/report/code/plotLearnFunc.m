%%%%%%%% plotLearnFunc %%%%%%%%%%%%%%%%%%
%%% Plots bar diagram for given lvl 1 and 2
%%% parameters for different learning functions
%%% Arguments: 
%%% lvl1Neurons: number of Level 1 Neurons
%%% lvl2Neurons: number of Level 2 Neurons
%%% finalTestDataTargets: test data and expected output
%%% finalTrainData, finalTrainDataTargets: train data and expected output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function []= plotLearnFunc(lvl1Neurons, lvl2Neurons, trainFunction,...
    finalTrainData, finalTrainDataTargets, finalTestData, finalTestDataTargets)
    
learnFunctions = {'learngdm', 'learngd'};
for i=1:2
    %Create new neural network
    if lvl2Neurons == 0  %No second hidden level of neurons
        net = newff(finalTrainData, finalTrainDataTargets, [ lvl1Neurons ], ...
            {},trainFunction, char(learnFunctions(i))); 
    else %create 2nd level with secondLevelNeurons number of neurons
        net = newff(finalTrainData, finalTrainDataTargets,[lvl1Neurons lvl2Neurons], ...
            {},trainFunction, char(learnFunctions(i)));        
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
axis([0,3,0,1.1]); %set upper limits on x,y axis
ylabel('Accuracy');
xlabel('Learning function');
set(gca,'XTickLabel',['learngdm';'learngd ']);
title([ 'Accuracy for different learning functions']);
saveas(y,'learnFunc.png');
end