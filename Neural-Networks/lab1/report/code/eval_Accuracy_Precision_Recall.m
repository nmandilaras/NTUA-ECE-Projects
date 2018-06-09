function [accuracy,precision,recall]=eval_Accuracy_Precision_Recall(nnOutput,expectedOutput)
[index1,nnCategory]=max(nnOutput);
[index2,category]=max(expectedOutput);

nnOutput2=zeros(size(nnOutput));
expectedOutput2=zeros(size(expectedOutput));

for(i=1:107)
    nnOutput2(nnCategory(i),i)=1;;
    expectedOutput2(category(i),i)=1;
end


accuracy=sum(sum(nnOutput2&expectedOutput2))/sum(sum(expectedOutput2));
precision=sum(nnOutput2&expectedOutput2,2)./sum(nnOutput2,2);
recall=sum(nnOutput2&expectedOutput2,2)./sum(expectedOutput2,2);



