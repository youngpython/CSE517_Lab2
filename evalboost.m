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
   % disp(BDT{i});
   preds(i,:) = evaltree(BDT{i},xTe); 
end
%FIXME Use mean
%predictions = round((1/n)*sum(preds,1));
%FIXME Use mode

predictions = zeros(1,m);
for i = 1:m
    predictions(i) = mode(preds(:,i));
end


