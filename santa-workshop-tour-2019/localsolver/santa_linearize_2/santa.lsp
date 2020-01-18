use io;

function param(){
    // lsSeed = 9;
    // if(lsTimeLimit == nil) lsTimeLimit = 200;
    // 62868.000000 6020.043432
    lsObjectiveThreshold = {63000,6030};
    // lsObjectiveThreshold = 6021;

    inFileInitial = "santa.out";
    for[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] x[i][d].value = 0;
    try{
        inInit = io.openRead(inFileInitial);
        for[i in 0..N_FAMILIES-1]{
            x[i][inInit.readInt()].value =  1;
            }
    }   
    catch(inInit){
        println("***********************");
        println("No Input File santa.out");
        println("***********************");
    }


    inFileOccInit = "santa_occ.out";
    for[i in 0..N_DAYS-1][u in 0..N_OCCUPANCY-1] y[i][u].value = 0;

    try{
        inInitOcc = io.openRead(inFileOccInit);
        for[ i in 0..N_DAYS-1]{
            N[i] = inInitOcc.readInt();
            y[i][N[i]-125].value = 1;
        }

    }   
    catch(inInitOcc){
        println("********************************");
        println("No Input File santa_init_occ.out");
        println("********************************");
    }

}

function input(){
    solFileName = "santa.out";
    inFileCost = "santa_cost.in";
    inFileSize ="santa_size.in";
    inFileAccCost = "santa_acc_cost_round.in";

    
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
        // ACC_COST_MATRIX[i][j in 0..N_OCCUPANCY-1] = inAccCost.readDouble();
        ACC_COST_MATRIX[i][j in 0..N_OCCUPANCY-1] = inAccCost.readInt();

    }


    // x[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] <- bool();
    x[i in 0..N_FAMILIES-1][d in 0..N_DAYS-1] <- bool();
    // y[i in 0..N_DAYS-1][u in 0..N_OCCUPANCY-1] <- bool();
    y[i in 0..N_DAYS-1][u in 0..N_OCCUPANCY-1] <- bool();
    y[N_DAYS]<-y[N_DAYS-1];

    N[d in 0..N_DAYS-1]<-sum[i in 0..N_FAMILIES-1](x[i][d]*FAMILY_SIZE[i]);
    N[N_DAYS]<-N[N_DAYS-1];

    local j =  MIN_OCCUPANCY;
    for[i in 0..N_OCCUPANCY-1]{
        c[i] = j;
        j+=1;
    }

    
}

function model(){

    // Objectives
    preference <- sum[i in 0..N_FAMILIES-1][d in 0..N_DAYS-1] (x[i][d]*COST_MATRIX[i][d]);

    // accounting <- sum[u in 0..N_OCCUPANCY-1](ACC_COST_MATRIX[u][u]*y[N_DAYS-1][u])+    
    //                 sum[d in 0..N_DAYS-2][u in 0..N_OCCUPANCY-1][v in 0..N_OCCUPANCY-1] (ACC_COST_MATRIX[u][v]*y[d][u]*y[d+1][v]);
    accounting <-  sum[d in 0..N_DAYS-1][u in 0..N_OCCUPANCY-1][v in 0..N_OCCUPANCY-1] (ACC_COST_MATRIX[u][v]*y[d][u]*y[d+1][v]);


    // 62868.000000 6020.043432
    // minimize preference+accounting;
    // minimize accounting+preference;
    // minimize preference;
   
    minimize preference;
    minimize accounting;
    // constraint accounting == 6020;
    constraint accounting<7000;
    constraint accounting>5000;
    // constraint preference>62867;
    // constraint accounting>6000;
    
    // minimize accounting;

    // Constraints
    // Real occupancy


    // Initial conditions
    // constraint N[N_DAYS-1] == 125;

    // Each occupany is limited
    // for[d in 0..N_DAYS-1]{
    //     constraint N[d] >= MIN_OCCUPANCY;
    //     constraint N[d] <= MAX_OCCUPANCY;
    // }

    // Each family only get one day

    for[i in 0..N_FAMILIES-1]{
        constraint sum[d in 0..N_DAYS-1](x[i][d]) == 1;
    }
    

    for[d in 0..N_DAYS-1]{
        // daily occupancy same as number of peoples choose the days
        y_sum_u <- sum[u in 0..N_OCCUPANCY-1](y[d][u]*c[u]);
        constraint y_sum_u == N[d];
        
        // every day have only one occupancy
        y_sum <- sum[u in 0..N_OCCUPANCY-1] (y[d][u]);
        constraint y_sum == 1;
    }


    // for[d in 0..N_DAYS-2]{
    //     y_sum_u <- sum[u in 0..N_OCCUPANCY-1] (y[d][u]*c[u]);
    //     y_sum_v <- sum[v in 0..N_OCCUPANCY-1] (y[d+1][v]*c[v]);
    //     constraint y_sum_u == N[d];
    //     constraint y_sum_v == N[d+1];
        // y_sum <- sum[v in 0..N_OCCUPANCY-1][u in 0..N_OCCUPANCY-1] (y[d][u]);
        // constraint y_sum == 1;

    // }

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
    local dayFile = io.openWrite("day.out");
    for[d in 0..N_DAYS]{

        dayFile.print(N[d]+" ");

    }
    // local proba = io.openWrite("proba.out");
    // for[i in 0..N_FAMILIES-1][d in 0..N_DAYS-1]{
    //     proba.print(x[i][d].value+" ");
    //     }

    
}



