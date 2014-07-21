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

    n_iter = size(history, 2);
    res = zeros([n_iter, 2]);
    
    % 2. Compile java trainer
    setenv('tMDP', num2str(whichMDP));
    cd([trainerDir 'consoleTrainerJavaHelicopter']);
    !sed "s/whichTrainingMDP = [0-9]/whichTrainingMDP = ${tMDP}/" <src/consoleTrainerBackup >src/consoleTrainer.java
    !make

    % 3. Loop over history and evaluate policies
    for j=1:n_iter
        theAgent = helicopter_agent(history{j}.policy, codecDir, pilcoDir);
        [res(j, 1), res(j, 2)] = evaluatePolicy(theAgent, trainerDir, pilcoDir);
    end
    
end


function [m, s]=evaluatePolicy(theAgent, trainerDir, pilcoDir)
% Auxiliar function for evaluateHistory. 

    sample = 10;		% Number of trajectories to generate
    steps = zeros([sample, 1]);
    
    for j=1:sample
        cd([trainerDir 'consoleTrainerJavaHelicopter']);
        !bash run.bash &
        cd([pilcoDir 'scenarios/helicopter']);
        runAgent(theAgent);
        newdata = load('GPHistory.mat');
        steps(j) = size(newdata.helicopter_agent_struct, 1) - 1;
    end
    
    m = mean(steps);
    s = std(steps);
    
end
