# Optimal_Control_in_CRNs
Demo code for paper "Geometry of optimal control in chemical reaction networks in the adiabatic limit"
https://arxiv.org/abs/2407.05620

If you have any questions, feel free to contact me at yikuanzhang@outlook.com
## Usage

Requirments: Matlab R2021b; ICLOSC2.5;

Here is the instruction to install ICLOCS2.5 in PC: http://www.ee.ic.ac.uk/ICLOCS/default.htm 

* Clone, Setup project on your PC
  ```
  $ git clone https://github.com/Yikuan-PKU/Optimal_Control_in_CRNs.git
  ```
  ```
  $ bash requirements.sh
  ```
  It should take several minites to finish all installation.
   
## Run Demo in Each Subfolders for Figures Shown in the Paper


 * To get the figures related to the three state model, simply type:  
    ```
    $ cd ./Three_state
    ```
    To get the figures of 4 Phases of optimal protocols (together with the FIG. 2(b-c)) for 3_state model in the adiabatic limit (one can change "para" for results with different parameters), simply type
    ```
    $ matlab -batch main.m && Plot4Phases.mlx
    ```
    To get the figures of optimal protocols for 3_state model in finite control time (one can change "para" for results with different parameters), simply type
    ```
    $ matlab -batch Plot_finite_time.m 
    ```

 
 * To get the figures related to the two state model, simply type:
    ```
    $ cd ./Two_state
    ```
    To get the figures of optimal protocols for 2_state model (one can change "para" for results with different parameters), simply type
    ```
    $ matlab -batch main_twostate.m 
    ```
    To get the figures in FIG. S1 (one can change "para" for results with different parameters), simply type
    ```
    $ matlab -batch acn.m 
    ```
 
 
 * To get the figures related to the corepressor model, simply type:
    ```
    $ cd ./Corepressor
    ```
    To get the figures related to the original corepressor model, simply type:
    ```
    $ cd ./Original
    ```
    ```
    $ matlab -batch costPlot.mlx && main.mlx
    ```
    To get the figures related to the direct transport model, simply type:
    ```
    $ cd ./DirectTransport
    ```
    ```
    $ matlab -batch costPlot.mlx 
    ```
 * To get the figures related to the Phase Diagram, simply type:
    ```
    $ cd ./PhaseDiagram
    ```
    Before plotting the Phase Diagram, get the data for the ensemble comprising the Phase Diagram:
    ```
    $ cd ./Get_Data
    ```
    ```
    $ matlab -batch PhaseData.m
    ```
    Then, transfer the generated data file "PhaseData.mat" into the folder "PhasePlt". Get into this folder and plot,
    ```
    $ cd ./PhasePlt
    ```
    ```
    $ matlab -batch PhasePlot.m && PhasePlot_simplified.m
    ```

 * To get the FIG. S3, simply type:

    ```
    $ matlab -batch ./PhaseDiagram/PhasePlt/BoundPlot.mlx
    ```
   
   
