use io;

function input(){
    solFileName = "santa.out";
    inFileCost = "santa_cost.in";
    inFileSize ="santa_size.in";
    
    N_FAMILIES = 4;
    N_DAYS = 4;

    local inCost = io.openRead(inFileCost);
    local inSize = io.openRead(inFileSize);

    FAMILY_SIZE[i in 0..N_FAMILIES-1] = inSize.readInt();
    println(FAMILY_SIZE);

    for[i in 0..N_FAMILIES-1]{
        COST_MATRIX[i][d in 1..N_DAYS] = inCost.readInt();
    }    
    println(COST_MATRIX);

    MAX_OCCUPANCY = 1;
    MIN_OCCUPANCY = 0;
    
}

function model(){
    x[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] <- bool();
    N[d in 1..N_DAYS]<-sum[i in 0..N_FAMILIES-1](x[i][d]*FAMILY_SIZE[i]);
    N[N_DAYS+1]<-N[N_DAYS];

    for[i in 0..N_FAMILIES-1]{
        constraint sum[d in 1..N_DAYS](x[i][d]) == 1;
    }

    for[d in 1..N_DAYS]{
        constraint N[d] >= MIN_OCCUPANCY;
        constraint N[d] <= MAX_OCCUPANCY;
    }

    prefer_costs<-sum[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] (x[i][d]*COST_MATRIX[i][d]);
    minimize prefer_costs;
    /*
    accounting_penalty<- sum[d in 1..N_DAYS] ((N[d]-125)/400.0*pow(N[d],0.5+abs(N[d]-N[d+1])/50.0));
    minimize prefer_costs+accounting_penalty;
    */
		
}

function param(){
    if(lsTimeLimit == nil) lsTimeLimit = 20;
}

function output(){
    println(prefer_costs.value);
    /*println(accouting_penalty);*/
    local solFile = io.openWrite(solFileName);
    for[i in 0..N_FAMILIES-1][d in 1..N_DAYS]{
        if(x[i][d].value == 1){
            print(d+" ");
            solFile.print(d+" ");
        }
    }
    
}



