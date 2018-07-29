# Optimal Switching Sequence for Switched Linear System

Test instances and code for finding the optimal switching sequence of a switched linear system

For more details, please refer to the following working paper:

Wu, Zeyang, and Qie He. "Optimal switching sequence for switched linear systems." arXiv preprint arXiv:1805.04677 (2018).

## Overview

This directory contains code for the forward dynamic programming algorithm (FDP) described in the paper above. The code is written in Matlab. You can use it to generate instances of specified parameters and solve them by FDP. We also provide an AMPL script to solve the instances with a global optimization solver Baron. 

## How to run the code

The script 'gen_instance_and_solve_by_FDP.m' generates all the test instances and then solves them with FDP. The test results will be stored in the *.dat files. 

1. There are 10 combinations of parameters. For each combination, the script generates 10 random instances.
2. There is a time limit of 600s to run FDP for each instance.


In the Matlab command line, simply run 
    
    $gen_instance_and_solve_by_FDP


To solve the instances by AMPL, please first run 
    
    $gen_instances_ampl.m

in Matlab to generate *.dat files for AMPL and then run 'switched_system_baron.run' in AMPL to solve the instances.
