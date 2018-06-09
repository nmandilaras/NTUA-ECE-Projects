%%%%% myTrain %%%%%%%%%%%%%%%%%%%
%%% Finds plots accuracy for each of the 4 training functions and for 5:5:30 1st level
%%% neurons, but only secondLevelNeurons number of neurons in 2nd level
%%% Arguments:
%%% finalTestData, finalTestDataTargets: test data and expected output
%%% finalTrainData, finalTrainDataTargets: train data and expected output
%%% secondLevelNeurons: 0 if no 2nd level neurons exist, else it's value is
%%% number of 2nd level neurons
%%% Return value: acc2return
%%% Rows: 1 of the 4 training functions in that order: []
%%% Columns: Number of neurons in 1st level (5:5:30)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function acc2return = myTrain(finalTestData, finalTrainData, finalTrainDataTargets, ...
    finalTestDataTargets, secondLevelNeurons)
indices = [5:5:30];
trainFunctions = ['traingdx'; 'trainlm '; 'traingd ' ;'traingda'];
y = figure,
hold on;
acc2return = [];
for j=1:4   %Loop for the different Training functions
    for i=5:5:30
        %Create new neural network
        if secondLevelNeurons == 0  %No second hidden level of neurons
            net = newff(finalTrainData, finalTrainDataTargets,[i], {},deblank(trainFunctions(j,:))); 
        else %create 2nd level with secondLevelNeurons number of neurons
            net = newff(finalTrainData, finalTrainDataTargets,[i secondLevelNeurons], {},deblank(trainFunctions(j,:)));             
        end
     %%%2C THAT   yournet.trainParam.showWindow=0; %default is 1
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
    subplot(2,2,j);
    %display(accuracy(indices));
    bar(accuracy);
    axis([0,35,0,1.1]); %set upper limits on x,y axis
    ylabel('Accuracy');
    xlabel('Number of neurons (1st level)');
    title([ trainFunctions(j,:) ' and ' int2str(secondLevelNeurons) ' hiddden level(s)']);
    acc2return(j,:)=accuracy(indices);
end
  %Save image immediately to file
  saveas(y,['NNlvls-' int2str(secondLevelNeurons) '.png']);
  %display(acc2return);
end