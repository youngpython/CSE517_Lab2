function predictions=evalforest(F,xTe)
% function preds=evalforest(F,xTe);
%
% Evaluates a random forest on a test set xTe.  
%
% input: 
% F   | Forest of decision trees
% xTe | matrix of m input vectors (matrix size dxm)
%
% output: 
%
% preds | predictions of labels for xTe
%
[~,n] = size(F);
[~,m] = size(xTe);
preds = zeros(n,m);
for i = 1:n
   preds(i,:) = evaltree(F{i},xTe); 
end
%FIXME Use mean
%predictions = round((1/n)*sum(preds,1));
%FIXME Use mode

predictions = zeros(1,m);
for i = 1:m
    predictions(i) = mode((preds(:,i)));
end
