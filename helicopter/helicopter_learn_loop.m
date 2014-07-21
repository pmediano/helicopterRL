%% helicopter_learn_loop.m
% *Summary:* Script to learn a controller for the helicopter problem
%
%% High-level steps
% # Initialize variables and compile RL-Glue trainer
% # Generate random trajectories to speed up learning
% # Apply learning loop (model learning, policy learning, policy application)

%% Code

% 1. Initialization
clear all; close all;
settings_hc;                  	% Load scenario-specific settings

use_reward_model = false;
use_previous_history = false;

% Modify the trainer source files and compile for the desired MDP
whichMDP = 7;
setenv('tMDP', num2str(whichMDP));
cd([trainerDir 'consoleTrainerJavaHelicopter']);
!sed "s/whichTrainingMDP = [0-9]/whichTrainingMDP = ${tMDP}/" <src/consoleTrainerBackup >src/consoleTrainer.java
!make

% Get a suitable name for the history file
cd([pilcoDir 'scenarios/helicopter']);
getHistoryFilename;


% 2. Collect data with random policy to start learning, or start from the
% latest history file
if ~use_previous_history
    cd([trainerDir 'testTrainerJavaHelicopter']);
    !sed "s/whichTrainingMDP = [0-9]/whichTrainingMDP = ${tMDP}/" <src/testTrainerBackup >src/testTrainer.java
    !make
    !bash run.bash &
    cd([agentDir 'randomAgentMatlab']);
    delete(['randomDataMDP' num2str(whichMDP) '.mat']);
    theRandomAgent = random_agent_matlab(whichMDP, codecDir, agentDir);
    runAgent(theRandomAgent);

    load([agentDir 'randomAgentMatlab/randomDataMDP' num2str(whichMDP) '.mat']);
    
    delta_n = min(n_init, size(random_data.x, 2));
    x = random_data.x(1:delta_n,:);
    y = random_data.y(1:delta_n,:);
    r_x = random_data.r_x(1:delta_n,:);
    r_y = random_data.r_y(1:delta_n,:);
    H = 5;
else
    load(historyFilename);
    x = history{end}.x;
    y = history{end}.y;
    r_x = history{end}.r_x;
    r_y = history{end}.r_y;
    dynmodel = history{end}.dynmodel;
    if use_reward_model
        if ~isfield(history{end}, 'reward_dynmodel')
            disp('Requested reward model, but no reward model in previous history. Abort.');
            return
        else
            reward_dynmodel = history{end}.reward_dynmodel;
        end
    end
    policy = history{end}.policy;
    H = history{end}.H;
    last_size = history{end}.steps;
end


% Start learning loop. Finish when the helicopter makes a successful run (6000 steps)
cd([pilcoDir 'scenarios/helicopter']);
j = 1;
while ~exist('last_size', 'var') || last_size < 5990
    
    % 3. Train GP's and specify cost function
    
    % 3.1. Train GP model to predict reward to use as cost function, or
    % set parameters of user-defined cost function
    if use_reward_model
        trainRewardModel;
        cost.fcn = @Rbased_loss_hc;
        cost.rewardgpmodel = reward_dynmodel;
        history{end}.reward_dynmodel = reward_dynmodel;
    else
        cost.width = 1;
        cost.fcn = @loss_hc;
    end

    % 3.2. Train GP for the helicopter dynamics
    trainHelicopterModel
    if exist('history', 'var'); history{end+1}.dynmodel = dynmodel; else history{1}.dynmodel = dynmodel; end
    
    % 4. Learn policy and save structure
    H = H + 5;
    learnPolicy;
    policy.date = clock;
    
    history{end}.policy = policy;
    history{end}.H = H;
    
    % 5. Run the simulator with the latest policy until trajectory is longer than lower limit
    last_size = 0;
    min_last_size = H;
    while last_size < min_last_size
    	cd([trainerDir 'consoleTrainerJavaHelicopter']);
    	!bash run.bash &
    	cd([pilcoDir 'scenarios/helicopter']);
    	theAgent = helicopter_agent(policy, codecDir, pilcoDir);
    	runAgent(theAgent);
 
   	newdata = load('GPHistory.mat');
    	newdata = newdata.helicopter_agent_struct;
    	last_size = size(newdata,1) - 1;
    end

    % 6. Get new data from the last trajectory
    delta_n = min(last_size, max_last_size) + 1;
    x = [x; newdata(1:delta_n-1,1:16)];
    y = [y; newdata(2:delta_n,1:12)];
    r_x = [r_x; newdata(2:delta_n,1:12)];
    r_y = [r_y; newdata(2:delta_n, 17)];

    
    history{end}.steps = last_size;
    history{end}.x = x;
    history{end}.y = y;
    history{end}.r_x = r_x;
    history{end}.r_y = r_y;
    history{end}.trajectory = newdata;
    
    save(historyFilename, 'history');
    
    disp(['Length of the last trajectory is ' num2str(last_size)]);
    
    % 7. Plot NLPD of model when following the trajectory
		drawNLDPplots;
		    
    j = j + 1;
    
end
