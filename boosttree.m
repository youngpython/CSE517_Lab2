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
prevweights = weights;
for m = 1:nt
   boosted_trees{m}.alpha = weights;
   %disp(boosted_trees{m});
   %disp(boosted_trees{m}.alpha);
   boosted_trees{m}.tree = id3tree(x,y,maxdepth,weights,false,true);%FIXME Prune?
   %disp(boosted_trees{m}.tree);
   h_x = evaltree(boosted_trees{m}.tree,x);
   indicator = y ~= h_x; %FIXME Are the right ones 0 or -1
   err = sum(indicator.*weights);
   %ERR = indicator.*weights
   %ERR_SUM = err
   if err > .5
      % disp(m)
       break;
   end
   stopping_point = m;
   alpha = (1/2)*log((1-err)/err);
   %BDT = BDT + alpha*T; %FIXME In the pseudocode, but Dr. Weinberger says
   %we don't have to
   
   %Convert predictions and y vectors to 1's and -1's (rather than 1's
   %and 2's or whatever they may be)
   pos = max(y);
   neg = min(y);
   h_x(h_x == neg) = -1;
   h_x(h_x == pos) = 1; %Only relevant when training label 
   y_dummy = y; 
   y_dummy(y_dummy == neg) = -1;
   y_dummy(y_dummy == pos) = 1;
   %prevweights = weights;
   for i = 1:n
      weights(i) = (weights(i)*exp(-1*alpha*h_x(i)*y_dummy(i)));
   end
   %weights = weights./norm(weights);
   weights = weights./sum(weights);
   %weights = weights./(2*sqrt(err*(1-err)));
   %disp(weights)
   %disp('sum of weights inside loop')
   %disp(sum(weights))
   %(2*sqrt(err*(1-err)));
end
%weights = weights./norm(weights);
%disp('got here')
%disp(prevweights)
%weights = weights./sum(weights);
%disp(sum(prevweights))
%BDT = boosted_trees;
BDT = cell(1,stopping_point);
for i=1:stopping_point
    BDT{i} = boosted_trees{i}.tree;
end

%BDT=boosted_trees(1:stopping_point).tree;
%disp(BDT);

%BDT = id3tree(x,y,maxdepth,prevweights,false,true);
