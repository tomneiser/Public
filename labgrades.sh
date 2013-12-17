#!/bin/bash

##  -------------------------------------------------------------------------------
##  If you've downloaded the roster as an excel file and entered the grades there, this script will create formatted files for each lab to allow uploading to MyUCLA.
##  This script takes a somewhat special "Workbook1.txt" as argument: You can create it by copying the gradebook body into a new excel file and deleting the three adjacent columns containing students' e-mail, major and section as they will not be required. Save as a tab-delimited text file "Workbook1.txt" and move to the same directory as this script. The first line should be of the format: UID <tab> "Joe Bruin" <tab> # <tab> # etc.
##  Run this script from a Unix command line, "IP:Directory user$ bash this_script.sh"
##  For the nth Lab on MyUCLA, upload (n-1).txt
##  -------------------------------------------------------------------------------

##  To do:
##  remove empty lines by code, not by hand
##  -------------------------------------------------------------------------------


OLD_IFS="$IFS"                          # secure default IFS
IFS=$'\t'                               # new IFS only listens to tabs


rm -f grades.txt                        # remove previous versions of grades.txt
cp -f Workbook1.txt grades.txt          # copy Workbook1 for manipulation

roster=($(cat grades.txt))              # read grades into array

echo "How many students do you have?"
read students
echo "How many labs were completed?"
read labN
echo "OK. Creating files."

c=$labN+2                               # number of colums in grade array


## remove previous instances of lab files
for ((i=0; i< $labN; ++i)); do
    rm -f $i.txt
done

## reformat array into labN small files for uploading: UID <tab> Name <tab> grade
for ((i=0; i< $labN; ++i)); do

    for ((n=0; n< $students; ++n)); do

        echo    ${roster[0+$n*($c)]}    ${roster[1+$n*($c)]}    ${roster[2+$i+$n*($c)]} >> temp1.txt
    done

sed -e '/^$/d' temp1.txt > temp2.txt    # remove empty lines (not yet working)
sed -e 's/\"/	/g' temp2.txt > $i.txt  # replace quotes by tabs, bundle grades into file

rm -f temp1.txt                         # clear temp files for reuse
rm -f temp2.txt

done

IFS="$OLD_IFS"                          # return IFS to default value