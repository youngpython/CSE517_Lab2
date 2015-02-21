function T=id3tree(xTr,yTr,maxdepth,weights,current_pos,alloc)
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
disp('recursive call');
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
if nargin<6
    T = zeros(7,n);
    T(7,:) = 1:n;
end

if length(unique(yTr','rows')) == 1  || maxdepth == 0 %If all the y's are the same, or max depth reached
    alloc = [yTr(1);0;0;0;0;floor(current_pos/2);current_pos];
    
elseif length(unique(xTr','rows')) == 1 || maxdepth == 0 %If all columns in xTr are the same, or max depth reached
    alloc = [mode(yTr);0;0;0;0;floor(current_pos/2);current_pos];
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
    
    alloc = [ id3tree(SL_x,SL_y,maxdepth-1,SL_weights,2*current_pos) [mode(yTr);feature;cut;2*current_pos;2*current_pos+1;floor(current_pos/2);current_pos]   id3tree(SR_x,SR_y,maxdepth-1,SR_weights,2*current_pos+1)];   
    
end
alloc = sortrows(alloc',7)';
replace_indices = alloc(7,:);
T(:,replace_indices) = alloc;
disp(T);
end
