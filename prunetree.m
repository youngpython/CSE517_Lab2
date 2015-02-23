function T=prunetree(T,xTe,y)
% function T=prunetree(T,xTe,y)
%
% Prunes a tree to minimal size such that performance on data xTe,y does not
% suffer.
%
% Input:
% T = tree
% x = validation data x (dxn matrix)
% y = labels (1xn matrix)
%
% Output:
% T = pruned tree 
%

n = length(y);
for level = ceil(log2(length(T))):-1:2
    original_error = (1/n)*sum((evaltree(T,xTe)-y).^2);
    deletable = (2^(level-1)):length(T);
    new_leaves = (2^(level-2)):(2^(level-1)-1);
    pruned_T = T;
    pruned_T(:,deletable) = zeros(6,length(deletable));
    pruned_T(2:5,new_leaves) = zeros(4,length(new_leaves));
    if (1/n)*sum((evaltree(pruned_T,xTe)-y).^2) <= original_error
        T = pruned_T;
    else
        break;
    end
end
