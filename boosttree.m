function BDT=boosttree(x,y,nt,maxdepth)
% function BDT=boosttree(x,y,nt,maxdepth)
%
% Learns a boosted decision tree on data x with labels y.
% It performs at most nt boosting iterations. Each decision tree has maximum depth "maxdepth".
%
% INPUT: 
% x  | input vectors dxn
% y  | input labels 1xn
% nt | number of trees (default = 100)
% maxdepth | depth of each tree (default = 3)
%
% OUTPUT:
% BDT | Boosted DTree
%
boosted_trees = cell(1,nt);
if ~exist('nt', 'var')==1 || isempty(nt)
   nt = 100; 
end
if ~exist('maxdepth', 'var')==1 || isempty(maxdepth)
   maxdepth = 3; 
end
[~,n] = size(x);
weights = ones(1,n)./n;
for m = 1:nt
   boosted_trees{m}.alpha = weights;
   %create a tree using the up-to-date weights
   boosted_trees{m}.tree = id3tree(x,y,maxdepth,boosted_trees{m}.alpha,false,true);
   h_x = evaltree(boosted_trees{m}.tree,x);
   %find the labels the tree got right, mark the wrongly labeled vectors
   %with a 1
   indicator = y ~= h_x; 
   %weighted error is the sum of all weights of the incorrectly predicted
   %vectors
   err = sum(indicator.*weights);
   if err > .5
       break;
   end
   stopping_point = m;
   alpha = (1/2)*log((1-err)/err);
   
   %convert predictions and y vectors to 1's and -1's (rather than 1's
   %and 2's or whatever they may be)
   pos = max(y);
   neg = min(y);
   h_x(h_x == neg) = -1;
   h_x(h_x == pos) = 1; %Only relevant when training label 
   y_dummy = y; 
   y_dummy(y_dummy == neg) = -1;
   y_dummy(y_dummy == pos) = 1;
   for i = 1:n
      weights(i) = (weights(i)*exp(-1*alpha*h_x(i)*y_dummy(i)));
   end
   %normalize weights
   weights = weights./sum(weights);
end

%create the final BDT, which will have each of the boosted_tree
%entries in it
BDT = cell(1,stopping_point);
for i=1:stopping_point
    BDT{i} = boosted_trees{i}.tree;
end
