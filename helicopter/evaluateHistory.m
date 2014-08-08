%% evaluateHistory.m
% *Summary:* Evaluate the performance of the policies in a certain learning history.
%
% *Input arguments:*
%    whichMDP:	number of the MDP to test policies on
%    history:	cell array, each cell contains a policy to be evaluated
%
% *Output arguments:*
%    res: 	matrix with the average and std of steps survived by each policy
%
%% High-level steps
%
% # Set up configuration for helicopter scenario (paths, variables, etc)
% # Compile java trainer to run desired MDP
% # Evaluate each policy in history file \verb@sample@ times and return statisics

%% Code

function res=evaluateHistory(whichMDP, history)

    % 1. Set up helicopter configuration
    settings_hc;

    n_iter = numel(history);
    res = zeros([n_iter, 5]);
    
    % 2. Compile java trainer
    setenv('tMDP', num2str(whichMDP));
    cd([trainerDir 'consoleTrainerJavaHelicopter']);
    !sed "s/whichTrainingMDP = [0-9]/whichTrainingMDP = ${tMDP}/" <src/consoleTrainerBackup >src/consoleTrainer.java
    !make

    % 3. Loop over history and evaluate policies
    for j=1:n_iter
        theAgent = helicopter_agent(history{j}.policy, codecDir, pilcoDir);
        res(j, 1) = size(history{j}.dynmodel.targets, 1);
        [res(j, 2), res(j, 3), res(j, 4), res(j, 5)] = evaluatePolicy(theAgent, trainerDir, pilcoDir);
    end
    
end

function [mean_time, std_time, mean_reward, std_reward]=evaluatePolicy(theAgent, trainerDir, pilcoDir, nb_samples)
% Auxiliar function for evaluateHistory. 

    if nargin < 4
        sample = 10;		% Number of trajectories to generate
    else
        sample = nb_samples;
    end
    steps = zeros([sample, 1]);
    rewards = zeros([sample, 1]);
    
    for j=1:sample
        cd([trainerDir 'consoleTrainerJavaHelicopter']);
        !bash run.bash &
        cd([pilcoDir 'scenarios/helicopter']);
        runAgent(theAgent);
        newdata = load('GPHistory.mat');
        steps(j) = size(newdata.helicopter_agent_struct, 1) - 1;
        rewards(j) = mean(newdata.helicopter_agent_struct(:, 17));
    end
    
    mean_time = mean(steps);
    std_time = std(steps);
    mean_reward = mean(rewards);
    std_reward = std(rewards);
    
end
