clear all

// Load data 
use "/Users/clement/Desktop/ULB/Doctorat/ECARES M2/Advanced topics in Economics/Project/Gravity_trade_2/src/final_data.dta"
	// Let's have a look 
	. describe

// Generating log variables for gdp_i and gdp_j and dist.
generate lv = ln(v)
generate log_gdp_i = ln(gdp_i)
generate log_gdp_j = ln(gdp_j)
generate log_dist =  ln(dist)

// First regression using simplest model
reg lv log_gdp_i log_gdp_j log_dist WTO_i WTO_j rta cu fta eia ps
reg lv log_gdp_i log_gdp_j log_dist BRI_i BRI_j WTO_i WTO_j rta cu fta eia ps


// Prep for F.E.
egen o=group(i)
egen d=group(j)
egen od=group(i j)
egen ot=group(i RefYear)
egen dt=group(j RefYear)

reghdfe lv log_dist, a(o d) // this is a regression with F.E. for the exporter and for the importer
reg lv log_gdp_i log_gdp_j log_dist BRI_i BRI_j WTO_i WTO_j BRICS_i BRICS_j rta cu fta eia ps BRI_OECD  // this is a regression with F.E. for the pair importer/exporter

// 8 Compare 'reghdfe lv ldist, a(o d)' with 'reghdfe lv ldist cluster (od)
reghdfe lv log_dist, a(o d)
reghdfe lv log_dist, a(o d) cluster (od)
	// what does cluster do?
