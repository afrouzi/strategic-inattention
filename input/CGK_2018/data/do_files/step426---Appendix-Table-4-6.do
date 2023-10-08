
clear all
set more off
cd "C:\Dropbox\Firm Survey\AER-final\replication_folder\workfiles"
use master_file_public_release, clear

tabulate w4_ssatt_good w4_ssatt_bad [aw=w4_wgtE_43], nofreq cell
