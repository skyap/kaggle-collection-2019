include "globals.mzn"; 

int: n_family = 5000;
int: n_days = 100;
int: n_choice = 10;
array [1..n_family] of int:n_people;%= [8,3,4,3];
array [1..n_family,1..n_choice] of int:choice;%= [|1,2,3|4,3,2|1,4,3|4,2,1|];
array [1..n_family] of var 1..n_days :family;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% between 125 and 300
constraint forall(i in 1..n_days)(daily_occupancy[i]<=300/\daily_occupancy[i]>=200); 
array[1..n_days] of var 125..300: daily_occupancy = array1d(1..n_days,[count([family[i]| i in 1..n_family],j)|j in 1..n_days]); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% penalty of voucher
var int: penalty = sum(i in 1..n_family)( if family[i] == choice[i,1] then 0 
                                                elseif family[i] == choice[i,2] then 50
                                                elseif family[i] == choice[i,3] then 50+9*n_people[i] 
                                                elseif family[i] == choice[i,4] then 100+9*n_people[i] 
                                                elseif family[i] == choice[i,5] then 200+9*n_people[i] 
                                                elseif family[i] == choice[i,6] then 200+18*n_people[i] 
                                                elseif family[i] == choice[i,7] then 300+18*n_people[i] 
                                                elseif family[i] == choice[i,8] then 300+36*n_people[i] 
                                                elseif family[i] == choice[i,9] then 400+36*n_people[i] 
                                                elseif family[i] == choice[i,10] then 500+36*n_people[i] +199*n_people[i]
                                                else 500+36*n_people[i]+398*n_people[i]
                                                endif);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% accounting cost                                             

            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                     
                                           
                                         		
solve minimize  penalty;
output[show(family),show(penalty)];


