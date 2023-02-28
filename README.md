# photosynthesis temperature response models
Models the response of net assimilation to rising leaf temperature

System Requirements

•	Any computer which can run R computer language and RStudio with no non-standard hardware required.
•	R computer language can be downloaded from https://cran.r-project.org/mirrors.html 
•	Software was run using R version 4.1.2 (2021-11-01) and RStudio 2021.09.2.
•	installed packages readxl (https://CRAN.R-project.org/package=readxl) and Metrics (https://CRAN.R-project.org/package=Metrics)

Instructions for running code

1. Download and save to a folder the model code file [[photosynthesis temperature respnse model](https://github.com/ascafaro/photosynthesis_temperature_response_models/blob/main/photosynthesis%20temperature%20response%20model.R)] and the linked data file [[photosynthesis temperature response curves](https://github.com/ascafaro/photosynthesis_temperature_response_models/blob/main/photosynthesis%20temperature%20response%20data.xlsx)]

2. Double click the code which should open it in in RStudio
3. Run the code.
4. The code will generate and save in the same folder: 
      a) A pdf document that contains a graph and indices of the model fit for each photosynthesis temperature response curve present in the excel data  file.
      b) A csv spreadsheet with the model outputs listed for each temperature response curve.
5. Delete examples and add measured temperature response curves to the data file. Make sure that a unique identifier number is placed in the “set” column for each individual temperature curve added. 
6. If the data file is to be renamed please update the code to reflect the new data file mane by changing the following line of code to the new name: photosynthesis<-as.data.frame(read_excel("photosynthesis temperature response data.xlsx", col_names = TRUE, sheet = "photosynthesis"))


Input data column descriptions

set: A unique number given to each set of data relating to an individual temperature response curve.

species: The genus and species name for which a temperature response curve was measured. Can be changed to any identifier relevant to the corresponding temperature response curve (e.g. sample name or treatment name).

growth_temp: The average day/light temperature (mean daily maximum temperature at which a species was grown) in °C.

plant_functional_type: A description of which physiological type the species belongs to (herb/grass, temperate tree, shrub, needle-leaf tree, tropical tree, tropical montane tree).

reference: The authors and year of publication

doi: The Digital Object Identifier for the papers from which data was extracted

temperature: The measured leaf temperature in °C.

photo: The measured net photosynthetic CO2 assimilation rate at a given temperature in µmol CO2 m-2 s-1.


Model output column descriptions

set: A unique number given to each set of data relating to an individual temperature response curve.

species: The genus and species name for which a temperature response curve was measured. 

growth_temp: The average day/light temperature (mean daily maximum temperature at which a species was grown) in °C.

plant_functional_type: A description of which physiological type the species belongs to (herb/grass, temperate tree, shrub, needle-leaf tree, tropical tree, tropical montane tree).

climate: Categorised as “cool” or “warm” based on whether the measurements were recorded for a plant with a growth temperature below or above 25°C, respectively.

mn: The modelled number of Rubisco catalytic sites per unit of leaf area (µmol m-2) based on the assimilation rate and the catalytic rate constant of Rubisco.  

Ac-RMSE: The root mean squared error (RMSE) of the temperature response curve assimilation observations compared to the modelled carboxylation limited assimilation observations (µmol CO2 m-2 s-1).

Ac-bias: The bias in observations of assimilation being greater than modelled carboxylation limited assimilation predictions (µmol CO2 m-2 s-1).

J: The modelled chloroplast electron transport rate at 22°C based on corresponding assimilation rates.

Ar-RMSE: The root mean squared error (RMSE) of the temperature response curve assimilation observations compared to the modelled RuBP regeneration limited assimilation observations (µmol CO2 m-2 s-1).


Ar-bias: The bias in observations of assimilation being greater than modelled RuBP regeneration limited assimilation predictions (µmol CO2 m-2 s-1).
