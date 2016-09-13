#!/bin/bash

shopt -s xpg_echo

lin=`tput lines`
col=`tput cols`
pos1X=0
pos1Y=0
cc="\e[1;31m"
green="\e[38;5;47m"
orang="\e[48;5;208m"
red="\e[38;5;15m"
null="\e[0m"
count=0
tempX=0
tempY=0
crazy_mode=0

if [ $# -ne 0 ] && [ $1 -eq 1 ]
then
    crazy_mode=1
    red="\e[38;5;196m"
fi

if [ $# -ne 0 ] && [ $1 -eq 2 ]
then
    exit 0
fi

trap "{ tput cnorm; echo \"YOU CANNOT KILL A BUNNY !\"; ~/.config/config_bashrc 1; clear; exit 0; }" SIGINT SIGTERM 

# ERASE LAST BUNNY
fun_erase_bunny()
{
    tput cup ${POSY[$cur]} ${POSX[$cur]}
    tput dch 5
    tput ich 5
    tput cup $((${POSY[$cur]}+1)) ${POSX[$cur]}
    tput dch 5
    tput ich 5
    tput cup $((${POSY[$cur]}+2)) ${POSX[$cur]}
    tput dch 5
    tput ich 5
}

# PRINT CARROT
fun_print_carrot()
{
    tput sc
    tput cup $2 $1
    echo -en "${green}|"
    tput cup $(($2+1)) $1
    echo -en "${orang} $null"
    tput rc
}

fun_print_bunny()
{
    echo -en "${red}(\ /)${null}"
    tput cup $((${POSY[$cur]}+1)) ${POSX[$cur]}
    echo -en "${red}(${COLOR[$cur]}O${red}.${COLOR[$cur]}o${red})${null}"
    tput cup $((${POSY[$cur]}+2)) ${POSX[$cur]}
    echo -en "${red}(> <)${null}"
}

fun_print_big_bunny()
{
    echo -n "^___^"
    echo -n "{0_o}"
    echo -n "/)__)"
    echo -n " \" \" "
}

# UP
fun_up_bunny()
{
    tput sc
    fun_erase_bunny
    POSY[$cur]=$((${POSY[$cur]}-1))
    tput cup ${POSY[$cur]} ${POSX[$cur]}
    fun_print_bunny
    tput rc
}

# DOWN
fun_down_bunny()
{
    tput sc
    fun_erase_bunny
    POSY[$cur]=$((${POSY[$cur]}+1))
    tput cup ${POSY[$cur]} ${POSX[$cur]}
    fun_print_bunny
    tput rc
}

# LEFT
fun_left_bunny()
{
    tput sc
    fun_erase_bunny
    POSX[$cur]=$((${POSX[$cur]}-1))
    tput cup ${POSY[$cur]} ${POSX[$cur]}
    fun_print_bunny
    tput rc
}

# RIGHT
fun_right_bunny()
{
    tput sc
    fun_erase_bunny
    POSX[$cur]=$((${POSX[$cur]}+1))
    tput cup ${POSY[$cur]} ${POSX[$cur]}
    fun_print_bunny
    tput rc
}

# 256 RANDOM COLOR
fun_random_256()
{
    rand=-1
    while [ $rand -lt 0 ]
    do
        rand=$RANDOM
        let "rand %= 255"
    done
    echo $rand
}

# NEW DESTINATION
fun_get_new_destination()
{
    NEXTX[$1]=$(($RANDOM%$(($col-6))))
    NEXTY[$1]=$(($RANDOM%$((lin-4))))
    fun_print_carrot ${NEXTX[$1]} ${NEXTY[$1]}
}

cur=0;
max=1;

POSX[0]=0
POSY[0]=2
fun_get_new_destination 0
RANDX[0]=$(($RANDOM%$(($col-6))))
RANDY[0]=$(($RANDOM%$((lin-4))))
COLOR[0]="\e[38;5;"$(fun_random_256)"m"

while true;
do
    if [ $crazy_mode -ne 1 ]
    then
        sleep 0.05
    else
        sleep 0.01
    fi

    if [ $count -ge 100 ] && ( [ $max -lt 6 ] || [ $crazy_mode -eq 1 ] )
    then
        POSX[$max]=60
        POSY[$max]=2
        fun_get_new_destination $max
        RANDX[$max]=$(($RANDOM%$(($col-6))))
        RANDY[$max]=$(($RANDOM%$((lin-4))))
        COLOR[$max]="\e[38;5;"$(fun_random_256)"m"
        max=$(($max+1))
        count=0
    else
        count=$(($count+1))
    fi

    while [ $cur -lt $max ];
    do
        COLOR[$cur]="\e[38;5;"$(fun_random_256)"m"

        tput civis
        if [ ${POSY[$cur]} -lt ${NEXTY[$cur]} ]; then fun_down_bunny
        elif [ ${POSX[$cur]} -gt ${NEXTX[$cur]} ]; then fun_left_bunny
        elif [ ${POSY[$cur]} -gt ${NEXTY[$cur]} ]; then fun_up_bunny
        elif [ ${POSX[$cur]} -lt ${NEXTX[$cur]} ]; then fun_right_bunny
        else fun_get_new_destination $cur
        fi
        tput cnorm

        cur=$(($cur+1))
    done
    cur=$((${cur}%${max}))
done
