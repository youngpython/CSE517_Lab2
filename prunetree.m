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
%{
n = length(y);
for node = length(T):-2:3
    original_error=1 - analyze('acc',y,evaltree(T,xTe));
    pruned_T = T;
    to_delete = pruned_T(:,node);
    to_delete_sibling = pruned_T(:,node-1);
    if to_delete(6,:) ~= to_delete_sibling(6,:) && to_delete(6,:) ~= 0 && to_delete_sibling(6,:) ~= 0 
        disp('nodes have different parent');
        disp(node);
        disp(node-1);
    end
    
    if to_delete(6,:) ~= 0
       pruned_T(:,node-1:node) = zeros(6,2);
       pruned_T(2:5,to_delete(6,:)) = zeros(4,1); 
    end
    newError=1 - analyze('acc',y,evaltree(pruned_T,xTe));
    if newError <= original_error
        T = pruned_T;
    end
end
%}
%leaves = T(:,T(T(2:5,:)==0));
parents_of_leaves = parents(T);
for i = 1:length(parents_of_leaves)
    original_error = 1 - analyze('acc',y,evaltree(T,xTe));
    pruned_T = T;
    pruned_T(2:5,parents_of_leaves(i)) = zeros(4,1);
    newError = 1 - analyze('acc',y,evaltree(pruned_T,xTe));
    if newError <= original_error
        T = pruned_T;
        parents_of_leaves = parents(T);
    end

end

end

function parents_of_leaves = parents(T)
    [~,n] = size(T);
    parents_of_leaves = [];
    for j = 2:n-1 %FIXME Off-by-one error?
       possible_left_leaf = T(:,j);
       possible_right_leaf = T(:,j+1);
       if isequal(possible_left_leaf(2:5,:), possible_right_leaf(2:5,:), zeros(4,1))
          if isequal(possible_left_leaf(6,:), possible_right_leaf(6,:)) && ~isequal(possible_left_leaf(6,:), 0) && ~isequal(possible_right_leaf(6,:), 0)
             parents_of_leaves = [parents_of_leaves possible_left_leaf(6,:)];
          end
       end
    end
    parents_of_leaves = sort(parents_of_leaves, 'descend'); %FIXME The original tree (after eval?) has NaN values
end
