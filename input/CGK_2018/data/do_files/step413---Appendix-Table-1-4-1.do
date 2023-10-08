clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

 gen anzsic_code3=floor(anzsic_code/10)

 cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\do_files"
 do load_rreg2
 
 capture cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\output"
 
 *============================================================================
 * 							create variables
 *============================================================================
 

 gen D12=(w1_epi_12m~=. & w2_epi_12m~=.) if w1_epi_12m~=.
 gen D13=(w1_epi_12m~=. & w3_epi_12~=.) if w1_epi_12m~=.
 gen D14=(w1_epi_12m~=. & w4_ue~=.) if w1_epi_12m~=.
 gen D1234 = (w1_epi_12m~=. & w2_epi_12m~=.  & w3_epi_12~=.  & w4_ue~=.) if w1_epi_12m~=.

 gen D67=(w6_epi_12m~=. & w7_epi_12m~=.) if w6_epi_12m~=.

 
 *============================================================================
 * 							waves 1, 2, 3, 4
 *============================================================================
 gen ln_age=log(w1_age)
 gen ln_L=log(w1_employment)
 
 egen agg1s=group(agg1)
 gen agg1s_1=agg1s==1
 gen agg1s_2=agg1s==2
 gen agg1s_3=agg1s==3
 gen agg1s_4=agg1s==4
 
 reg D12 w1_epi_12m ln_age ln_L w1_labor_cost_share w1_trade_share w1_competitors i.agg1s
 outreg2 w1_epi_12m ln_age ln_L w1_labor_cost_share w1_trade_share w1_competitors ///
		using AppendixTable_1_4_1, replace dec(3) ctitle("waves 1 => 2")
		
reg D13 w1_epi_12m ln_age ln_L w1_labor_cost_share w1_trade_share w1_competitors i.agg1s
outreg2 w1_epi_12m ln_age ln_L w1_labor_cost_share w1_trade_share w1_competitors ///
		using AppendixTable_1_4_1, append dec(3) ctitle("waves 1 => 3")
		
reg D14 w1_epi_12m ln_age ln_L w1_labor_cost_share w1_trade_share w1_competitors i.agg1s
outreg2 w1_epi_12m ln_age ln_L w1_labor_cost_share w1_trade_share w1_competitors ///
		using AppendixTable_1_4_1, append dec(3) ctitle("waves 1 => 4")		

reg D1234 w1_epi_12m ln_age ln_L w1_labor_cost_share w1_trade_share w1_competitors i.agg1s
outreg2 w1_epi_12m ln_age ln_L w1_labor_cost_share w1_trade_share w1_competitors ///
		using AppendixTable_1_4_1, append dec(3) ctitle("waves 1 => 2,3,4")	

 *============================================================================
 * 							waves 6, 7
 *============================================================================
 capture drop anzsic_code3		
 gen anzsic_code3=floor(w6_anzsiccode/10)
 gen anzsic_code2=floor(w6_anzsiccode/100)

 drop agg1
 gen agg1="Manufacturing" if anzsic_code2>=11 & anzsic_code2<=25 & anzsic_code2~=.
 replace agg1="Construction and Transportation" if anzsic_code2==30 | anzsic_code2==32 | anzsic_code2==46 | anzsic_code2==47 | anzsic_code2==48 | anzsic_code2==49 | anzsic_code2==1 | anzsic_code2==51 | anzsic_code2==52 | anzsic_code2==53
 replace agg1="Professional and Financial Services" if anzsic_code2>=54 & anzsic_code2~=.
 replace agg1="Trade" if anzsic_code2>=33 & anzsic_code2<=45 & anzsic_code2~=.
 
 gen w6_trade_share=100-w6_sales_nz

 gen ln_age6=log(w6_firm_age)
 gen ln_L6=log(w6_employment)
 
 reg D67 w6_epi_12m ln_age6 ln_L6 w6_labor_cost_share w6_trade_share w6_competitors i.agg1s
 outreg2 w6_epi_12m ln_age6 ln_L6 w6_labor_cost_share w6_trade_share w6_competitors  ///
		using AppendixTable_1_4_1, append dec(3) ctitle("waves 6 => 7")		
