clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

 gen anzsic_code3=floor(anzsic_code/10)


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  							  
*								row 1
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
egen  S3=rsum(w4_track_pif w4_track_uef w4_track_gdpf)
egen S3c=rownonmiss(w4_track_pif w4_track_uef w4_track_gdpf)
replace S3=. if S3c==0

gen S3d=(S3==3) if S3~=.


*** column 1
sum S3d [aw=w4_wgtE_43]

*** column 2
tab w4_track_time3 [aw=w4_wgtE_43]

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  							  
*								row 2
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
capture drop S3*
egen  S3=rsum(w4_track_pif w4_track_uef)
egen S3c=rownonmiss(w4_track_pif w4_track_uef w4_track_gdpf)
replace S3=. if S3c==0

gen S3d=(S3==2) & (w4_track_gdpf==0) if S3~=.

*** column 1
sum S3d [aw=w4_wgtE_43]

*** column 2
tab w4_track_time2 [aw=w4_wgtE_43] if S3d==1

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  							  
*								row 3
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
capture drop S3*
egen  S3=rsum(w4_track_pif w4_track_gdpf)
egen S3c=rownonmiss(w4_track_pif w4_track_uef w4_track_gdpf)
replace S3=. if S3c==0

gen S3d=(S3==2) & (w4_track_uef==0) if S3~=.

*** column 1
sum S3d [aw=w4_wgtE_43]

*** column 2
tab w4_track_time2 [aw=w4_wgtE_43] if S3d==1


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  							  
*								row 4
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
capture drop S3*
egen  S3=rsum(w4_track_uef w4_track_gdpf)
egen S3c=rownonmiss(w4_track_pif w4_track_uef w4_track_gdpf)
replace S3=. if S3c==0

gen S3d=(S3==2) & (w4_track_pif==0) if S3~=.

*** column 1
sum S3d [aw=w4_wgtE_43]

*** column 2
tab w4_track_time2 [aw=w4_wgtE_43] if S3d==1

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  							  
*								row 5
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
capture drop S3*
egen  S3=rsum(w4_track_pif)
egen S3c=rownonmiss(w4_track_pif w4_track_uef w4_track_gdpf)
replace S3=. if S3c==0

gen S3d=(S3==1) & (w4_track_uef==0) & (w4_track_gdpf==0) if S3~=.

*** column 1
sum S3d [aw=w4_wgtE_43]

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  							  
*								row 5
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
capture drop S3*
egen  S3=rsum(w4_track_uef)
egen S3c=rownonmiss(w4_track_pif w4_track_uef w4_track_gdpf)
replace S3=. if S3c==0

gen S3d=(S3==1) & (w4_track_pif==0) & (w4_track_gdpf==0) if S3~=.

*** column 1
sum S3d [aw=w4_wgtE_43]

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  							  
*								row 6
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
capture drop S3*
egen  S3=rsum(w4_track_gdpf)
egen S3c=rownonmiss(w4_track_pif w4_track_uef w4_track_gdpf)
replace S3=. if S3c==0

gen S3d=(S3==1) & (w4_track_pif==0) & (w4_track_uef==0) if S3~=.

*** column 1
sum S3d [aw=w4_wgtE_43]



