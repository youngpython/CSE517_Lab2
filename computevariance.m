function variance=computevariance(xTe,treedepth,hbar)
% function variance=computevariance(xTe,OFFSET,treedepth,Nsmall,NMODELS,hbar)
% 
% computes the variance of classifiers trained on data sets from
% toydata.m with pre-specified "OFFSET" and a finite "treepdeth",
% evaluated on xTe. 
% the prediction of the average classifier is assumed to be stored in "hbar".
%
% The "infinite" number of models is estimated as an average over NMODELS. 
%
% INPUT:
% xTe       | dxn matrix, of n column-wise input vectors (each d-dimensional)
% treedepth | max treedepth of the decision tree models
% hbar      | 1xn vector of the predictions of hbar on the inputs xTe
% 

global Nsmall NMODELS OFFSET;
[~,n]=size(xTe);
variance=zeros(1,n);
for j=1:NMODELS
    [xTr,yTr] = toydata(OFFSET,Nsmall);
    h_d = evaltree(id3tree(xTr,yTr,treedepth),xTe);
    variance = variance + (h_d - hbar).^2;
end;
variance=mean(variance)/NMODELS;


