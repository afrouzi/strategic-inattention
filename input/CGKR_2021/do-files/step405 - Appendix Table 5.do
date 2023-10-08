clear all
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\output"


encode w8_exper_group, gen(w8_exper_groupN)


****============================================================================
*** check whether treatment had an effect
****============================================================================


*** implied mean prediction of inflation
reghdfe  w8_epi_12m_exper i.w8_exper_groupN#c.w8_epi_12m, absorb(w8_exper_groupN) vce(robust)
outreg2 using appendix_table02.dta, dta replace dec(3) ctitle("LOE")


***** Follow-up ******

*** implied mean prediction of inflation
reghdfe  w9_epi_12m_implied i.w8_exper_groupN#c.w8_epi_12m, absorb(w8_exper_groupN) vce(robust)
outreg2 using appendix_table02.dta, dta append dec(3) ctitle("LOE: follow-up")
 
