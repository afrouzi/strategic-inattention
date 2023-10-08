clear all 
set more off

capture cd "C:\Dropbox\Firm Survey\HigherOrderExpectations\QJE Final\replication\workfiles"

use workfile_QJE, clear

encode w8_exper_group, gen(w8_exper_groupN)

		
twoway (hist w8_kguess if w8_kguess_timetrack>=20, start(0) w(1)) ///
	(hist w8_kguess if w8_kguess_timetrack<20, start(0) w(1) fcolor(none) lcolor(black)) ///
		, legend(label(1 "response time >=20 seconds") ///
				 label(2 "response time <20 seconds") rows(2) ring(0) position(1)) ///
		graphregion(color(white)) bgcolor(white) ///
		xtitle("Guess") ///
		xlabel(0(10)100) ///
		text(0.34 33 "K=1", color(red)) ///
		text(0.255 23 "K=2", color(red)) ///
		text(0.21 15 "K=3", color(red)) ///
		text(0.18 10 "K=4", color(red)) ///
		text(0.05  6 "K=5", color(red)) 
		
