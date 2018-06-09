%% 4A
%Load dataset
data = load('NIPS500.mat');
patterns = data.Patterns;
terms = data.terms;
titles = data.titles;
res = tfidf1(patterns);
% res = full(tfidf1(patterns))';

%% 4B
global IW distances;
patterns = res;
D = size(patterns,1);
minMax4b  = zeros(D,2);
%Find mins and maxs
for i = 1:D
    minMax4b(i,1)=min(patterns(i,:));
    minMax4b(i,2)=max(patterns(i,:));
end
gridSize4b = [10 10];   %10x10 neurons
numNeurons = 100;
OrderLR4b = 0.9;        %initial training learning rate
OrderEpochs4b = 750;    %ordering No. of epochs
TuneLR4b = 0.1;         %tuning learning rate
somCreate4b(minMax4b, gridSize4b);
%Set training parameters
somTrainParameters(OrderLR4b, OrderEpochs4b, TuneLR4b);
%Train SOM
somTrain(patterns);
% %Display 
fig = figure;
somShow(IW,gridSize4b);
% name = ['4B_' int2str(gridSize4b(1,1)) 'x' int2str(gridSize4b(1,2)) '-' int2str(OrderLR4b) ...
%     '-' int2str(OrderEpochs4b) '-' int2str(TuneLR4b) '.png'];
% saveas(fig, name);
%2nd type of plot (?)
% plot2DSomData(IW,distances,patterns);

%% 4C %%
% % i)
% outp = zeros(numNeurons,size(patterns,2));
% for i = 1:size(patterns,2)
%     outp(:,i) = somOutput(patterns(:,i));
% end
% % Sum for each neuron (row)
% numOfDocs = sum(outp,2);
% figure;
% plot(numOfDocs);
% figure;
% bar(numOfDocs);

%% ii)
% file_4Cii = fopen('4C_ii.txt','w');
% fprintf(file_4Cii,'Titles with min distances\n');
% fprintf(file_4Cii,'  Neuron & Title \n');
% for n=1:numNeurons
%     for p=1:D
%         dist(p)=negdist(IW(n,:),patterns(:,p));
%     end
%     [maxii,maxindii]=max(dist);
%     fprintf(file_4Cii,'%d &  %s\n', n, titles{maxindii});
% end
% %% iii)
% % IWtemp = IW;
% % for i = 1:numNeurons
% %     totalMin = min(IWtemp(i,:));
% %     %1st max
% %     [~, max1ind] = max(IWtemp(i,:));
% %     IWtemp(i,max1ind)=totalMin;
% %     [~, max2ind] = max(IWtemp(i,:));
% %     IWtemp(i,max2ind)=totalMin;
% %     [~, max3ind] = max(IWtemp(i,:));
% %     termsForNeuron(i,:) = [terms(max1ind) terms(max2ind) terms(max3ind)];
% % end
% 
% % %% iv)
% % %Find term's indexes
% for i = 1:size(terms)
%     if (strcmp(terms(i), 'network'))
%         Index_network = i;
%     end
%     if (strcmp(terms(i), 'function'))
%         Index_func = i;
%     end
% end
% 
% max4iv_net = max(IW(:,Index_network));
% max4iv_func = max(IW(:,Index_func));
% moreThan30 = zeros(numNeurons, 1);
% for i=1:numNeurons
%     if (IW(i, Index_network) > (max4iv_net * 0.3)) && (IW(i, Index_func) > (max4iv_func * 0.3))
%         moreThan30(i) = 1;
%     end
% end
% % y = figure;
% % bar(moreThan30);
% % axis([0 numNeurons+5 0 1.5]);
% % title('Neurons for network and function >0.3 max');
% % saveas(y,'4Civ.png');
% 
% % %% v) Esto oti ennoei to iv)...
% % meanMaxMoreThan30 = zeros(1,8296);
% % %termsIW = Nx8296 (neurons x terms)
% % termsIW = IW*patterns;
% % %iterate for each term after finding total max
% % totalMaxIW = max(termsIW(:));
% % for i = 1:8296
% %     meanMaxMoreThan30(i) = (sum((moreThan30 .* termsIW(:, i)), 1) / sum(moreThan30)) / totalMaxIW ;
% % end
