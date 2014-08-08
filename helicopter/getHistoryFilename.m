%% getHistoryFilename.m
% *Summary:* Script to find a name for the history file to be used.
% If user set |use_previous_history=true|, the name of the latest existing
% history file is returned. If |use_previous_history=false|, return a name
% for a new file. 
%

%% Code

historyFilename = sprintf('historyMDP%i.mat', whichMDP);

if ~use_previous_history && ~exist(historyFilename, 'file')
    disp(['Creating first history file for this MDP, ' historyFilename]);

elseif use_previous_history && ~exist(historyFilename, 'file')          % If the user requests a previous history but 
                                                                    % there are no saved histories, notify
    disp(['No previous history to load. Generating random data. Saving history in ' historyFilename]);
    use_previous_history = false;
else                                                                % If a history file exists, add a subindex
    history_nb = 2;
    historyFilename = sprintf('historyMDP%i.%i.mat', whichMDP, history_nb);
    if use_previous_history && ~exist(historyFilename, 'file')
        historyFilename = sprintf('historyMDP%i.mat', whichMDP);
        disp(['Using data from file ' historyFilename]);
    else
        while exist(historyFilename, 'file')                        % Find the latest history file for this MDP
            history_nb = history_nb + 1;
            historyFilename = sprintf('historyMDP%i.%i.mat', whichMDP, history_nb);
        end
        if use_previous_history                                     % If user requested previous history, go back
                                                                    % one step to get the latest existing file
            history_nb = history_nb - 1;
            historyFilename = sprintf('historyMDP%i.%i.mat', whichMDP, history_nb);
            disp(['Using history from the latest file, ' historyFilename]);
        else
            disp(['Creating new file ' historyFilename]);
        end
    end
end

