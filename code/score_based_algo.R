library(ctbn)
source("code/experiment_utils.R")

score_based <- function(samples,variables){
    tmp_ctbn = NewCtbn(variables)
    LearnCtbnStruct(tmp_ctbn,samples)
    score.learned.dyn.str = GetDynStruct(tmp_ctbn)
    tmp_ctbn <- DeleteCtbn(tmp_ctbn)
    garbage <- gc()
    return(score.learned.dyn.str)
}


datasets_path =c()
for(i in list(3,4,5,6,10,15,20)){
	datasets_path = c(datasets_path, paste("data/networks_and_trajectories_binary_data_",i,".RData",sep=""))
}

print("binary data")
algo_experiments(datasets_path, score_based,"score_based","binary_data")

datasets_path =c()
for(i in list(3,4,5,6,10,15)){
	datasets_path = c(datasets_path, paste("data/networks_and_trajectories_ternary_data_",i,".RData",sep=""))
}


print("ternary data")
algo_experiments(datasets_path, score_based,"score_based","ternary_data")

