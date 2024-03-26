#!/bin/bash


help() {
    echo ""
    echo "Program purpose: Processing the provided text into a bag of words model."
    echo "Bag of words is a model that disregards the order of words but counts their occurrences."
    echo "Thanks to this, we can determine the general topic of the text and compare it to others."
    echo "This model is used in NLP (Natural Language Processing) and IR (Information Retrieval)."
    echo ""
    echo "To run the program, use ./bash_simple_bag_of_words.sh 'filename to process', optionally"
    echo "adding one of the options. It is important that the filename contains the '.txt' extension "
    echo "as the program checks whether it will be able to handle the given file based on it."
    echo ""
    echo "Options: The program has two available options: -h/--help which you just used, and -log, which causes"
    echo "the program to write words and their counts to the file 'filename'_results.txt instead of printing them to the screen."
    echo "The program ignores unknown parameters."
    echo ""
    echo "The program will inform the user if: they forget to provide a file, provide an incorrect file name, have incorrect"
    echo "character encoding set, or if the result file for the current file already exists."
    echo ""
    exit 0
}

for opcja in "$@"; do
  if [[ "$opcja" == "-h" ]]  || [[ "$opcja" == "--help" ]]; then
    help
  fi 
done

for opcja in "$@"; do
  if [[ "$opcja" == "-log" ]]; then
     echo ""
     echo "Option to save to file chosen"
     logowanie_do_pliku="true" 
  fi 
done



if [ -z $1 ]; then
    echo "File not provided"
    exit 1
fi


if [[ "$1" == *.txt ]]; then
    echo "The file is in the correct .txt format"
else
    echo "The file is not in the correct format or lacks the proper extension."
    echo "File name: $1"
    exit 1
fi


kodowanie=$(file -i "$1" | grep -o 'charset=[^;]*')
kodowanie="${kodowanie/'charset='/}"
if [ -n "$kodowanie" ]; then
    echo "Your file is using encoding: $kodowanie"
    if [ "$kodowanie" = "utf-8" ]; then
       echo "This is the correct encoding"
    else
	echo "This is not the correct encoding, try a file encoded in utf-8"
	exit 1
    fi
else
    echo "I couldn't find information about how the file is encoded."
    exit 1
fi



if [ ! -f "$1" ]; then
    echo -n "I can't find this file: "
    echo $1
    echo "Make sure you provided me with the correct name"
    echo ""
    exit 1
else
    echo -n "I found the file: "
    echo $1
fi

declare -A licznik_slow


tekst=`cat $1`
przefiltrowany="$(echo -n "$tekst" | tr -d ',.0123456789!?()[]{}"')"
przefiltrowany="${przefiltrowany,,}"


for slowo in $przefiltrowany; do

    if [[ -z "${licznik_slow["$slowo"]}" ]]; then
	licznik_slow["$slowo"]=1
    else
	licznik_slow["$slowo"]=$((licznik_slow["$slowo"] + 1))
    fi    
done


najwiecej_wystapien=0
for i in "${!licznik_slow[@]}"
do
  if [ "${licznik_slow[$i]}" -gt "$najwiecej_wystapien" ]; then
      najwiecej_wystapien=${licznik_slow[$i]}
  fi  
done

if [[ "$logowanie_do_pliku" == "true" ]]; then 

    poczatek=$(echo "$1" | tr -d '.')
    koncowka="_wyniki.txt"
    nazwa_pliku="$poczatek$koncowka"
    if [ -f "$nazwa_pliku" ]; then
	echo "File $nazwa_pliku already exists, please delete it"
	echo ""
	exit 1
    fi
    echo "Creating file called: $nazwa_pliku"
    for ((licznik = $najwiecej_wystapien; licznik >= 1; licznik--)); do

       for i in "${!licznik_slow[@]}"
       do
	   if [ "${licznik_slow[$i]}" = $licznik ]; then
	       echo -n "Word: $i | " >> "$nazwa_pliku"
	       echo "${licznik_slow[$i]}" >> "$nazwa_pliku"
	   fi
       done
    done


else
    
    for ((licznik = $najwiecej_wystapien; licznik >= 1; licznik--)); do

	for i in "${!licznik_slow[@]}"
	do
	    if [ "${licznik_slow[$i]}" = $licznik ]; then
        	printf "Word: %-20s | " "$i"
		echo "${licznik_slow[$i]}"
	    fi
	done
    done
fi




