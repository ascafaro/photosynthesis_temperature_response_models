# photosynthesis_temperature_response_models
Models the response of net assimilation to rising leaf temperature
Instructions for running code for NCOMMS-22-43018

1.	Download and unzip the folder which contains this file. The folder also contains:
a)	The R code for model analysis and figure generation as a R. file named “NCOMMS-22-43018_code (see instruction below for running code).
b)	The Rubisco activation state temperature response curves compiled for the literature as an xlsx file named “activation state data”.
c)	The photosynthesis temperature response curves compiled from the literature as an xlsx file named “photosynthesis data”.
d)	The photosynthesis versus leaf temperature data from Lin et al. 2015 doi:10.1038/NCLIMATE2550 used to create the composite photosynthesis temperature response curve as a csv file named “composite data”.
e)	The photosynthesis temperature response curves from Slot & Winter (2017) doi:10.1111/nph.14469 relating to Panama tropical species and Supplementary Fig. 3 as a csv file named “Panama”.
f)	The expected increase in heatwave intensity with every degree of warming from Perkins-Kirkpatrick & Gibson 2017 doi:10.1038/s41598-017-12520-2 as a xlsx file named “heatwave data”.
g)	The Rubisco kinetics data from Orr et al.  2016 doi:10.1104/pp.16.00750 as an xlsx file named “Orr et al 2016 Rubisco data”.
2.	Have the latest R and RStudio installed on your computer
3.	Install the R packages “readxl” and “Metrix” using the RStudio Tools/Install Packages function from the CRAN Repository. Direct links to package downloads:
a)	https://github.com/mfrasco/Metrics 
b)	https://readxl.tidyverse.org, https://github.com/tidyverse/readxl
4.	Save and unzip the folder named “NCOMMS-22-43018” that contains this document. 
5.	Click and open the .R code file named “NCOMMS-22-43018_code” in RStudio or in the R console.
6.	Click on the source button in RStudio to run the entire code
7.	The code will generate and save in the same folder: 
a)	Figures 1 to 5 as pdf files matching the figures in the main text.
b)	a csv file called “individual species model fit” which will contain the information from the Ac with Rubisco deactivation model fit to each individual species tested.
c)	A pdf file named “supplementary figures” which will contain the four supplementary figures referred to in the main text.

System Requirements

•	Any computer which can run R computer language and RStudio with no non-standard hardware required.
•	R computer language can be downloaded from https://cran.r-project.org/mirrors.html and should only take minutes to download  
•	Software was run using R version 4.1.2 (2021-11-01) and RStudio 2021.09.2.
