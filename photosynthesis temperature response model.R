### required Packages installed ###
library(readxl) # package that needs to be installed
library(Metrics) # package that needs to be installed

### set the working directory to the provided data and script folder ###
wd<- getwd() # gets the path of the R working directory
setwd(wd) # sets the working directory to the data and script folder

#### The data used in analysis ###

#photosynthesis temperature response curves and information about growth temperature
photosynthesis<-as.data.frame(read_excel("example photosynthesis temperature response data.xlsx", col_names = TRUE, sheet = "photosynthesis"))

# assign cool or warm grown to each row of data based on growth temperature
# daily mean maximum temperature of below 25°C (cool) or above 25°C (warm). 
# when mean maximum temperature is 25°C assign as cool if maximum photosynthesis occurs below 30°C
coolorWarm.f<- function (x) {
  photodata<-photosynthesis[photosynthesis$set==x,]
  photoMaxTemp<- photodata$temperature[which(photodata$photo==max(photodata$photo))]
  if (photodata$growth_temp[1] < 25) {climate<-rep("cool",nrow(photodata))}
  else if (photodata$growth_temp[1] > 25) {climate<-rep("warm",nrow(photodata))}
  else if (photodata$growth_temp[1] > 25) {climate<-rep("warm",nrow(photodata))}
  else if (photodata$growth_temp[1] == 25 & photoMaxTemp < 30) {climate<-rep("cool",nrow(photodata))}
  else {climate<-rep("warm",nrow(photodata))}
}

l<-unique(photosynthesis$set)
photosynthesis$climate<-unlist(lapply(1:length(l), function (x) {coolorWarm.f(l[x])}))


### constants ###

O<- c(21) # atmospheric O2 in kPa assuming 101 kPa atmospheric Pressure
K<- c(273.15) # kelvin
R<- c(8.314) # gas constant J K-1 mol-1
T<- seq(0,52,0.01) # create a fine scale temperature range for simulations in degree Celcius

### equations ###

# Arrhenius equation with activation energy (Ea), parameter value at 25C (P_25)
temp.f<-function(P25,Ea,T){y=P25*exp(Ea*(T-25)/(R*298*(K+T)))} 
# Ac from standard C3 photosynthesis model, Farquhar et al. 1980 doi:10.1007/BF00386231
Ac.f<-function (n,kcat,Cc,gamma,Kc,Ko,Rlight) {Ac<-(((Cc-gamma)*n*kcat)/(Cc+Kc*(1+O/Ko)))-Rlight} 
# Ac with Rubisco deactivation accounted for
AcDeactivation.f<-function (n,kcat,Cc,gamma,Kc,Ko,Rlight,Ed,Th,T) {Ac<-(((Cc-gamma)*(n*(1/((1+exp((Ed/R)*((1/Th)-(1/(T+K))))))))*kcat)/(Cc+Kc*(1+O/Ko)))-Rlight} 
# Ar from standard C3 photosynthesis model, Farquhar et al. 1980 doi:10.1007/BF00386231
Ar.f<- function (J,gamma) {((Cc-gamma)*J)/(4*Cc+8*gamma)-Rlight}
# June et al. 2004 doi:10.1071/FP03250 equation to determine temperature response of electron transport (J)
J.f<- function (JatTopt,ToptJ,omega, T) {JTl<-JatTopt*exp(-((T-ToptJ)/omega)^2)}



### C3 photosynthesis model parameters ###

## Rubisco enzyme kinetics ##
# based on the values presented for multiple plant species in Orr 2016 doi:10.1104/pp.16.00750 & Galmes et al 2016 doi:10.1093/jxb/erw267
 
# cool parameters
EdCool<- 199067 # Deactivation energy (J mol-1)            
T0.5Cool<- 312.1 # temperature at which enzyme activity is halved (kelvin)
kcatCoolat25<- 3.185 # Rate constant of fixation (CO2 s-1) at 25°C
kcatCoolEa<- 61245 # activation energy of rate constant (J mol-1)
kcatCool<-temp.f(kcatCoolat25,kcatCoolEa,T) # rate constant applied to all simulated leaf temperatures
KcCoolat25<-40.88 # Michaelis-Menten constant of Rubisco for CO2 at 25°C (Pa)
KcCoolEa<- 58048 # activation energy of Michaelis-Menten constant of Rubisco for CO2  (J mol-1)
KcCool<-temp.f(KcCoolat25,KcCoolEa,T) # Michaelis-Menten constant of Rubisco for CO2 applied to all simulated leaf temperatures
KoCoolat25<-29.179 # Michaelis-Menten constant of Rubisco for O2 at 25°C (kPa)
KoCoolEa<- 27446 # activation energy of Michaelis-Menten constant of Rubisco for O2  (J mol-1)
KoCool<-temp.f(KoCoolat25,KoCoolEa,T)  # Michaelis-Menten constant of Rubisco for O2 applied to all simulated leaf temperatures
gammaCoolat25<- 3.94 # CO2 compensation point in the absence of light respiration at 25°C (Pa)
gammaCoolEa<- 26673 # activation energy of the CO2 compensation point in the absence of light respiration (J mol-1)
gammaCool<-temp.f(gammaCoolat25,gammaCoolEa,T) # the CO2 compensation point in the absence of light respiration applied to all simulated leaf temperatures
  
