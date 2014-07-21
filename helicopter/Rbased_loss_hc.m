%% Rbased_loss_hc.m
%   function [L, dLdm, dLds, S2] = Rbased_loss_hc(cost, m, s)
%
% *Input arguments:*
%
%   cost            cost structure
%    .rewardgpmodel GP to predict reward given state
%   m               mean of state distribution                      [D x  1 ]
%   s               covariance matrix for the state distribution    [D x  D ]
%
% *Output arguments:*
%
%   L     expected cost                                             [1 x  1 ]
%   dLdm  derivative of expected cost wrt. state mean vector        [1 x  D ]
%   dLds  derivative of expected cost wrt. state covariance matrix  [1 x D^2]
%   S2    variance of cost                                          [1 x  1 ]


function [L, dLdm, dLds, S2] = Rbased_loss_hc(cost, m, s)
%% Code
	[L, S2, ~, dLdm, ~, ~, dLds, ~, ~] = gp1d(cost.rewardgpmodel, m, s);

end


