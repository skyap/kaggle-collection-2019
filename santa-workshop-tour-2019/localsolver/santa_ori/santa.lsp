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

    x[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] <- bool();


    MAX_OCCUPANCY = 300;
    MIN_OCCUPANCY = 125;
    OCC_PENALTY = 50;
    
}

function model(){
    // x[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] <- bool();
    N[d in 1..N_DAYS]<-sum[i in 0..N_FAMILIES-1](x[i][d]*FAMILY_SIZE[i]);
    N[N_DAYS+1]<-N[N_DAYS];

    // constraint N[N_DAYS+1] == 300;

    for[i in 0..N_FAMILIES-1]{
        constraint sum[d in 1..N_DAYS](x[i][d]) == 1;
    }

    /*for[d in 1..N_DAYS]{
        constraint N[d] >= MIN_OCCUPANCY;
        constraint N[d] <= MAX_OCCUPANCY;
    }*/

    prefer_costs<-sum[i in 0.. N_FAMILIES-1][d in 1..N_DAYS] (x[i][d]*COST_MATRIX[i][d]);
    accounting_penalty<- sum[d in 1..N_DAYS](ACC_COST_MATRIX[N[d]][abs(N[d]-N[d+1])]);
    occupancy_costs<-sum[d in 1..N_DAYS](occ_cost(N[d]));


  
    // minimize prefer_costs;
    // minimize prefer_costs+occupancy_costs;
    // minimize prefer_costs+accounting_penalty;
    minimize prefer_costs+accounting_penalty+occupancy_costs;
    
     
		
}
function occ_cost(x){
    return max(0,x-MAX_OCCUPANCY,MIN_OCCUPANCY-x)*OCC_PENALTY;
}

function output(){
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
    
}



