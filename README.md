# PECSim v1.02
Matlab based Software to simulate a photocathode based on a redox active polymer matrix.

This software can be used to simulate photoelectrodes based on redox-active films (mediated electron transfer). Different models can be 
selected under "Choose appropriate Model" or "Menu -> Model (Ctrl + M)". The simulation is only valid under various assumptions, please 
check the publication below (Open access) to find out if one of the models fit for your system. This paper could serve as a general 
literature citation when the PECSim software is employed for the simulation of redox active film based biophotoelectrodes:

Buesen, D.; Hoefer, T.; Zhang, H.; Plumere, N. A Kinetic Model for Redox-Active Film Based Biophotoelectrodes. Faraday Discuss. 2019. 
https://doi.org/10.1039/C8FD00168E.

In the Source code, which was developed at an earlier stage some notations were different compared to the final publication. The following 
list compares all important indices between source code and publication:

Name        | publication | source code

Mediator    | M           | M; M //
Catalyst    | P           | E //
1st species | Y (red/ox)  | S1; SP1 //
2nd species | Z (red/ox)  | S2; SP2 //
Theta_MM    | theta_MM    | theta //
Theta_MP    | theta_MP    | theta_bi //
kappa_bi    | kappa_bi    | kappa_SV //
