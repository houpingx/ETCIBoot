-------------------
General Information
-------------------
This directory contains the data set and codes we used in the following paper: 
"Towards Confidence in the Truth: A Bootstrapping based Truth Discovery Approach"
Houping Xiao, Jing Gao, Qi Li, Fenglong Ma, Lu Su, Yunlong Feng, Aidong Zhang 

Any problem, please email: houpingx@buffalo.edu


-------------------
USAGE LICENSE:
-------------------
Please note that the data and codes are released as the way they are. The authors assume no responsibility for any potential problems. Permission to use the data and codes is granted for academic and education uses only. Please acknowledge the use of this package by citing the above paper if you publish materials based on the data and/or codes obtained from this package. The user may not redistribute any part of the package without separate permission.  


--------------------
Directory structure
--------------------

    ETCIBoot
    |-- ETCIBootV2.m             # Matlab codes for ETCIBoot method
	|-- run.m                    # Matlab codes to run ETCIBoot method on the Indoor Floorplan data set
    |-- step_dataset.txt         # the Indoor Floorplan data set
	|-- step_ground_truth.txt    # the corresponding ground truths for the Indoor Floorplan data set
	|-- MAD.m RMSE.m             # the used measures
    |-- README                   # this file


---------------------------------------------------
Detailed discription
---------------------------------------------------
1) data set file:
1.1) file name: step_dataset.txt
1.2) format of each line: "entry-id entry-value source-id\n". The delimiters are tabs. 
                          If two rows have same entry-id, they are describing on the same entry.
                          The entry-value is in meters.
                          If two rows have same source-id, they are from the same source.
1.3) Example: the top lines of file "step_dataset.txt":
14	8.45	1
15	5.85	1
16	11.7	1
17	15.6	1

2) ground truth files:
2.1) file name: step_ground_truth.txt
2.2) format of each line: "entry-id entry-value\n". The delimiters are tabs.
                          Each row has a unique entry-id.
                           The entry-value is in meters.
2.3) Example: the top lines of file "step_ground_truth.txt":
1	10.8
2	10.8
3	10.8
4	10.8
5	10.8
6	10.8

3) Matlab script:
3.1) file name: run.m
3.2) description:
     Run this script to conduct ETCIBoot method on the data set. 

4) Matlab functions:
4.1) ETCIBootV2.m
4.1.1) Input: 
            a. An array of the data. 
            b. Number of iterations.
			c. Significance level
4.1.2) Output:
            a. An array of aggregation results from ETCIBoot method. Format of each line: "entry-id | entry-value". 
            b. A matrix of source weights. Format of each line: "source-id | source-weight"
--------------------------------- END --------------------------------
