function T=id3tree(xTr,yTr,maxdepth,weights,current_T,current_pos)
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
if nargin<4
    weights=ones(1,n)./n;
end
if nargin<3
   maxdepth = ceil(log2(n)); %FIXME Unsure about this
end
if nargin<6
    current_pos = 1;
end
if nargin<5
    current_T = zeros(6,n);
    %initialize root in current_T
    [feature,cut,Hbest]=entropysplit(xTr,yTr,weights);
    current_T(:,current_pos) = [mode(yTr);feature;cut;2*current_pos;2*current_pos + 1;0];
end
if length(unique(yTr','rows')) == 1 %If all the y's are the same
    %{
    T = yTr(:,1); %These should be leaves, not nodes
    %}
    %current_T(:,current_pos) = [yTr(1);0;0;0;0;0];
    disp('reached unsplittable 1');
    T = current_T;
    
elseif length(unique(xTr','rows')) == 1 %If all columns in xTr are the same
    %T = [mode(yTr);0;0;0;0;0];
    %{
    %Split the matrix into a cell array, where each cell contains a column
    C = mat2cell(yTr, size(yTr, 1), ones(1, size(yTr, 2)));
    %Convert the column in each cell into a string
    D = cellfun(@(x) mat2str(x), C, 'UniformOutput', false);
    %Find the mode string
    [unique_strings, ~, string_map]=unique(D);
    most_common_string=unique_strings(mode(string_map));
    %A string of the column matrix should now appear.  Split by delimiters
    strcol = strsplit(most_common_string{1},{';','[',']',' '});
    %Convert the split numbers to doubles, remove the trailing '' strings
    %on either end, and transpose the row to a column.
    T = str2double(strcol(2:end-1))';
    %}
    disp('reached unsplittable 2');
    T = current_T;
else
    disp('reached splittable');
    [feature,cut,Hbest] = entropysplit(xTr,yTr,weights);
    left_idx = xTr(feature,:)<=cut;
    SL_x = xTr(:,left_idx);
    SL_y = yTr(:,left_idx);
    SL_weights = weights(:,left_idx);
    right_idx = xTr(feature,:)>cut;
    SR_x = xTr(:,right_idx);
    SR_y = yTr(:,right_idx);
    SR_weights = weights(:,right_idx);
    [feature_left,cut_left,Hbest_left] = entropysplit(SL_x,SL_y,SL_weights);
    [feature_right,cut_right,Hbest_right] = entropysplit(SR_x,SR_y,SR_weights);
    current_T(:,2*current_pos) = [mode(SL_y);feature_left;cut_left;2*(2*current_pos);2*(2*current_pos)+1;current_pos];
    current_T(:,2*current_pos + 1) = [mode(SR_y);feature_right;cut_right;2*(2*current_pos + 1);2*(2*current_pos + 1)+1;current_pos];
    current_pos = current_pos*2;
    T = current_T;
    SL = id3tree(SL_x,SL_y,maxdepth,SL_weights,current_T,current_pos);
    disp(SL);
    SR = id3tree(SR_x,SR_y,maxdepth,SR_weights,current_T,current_pos);
    disp(SR);
    
    %append on the order of two nodes at once
    %for i in range(current_pos,2*current_pos-1)
    %positions = current_pos:2*current_pos-1;
    %cellfun(@(x) current_T(:,x) = [,positions 

    
    %current_T(:,current_pos) = [mode(yTr);feature;cut;2*current_pos;
    %       2*current_pos + 1;0];
    %
    %current_T(:,2*current_pos) = [mode(SL_y);feature;cut
    %Split training data into Left and Right sets
    %
    
    
end

 



