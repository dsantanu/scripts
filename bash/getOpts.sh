#!/bin/bash -E

#########################################################################################
# DESCRIPTION : When getopts looks for an argument, it literally takes the next one	#
#		(to an option), even if it's another option. This script stops that	# 
#		if that not desired. Using this, both '-c  -f' and '-c "    "' will 	#
#		report 'Missing argument for that particular option.
# AUTHOR      :	Santanu Das
#
#

function ifEmpty()
{
    local VAL=$1
    local OPT=$2

    [[ -z "${VAL}" || "${VAL}" =~ ^[[:space:]]*$ || "${VAL}" == -* ]] \
    && { echo -e "\n  ERROR: Missing argument for option: -${OPT}\n" >&2; exit 1; }
}

function optsGet()
{
    while getopts ":c:h:f" opt; do
        case $opt in
            c ) ifEmpty "${OPTARG}" "${opt}"
                CiNAME=${OPTARG//[[:space:]]}".tEsTsTr"
                ;;
            h ) ifEmpty "${OPTARG}" "${opt}"
                HiNAME=${OPTARG//[[:space:]]}
                ;;
            f ) FORCE=true
                ;;
            \?) echo -e "Invalid option: -$OPTARG\n" >&2;;
            : ) echo -e "Missing argument for option: -$OPTARG\n" >&2; exit 1;;
            * ) echo -e "Unimplemented option: -$OPTARG\n" >&2; exit 1;;
        esac
    done

    shift $((OPTIND - 1))
}

optsGet "${@}"
echo -e "CNAME: ${CiNAME:-Not Given}"
echo -e "HNAME: ${HiNAME:-Not Given}"
