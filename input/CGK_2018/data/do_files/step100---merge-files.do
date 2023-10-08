clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"

***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** 			merge waves
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

use wave1, clear
joinby firmid using wave2, unmatched(both)
tab _merge
rename _merge _merge12

joinby firmid using wave3, unmatched(both)
tab _merge
rename _merge _merge13

joinby firmid using wave4, unmatched(both)
tab _merge
rename _merge _merge14

joinby firmid using wave5, unmatched(both)
tab _merge
rename _merge _merge15

joinby firmid using wave6, unmatched(both)
tab _merge
rename _merge _merge16

joinby firmid using wave7, unmatched(both)
tab _merge
rename _merge _merge17

*** industry codes
joinby firmid using ANZSICcodes, unmatched(both)
tab _merge
rename _merge _merge1codes

*** weights
joinby firmid using NZ_census_weights_employment, unmatched(both)
tab _merge
rename _merge _merge1wgtE

foreach var in 2 3 4 6 7 {
joinby firmid using NZ_census_weights_employment_w`var', unmatched(both)
tab _merge
rename _merge _merge1wgtE_w`var'
}


 *===================================================================
 * now create industry level indices as done for PPI measures 
 * (see PPI weights by industry.xlsx for industry categories and www.abs.gov.au/ausstats for associated SIC codes)
 
 * sic2 is defining industries at finest level available for ppi industry inflation
 * sic1 is industry-level (i.e. manufacturing, construction, retail trade, etc...), ppi inflation always available
 * agg1 is our preferred aggregation level for figures and comparisons(4 groups)
 * agg2 is hybrid of sic1 & sic2 s.t. all sectors have >100 firms (some are finer decomps than ppi inflation availability)
 
 * manufacturing 
 gen sic2 = "not classified"
 gen sic1 = "not classified"
 gen agg1 = "not classified"
 gen agg2 = "not classified"
 replace sic2="CC11" if anzsic_code>1109.9 & anzsic_code<1119.9
 replace sic2="CC12" if anzsic_code>1119.9 & anzsic_code<1129.9
 replace sic2="CC13" if anzsic_code>1129.9 & anzsic_code<1139.9
 replace sic2="CC14" if anzsic_code>1139.9 & anzsic_code<1199.9
 replace sic2="CC15" if anzsic_code>1199.9 & anzsic_code<1299.9
 replace sic2="CC21" if anzsic_code>1299.9 & anzsic_code<1399.9
 replace sic2="CC31" if anzsic_code>1399.9 & anzsic_code<1499.9
 replace sic2="CC32" if anzsic_code>1499.9 & anzsic_code<1599.9
 replace sic2="CC41" if anzsic_code>1599.9 & anzsic_code<1699.9
 replace sic2="CC51" if anzsic_code>1699.9 & anzsic_code<1799.9
 replace sic2="CC52" if anzsic_code>1799.9 & anzsic_code<1899.9
 replace sic2="CC53" if anzsic_code>1899.9 & anzsic_code<1999.9
 replace sic2="CC61" if anzsic_code>1999.9 & anzsic_code<2099.9
 replace sic2="CC71" if anzsic_code>2099.9 & anzsic_code<2199.9
 replace sic2="CC72" if anzsic_code>2199.9 & anzsic_code<2299.9
 replace sic2="CC81" if anzsic_code>2299.9 & anzsic_code<2399.9
 replace sic2="CC82" if anzsic_code>2399.9 & anzsic_code<2499.9
 replace sic2="CC91" if anzsic_code>2499.9 & anzsic_code<2599.9
 replace sic1="CC" if anzsic_code>1109.9 & anzsic_code<2599.9
 replace agg1="Manufacturing" if sic1=="CC"
 replace agg2="Food and Beverage" if anzsic_code>1109.9 & anzsic_code<1219.9
 replace agg2="Textile and Clothing" if sic2=="CC21"
 replace agg2="Paper/Wood, Printing and Furniture" if sic2=="CC31" | sic2=="CC32" | sic2=="CC41" | sic2=="CC91"
 replace agg2="Chemicals and Metals" if anzsic_code>1699.9 & anzsic_code<2299.9
 replace agg2="Equipment and Machinery" if anzsic_code>2299.9 & anzsic_code<2499.9
 
  * construction
 replace sic2="EE11" if anzsic_code>2999.9 & anzsic_code<3099.9
 replace sic2="EE12" if anzsic_code>3099.9 & anzsic_code<3199.9
 replace sic2="EE13" if anzsic_code>3199.9 & anzsic_code<3299.9
 replace sic1="EE" if anzsic_code>2999.9 & anzsic_code<3299.9
 
 * wholesale trade
 replace sic2="FF" if anzsic_code>3299.9 & anzsic_code<3899.9
 replace sic1="FF" if anzsic_code>3299.9 & anzsic_code<3899.9
 replace agg2="Wholesale Trade" if sic1=="FF"
 
 * retail trade & accomodation
 replace sic2="GH11" if anzsic_code>3899.9 & anzsic_code<4099.9
 replace sic2="GH12" if anzsic_code>4099.9 & anzsic_code<4199.9
 replace sic2="GH13" if anzsic_code>4199.9 & anzsic_code<4399.9
 replace sic2="GH21" if anzsic_code>4399.9 & anzsic_code<4599.9
 replace sic1="GH"   if anzsic_code>3899.9 & anzsic_code<4599.9
 replace agg1="Trade" if sic1=="FF" | sic1=="GH"
 replace agg2="Car, Supermarket and Food Retailing" if sic2=="GH11" | sic2=="GH12"
 replace agg2="Other Store Retailing" if sic2=="GH13"
 replace agg2="Hotel and Food Services" if sic2=="GH21"
 
  * transport, postal and warehousing
 replace sic2="II11" if anzsic_code>4599.9 & anzsic_code<4699.9
 replace sic2="II12" if anzsic_code>4699.9 & anzsic_code<5099.9
 replace sic2="II13" if anzsic_code>5099.9 & anzsic_code<5399.9
 replace sic1="II"  if anzsic_code>4599.9 & anzsic_code<5399.9
 replace agg1="Construction and Transportation" if sic1=="EE" | sic1=="II" 
 replace agg2="Construction and Transportation" if sic1=="EE" | sic1=="II" 
 
 * information media and telecommunications
 replace sic2="JJ11" if anzsic_code>5399.9 & anzsic_code<5499.9
 replace sic2="JJ12" if anzsic_code>5499.9 & anzsic_code<6099.9
 replace sic1="JJ" if anzsic_code>5399.9 & anzsic_code<6099.9
 
 * financial and insurance services (no 61)
 replace sic2="KK11" if anzsic_code>6199.9 & anzsic_code<6299.9
 replace sic2="KK12" if anzsic_code>6299.9 & anzsic_code<6399.9
 replace sic2="KK13" if anzsic_code>6399.9 & anzsic_code<6499.9
 replace sic1="KK" if anzsic_code>6199.9 & anzsic_code<6499.9
 replace agg1="Financial Industries" if sic1=="KK" 
 replace agg2="Finance" if sic2=="KK11"
 replace agg2="Insurance" if sic2=="KK12"
 replace agg2="Aux. Finance and Insurance Services" if sic2=="KK13"
 
 * rental, hiring, and real estate services
 replace sic2="LL11" if anzsic_code>6599.9 & anzsic_code<6699.9
 replace sic2="LL12" if anzsic_code>6699.9 & anzsic_code<6799.9
 replace sic1="LL" if anzsic_code>6599.9 & anzsic_code<6799.9
 replace agg2="Rental, Hiring and Real Estate Services" if sic1=="LL"
  
 * professional and administrative services
 replace sic2="MN11" if anzsic_code>6899.9 & anzsic_code<7199.9
 *replace sic2="MN21" if anzsic_code>7199.9 & anzsic_code<7399.9: we have none of these firms
 replace sic1="MN" if anzsic_code>6899.9 & anzsic_code<7399.9
 replace agg1="Professional and Financial Services" if sic1=="JJ" | sic1=="MN" | sic1=="KK" | sic1=="LL"
 replace agg2="All other professional services" if sic1=="MN" | sic1=="JJ"
 replace agg2="Legal Services" if anzsic_code==6931
 replace agg2="Accounting" if anzsic_code==6932

 drop if firmid==.
