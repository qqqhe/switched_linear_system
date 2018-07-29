% 
   %  File: forward_dynamic_programming.m
   % 
   %  Author :   Zeyang Wu
   %  Date   :   2018-06-25
   % 
   %  Project : Switch Linear Systems
   %   
   %  Description :  
   %                     
   %    1) The script is a subroutine in the script 
   %             gen_instance_and_solve_by_FDP
   %       It will solve the instance generated in that script by forward
   %       dynamic programming. 
   %    
   %    2) To run the FDP separately, the following parameters need to be
   %    specified:
   %        n - the dimension of the problem
   %        m - the number of matrices
   %        Drug{i} - the m n-by-n matrices
   %        x0 - an initial n-by-1 vector 
   %        time_Limit_For_FDP - time limit
   % 
   %    How to run the script:
   %        specify the parameters above
   %        gen_instance_and_solve_by_FDP
% 



Number_of_Vertices = zeros(K,1);   
Number_of_Vertices(1) = 0;

tic

%This parameter is used to generate enough points for building a
%full-dimensional polytope. 
K_initial = 4;

%When n > 5, our algorithm employs Matlab’s build-in function convhulln to
%construct the set of extreme points directly. When n <= 6, our algorithm
%solves a linear program with the commercial solver Gurobi to identify each
%extreme point. 

if n > 5
    %Generate certain number of points     
    Vertice_Coordinate = x0;
    for  K_index = 1:K_initial
        Vertex_temp = Candidate_Vertex_Coordinates;
        Candidate_Vertex_Coordinates = Drugs{1} * Candidate_Vertex_Coordinates;
        for m_temp = 2 : m
            Candidate_Vertex_Coordinates = [Candidate_Vertex_Coordinates,Drugs{m_temp}*Vertex_temp];
        end
    end
    
    %Solves a linear program with the commercial solver Gurobi to identify
    %each extreme points
    for K_index = K_initial + 1: K      
        Vertex_temp = Candidate_Vertex_Coordinates;
        Candidate_Vertex_Coordinates = Drugs{1}*Candidate_Vertex_Coordinates;

        for m_temp = 2 : m
            Candidate_Vertex_Coordinates = [Candidate_Vertex_Coordinates,Drugs{m_temp}*Vertex_temp];
        end


        A = Candidate_Vertex_Coordinates';
        [row_A, col_A] = size(A); 
        A = [A,-ones(row_A,1)];
        num_points_index = 1;

        for Iteration_Index = 1:row_A
            if num_points_index > size(A,1)
                break;
            end

            %use Primal Method to verify whether a point is extreme point
            v1 = primal(num_points_index, A, n, 1e-5);
            %use Dual Method to verify whether a point is extreme point
            %v2 = dual(num_points_index, A, n, 1e-5);

            %if (v1 < 0.9 && v2 <0.9)
            if (v1 < 0.9)
                A = [A(1:num_points_index-1,:);A(num_points_index+1:size(A,1),:)];
                num_points_index = num_points_index - 1;
            end    
            num_points_index = num_points_index + 1;

            if toc > time_Limit_For_SCH
                %fprintf('SCH is terminated due to time limit. \n');
                break;
            end
        end

        %Return new vertices to X4Vertices
        Number_of_Vertices(K_index) = size(A,1);
        Candidate_Vertex_Coordinates = A(:,1:n)';
    end    
else
    %If the dimension n < 8, we use buildin function 
    Candidate_Vertex_Coordinates = x0;
    for  K_index = 1:K_initial
        Vertex_temp = Candidate_Vertex_Coordinates;
        Candidate_Vertex_Coordinates = Drugs{1}*Candidate_Vertex_Coordinates;
        for m_temp = 2 : m
        Candidate_Vertex_Coordinates = [Candidate_Vertex_Coordinates,Drugs{m_temp}*Vertex_temp];
        end
    end
    
    Convexhull_Facet_Order = convhulln(Candidate_Vertex_Coordinates');
    Convexhull_Vertex_Order = unique(Convexhull_Facet_Order)';
    Candidate_Vertex_Coordinates = Candidate_Vertex_Coordinates(:,Convexhull_Vertex_Order);
    Number_of_Vertices(K_index) = size(Convexhull_Vertex_Order,2);

    for K_index = K_initial+1:K
        Vertex_temp = Candidate_Vertex_Coordinates;
        Candidate_Vertex_Coordinates = Drugs{1}*Candidate_Vertex_Coordinates;
        for m_temp = 2 : m
        Candidate_Vertex_Coordinates = [Candidate_Vertex_Coordinates,Drugs{m_temp}*Vertex_temp];
        end
        Convexhull_Facet_Order = convhulln(Candidate_Vertex_Coordinates', {'Qt','QbB'});

        Convexhull_Vertex_Order = unique(Convexhull_Facet_Order)';
        Candidate_Vertex_Coordinates = Candidate_Vertex_Coordinates(:,Convexhull_Vertex_Order);
        Number_of_Vertices(K_index) = size(Convexhull_Vertex_Order,2);
        
        if toc > time_Limit_For_FDP
            %fprintf('FDP is terminated due to time limit. \n');
            break;
        end
    end
end


res = 0;
for index = 1 : Number_of_Vertices(K) 
    b = Candidate_Vertex_Coordinates(:, index)';
    res = max(res, b * b');
end

res % output result
toc % record time














