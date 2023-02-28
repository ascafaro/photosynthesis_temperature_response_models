# photosynthesis_temperature_response_models
Models the response of net assimilation to rising leaf temperature
System Requirements

•	Any computer which can run R computer language and RStudio with no non-standard hardware required.
•	R computer language can be downloaded from https://cran.r-project.org/mirrors.html 
•	Software was run using R version 4.1.2 (2021-11-01) and RStudio 2021.09.2.
•	installed packages readxl (https://CRAN.R-project.org/package=readxl) and Metrics (https://CRAN.R-project.org/package=Metrics)

Instructions for running code

1.	Open RStudio and paste the code from the photosynthesis_temperature_response_models repository into the script editor and save as a .r file in a designated folder
2.	In the same designated folder download and save from the repository the template photosynthesis temperature response data file named “”.
3.	Run the code.
4.	The code will generate and save in the same folder: 
a)	a pdf document that contains a graph and indices of the model fit for each photosynthesis temperature response curve present in the excel data file
b)	A csv spreadsheet with the model outputs listed for each temperature response curve.
5.	Delete examples and add measured temperature response curves to the data file. Make sure that a unique identifier number is placed in the “set” column for each individual temperature curve added. 
6.	If the data file is to be renamed please update the code to reflect the new data file mane by changing this line of code to the new name:


Input data column descriptions

set: A unique number given to each set of data relating to an individual temperature response curve.

species: The genus and species name for which a temperature response curve was measured. Can be changed to any identifier relevant to the corresponding temperature response curve (e.g. sample name or treatment name).

growth_temp: The average day/light temperature (mean daily maximum temperature at which a species was grown) in °C.

plant_functional_type: A description of which physiological type the species belongs to (herb/grass, temperate tree, shrub, needle-leaf tree, tropical tree, tropical montane tree).

temperature: The measured leaf temperature in C.

photo: The measured net photosynthetic CO2 assimilation rate at a given temperature in mol CO2 m-2 s-1.


Model output column descriptions

set: A unique number given to each set of data relating to an individual temperature response curve.

species: The genus and species name for which a temperature response curve was measured. 

growth_temp: The average day/light temperature (mean daily maximum temperature at which a species was grown) in C.

plant_functional_type: A description of which physiological type the species belongs to (herb/grass, temperate tree, shrub, needle-leaf tree, tropical tree, tropical montane tree).

climate: Categorised as “cool” or “warm” based on whether the measurements were recorded for a plant with a growth temperature below or above 25C, respectively.

mn: The modelled number of Rubisco catalytic sites per unit of leaf area (mol m-2) based on the assimilation rate and the catalytic rate constant of Rubisco.  

Ac-RMSE: The root mean squared error (RMSE) of the temperature response curve assimilation observations compared to the modelled carboxylation limited assimilation observations (mol CO2 m-2 s-1).

Ac-bias: The bias in observations of assimilation being greater than modelled carboxylation limited assimilation predictions (mol CO2 m-2 s-1).

J: The modelled chloroplast electron transport rate at 22C based on corresponding assimilation rates.

Ar-RMSE: The root mean squared error (RMSE) of the temperature response curve assimilation observations compared to the modelled RuBP regeneration limited assimilation observations (mol CO2 m-2 s-1).


Ar-bias: The bias in observations of assimilation being greater than modelled RuBP regeneration limited assimilation predictions (mol CO2 m-2 s-1).
