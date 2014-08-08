This trainer is meant to run console-based experiments with the Helicopter java domains for the rl-competition.

run.bash:
- Starts RL_glue
- Starts the dynamic environment loader which can load any of the three environments
- Starts a console based experiment program that can load whichever of the environments

To recompile the trainer:
$> make clean
$> make

in the consoleTrainerJava directory.

You need to start your own agent.
