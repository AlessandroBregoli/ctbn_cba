subsamples=c(100,200,300)

print("quaternary data_01")
cardinality_data="quaternary_data_01"

datasets_path =c()
for(i in tail(args, -1)){
	datasets_path = c(datasets_path, paste("data/networks_and_trajectories_",cardinality_data,"_",i,".RData",sep=""))
}
