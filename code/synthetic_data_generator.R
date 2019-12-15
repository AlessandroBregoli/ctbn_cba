library(ctbn)
library(parallel)

generate_random_structure <- function(vars,p){
  variables = vars$Name
  from = c()
  to = c()
  for(x in 1:(length(variables))){
    for(y in 1:length(variables)){
      if(x == y)
        next()
      if(runif(1) < p){
        from =  c(from,variables[x])
        to = c(to,variables[y])
      }
    }
  }
  ret = data.frame(from,to,stringsAsFactors = FALSE)
  colnames(ret) = c("From","To")
  variables = unique(as.vector(as.matrix(ret)))
  return(list("struct"=ret,"variables"=vars[vars$Name %in% variables,]))
}

generate_random_structure_without_unidirected_edges <- function(vars,p){
  variables = vars$Name
  from = c()
  to = c()
  for(x in 1:(length(variables)-1)){
    for(y in (x+1):length(variables)){
      if(runif(1) < p){
        from =  c(from,variables[x])
        to = c(to,variables[y])
      }
      else if(runif(1) < p){
        from =  c(from,variables[y])
        to = c(to,variables[x])
      }
    }
  }
  ret = data.frame(from,to,stringsAsFactors = FALSE)
  colnames(ret) = c("From","To")
  variables = unique(as.vector(as.matrix(ret)))
  return(list("struct"=ret,"variables"=vars[vars$Name %in% variables,]))
}

#generate a single random cim dataframe for a binary variable
generate_rc <- function(min,max, value){
  random_list = c()
  for(x in 1:value){
    random_list = c(random_list,list(runif(value,min,max)))
  }
    
  ret = data.frame(random_list,row.names = 0:(value-1))
  colnames(ret)=0:(value-1)
  diag(ret) = 0
  diag(ret) = -rowSums(ret)
  return(ret)
}

generate_random_cim <- function(struct,vars,min,max){
  ret = list()
  variables = vars$Name
  for(x in variables){
    in_nodes = struct[struct["To"]==x,]["From"]
    ret[[x]] = list()
    if(nrow(in_nodes) == 0){
      ret[[x]][[x]] = generate_rc(min,max,vars[vars$Name==x,"Value"])
    }
    else{
      comb = list()
      for(y in in_nodes$From){
        comb = c(comb,list(0:(vars[vars$Name==y,"Value"]-1)))
      }
      comb = expand.grid(comb)
      for(c in 1:nrow(comb)){
        index=paste(in_nodes[1,],"=",comb[c,1],sep="")
        if(nrow(in_nodes) > 1){
          for(j in 2:nrow(in_nodes)){
            index=paste(index,",",in_nodes[j,],"=",comb[c,j],sep="")   
          }
        }
        ret[[x]][[index]] = generate_rc(min,max,vars[vars$Name==x,"Value"])
      }
    }
  }
  return(ret)
}

generate_samples <- function(vars,dyn.str,dyn.cims, nsample=1000, time_end=100){
  tmp_ctbn <- NewCtbn(vars)
  # Dynamic structure
  SetDynStruct(tmp_ctbn,dyn.str)
  SetDynIntMats(tmp_ctbn,dyn.cims)
  samplesFull <- SampleFullTrjs(tmp_ctbn,t.begin=0,t.end=time_end,num=nsample)
  tmp_ctbn <- DeleteCtbn(tmp_ctbn)
  garbage <- gc()
  return(samplesFull)
}

generate_networks_and_samples <- function(vars, n_iter,edge_prob=0.3,time_end=200, nsample=1500){
  ret = list()
  for(i in 1:n_iter){
    print(paste("Var",nrow(vars)," - ",i,"/",n_iter))
    repeat{
      tmp_str = try(generate_random_structure(vars,edge_prob))
      if(!is.character(tmp_str))
        if(nrow(tmp_str$variables) == nrow(vars))
          break
    }
    dyn.str = tmp_str$struct
    variables = tmp_str$variables
    tmp_str <- NULL
    dyn.cims = generate_random_cim(dyn.str,variables,1,5)
    samples = generate_samples(variables,dyn.str, dyn.cims, time_end = time_end, nsample=nsample)
    ret[[i]] = list(dyn.str=dyn.str, variables=variables, dyn.cims=dyn.cims, samples=samples)
  }

  return(ret)
}

