%function dual
%
%The function calls solver Gurobi to solve a linear program and return the
%optimal value. 
%If the value is strictly less than 0, then the point is not an extreme
%point. Otherwise it is the extreme point and the optimal value is 1.
%For the detailed formulation, please refer to the website
% https://www.inf.ethz.ch/personal/fukudak/polyfaq/node22.html#polytope:Vredundancy
%
% This function essentially solve the dual of the above LP.

function [ objval_dual ] = dual( num_points_index, A, n ,OptTol)
    %Arguments
    %num_points_index: index of the point that will be examined
    %A: a matrix that stores the coordinates of points in each row
    %n: dimension of the points
    %OptTol: torlerence of the solver
    
    %set parameters    
    [row_A, col_A] = size(A);    
    GurobiLPModel_A = sparse(A);
    GurobiLPModel_rhs = zeros(row_A,1);
    GurobiLPModel_rhs(num_points_index) = 1;
    GurobiLPModel_obj = A(num_points_index,:);
    
    %Dual Method
    try
        clear model;
        model.A = GurobiLPModel_A';
        model.obj = GurobiLPModel_rhs;
        model.rhs = GurobiLPModel_obj;
        model.sense = '=';
        model.vtype = 'C';
        model.modelsense = 'min';
        %By default, the variables are non-negative
        
        clear params;
        params.outputflag = 0;%No output, 1 by default
        params.resultfile = '';%No result file
        params.OptimalityTol = OptTol;%Improve accuracy
        
        %solve the LP by gurobi
        result = gurobi(model, params);
        
        %disp(result)
        
        %result.x  
        
        %fprintf('Obj: %e\n', result.objval);
    
    catch gurobiError
        fprintf('Error reported\n');
    end
    
    %if the LP is not solved, we simply return 1
    if (isfield(result, 'objval'))
        objval_dual = result.objval;
    else 
        objval_dual = 1;
    end

end

