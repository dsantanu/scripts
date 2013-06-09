    POSE : Check if a password is at least 8 characters long   #
#           and have at least three (3) of these four(4) things #
# 	    * UPPERCASE 					#
#	    * lowercase						#
#	    * digits						#
#	    * one of these 4 special characters - !,@,#,$	#
# AUTHOR  : Santanu Das, London                                 #
#################################################################

while :
do
    echo -n 'Type test password: '
    
    read pw || break
    c=0

    case $pw in
    ????????*)

        case $pw in
        *[A-Z]*)
            let c++
        esac

        case $pw in
        *[a-z]*)
            let c++
        esac

        case $pw in
        *[0-9]*)
            let c++
        esac

        case $pw in
        *[\!\@\#\$]*)
            let c++
        esac

        if [ $c -ge 3 ]
        then
            echo OK
        else
            echo "That password only included $c categories of characters"
        fi
        ;;
    *)
        echo "That password is shorter than 8 characters"
    esac
done

