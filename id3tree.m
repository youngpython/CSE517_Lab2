function T=id3tree(xTr,yTr,maxdepth,weights,current_pos)
% function T=id3tree(xTr,yTr,maxdepth,weights)
%
% The maximum tree depth is defined by "maxdepth" (maxdepth=2 means one split). 
% Each example can be weighted with "weights". 
%
% Builds an id3 tree
%
% Input:
% xTr | dxn input matrix with n column-vectors of dimensionality d
% xTe | dxm input matrix with n column-vectors of dimensionality d
% maxdepth = maximum tree depth
% weights = 1xn vector where weights(i) is the weight of example i
% 
% Output:
% T = decision tree 
%

% Answer to question 6a - if each parent splits (roughly) binary,
% expected value of q is, for n elements, 2^(n+1) - 1

[~,n]=size(xTr);
if nargin<4
    weights=ones(1,n)./n;
end
if nargin<3
   maxdepth = ceil(log2(n)); %FIXME Unsure about this
end
if nargin<5
    current_pos = 1;
    disp('T refreshed');
end

if length(unique(yTr','rows')) == 1  || maxdepth == 0 %If all the y's are the same, or max depth reached
    T = [yTr(1);0;0;0;0;floor(current_pos/2)];
    
elseif length(unique(xTr','rows')) == 1 || maxdepth == 0 %If all columns in xTr are the same, or max depth reached
    T = [mode(yTr);0;0;0;0;floor(current_pos/2)];
else
    [feature,cut,~] = entropysplit(xTr,yTr,weights);
    left_idx = xTr(feature,:)<=cut;
    SL_x = xTr(:,left_idx);
    SL_y = yTr(:,left_idx);
    SL_weights = weights(:,left_idx);
    
    right_idx = xTr(feature,:)>cut;
    SR_x = xTr(:,right_idx);
    SR_y = yTr(:,right_idx);
    SR_weights = weights(:,right_idx);
    T = [id3tree(SL_x,SL_y,maxdepth-1,SL_weights,2*current_pos) [mode(yTr);feature;cut;2*current_pos;2*current_pos+1;floor(current_pos/2)] id3tree(SR_x,SR_y,maxdepth-1,SR_weights,2*current_pos+1)];   
end
T = sortrows(T',6)';
%{
current_pos = 1;
[feature,cut,Hbest] = entropysplit(xTr,yTr,weights);
T(:,current_pos) = [mode(yTr);feature;cut;2*current_pos;2*current_pos+1;0];
for i=1:maxdepth
   for position = current_pos:2*current_pos-1
      %T(:,position) = [mode(yTr);0;0;0;0;0];
      %if it's 2*i, get left
      %if it's 2*i+1, get right
      [feature,cut,Hbest] = entropysplit(xTr,yTr,weights);
      if mod(position,2) == 0
        left_idx = xTr(feature,:)<=cut;
        SL_x = xTr(:,left_idx);
        SL_y = yTr(:,left_idx);
        SL_weights = weights(:,left_idx);
      end
   end
   current_pos = current_pos*2;
%}
end



