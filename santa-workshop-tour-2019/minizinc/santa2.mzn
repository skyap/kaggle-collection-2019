include "globals.mzn"; 

int: n_family = 5000;
int: n_days = 100;
int: n_choice = 10;
array [1..n_family] of int:n_people;%= [8,3,4,3];
array [1..n_family,1..n_choice] of int:choice;%= [|1,2,3|4,3,2|1,4,3|4,2,1|];
array [1..n_family] of var 1..n_days :family;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% between 125 and 300
constraint forall(i in 1..n_days)(daily_occupancy[i]<=300/\daily_occupancy[i]>=125); 
array[1..n_days] of var 125..300: daily_occupancy = array1d(1..n_days,[count([family[i]| i in 1..n_family],j)|j in 1..n_days]); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% penalty of voucher
var 0..11615302: penalty = sum(i in 1..n_family)( if family[i] == choice[i,1] then 0 
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
                                          
array[1..n_days] of var 0..3032: accounting_cost;
array[1..n_days] of var 0.5..3.5:temp;
array[1..n_days] of var 0.0..300.0:temp2;
constraint 
      forall(i in 1..n_days)
      (     
      if i == 1 then accounting_cost[(n_days+1)-i] = max([0.0,(daily_occupancy[(n_days+1)-i] - 125.0)  * sqrt(daily_occupancy[(n_days+1)-i])]) 
      else
      temp[(n_days+1)-i] = 0.5+abs(daily_occupancy[(n_days+1)-i] - daily_occupancy[(n_days+1)-i+1])/50.0/\
      temp2[(n_days+1)-i] = daily_occupancy[(n_days+1)-i]/\
      accounting_cost[(n_days+1)-i] =  max([0.0,(daily_occupancy[(n_days+1)-i] - 125.0)  * (temp2[(n_days+1)-i]*temp[(n_days+1)-i])]) 
      endif
       );
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                     
                                           
                                         		
solve minimize  penalty+sum(i in 1..n_days)(accounting_cost[i]/400.0);
output[show(family),show(penalty),show(daily_occupancy),show(penalty+sum(i in 1..n_days)(accounting_cost[i]/400.0))];


