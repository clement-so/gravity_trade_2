clear all

use "C:\Users\user\OneDrive\Courses\Ph.D. courses\Advanced Topics in International Economics\New Report\data.dta" 

************************
*** GENERATE INDEXES ***
************************
egen o = group(i)
egen d = group(j)
egen od = group(i j)
egen ot = group(i t)
egen dt = group(j t)
drop if o ==. 
drop if d ==.

****************************
*** RECOGNIZE PANEL DATA ***
****************************
rename index pair
rename t year
xtset pair year, delta(1)

*******************
*** GENERATE FE ***
*******************

tabulate year, generate (year_fe) //Time FE
*tabulate od, generate (od_fe) //Pair FE 
*tabulate ot, generate(ot_fe) //Exporter-year FE
*tabulate dt, generate(dt_fe) //Importer-year FE

**************************************
*** GENERATE EXPLANATORY VARIABLES ***
**************************************

gen BRI = BRI_i*BRI_j

*********************************************
*** GENERATE LOGS OF CONTINUOUS VARIABLES ***
*********************************************

gen log_trade = log(v)
gen log_dist = log(dist)
gen log_gdp_i = log(gdp_i)
gen log_gdp_j = log(gdp_j)


***********************
*** OLS REGRESSIONS ***
***********************

reg log_trade log_gdp_i log_gdp_j log_dist, cluster(od)

reg log_trade log_gdp_i log_gdp_j log_dist BRI, cluster(od)

reg log_trade log_gdp_i log_gdp_j log_dist BRI year_fe*, cluster(od)


************************
*** HDFE REGRESSIONS ***
************************

reghdfe log_trade BRI, a(o d)