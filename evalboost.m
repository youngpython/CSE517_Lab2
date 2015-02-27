function preds=evalboost(BDT,xTe)
% function preds=evalboost(BDT,xTe);
%
% Evaluates a boosted decision tree on a test set xTe.  
%
% input: 
% BDT | Boosted Decision Trees
% xTe | matrix of m input vectors (matrix size dxm)
%
% output: 
%
% preds | predictions of labels for xTe
%
[n,~] = size(BDT);
[~,m] = size(xTe);
preds = zeros(n,m);

for i = 1:n
   preds(i,:) = evaltree(BDT{i},xTe); 
end

predictions = zeros(1,m);
for i = 1:m
    predictions(i) = mode(preds(:,i));
end


