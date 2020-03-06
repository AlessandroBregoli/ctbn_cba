subsamples=c(100,200,300)
datasets_path =c()
for(i in list(3,4,5,6,10,15)){
	datasets_path = c(datasets_path, paste("data/networks_and_trajectories_binary_data_",i,".RData",sep=""))
}

print("binary data")
cardinality_data="binary_data"
