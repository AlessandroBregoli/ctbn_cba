# Constraint-based Learning for Continuous-Time Bayesian Network

## Dependencies

During this project we used both R and python.

### R dependencies

- [CTBN-RLE](http://rlair.cs.ucr.edu/ctbnrle/Rinterface/)
- [jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html)
- [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)

### Python3 dependencies:

- [dvc](https://dvc.org/)
- [numpy](https://numpy.org/)
- [pandas](https://pandas.pydata.org/)
- [scipy](https://www.scipy.org/)
- [tqdm](https://pypi.org/project/tqdm/)


## DVC

We decided to use the Data Version Control (dvc) software in order to define
a pipeline for each experiment. 

"_DVC is built to make ML models shareable and reproducible._ 
_It is designed to handle large files, data sets, machine learning models,_ 
_and metrics as well as code._" [dvc.org](https://dvc.org/)


## Dataset

We have generated  datasets combining the following parameters:

- Number of nodes: 3,4,5,6,10,15,20
- Network density: 0.1,0.2,0.3
- Node cardinality: 2,3
- Time end:100
- Number of trajectories: 100,200,300

## Reproduce the experiments

During our research we developed and tested multiple algorithms but, for brevity, we decided
to present only the best two:

- ![CTPC{\chi ^2}](https://render.githubusercontent.com/render/math?math=CTPC_%7B%5Cchi%20%5E2%7D)
- ![CTPC{KS}](https://render.githubusercontent.com/render/math?math=CTPC_%7BKS%7D)

We assess the performance of this two algorithms against that of the score-based algorithm implemented
in the CTBN-RLE library.

In order to reproduce the experiments the following commands must be executed.

### ![CTPC{\chi ^2}](https://render.githubusercontent.com/render/math?math=CTPC_%7B%5Cchi%20%5E2%7D)

- `dvc repro algo_dvc_files/exp_and_chi2_test_pc_based_algo/exp_and_chi2_test_pc_based_algo_binary_01.dvc`
- `dvc repro algo_dvc_files/exp_and_chi2_test_pc_based_algo/exp_and_chi2_test_pc_based_algo_binary_02.dvc`
- `dvc repro algo_dvc_files/exp_and_chi2_test_pc_based_algo/exp_and_chi2_test_pc_based_algo_binary.dvc`
- `dvc repro algo_dvc_files/exp_and_chi2_test_pc_based_algo/exp_and_chi2_test_pc_based_algo_ternary_01.dvc`
- `dvc repro algo_dvc_files/exp_and_chi2_test_pc_based_algo/exp_and_chi2_test_pc_based_algo_ternary_02.dvc`
- `dvc repro algo_dvc_files/exp_and_chi2_test_pc_based_algo/exp_and_chi2_test_pc_based_algo_ternary.dvc`

### ![CTPC{KS}](https://render.githubusercontent.com/render/math?math=CTPC_%7BKS%7D)

- `dvc repro algo_dvc_files/exp_and_ks_test_pc_based_algo/exp_and_ks_test_pc_based_algo_binary_01.dvc`
- `dvc repro algo_dvc_files/exp_and_ks_test_pc_based_algo/exp_and_ks_test_pc_based_algo_binary_02.dvc`
- `dvc repro algo_dvc_files/exp_and_ks_test_pc_based_algo/exp_and_ks_test_pc_based_algo_binary.dvc`
- `dvc repro algo_dvc_files/exp_and_ks_test_pc_based_algo/exp_and_ks_test_pc_based_algo_ternary_01.dvc`
- `dvc repro algo_dvc_files/exp_and_ks_test_pc_based_algo/exp_and_ks_test_pc_based_algo_ternary_02.dvc`
- `dvc repro algo_dvc_files/exp_and_ks_test_pc_based_algo/exp_and_ks_test_pc_based_algo_ternary.dvc`

### Score based

- `dvc repro algo_dvc_files/score_based/score_based_binary_01.dvc`
- `dvc repro algo_dvc_files/score_based/score_based_binary_02.dvc`
- `dvc repro algo_dvc_files/score_based/score_based_binary.dvc`
- `dvc repro algo_dvc_files/score_based/score_based_ternary_01.dvc`
- `dvc repro algo_dvc_files/score_based/score_based_ternary_02.dvc`
- `dvc repro algo_dvc_files/score_based/score_based_ternary.dvc`


## Results

All the results can be retrived in the _metrics_ folder in json format.
