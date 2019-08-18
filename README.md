# sqliteCSVprep.sh
a bash script that uses awk and sed to create an sqlite database from "n" CSV files

Created to build an SQLITE database file from MAXMIND GeoLite2 CSV files. 

Will work with any CSV files. 

Instructions:
= obtain CSV files that have a header row
= download this script and make it executable
= pass "n" CSV files to the script
= view the output; pipe to a file to save the output
= create the DB using the command: sqlite3 dbname.db < myoutput.sql
