subsamples=c(100,200,300)

print("quaternary data")
cardinality_data="quaternary_data"

datasets_path =c()
for(i in tail(args, -1)){
	datasets_path = c(datasets_path, paste("data/networks_and_trajectories_",cardinality_data,"_",i,".RData",sep=""))
}
