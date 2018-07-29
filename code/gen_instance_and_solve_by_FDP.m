% 
   %  File:   gen_instance_and_solve_by_FDP.m
   % 
   %  Author :   Qie He
   %  Date    :   2018-06-25
   % 
   %  Project : Switch Linear Systems
   %   
   %  Description :  
   %                     
   %    1) The script generates test instances for the optimal switching
   %    sequence problem. The element initial vector is uniformly 
   %    distributed between 0 and 1. Each element of the matrices is 
   %    uniformly distributed between -1 and 1. Then the instances are 
   %    solved by the forward dynamic programming (FDP) in the paper.
   %    
   %    2) The results is stored in a .txt file in the current directory. 
   %       The AMPL instance data file will be stored as some *.dat file in 
   %       the instances folder. After execution, we can use AMPL script 
   %              switched_system_baron
   %       to solve the instances by Baron in AMPL. 
   %
   %    3) Parameters: 
   %        instance_size_pair contains triplets of the size of instances.
   %        (n,m,K): n - dimension of the problem
   %                 m - number of matrices in the set
   %                 K - number of the planning horizon
   %        
   %        num_instances: number of instances will be generated for each
   %        size pair. 
   %        
   %        time_Limit_For_FDP: The time limit for the FDP algorithm. 
   % 
   %    How to run the script:
   %    There should be a folder named instances in the current directory.
   %    Run the script directly in the Matlab command line.
   %        gen_instance_and_solve_by_FDP
   %    
   % 
% 


rng(1); % set seed

num_instances = 10;
% instance size pair, each row represents an (n,m,K)-configuration
instance_size_pair = ...
[2, 2, 20;
 2, 2, 50;
 2, 2, 500;
 2, 5, 500; 
 2, 10, 500; 
 5, 2, 100;
 5, 5, 100;
 5, 10, 100;
 8, 2, 50;
 10, 2, 20];

time_Limit_For_FDP = 600; %time limit

instance_ampl_dir = '.\instances\';

% Generate a string of instance list for the AMPL script "switched_system_baron.run"
string_instances = '{';

Result_FDP_fileID = fopen('.\Result_FDP.txt', 'w');

for i = 1:size(instance_size_pair,1)
            n = instance_size_pair(i, 1);
            m = instance_size_pair(i, 2);
            K = instance_size_pair(i, 3);
            for index_instance = 1 : num_instances
                filename = strcat('n', num2str(n), '_m', num2str(m), '_K', num2str(K), '_', num2str(index_instance));
                
                string_instances = strcat(string_instances, '"', filename, '", ');   
                
                filename_ampl = strcat(instance_ampl_dir, filename, '.dat');
                fileID = fopen(filename_ampl, 'w');
                fprintf(fileID, 'param n := %d;\n\n', n);
                fprintf(fileID, 'param m := %d;\n\n', m);
                fprintf(fileID, 'param K := %d;\n\n', K);
                row_indices = [1:n];
                a = rand(1,n);
                init_vec = [row_indices; a];            
                fprintf(fileID, 'param a :=\n');
                fprintf(fileID, '%d \t %f\n', init_vec);
                fprintf(fileID, ';');
                
                
                x0 = a'; % set initial vector for FDP
                
                fprintf(fileID, '\n param A :=\n');
                for l = 1:m
                    matrix = 2*rand(n)-1; % Generate a random matrix whose elements are in [0,1]
                    Drugs{l} = matrix;
                    fprintf(fileID, '[%d, *, *]:  ', l);
                    for col_index = 1:n
                        fprintf(fileID, '%d\t', col_index);
                    end
                    fprintf(fileID, ':=\n');
                    for row_index = 1:n
                        fprintf(fileID, '%d\t', row_index);
                        for col_index = 1:n
                            fprintf(fileID, '%f\t', matrix(row_index, col_index));
                        end
                        fprintf(fileID, '\n');
                    end
                    if l < m
                        fprintf(fileID, '\n');
                    end
                end
                tic;
                
                fprintf(fileID, ';\n');      
                
                %The instance is solved by Algorithm 1 in the paper.
                forward_dynamic_programming;
                %Record the result of Algorithm 1 and save it to the end of
                %the file. 
                fprintf(Result_FDP_fileID, filename);
                fprintf(Result_FDP_fileID, '\n');
                if toc > time_Limit_For_FDP
                    fprintf(Result_FDP_fileID, 'result = Limit \n');
                else 
                    fprintf(Result_FDP_fileID, 'result = Optimal \n');
                end
                
                fprintf(Result_FDP_fileID, 'time: %f \n', toc);
                fprintf(Result_FDP_fileID, 'objective: %f \n \n', res);
                
                
                fclose(fileID);
            end
end

%store the instances information for AMPL script.
fileID = fopen(strcat(instance_ampl_dir, 'instance_string.txt'), 'w');
fprintf(fileID, '%s', string_instances);
fclose(fileID);     

                
