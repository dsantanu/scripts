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
ERR=$(printf "\n%-25s" "$(echo -e "\033[1;31m[ ERROR ]\033[0m")")
WRN=$(printf "\n%-25s" "$(echo -e "\033[1;33m[ WARN  ]\033[0m")")
INF=$(printf "\n%-25s" "$(echo -e "\033[1;36m[ INFO  ]\033[0m")")
TAB=$(printf "%-14s" "$(echo)")

## Integer Validation
function intCHK() 
{
    local n=$1
    [[ -z "${n##*[!0-9]*}" ]] \
    && { echo -e "${ERR}${n}: Not a valid digit. Try again!!\n"; exit 1; } || :
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
    echo -e "${ERR}Too few argument!! \
            \n${TAB}Usage: $0 <int1> [int2]\n"
    exit 1

## Check on a single number
elif [ $# -eq 1 ]; then

    # Accept only valid number
    intCHK $1
        
    # A Prime must be bigger than 1
    if [ $1 -lt 2 ]; then
        echo -e "${ERR}A Prime number must be bigger than 1!!\n"
        exit 1
    fi

    # 
    primeCHK $1
    if [ "$prime" == "yes" ]; then
        echo -e "${INF}$1 is a PRIME number.\n" 
    else
        echo -en "${INF}$1 ($p) is NOT a prime nmber.\n"
    fi

    exit 0

## Check on a range of numbers
else
    # Input validation
    intCHK $1 && intCHK $2

    if [ $# -gt 2 ]; then
        echo -e "${WRN}Too many arguments!! \
		\n${TAB}Taking only first two entries...\n" 
    fi

    # define the array
    a=( )
    en="$2" && en=$(( ${#en}+1 ))
    count=1

    echo
    for ix in $(eval echo {"$1".."$2"}); do
        primeCHK $ix

        [ "$prime" == "yes" ] && a[${#a[*]}]=$ix && printf "%$(echo $en)d " $ix && let count++
        [ $count -eq 7 ] && count=1 &&  echo
        let ix++

    done
fi

#echo "COUNT: ${#a[@]}"
[ ${#a[@]} -lt 1 ] && { echo -e "${INF}There is NO prime number in the range!!\n"; exit 0; }

#s=$(printf "\n%-40s" "-") && echo "${s// /-}"
s=$(printf "\n%-$(echo $(( en*7)))s " "-") && echo "${s// /-}"
#echo -en "There are "; echo -e '\E[1;34m'"\033[1m${#a[@]}\033[0m Prime numbers in the range.\n" && exit 0
echo -e "${INF}There are \E[1;34m\033[1m${#a[@]}\033[0m Prime numbers in the range.\n" && exit 0
