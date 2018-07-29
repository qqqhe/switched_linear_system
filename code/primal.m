%function primal
%
%The function calls solver Gurobi to solve a linear program and return the
%optimal value. 
%If the value is strictly less than 0, then the point is not an extreme
%point. Otherwise it is the extreme point and the optimal value is 1.
%For the detailed formulation, please refer to the website
% https://www.inf.ethz.ch/personal/fukudak/polyfaq/node22.html#polytope:Vredundancy


function [ objval_primal ] = primal(num_points_index, A, n, OptTol)  
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
    
    %Primal Method
    try
        clear model;
        model.A = GurobiLPModel_A;
        model.obj = GurobiLPModel_obj;
        model.rhs = GurobiLPModel_rhs;
        model.sense = '<';
        model.vtype = 'C';
        model.modelsense = 'max';
        %A variable with infinite upper and lower bounds is referred 
        %to as a free variable. Any bound larger than 1e30 is treated as infinite.
        model.lb = -1e31*ones(n+1,1);
        clear params;
        params.outputflag = 0;%No output, 1 by default
        params.resultfile = '';%No result file
        params.OptimalityTol = OptTol;%improve accuracy
        %params.NumericFocus = 3;
        params.presolve = 0;
        
        %solve by gurobi
        result = gurobi(model, params);
        
        %disp(result)
        
        %result.x  
        
        %fprintf('Obj: %e\n', result.objval);
    
    catch gurobiError
        fprintf('Error reported\n');
    end
    
    %if the LP is not solved, we simply return 1
    if (isfield(result, 'objval'))
        objval_primal = result.objval;
    else 
        objval_primal = 1;
    end
    
end

