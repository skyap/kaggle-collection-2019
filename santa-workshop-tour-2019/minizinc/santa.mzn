include "globals.mzn"; 

int: n_family = 4;
int: n_days = 4;
int: n_choice = 3;
array [1..n_family] of int:n_people = [8,3,4,3];
array [1..n_family,1..n_choice] of int:choice = [|1,2,3|2,3,4|1,3,4|1,2,4|];
array [1..n_family] of var 1..n_days :family;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% between 125 and 300
constraint forall(i in 1..n_days)(daily_occupancy[i]<=1/\daily_occupancy[i]>=0); 
array[1..n_days] of var int: daily_occupancy = array1d(1..n_days,[count([family[i]| i in 1..n_family],j)|j in 1..n_days]); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% penalty of voucher
var int: penalty = sum(i in 1..n_family)( if family[i] == choice[i,1] then 0 
                                                elseif family[i] == choice[i,2] then 1*n_people[i] 
                                                elseif family[i] == choice[i,3] then 2*n_people[i] 
                                                else 3*n_people[i]
                                                endif);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% accounting cost    
                                          
% var float:accounting_cost = max(0.0,(obj2[4] - 125.0) / 400.0 * sqrt(obj2[4]));
% var int: today_count = 0;
% var int: different = 0;
% var int: yesterday_count = accounting_cost;
% constraint 
%       forall(i in 3..1)
%       (
%           today_count = obj2[i]
%           different = abs(today_count - yesterday_count)
%        );
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                     
                                             
                                         		
solve minimize  penalty;
output[show(family),show(penalty),show(daily_occupancy)];


