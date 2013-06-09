#!/bin/env bash

#################################################################
# PURPOSE : Check if a number is prime or not			#
#           Finds all the Prime numbers in a range		#
# USAGE   : prime.sh <int1> [int2]				#
# AUTHOR  : Santanu Das, London					#
#################################################################

## Exit due to fatal program error
function onExit() 
{
   local exit_status=${1:-$?}
   echo Exiting $(basename $0) with error: $exit_status 1>&2
   exit $exit_status
}
trap onExit ERR 

## Color code
ErroR=$(echo -e '\E[0;31m'"\\n\033[1m[ ERROR ]\\t\033[0m")
InfO=$(echo -e '\E[0;32m'"\\n\033[1m[ INFO ]\\t\033[0m")
WarN=$(echo -e '\E[1;33m'"\\n\033[1m[ WARNING ]\\t\033[0m")

## Integer Validation
function intCHK() 
{
    local d=$1
    input=$(echo $d | /usr/bin/python -c "print raw_input().isdigit()")
}

## Check if a given number is prime 
function primeCHK() 
{
    local i=2 
    local d=$1
    local s=$(echo "sqrt($d)" | bc)
    prime="yes"

    while [ $i -le $s ]
    do
        if [ $(((d/i)*i)) -eq $d ]; then
            prime="no"
            p=$(factor $d | sed -e 's/^[[:digit:]]*: //' -e 's/[ ]+*/*/g')
            break
        else
            prime="yes"
        fi  
        let i++ 
    done
}

## Usage: Input validation
if [ $# -lt 1 ]; then
    echo -en "${ErroR}"; echo "Too few parameters...."
    echo -e "\t\tUsage: $0 <int1> [int2]\n"
    exit 1

## Check on a single number
elif [ $# -eq 1 ]; then
    intCHK $1
    if [ $input != "True" ]; then
        echo -en "${ErroR}"; echo "Not a valid digit. Try again!!"
        exit 1
    else
        # A Prime must be bigger than 1
        if [ $1 -lt 2 ]; then
            echo -en "${Error}"; echo -e "A Prime number must be bigger than 1!\n"
            exit 1
        fi

        # 
        primeCHK $1
        if [ "$prime" == "yes" ]; then
            echo -en "${InfO}"; echo -e "$1 is a PRIME number.\n" 
        else
            echo -en "${InfO}"; echo -e "$1 ($p) is NOT a prime nmber.\n"
        fi
    fi
    exit 0

## Check on a range of numbers
else
    if [ $# -gt 2 ]; then
        echo -en "${WarN}"; echo -e "Too many arguments!!\n\t\tTaking only first two entries...\n" 
    fi

    # define the array
    a=( )
    en="$2" && en=$(( ${#en}+1 ))
    count=1

    for ix in $(eval echo {"$1".."$2"}); do
        primeCHK $ix

        [ "$prime" == "yes" ] && a[${#a[*]}]=$ix && printf "%$(echo $en)d " $ix && let count++
        [ $count -eq 7 ] && count=1 &&  echo
        let ix++

    done
fi

#echo "COUNT: ${#a[@]}"
[ ${#a[@]} -lt 1 ] && { echo -e "\nThere is no prime number in the range!\n"; exit 0; }
s=$(printf "\n%-40s" "-") && echo "${s// /-}"
#echo -e "There are ${#a[@]} Prime numbers in the range.\n" && exit 0
echo -en "There are "; echo -e '\E[1;34m'"\033[1m${#a[@]}\033[0m Prime numbers in the range.\n" && exit 0
