#usage: 
#./sqliteCSVprep.sh GeoLite2-Country-Blocks-IPv4.csv GeoLite2-ASN-Blocks-IPv4.csv GeoLite2-Country-Locations-en.csv > new.sql
# sqlite3 latest_geoip.db < new.sql


#$ sqlite3 latest_geoip.db "select * from GEOLITE2_COUNTRY_BLOCKS_IPV4 as BLOCKS, GEOLITE2_COUNTRY_LOCATIONS_EN as LOCS  where BLOCKS.geoname_id=1814991 and BLOCKS.geoname_id = LOCS.geoname_id"


#bugs? not really a bug, but you must check the CREATE TABLE named to ensure correct import.

dts=$(date +"%Y.%m.%d_%H.%M.%s")

for var in "$@"
do 
 #echo "$var"
 WC=$(wc -l "$var" | awk '{print $1}')
 
 TNYM=$(echo "$var" |  sed 's/\./_/g ; s/\-/_/g' | awk '{print toupper($1)}')
 L01=$(head -n 1 $var)
 NFC=$(echo $L01 | awk -F',' '{print NF}')  

 echo "CREATE TABLE $TNYM ("
 echo "-- $var _ $dts _ NF=$NFC _ LC=$WC" 
 echo "-- header row __ $L01"
 L02=$(head -n 2 $var | tail -n 1 )
 L03=$(head -n 3 $var | tail -n 1 )
 echo "-- 1st data row __ $L02"
 echo "-- 2nd data row __ $L03"
 
 echo $L01 | awk -F',' 'function isnum(x){return(x==x+0)} {for (f=1; f<=NF; f++){ tExtra=","; if(f==NF){tExtra=" ";} if(isnum($f)){print $f,"INT ",tExtra}else{ print $f,"TEXT ",tExtra}}}' 
 echo $L02 | awk -F',' 'function isnum(x){return(x==x+0)} {for (f=1; f<=NF; f++){ tExtra=","; if(f==NF){tExtra=" ";} if(isnum($f)){print "-- ",$f,"INT ",tExtra}else {print "-- ",$f,"TEXT ",tExtra}}}'

 echo "); -- end table"
 filenohdr="$var"_nohdr.csv
 tail -n +2 "$var" > $filenohdr
 echo ".mode csv"
 echo ".import $filenohdr $TNYM"

done

echo "-- Tables in the database:"
echo .tables