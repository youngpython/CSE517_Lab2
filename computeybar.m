function ybar=computeybar(xTe)
% function [ybar]=ybar(xTe);
% 
% computes the expected label 'ybar' for a set of inputs x
% generated from two standard Normal distributions (one offset by OFFSET in
% both dimensions.)
%
% INPUT:
% xTe | a dxn matrix of column input vectors
% 
% OUTPUT:
% ybar | a 1xn vector of the expected label ybare(x)
%

global OFFSET;

[~,n]=size(xTe);
ybar=zeros(1,n);

% Feel free to use the following function to compute p(x|y)
normpdf=@(x,mu,sigma)   exp(-0.5 * ((x - mu)./sigma).^2) ./ (sqrt(2*pi) .* sigma);

% Computing p(x|y)
%disp(arrayfun(@(x)(normpdf(x,0,1)),xTe));
%p_x = arrayfun(@(x)(normpdf(x,0,1)),xTe) + arrayfun(@(x)(normpdf(x,OFFSET,1)),xTe);
%p_x_y = arrayfun(@(x)(normpdf(x,OFFSET,2)),xTe);
%p_y_given_x = p_x_y./p_x; %FIXME Is this even remotely the right way to get p(y|x)?
%ybar = arrayfun(@(x) (integral(@(y)(y*x),0,1)), p_y_given_x);
%disp(size(ybar));

% Computing p(x|y=1)
cov = eye(2);
mu_std = zeros(2,1);
mu_offset = ones(2,1)*OFFSET;
p_y = [.5,.5];
%[~,N] = size(xTe);
p_x_given_y_1 = cellfun(@(x)(mvnpdf(x,mu_std,cov)), num2cell(xTe,1));
p_x_given_y_2 = cellfun(@(x)(mvnpdf(x,mu_offset,cov)), num2cell(xTe,1));
p_y_1_given_x = (p_y(1)*p_x_given_y_1)./(p_y(1)*p_x_given_y_1 + p_y(2)*p_x_given_y_2);
p_y_2_given_x = 1-p_y_1_given_x;
ybar = 1*p_y_1_given_x + 2*p_y_2_given_x;
%first_class = num2cell(xTe(:,1:floor(N/2)),1);
%second_class = num2cell(xTe(:,ceil(N/2):end),1);
%p_x_given_y_1 = cellfun(@(x)(mvnpdf(x,mu_std,cov)), first_class);
%p_x_given_y_2 = cellfun(@(x)(mvnpdf(x,mu_std,cov)), second_class);
%p_x = cellfun(@(x)(mvnpdf(x,mu_offset,2*cov)), num2cell(xTe,1)); %FIXME Left off here
%p_y_given_x = (p_y(1)*p_x_given_y_1./p_x) + (p_y(2)*p_x_given_y_2./p_x);
%ybar = arrayfun(@(x)(integral(@(y)(y*x),1,2)), p_y_given_x);