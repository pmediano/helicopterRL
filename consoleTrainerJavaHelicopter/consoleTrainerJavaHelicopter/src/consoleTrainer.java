/* console Trainer for RL Competition
* Copyright (C) 2007, Brian Tanner brian@tannerpages.com (http://brian.tannerpages.com/)
* 
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* 
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA. 
* NOTE: this program has been slightly modified by Pedro Mediano for the helicopterRL project at Imperial College London. More information in https://github.com/pmediano/helicopterRL .
*
**/
import org.rlcommunity.rlglue.codec.RLGlue;

public class consoleTrainer {


	public static void main(String[] args) throws InterruptedException {
	
		int whichTrainingMDP = 0; // select the MDP to load

		consoleTrainerHelper.loadHelicopter(whichTrainingMDP);	
		RLGlue.RL_init();

		int episodeCount = 1; //number of episodes to run
		int maxEpisodeLength = 6001; //set a maxEpisodeLength to cut off long episodes
	
		int totalSteps = 0;//counter for the total number of steps taken to finish all episodes
		//run the episodes with RL_episode(maxEpisodeLength)
		for(int i=0; i<episodeCount; i++){
			RLGlue.RL_episode(maxEpisodeLength);
			totalSteps+=RLGlue.RL_num_steps();
			System.out.println("Episode: "+i+" steps: "+RLGlue.RL_num_steps());
		}	
	
		System.out.println("totalSteps is: "+totalSteps);
		
		//clean up the environment and end the program
		RLGlue.RL_cleanup();
	}
}