# warm parameters
EdWarm<-211838
T0.5Warm<- 315.5
kcatWarmat25<- 2.57 
kcatWarmEa<- 69282
kcatWarm<-temp.f(kcatWarmat25,kcatWarmEa,T)
KcWarmat25<-35.88
KcWarmEa<- 57329
KcWarm<-temp.f(KcWarmat25,KcWarmEa,T)  
KoWarmat25<- 30.3
KoWarmEa<-  7255
KoWarm<-temp.f(KoWarmat25,KoWarmEa,T) 
gammaWarmat25<- 3.91
gammaWarmEa<- 29990
gammaWarm<-temp.f(gammaWarmat25,gammaWarmEa,T)

# CO2 concentration
Ca<-40 # ambient CO2 partial pressure (Pa)
Cc<-Ca*0.70 # chloroplast CO2 assumed to be same as Ci and 70% of the ambient Ca value (Pa)

# number of Rubisco active sites from global N concentrations
RubiscoArea<- 1.79 # Rubisco per unit leaf area in g m-2 from Onoda et al 2017
nRubisco<-70000 # 70,000 Dalton  per active site
n<- RubiscoArea/nRubisco*1000000 # number of Rubisco active sites in µmol m-2 s-1

#respiration in the light calculations
Rdark25<-1.88+0.2061*RubiscoArea-0.0402*25 # Global derived Rdark at 25C from GlobRes Atkin 2015 in umol m-2 s-1
RdarkT<-Rdark25*exp(0.1012*(T-25)+-0.0005*(T^2-25^2)) # global repiration response from Heskel in umol m-2 s-1
Rlight<- 0.7*RdarkT # 30% inhibition of Rdark inlight Harper 2016; Clark 2011 and Weerasighe 2014 as reported by Atkin 

# electron transport rate temperature response parameters from literature (J)
# cool grown
JatToptCool<-190.4
ToptJCool<- 31.66
omegaCool <- 20.08
# warm grown
JatToptWarm <- 242.4
ToptJWarm <- 36.84
omegaWarm <- 21.26

### model predictions ###

## models of carbolylation limited assimilation (Ac) without Rubisco deactivation
AcCool<-Ac.f(n = n, kcat = kcatCool, Cc = Cc, gamma = gammaCool, Kc = KcCool, Ko = KoCool, Rlight = Rlight)
AcWarm<-Ac.f(n = n, kcat = kcatWarm, Cc = Cc, gamma = gammaWarm, Kc = KcWarm, Ko = KoWarm, Rlight = Rlight)
## model of Ac with deactivation included
AcDeactivationlCool<-AcDeactivation.f(n,kcatCool,Cc,gammaCool,KcCool,KoCool,Rlight,EdCool,T0.5Cool,T)
AcDeactivationWarm<-AcDeactivation.f(n,kcatWarm,Cc,gammaWarm,KcWarm,KoWarm,Rlight,EdWarm,T0.5Warm,T)
## models of RuBP regeneration limited assimilation (Ar)
JCool<-J.f(JatToptCool,ToptJCool,omegaCool,T)
ArCool<- Ar.f(JCool,gammaCool)
JWarm<-J.f(JatToptWarm,ToptJWarm,omegaWarm,T)
ArWarm<- Ar.f(JWarm,gammaWarm)


### Ac with Rubisco activation and Ar models fits to individual cool and warm growth temperature response curves ###

