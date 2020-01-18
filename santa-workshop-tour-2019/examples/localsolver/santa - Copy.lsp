use io;

function param(){
    if(lsTimeLimit == nil) lsTimeLimit = 8*3600;
}

function input(){
    solFileName = "santa.out";
    inFileCost = "santa_cost.in";
    inFileSize ="santa_size.in";
    inFileAccCost = "santa_acc_cost.in";
    
    N_FAMILIES = 5000;
    N_DAYS = 100;

    local inCost = io.openRead(inFileCost);
    local inSize = io.openRead(inFileSize);
    local inAccCost = io.openRead(inFileAccCost);

    FAMILY_SIZE[i in 0..N_FAMILIES-1] = inSize.readInt();
   /* println(FAMILY_SIZE);*/
    for[i in 0..N_FAMILIES-1]{
        COST_MATRIX[i][d in 1..N_DAYS] = inCost.readInt();
    }    

    for[i in 0..499]{
        ACC_COST_MATRIX[i][j in 0..499] = inAccCost.readDouble();
    }

    /*println(COST_MATRIX);*/

    MAX_OCCUPANCY = 300;
    MIN_OCCUPANCY = 125;
    
}

function model(){
    x[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] <- bool();
    N[d in 1..N_DAYS]<-sum[i in 0..N_FAMILIES-1](x[i][d]*FAMILY_SIZE[i]);
    N[N_DAYS+1]<-N[N_DAYS];

    for[i in 0..N_FAMILIES-1]{
        constraint sum[d in 1..N_DAYS](x[i][d]) == 1;
    }

    /*for[d in 1..N_DAYS]{
        constraint N[d] >= MIN_OCCUPANCY;
        constraint N[d] <= MAX_OCCUPANCY;
    }*/


    occupancy_costs<-sum[d in 1..N_DAYS](occ_cost(N[d]));
    prefer_costs<-sum[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] (x[i][d]*COST_MATRIX[i][d]);
    //accounting_penalty<- sum[d in 1..N_DAYS] ((N[d]-125)/400.0*pow(N[d],0.5+abs(N[d]-N[d+1])/50.0));
    accounting_penalty<- sum[d in 1..N_DAYS](ACC_COST_MATRIX[N[d]][abs(N[d]-N[d+1])]);
    minimize prefer_costs+accounting_penalty+occupancy_costs+occupancy_costs;
		
}
function occ_cost(x){
    return max(0,x-MAX_OCCUPANCY,MIN_OCCUPANCY-x)*1000;
}



function output(){

    println(prefer_costs.value);
    println(accounting_penalty.value);
    println(occupancy_costs.value);
    local solFile = io.openWrite(solFileName);
    for[i in 0..N_FAMILIES-1][d in 1..N_DAYS]{
        if(x[i][d].value == 1){
            //print(d+" ");
            solFile.print(d+" ");
        }
    }
    
}



