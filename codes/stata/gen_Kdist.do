/****************************************************************************************************
* Afrouzi(2023): Strategic Inattention, Inflation Dynamics and the Non-Neutrality of Money
* Generate Distribution of the Number of Competitors for Calibration
*****************************************************************************************************/

* Graph specs
grstyle init
grstyle set plain
graph set eps fontface "Palatino"

* Import data and rename variables
use "$workingdir/master_file_processed.dta", clear

drop if w6_competitors == .

contract w6_competitors

* Step 1: Determine the minimum and maximum values of K.
summarize w6_competitors, detail

* Store min and max values for later use.
local minK = r(min)
local maxK = r(max)

* Step 2: Create a loop that iterates through every integer between minK and maxK.
forvalues i = `minK'/`maxK' {
    * Step 3: Check if i exists in the dataset.
    count if w6_competitors == `i'
    
    * Step 4: If i does not exist in the dataset, then add i to K and set _freq of i to 0.
    if r(N) == 0 {
        * Adding a new observation with K = i and _freq = 0.
        set obs `=_N+1'
        replace w6_competitors = `i' in `=_N'
        replace _freq = 0 in `=_N'
    }
}

sort w6_competitors

* First, calculate the total sum of _freq.
egen total_freq = total(_freq)

* generate the shares variable by dividing _freq by total_freq.
generate shares = _freq / total_freq

keep shares

* Specify the path and name of the CSV file to be created.
export delimited "$workingdir/shares.csv", replace


