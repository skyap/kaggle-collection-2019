use io;

function param(){
    // lsSeed = 9;
    // if(lsTimeLimit == nil) lsTimeLimit = 3*24*3600;

    
    // lsObjectiveThreshold = 68889;
    // lsObjectiveThreshold = 70000;

    // lsObjectiveThreshold = 70000;

    // try{
    //     inInit = io.openRead(inFileInitial);
    //     for[i in 0..458]{
    //         f = inInit.readInt();
    //         d = inInit.readInt();
    //         constraint x[f][d] == true;
    //         }
    // }   
    // catch(inInit){
    //     println("no input santa_first_choice.in");
    // }

    inFileInitial = "santa.out";
    for[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] x[i][d].value = 0;
    try{
        inInit = io.openRead(inFileInitial);
        for[i in 0..N_FAMILIES-1]{
            x[i][inInit.readInt()].value =  1;
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
    inFileAccCost = "santa_acc_cost_round.in";

    
    N_FAMILIES = 5000;
    N_DAYS = 100;
    MAX_OCCUPANCY = 300;
    MIN_OCCUPANCY = 125;
    OCC_PENALTY = 1;
    MIN_DIFF = 40;

    local inCost = io.openRead(inFileCost);
    local inSize = io.openRead(inFileSize);
    local inAccCost = io.openRead(inFileAccCost);
    

    FAMILY_SIZE[i in 0..N_FAMILIES-1] = inSize.readInt();
   /* println(FAMILY_SIZE);*/
    for[i in 0..N_FAMILIES-1]{
        COST_MATRIX[i][d in 1..N_DAYS] = inCost.readInt();
    }    

    for[i in 0..499]{
        // ACC_COST_MATRIX[i][j in 0..499] = inAccCost.readDouble();
        ACC_COST_MATRIX[i][j in 0..499] = inAccCost.readInt();

    }

    x[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] <- bool();
    // x[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] <- float(0,1);

    // inFileInitial = "santa_first_choice.in";
    // inInit = io.openRead(inFileInitial);
    // for[i in 0..874-1]{
    //     family_first_choice[i] = inInit.readInt();
    //     day_first_choice[i] = inInit.readInt();
    // }


    
}

function model(){
    // x[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] <- bool();
    N[d in 1..N_DAYS]<-sum[i in 0..N_FAMILIES-1](x[i][d]*FAMILY_SIZE[i]);
    N[N_DAYS+1]<-N[N_DAYS];


    // constraint N[100] == 125;
    // constraint N[99]==125;
    // constraint N[98]==125;
    // constraint N[97]==125;
    
    // constraint N[1]==300;
    // constraint N[2]==300;
    // constraint N[3]==300;
    // constraint N[4]==300;

    // for[d in 1..N_DAYS]{
    //     constraint abs(N[d]-N[d+1]) <= MIN_DIFF;
    // }

    // for[i in 0..874-1]{
    //     constraint x[family_first_choice[i]][day_first_choice[i]] == 1;
    // }


    for[i in 0..N_FAMILIES-1]{
        constraint sum[d in 1..N_DAYS](x[i][d]) == 1;
    }

    for[d in 1..N_DAYS]{
        constraint N[d] >= MIN_OCCUPANCY;
        constraint N[d] <= MAX_OCCUPANCY;
    }

    // constraint sum[d in 1..N_DAYS](ACC_COST_MATRIX[N[d]][abs(N[d]-N[d+1])]) <= 6000;

    prefer_costs<-sum[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] (x[i][d]*COST_MATRIX[i][d]);
    accounting_penalty<- sum[d in 1..N_DAYS](ACC_COST_MATRIX[N[d]][abs(N[d]-N[d+1])]);
    // accounting_penalty<- sum[d in 1..N_DAYS](abs(N[d]-N[d+1])*1000);
    // occupancy_costs<-(sum[d in 1..N_DAYS](occ_cost(N[d])))*OCC_PENALTY;


  
    // minimize prefer_costs;
    // minimize prefer_costs+occupancy_costs;
    // constraint occupancy_costs<threshold;
    // constraint prefer_costs<63000;
    // constraint accounting_penalty<6030;
    minimize prefer_costs+accounting_penalty;
    // minimize prefer_costs+accounting_penalty+occupancy_costs;
    
    // 62868.000000 6020.043432
     
		
}
function occ_cost(x){
    return max(0,x-MAX_OCCUPANCY,MIN_OCCUPANCY-x);
}

function output(){
    // iis = computeInconsistency();
    // println(iis);
    println("prefer_costs "+prefer_costs.value);
    try{

        println("accounting_penalty "+accounting_penalty.value);

    }
    catch(accounting_penalty){
        println("accounting_penalty not available");
    }
    try{
        println("occupancy_costs "+occupancy_costs.value);
    }
    catch(occupancy_costs){
        print("occupancy_costs not available");
    }

    local solFile = io.openWrite(solFileName);
    for[i in 0..N_FAMILIES-1][d in 1..N_DAYS]{
        if(x[i][d].value == 1){
            //print(d+" ");
            solFile.print(d+" ");
        }
    }
    // local proba = io.openWrite("proba.out");
    // for[i in 0..N_FAMILIES-1][d in 1..N_DAYS]{
    //     proba.print(x[i][d].value+" ");
    //     }

    
}



