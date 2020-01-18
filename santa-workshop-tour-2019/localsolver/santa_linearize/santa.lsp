use io;

function param(){
    lsSeed = 9;
    if(lsTimeLimit == nil) lsTimeLimit = 200;

    inFileInitial = "santa.out";
    
    try{
        inInit = io.openRead(inFileInitial);
        for[i in 0..N_FAMILIES-1]{
            x[i][inInit.readInt()].value =  true;
            }
    }   
    catch(inInit){
        println("No Input File santa.out");
    }

}

function input(){
    solFileName = "santa.out";
    inFileCost = "santa_cost.in";
    inFileSize ="santa_size.in";
    inFileAccCost = "santa_acc_cost.in";

    
    N_FAMILIES = 5000;
    N_DAYS = 100;
    MAX_OCCUPANCY = 300;
    MIN_OCCUPANCY = 125;
    //  176 - (175-300)
    N_OCCUPANCY = MAX_OCCUPANCY-MIN_OCCUPANCY+1;
    // N_OCCUPANCY = 176;
    OCC_PENALTY = 100;
    MIN_DIFF = 40;

    local inCost = io.openRead(inFileCost);
    local inSize = io.openRead(inFileSize);
    local inAccCost = io.openRead(inFileAccCost);
    

    FAMILY_SIZE[i in 0..N_FAMILIES-1] = inSize.readInt();

    for[i in 0..N_FAMILIES-1]{
        COST_MATRIX[i][d in 0..N_DAYS-1] = inCost.readInt();
    }    

    for[i in 0..N_OCCUPANCY-1]{
        ACC_COST_MATRIX[i][j in 0..N_OCCUPANCY-1] = inAccCost.readDouble();
    }

    // x[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] <- bool();
    x[i in 0..N_FAMILIES-1][d in 0..N_DAYS-1] <- bool();
    y[i in 0..N_DAYS-1][u in 0..N_OCCUPANCY-1][v in 0..N_OCCUPANCY-1] <- bool();

    local j =  MIN_OCCUPANCY;
    for[i in 0..N_OCCUPANCY-1]{
        c[i] = j;
        j+=1;
    }

    
}

function model(){

    // Objectives
    preference <- sum[i in 0..N_FAMILIES-1][d in 0..N_DAYS-1] (x[i][d]*COST_MATRIX[i][d]);
    accounting <- sum[d in 0..N_DAYS-1][u in 0..N_OCCUPANCY-1][v in 0..N_OCCUPANCY-1] (ACC_COST_MATRIX[u][v]*y[d][u][v]);

    minimize preference;
    minimize accounting;

    // Constraints
    // Real occupancy
    N[d in 0..N_DAYS-1]<-sum[i in 0..N_FAMILIES-1](x[i][d]*FAMILY_SIZE[i]);
    N[N_DAYS]<-N[N_DAYS-1];

    // Initial conditions
    // constraint N[N_DAYS-1] == 125;

    // Each occupany is limited
    for[d in 0..N_DAYS-1]{
        constraint N[d] >= MIN_OCCUPANCY;
        constraint N[d] <= MAX_OCCUPANCY;
    }

    // Each family only get one day

    for[i in 0..N_FAMILIES-1]{
        constraint sum[d in 0..N_DAYS-1](x[i][d]) == 1;
    }

    for[d in 0..N_DAYS-1]{
        y_sum_u <- sum[v in 0..N_OCCUPANCY-1][u in 0..N_OCCUPANCY-1] (y[d][u][v]*c[u]);
        y_sum_v <- sum[v in 0..N_OCCUPANCY-1][u in 0..N_OCCUPANCY-1] (y[d][u][v]*c[v]);
        constraint y_sum_u == N[d];
        constraint y_sum_v == N[d+1];
        // y_sum <- sum[v in 0..N_OCCUPANCY-1][u in 0..N_OCCUPANCY-1] (y[d][u][v]);
        // constraint y_sum == 1;

    }

    // for[d in 0..N_DAYS-2][t in 0..N_OCCUPANCY-1]{
    //     y_sum_u <- sum[u in 0..N_OCCUPANCY-1] (y[d][u][t]);
    //     y_sum_v <- sum[v in 0..N_OCCUPANCY-1] (y[d+1][t][v]);
    //     constraint y_sum_u == y_sum_v;
    // }
    
   
		
}


function output(){
    try{
        println("preference "+preference.value);
    }
    catch(preference){
        println("preference not available");
    }
    
    try{

        println("accounting "+accounting.value);

    }
    catch(accounting){
        println("accounting not available");
    }


    local solFile = io.openWrite(solFileName);
    for[i in 0..N_FAMILIES-1][d in 0..N_DAYS-1]{
        if(x[i][d].value == 1){
            //print(d+" ");
            solFile.print(d+" ");
        }
    }
    // local proba = io.openWrite("proba.out");
    // for[i in 0..N_FAMILIES-1][d in 0..N_DAYS-1]{
    //     proba.print(x[i][d].value+" ");
    //     }

    
}