generate_and_save <- function(data){
	vars = data[["vars"]]
	n_iter = data[["n_iter"]]
	edge_prob = data[["edge_prob"]]
	time_end=data[["time_end"]]
	nsample=data[["nsample"]]
	networks = generate_networks_and_samples(vars, n_iter, edge_prob, time_end, nsample)
	save(vars,networks, file=paste("data/networks_and_trajectories_var",nrow(vars),".RData",sep=""))
}

vars3_data = list(vars=data.frame("Name"=c("X","Y","Z"),"Value"=c(2,3,2),stringsAsFactors = FALSE),
		  n_iter=10,
		  edge_prob=0.3,
		  time_end=100,
		  nsample=1000)

vars4_data = list(vars=data.frame("Name"=c("X","Y","Z","Q"),"Value"=c(2,3,2,3),stringsAsFactors = FALSE),
		  n_iter=10,
		  edge_prob=0.3,
		  time_end=100,
		  nsample=1000)

vars5_data = list(vars=data.frame("Name"=c("X","Y","Z","Q","V"),"Value"=c(2,5,2,3,2),stringsAsFactors = FALSE),
		  n_iter=10,
		  edge_prob=0.3,
		  time_end=100,
		  nsample=1000)

vars6_data = list(vars=data.frame("Name"=c("X","Y","Z","Q","V","A"),"Value"=c(2,3,5,2,2,2),stringsAsFactors = FALSE),
		  n_iter=10,
		  edge_prob=0.3,
		  time_end=100,
		  nsample=1000)

vars10_data = list(vars=data.frame("Name"=c("X","Y","Z","Q","V","A","B","C","D","E"),"Value"=c(2,3,5,2,2,2,3,3,2,2),stringsAsFactors = FALSE),
		   n_iter=3,
		   edge_prob=0.2,
		   time_end=100,
		   nsample=1000)

vars15_data = list(vars=data.frame("Name"=c("X","Y","Z","Q","V","A","B","C","D","E","F","G","H","I","J"),"Value"=c(2,3,5,2,2,2,3,3,2,2,3,3,2,2,4),stringsAsFactors = FALSE),
		   n_iter=3,
		   edge_prob=0.2,
		   time_end=100,
		   nsample=1000)
vars20_data = list(vars=data.frame("Name"=c("X","Y","Z","Q","V","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O"),"Value"=c(2,3,5,2,2,2,3,3,2,2,2,3,5,2,2,2,3,3,2,2),stringsAsFactors = FALSE),
 		   n_iter=3,
		   edge_prob=0.2,
		   time_end=100,
		   nsample=1000)

vars50_data = list(vars=data.frame("Name"=c("X","Y","Z","Q","V","A","B","C","D","E",
					    "F","G","H","I","J","K","L","M","N","O",
					    "AX","AY","AZ","AQ","AV","AA","AB","AC","AD","AE",
					    "AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO",
					    "BX","BY","BZ","BQ","BV","BA","BB","BC","BD","BE"),
				   "Value"=c(2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2),stringsAsFactors = FALSE),
 		   n_iter=1,
		   edge_prob=0.2,
		   time_end=100,
		   nsample=1000)

vars100_data = list(vars=data.frame("Name"=c("X","Y","Z","Q","V","A","B","C","D","E",
					    "F","G","H","I","J","K","L","M","N","O",
					    "AX","AY","AZ","AQ","AV","AA","AB","AC","AD","AE",
					    "AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO",
					    "BX","BY","BZ","BQ","BV","BA","BB","BC","BD","BE",
					    "CX","CY","CZ","CQ","CV","CA","CB","CC","CD","CE",
					    "CF","CG","CH","CI","CJ","CK","CL","CM","CN","CO",
					    "CAX","CAY","CAZ","CAQ","CAV","CAA","CAB","CAC","CAD","CAE",
					    "CAF","CAG","CAH","CAI","CAJ","CAK","CAL","CAM","CAN","CAO",
					    "CBX","CBY","CBZ","CBQ","CBV","CBA","CBB","CBC","CBD","CBE"),
				   "Value"=c(2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2,
					     2,3,5,2,2,2,3,3,2,2),stringsAsFactors = FALSE),
 		   n_iter=1,
		   edge_prob=0.2,
		   time_end=100,
		   nsample=1000)

iter_list = list(vars3_data,
		 vars4_data,
		 vars5_data,
		 vars6_data,
		 vars10_data,
		 vars15_data,
		 vars20_data
		 )

mclapply(iter_list, generate_and_save, mc.cores=8)




