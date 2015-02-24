function hbar=computehbar(xTe,treedepth)
% function [hbar]=computehbar(xTe,treedepth);
% 
% computes the expected prediction of the average classifier (hbar)
% for data set xTe. 
% The of size Nsmall drawn from toydata.m with OFFSET 
% with id3trees with maxdepth "treedepth"
%
% The "infinite" number of models is estimated as an average over NMODELS. 
%
% INPUT:
% xTe       | dxn matrix, of n column-wise input vectors (each d-dimensional)
% treedepth | max treedepth of the decision tree models
%

global Nsmall NMODELS OFFSET;
[~,n]=size(xTe);
hbar=zeros(1,n);
for j=1:NMODELS
    [xTr,yTr] = toydata(OFFSET,Nsmall);
    hbar = hbar + evaltree(id3tree(xTr,yTr,treedepth),xTe);
end;
hbar=hbar./NMODELS;


