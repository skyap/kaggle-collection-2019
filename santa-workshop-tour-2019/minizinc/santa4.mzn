% https://github.com/hakank/hakank/blob/master/minizinc/gap.mzn

% number of agents 
int: m;

% number of jobs 
int: n;

% set of agents 
set of int: I = 1..m;

% set of jobs 
set of int: J = 1..n;

% cost of allocating job j to agent i 
array[I,J] of int: c;

% x[i,j] = 1 means job j is assigned to agent i 
array[I,J] of var 0..1: x;


% the objective is to find cheapest assignment (note that gap can also
% be formulated as maximization problem) 
var int: obj = sum(i in I, j in J) (c[i,j] * x[i,j]);
solve :: int_search( 
        [x[i,j] | i in I, j in J] ++ [obj] , 
        first_fail, indomain_min, complete)
    minimize obj;

constraint
  obj >= 0
  /\

  % job j must be assigned exactly to one agent 
  forall(j in J) (sum(i in I) (x[i,j]) = 1)

;

output [
  "\nobj: ", show(obj),  
];

%
% data
% 

% """
% These data correspond to the instance c515-1 (gap1) from:
%
%   I.H. Osman, "Heuristics for the Generalised Assignment Problem:
%   Simulated Annealing and Tabu Search Approaches", OR Spektrum, Volume
%   17, 211-225, 1995
%
%   D. Cattrysse, M. Salomon and L.N. Van Wassenhove, "A set partitioning
%   heuristic for the generalized assignment problem", European Journal
%   of Operational Research, Volume 72, 167-174, 1994 
%
% The optimal solution is 261 (minimization) or 336 (maximization) 
% """

m = 5000;

n = 5000;