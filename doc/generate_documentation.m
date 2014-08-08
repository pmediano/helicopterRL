% Sweep through the folders and auto-generate documentation for each file

clear all; close all

docFormats = {'latex'};
styles = {'styles/m2doctex.xsl', ''};

RootDir = '../';

for i = 1:length(docFormats)
outputDir{1} = [RootDir 'doc/tex/'];
outputDir{2} = [RootDir 'doc/html/'];
end


files = {
   [RootDir, 'helicopter/checkModel.m'], ...
   [RootDir, 'helicopter/drawNLPDplots.m'], ...
   [RootDir, 'helicopter/evaluateHistory.m'], ...
   [RootDir, 'helicopter/getHistoryFilename.m'], ...
   [RootDir, 'helicopter/helicopter_learn_loop.m'], ...
   [RootDir, 'helicopter/loss_hc.m'], ...
   [RootDir, 'helicopter/NLPD.m'], ...
   [RootDir, 'helicopter/Rbased_loss_hc.m'], ...
   [RootDir, 'helicopter/settings_hc.m'], ...
   [RootDir, 'helicopter/trainHelicopterModel.m'], ...
   [RootDir, 'helicopter/trainRewardModel.m'], ...
   [RootDir, 'randomAgentMatlab/random_agent_matlab.m'], ...
   [RootDir, 'GPAgentMatlab/helicopter_agent.m'], ...
  };

for i = 1:length(docFormats)

  outputDir{i} = [RootDir 'doc/', docFormats{i}, 'Folder/'];
  if ~exist(outputDir{i}, 'dir')
    mkdir(outputDir{i});
  end

  % define a new output format
  options = struct('format', docFormats{i}, ...
    'evalCode', false, ...
    'outputDir', outputDir{i}, ...
    'showCode', true, ...
    'stylesheet', styles{i} ...
    );

  
  fprintf('\r Generating %s %s\n', docFormats{i}, 'files ...');
  
  
  % sweep through the files
  for j = 1:length(files)
    publish(files{j}, options);
    fprintf('\r%i/%i',j,length(files));
  end
  
end

isLatex = cellfun(@(s) strcmp(s, 'latex'), docFormats);
if any(isLatex)
  fprintf('\r If you want to generate full LaTeX documentation, remember to get doc.tex in your LaTeX environment and compile it.');
end

fprintf('\r Done\n');
