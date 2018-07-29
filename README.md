# Optimal Switching Sequence for Switched Linear System

Test instances and code for finding the optimal switching sequence of a switched linear system

For more details, please refer to the following working paper:

Wu, Zeyang, and Qie He. "Optimal switching sequence for switched linear systems." arXiv preprint arXiv:1805.04677 (2018).

Overview

This directory contains the codes necessary to run the forward dynamic programming algorithm (FDP) in the paper. The code is written in Matlab and it can generate instances of different parameters and solve it by FDP. We also provide an AMPL script to solve the instances as well. 

Requirements

Recent versions of Matlab，AMPL are required. 


Run the code

The script 'gen_instance_and_solve_by_FDP.m' generates instances and solve it by FDP. There are two parameters can be specified in the test. You can modify it in the script directly. The test result will be recorded in the *.dat files. 

1. There are 10 sets of sizes of the test instances, e.g., dimension, number of matrices. By default, the script generates 10 instances of 10 different sizes.
2. There is a 600s time limit for FDP. This can also be modified in the file.   


In the Matlab command line, simply run 
    
    $gen_instance_and_solve_by_FDP


To solve the instances by AMPL, please first run 
    
    $gen_instances_ampl.m

in Matlab to generate *.dat files for AMPL and then run 'switched_system_baron.run' in AMPL to solve the instances.
