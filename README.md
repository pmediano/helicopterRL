helicopterRL
============

This code is part of the Reinforcement Learning for autonomous helicopter control project, my master's project. For a complete description of the project visit the website

http://wp.doc.ic.ac.uk/sml/

This was project was done with the Statistical Machine Learning group of Imperial College London under the supervision of Marc Deisenroth.

Dependencies
------------  
1. PILCO:    
Paper: http://machinelearning.wustl.edu/mlpapers/paper_files/ICML2011Deisenroth_323.pdf    
Code: http://mloss.org/software/view/508/

2. RL-Glue Core and Matlab codec:  
Paper: http://glue.rl-community.org/images/c/c2/Rlglue-mloss-jmlr-2009-PREPRINT.pdf  
Code: http://glue.rl-community.org  

3. Standard Matlab installation, Java and Java Compiler


Installation instructions
------------------------

1. Download PILCO, download and install RL-Glue Core and RL-Glue Matlab codec following instructions in the RL-Glue and RL-Library websites.
2. a) Download the Helicopter environment from the 2014 RL Competition website (https://sites.google.com/site/rlcompetition2014/domains/helicopter).  
  b) Or Download it from the RL-Library website (<a href="library.rl-community.org/wiki/Helicopter_(Java)">library.rl-community.org/wiki/Helicopter_(Java)</a>).  
3. Copy the `helicopter` folder in the `pilco_root/scenarios/` folder.
4. Copy the `GPAgentMatlab` and randomAgentMatlab folders in the `pilco_root/scenarios/helicopter/agents/` folder.
5. Copy the `testTrainerJavaHelicopter` and `consoleTrainerJavaHelicopter` in the `pilco_root/scenarios/helicopter/trainers` folder.
6. Edit `settings_hc.m` file and set the correct agent, trainer, codec and PILCO paths.


Usage
-----

You can play with the parameters of the algorithm and the learning task in `settings_hc.m` and `helicopter_learn_loop.m`. See comments inside the code for more information.

For a quick start, open a Matlab instance in `pilco_root/scenarios/helicopter/` and run `helicopter_learn_loop.m`.

