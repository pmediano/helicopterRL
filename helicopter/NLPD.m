%% NLPD.m
% *Summary:* Computes the Negative Log Predictive Density for a
% multivariate gaussian distribution.
%
% *Input arguments:*
%    x			observation
%    mu			mean vector of the distribution
%    sigma		covariance matrix of the distribution
%    d			(optional) dimensionality of input space
%
% *Output arguments:*
%    lp			computed NLPD

%% Code

function [ lp ] = NLPD(x, mu, sigma, d)

    if nargout==3; d = numel(x); end;

    diff = x-mu;
    lp = 0.5*(log(det(sigma)) + diff'*(sigma\diff) + d*1.837877066409345);

end
