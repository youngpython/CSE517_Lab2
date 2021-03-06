function [ypredict]=evaltree(T,xTe)
% function [ypredict]=evaltree(T,xTe);
%
% input: 
% T0  | tree structure
% xTe | Test data (dxn matrix)
%
% output: 
%
% ypredict : predictions of labels for xTe
%
[~,y] = size(xTe);
ypredict = zeros(1,length(xTe));
for xCol = 1:y
    xVec = xTe(:,xCol);
    current_pos = 1;
    while (~(T(4,current_pos)==0 && T(5,current_pos)==0))  
        feature = T(2,current_pos);
        cutoff = T(3,current_pos);
        if xVec(feature) <= cutoff
            %goes to left child of current node
            current_pos = current_pos*2;
        else
            current_pos = current_pos*2 + 1;
        end
        
    end
    ypredict(:,xCol) = T(1,current_pos);
end
        
        

    

