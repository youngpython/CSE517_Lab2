function F=forest(x,y,nt)
% function F=forest(x,y,nt)
%
% INPUT: 
% x | input vectors dxn
% y | input labels 1xn
%
% OUTPUT:
% F | Forest
%
maxdepth = 3; 


trees = cell(1,nt);
[d,n] = size(x);
weights = ones(1,n)./n;
for i = 1:nt
   training_vectors = randsample(n,n,true);
   xTr = zeros(d,n);
   yTr = zeros(1,n);
   for j = 1:n
       xTr(:,j) = x(:,training_vectors(j));
       yTr(:,j) = y(:,training_vectors(j));
   end
   trees{i} = prunetree(id3tree(xTr,yTr,maxdepth,weights,false,true),x,y); %FIXME Weights?
end
F = trees;