compress
notes: "Created by step100 - merge files.do"
save master_file, replace


*** remove identifiers, temp variables,  and variables not used in the paper
drop w3_manager_first_name w3_manager_surname w3_manager_position

drop  _merge?wgt*
drop _merge*
drop eb
drop w?_sic_desc*
drop w6_stocks  w6_bonds w6_infl_prot w6_cash w6_realestate w6_prec_comm w6_other_assets w6_speed_dp w6_price w6_price

drop w1_demand_ela w1_labor_supp
drop w1_ind_manuf w1_ind_fibs  w1_ind_others
drop w2_borrow_cos* 
drop w3_price_resp* w3_empl_resp* w3_wage_resp* w3_invest_res*
drop w3_fin_lit
drop w5*
drop w6_industry
drop w6_main
drop w6_edp_cust_12m
drop w6_epi_ho*
drop w6_epi_cust*
drop w7_epi_ho*
drop w7_epi_cust*
drop w2_epi_3m_ho w2_epi_12m_ho w1_epi_3m_ho w1_epi_12m_ho
drop w3_manager_af*
drop w7_industry
drop category
drop w2_output_units
drop industry_anz
drop w1_cost_elast* 
drop w1_subsector
drop subindustry
drop Industry
drop w6newfirm
drop w6_newfirm
drop anzsic_descri

compress 
save master_file_public_release, replace
