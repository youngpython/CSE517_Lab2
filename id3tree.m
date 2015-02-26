function T=id3tree(xTr,yTr,maxdepth,weights,isforest)
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

[d,n]=size(xTr);
if nargin<5
   isforest = false;
end
if nargin<4
    weights=ones(1,n)./n;
end
if nargin<3
   maxdepth = ceil(log2(n)); %FIXME Should actually be n, but can we get a better estimate on number of nodes?
end
T = zeros(7,n);
avail_features = 1:d;
alloc = id3treehelper(xTr,yTr,maxdepth,weights,1,isforest,avail_features,d);

alloc = sortrows(alloc',7)';
replace_indices = alloc(7,:);
T(:,replace_indices) = alloc;
T = T(1:6,:);
end

function alloc=id3treehelper(xTr,yTr,maxdepth,weights,current_pos,isforest,avail_features,d)
    if length(unique(yTr','rows')) == 1  || maxdepth == 0 %If all the y's are the same, or max depth reached
        alloc = [mode(yTr);0;0;0;0;floor(current_pos/2);current_pos];
    %If all columns in xTr are the same, or max depth reached
    elseif length(unique(xTr','rows')) == 1 || maxdepth == 0 
        alloc = [mode(yTr);0;0;0;0;floor(current_pos/2);current_pos];
    else
        if isforest == true
            feature_indices = randsample(avail_features,ceil(d*(4/7)));
            x = xTr(feature_indices,:); %FIXME Change back to x
            [feature,cut,~] = entropysplit(x,yTr,weights);
            %FIXME Originally picked a "feature" index that did not
            %correspond with the collapsed matrix
        else
            [feature,cut,~] = entropysplit(xTr,yTr,weights);  
        end
        if feature==0 %FIXME Delete
            alloc = [mode(yTr);0;0;0;0;floor(current_pos/2);current_pos]; %FIXME If we have this, do we need the others?
        else
            %TR_SIZE = size(xTr)
            %xTr(feature,:)
            %feature
            %cut
            left_idx = xTr(feature,:)<=cut;
            SL_x = xTr(:,left_idx);
            SL_y = yTr(:,left_idx);
            SL_weights = weights(:,left_idx);
            %SIZE_LX = size(SL_x)
            right_idx = xTr(feature,:)>cut;
            SR_x = xTr(:,right_idx);
            SR_y = yTr(:,right_idx);
            SR_weights = weights(:,right_idx);
            %SIZE_RX = size(SR_x)
            %[~,~,C] = mode(yTr);
            %disp(length(find(cellfun(@(x)(length(x)>1),C)))); %FIXME Mode
            alloc = [ id3treehelper(SL_x,SL_y,maxdepth-1,SL_weights,2*current_pos,isforest,avail_features,d),... 
                [mode(yTr);feature;cut;2*current_pos;2*current_pos+1;floor(current_pos/2);current_pos],... 
                id3treehelper(SR_x,SR_y,maxdepth-1,SR_weights,2*current_pos+1,isforest,avail_features,d)];  
            %disp(alloc);
        end
        
    end
    
end