clear all 
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

encode w8_exper_group, gen(w8_exper_groupN)

*=============================================================================
*					Wave 8 (main wave; pre-experiment)
*=============================================================================
*** row #1
sum w8_epi_12m_implied
sum w8_epi_12m_implied_std

*** row #2
sum w8_epi_ho_12m_implied
sum w8_epi_ho_12m_implied_std

corr  w8_epi_12m_implied w8_epi_ho_12m_implied

*** row #3: test equality
*** column (1): test equality of inflation expecta
ttest w8_epi_12m_implied == w8_epi_ho_12m_implied

*** column (2)
sdtest w8_epi_12m_implied == w8_epi_ho_12m_implied

*** column (3)
ttest w8_epi_12m_implied_std == w8_epi_ho_12m_implied_std

*=============================================================================
*					Wave 8 (main wave; post-experiment)
*=============================================================================
*** row #4
sum w8_epi_12m_exper

*** row #5
sum w8_epi_ho_12m_exper
 
corr  w8_epi_12m_exper w8_epi_ho_12m_exper

*** row #6: test equality
*** column (1): test equality of inflation expecta
ttest w8_epi_12m_exper == w8_epi_ho_12m_exper

*** column (2)
sdtest w8_epi_12m_exper == w8_epi_ho_12m_exper


*=============================================================================
*					Wave 9 (follow-up wave)
*=============================================================================
*** row #7
sum w9_epi_12m_implied
sum w9_epi_12m_implied_std

*** row #8
sum w9_epi_ho_12m_implied
sum w9_epi_ho_12m_implied_std
 
corr  w9_epi_12m_implied w9_epi_ho_12m_implied

*** row #9: test equality
*** column (1): test equality of inflation expecta
ttest w9_epi_12m_implied == w9_epi_ho_12m_implied

*** column (2)
sdtest w9_epi_12m_implied == w9_epi_ho_12m_implied

*** column (3)
ttest w9_epi_12m_implied_std == w9_epi_ho_12m_implied_std

*=============================================================================
*					Wave 9 (memonradum items)
*=============================================================================
*** row #10
sum w8_epi_12m

*** row #11
sum w8_pi_12m
 
corr w8_epi_12m w8_pi_12m w8_epi_12m_implied 

*** row #12 (unemployment)
sum w8_eue_12m_implied
sum w8_eue_12m_implied_std

corr w8_epi_12m_implied w8_eue_12m_implied

*** row #13 (wages)
sum w8_edw_12m_implied
sum w8_edw_12m_implied_std

corr w8_epi_12m_implied w8_edw_12m_implied
	
*** row #14	
sum w8_edp_3m
corr w8_edp_3m w8_epi_12m_implied

*** row #15
sum w8_edw_3m	
corr w8_edw_3m w8_epi_12m_implied

*** row #16
sum w8_edassets_3m
corr w8_edassets_3m w8_epi_12m_implied

*** row #17
sum w8_edworkers_3m
corr w8_edworkers_3m w8_epi_12m_implied



	
	