photo.species.f<- function (x) {
  photodata<-photosynthesis[photosynthesis$set==x,]
  photodata$temperature<-signif(photodata$temperature,3)[order(photodata$temperature)]
  if(photodata$climate[1] =="cool") { # fits cool parameters to cool categorised temperature response curves
    Ed<-EdCool
    T0.5<-T0.5Cool
    kcat<-kcatCool[pmatch(photodata$temperature,T,duplicates.ok = TRUE)]
    gamma<-gammaCool[pmatch(photodata$temperature,T,duplicates.ok = TRUE)]
    Kc<-KcCool[pmatch(photodata$temperature,T,duplicates.ok = TRUE)]
    Ko<-KoCool[pmatch(photodata$temperature,T,duplicates.ok = TRUE)]
    ToptJ<-ToptJCool
    omega<-omegaCool
    i<-which(photodata$temperature >=22)[1]} # i is the temperature for an individual  response curve that is 22°C or closest value above
  else {
    Ed<-EdWarm # fits warm parameters for warm species
    T0.5<-T0.5Warm
    kcat<-kcatWarm[pmatch(photodata$temperature,T,duplicates.ok = TRUE)]
    gamma<-gammaWarm[pmatch(photodata$temperature,T,duplicates.ok = TRUE)]
    Kc<-KcWarm[pmatch(photodata$temperature,T,duplicates.ok = TRUE)]
    Ko<-KoWarm[pmatch(photodata$temperature,T,duplicates.ok = TRUE)]
    ToptJ<-ToptJWarm
    omega<-omegaWarm
    i<-which(photodata$temperature >=22)[1]}
  
  Rlight<-Rlight[pmatch(photodata$temperature,T,duplicates.ok = TRUE)]
  #Ac model fits
  An<-photodata$photo[i]
  nat22<-((An+Rlight[i])*(Cc+Kc[i]*(1+O/Ko[i]))/(Cc-gamma[i]))/kcat[i] # derives a Rubisco catalytic site molar concentration µmol m-2 based on An value at 22C or closest above
  Ac<-AcDeactivation.f(nat22,kcat,Cc,gamma,Kc,Ko,Rlight,Ed,T0.5,photodata$temperature)
  #Ar model fits
  Jat22<-((An+Rlight[i])*(4*Cc+8*gamma[i]))/(exp(-((photodata$temperature[i]-ToptJ)/omega)^2)*(Cc-gamma[i]))
  J<-J.f(Jat22,ToptJ,omega,photodata$temperature)
  Ar.f<- function(J,gamma) {((Cc-gamma)*J)/(4*Cc+8*gamma)-Rlight} 
  Ar<-Ar.f(J,gamma)
  
  fiterrorAc<-rmse(photodata$photo,Ac) # rmse computes the root mean squared error between two numeric vectors for observed vs Ac model
  fiterrorAr<-rmse(photodata$photo,Ar) # rmse computes the root mean squared error between two numeric vectors for observed vs Ar model
  biAc<-bias(photodata$photo,Ac) #bias computes the average amount by which observedis greater than Ac predicted.
  biAr<-bias(photodata$photo,Ar) #bias computes the average amount by which observedis greater than Ar predicted.
  
  # graph the individual curve fits and print indices of model fit 
  plot(photodata$temperature, photodata$photo, ylim = c(0,40),xlim = c(0,50), 
        col = "black",xlab = bquote(Leaf~temperature~(degree*C)),
        ylab = bquote(italic(A)[n]~(mu*mol~CO[2]~m^2~s^-1)),pch=1)
  title(main=bquote(italic(.(photodata$species[1]))))
  lines(photodata$temperature, Ac)
  lines(photodata$temperature, Ar, lty = 3)
  legend("topleft", legend = c(paste("mn=",round(nat22[1],2)), paste("J=",round(Jat22[1],2)), paste("Ac-RMSE=",round(fiterrorAc[1],2)),
                               paste("Ar-RMSE=",round(fiterrorAr[1],2)), paste("Ac-Bias=",round(biAc[1],2)),paste("Ar-Bias=",round(biAr[1],2))))
  legend("topright", legend = c("Ac predicted", "Ar predicted"), lty = c(1,3))
  # summary of results in tabulated form
  out<-list(photodata$set, photodata$species,photodata$growth_temp,photodata$climate,photodata$plant_functional_type,nat22,fiterrorAc,biAc,
            Jat22,fiterrorAr, biAr, Ar)
}

l<-unique(photosynthesis$set) # lists the sets of photosynthesis curves from the input dataset
pdf(file = "model fit.pdf") # opens a pdf file to save figures
res<-sapply(1:length(l), function (x) {photo.species.f(l[x])}) # applies the model analysis which includes graphing across all sets in input data
dev.off() # closes the pdf file


res.f<-function (y) {sapply(1:length(l), function (x) res[[y,x]][1])} # unpacks the model analysis based on a selected objects of interest

out.df<-data.frame(res.f(1),res.f(2),res.f(3),res.f(4),res.f(5),res.f(6),res.f(7),res.f(8),res.f(9), res.f(10),res.f(11)) # dataframe with model results of interest
colnames(out.df)<-c("set","species", "growth_temp","plant_functional_type","climate","mn","Ac-RMSE", "Ac-bias","J", "Ar-RMSE", "Ar-bias") # manes for dataframe

### summary of analysis saved to folder ###
write.csv(out.df, file = "photosynthesis model outcomes.csv")
