#! /bin/bash
#===============
HOFF=9
VOFF=29 # offset
FONTBLKX=7 # terminal font block size x
FONTBLKY=15 # terminal font block size Y
SCREENBLKSZX=67 # divide screen horizontally in 4 columns each of size 52 terminal columns
SCREENBLKSZY=22 # divide screen vertically in 3 rows each of size 19 terminal rows

BPOSX=(0 0 0 0) # x coordinate of screen block positions array
BPOSY=(0 0 0) # y coordinate of screen block positions array

# Window position and size as logical blocks
#=================

opts=$1
wpos_new_x=0
wpos_new_y=0
wsz_new_x=4
wsz_new_y=3

wpos_cur_x=0
wpos_cur_y=0
wsz_cur_x=1
wsz_cur_y=1
#=================

# Window position and size in pixel
#=================
xpos=(0 0 0 0)
ypos=(0 0 0)
xsz=(0 0 0 0 0)
ysz=(0 0 0 0)

xpos_cur=0
ypos_cur=0
xsz_cur=0
ysz_cur=0
xpos_new=0
ypos_new=0
xsz_new=0
ysz_new=0
#=================

p1=$1
p2=$2
p3=$3
p4=$4
p5=$5
p6=$6

basic_calculation()
{
    # Basic calculations =======================================


    #BPOSX array
    i=0
    while [ $i -lt 4 ];
    do
        BPOSX[i]=$((i*(SCREENBLKSZX+1)))
        i=$((i+1))
    done
    #BPOSY array
    i=0
    while [ $i -lt 4 ];
    do
        BPOSY[i]=$((i*(SCREENBLKSZY+1)))
        i=$((i+1))
    done

    #xpos array
    i=0
    while [ $i -lt 4 ];
    do
        xpos[i]=$((HOFF + BPOSX[i]*FONTBLKX))
        i=$((i+1))
    done
    #ypos array
    i=0
    while [ $i -lt 3 ];
    do
        ypos[i]=$((VOFF + BPOSY[i]*FONTBLKY))
        i=$((i+1))
    done
    #xsz array
    i=0
    while [ $i -lt 5 ];
    do
        xsz[i]=$(((SCREENBLKSZX + 1)*FONTBLKX*i-FONTBLKX+4))
        i=$((i+1))
    done
    xsz[0]=${xsz[4]}
    #ysz array
    i=0
    while [ $i -lt 4 ];
    do
        ysz[i]=$(((SCREENBLKSZY + 1)*FONTBLKY*i-FONTBLKY+4))
        i=$((i+1))
    done
    ysz[0]=${ysz[3]}
    #xpos=$((HOFF + BPOSX[wpos_new_x]*FONTBLKX))
    #ypos=$((VOFF + BPOSY[wpos_new_y]*FONTBLKY))
    #xsz=$(((SCREENBLKSZX + 1)*FONTBLKX*wsz_new_x-FONTBLKX+4))
    #ysz=$(((SCREENBLKSZY + 1)*FONTBLKY*wsz_new_y-FONTBLKY+4))

    # Basic Calculation end ==================================
    echo "Basic calcs end"
}

win_prop_cur_logical()
{
    while [ $xpos_cur -ge ${xpos[$((wpos_cur_x+1))]} ];
    do
        wpos_cur_x=$((wpos_cur_x+1))
    done
    while [ $ypos_cur -ge ${ypos[$((wpos_cur_y+1))]} ];
    do
        wpos_cur_y=$((wpos_cur_y+1))
    done
    while [ $xsz_cur -gt ${xsz[$((wsz_cur_x))]} ];
    do
        wsz_cur_x=$((wsz_cur_x+1))
    done
    while [ $ysz_cur -gt ${ysz[$((wsz_cur_y))]} ];
    do
        wsz_cur_y=$((wsz_cur_y+1))
    done
    echo "-$wpos_cur_x-$wpos_cur_y-$wsz_cur_x-$wsz_cur_y===="
}

win_prop_cur_px()
{
    # Properties of current window =================================

    wid=$(xdotool getactivewindow)

    eval $(xwininfo -id $(xdotool getactivewindow) |
        sed -n -e "s/^ \+Absolute upper-left X: \+\([0-9]\+\).*/xpos_cur=\1/p" \
            -e "s/^ \+Absolute upper-left Y: \+\([0-9]\+\).*/ypos_cur=\1/p" \
           -e "s/^ \+Width: \+\([0-9]\+\).*/xsz_cur=\1/p" \
            -e "s/^ \+Height: \+\([0-9]\+\).*/ysz_cur=\1/p" )

    echo "$xpos_cur $ypos_cur $xsz_cur $ysz_cur $wid"

    # Properties of current window end =============================
}

win_prop_new_logical()
{
    wpos_new_x=$wpos_cur_x
    wpos_new_y=$wpos_cur_y
    wsz_new_x=$wsz_cur_x
    wsz_new_y=$wsz_cur_y
    case $p1 in
        px)
            case $p2 in
                i)
                    wpos_new_x=$((wpos_new_x+1))
                    ;;
                d)
                    wpos_new_x=$((wpos_new_x-1))
                    ;;
                *)
                    echo "incorrect parameters5"
                    ;;
            esac;;
        sx)
            case $p2 in
                i)
                    wsz_new_x=$((wsz_new_x+1))
                    ;;
                d)
                    wsz_new_x=$((wsz_new_x-1))
                    ;;
                *)
                    echo "incorrect parameters4"
                    ;;
            esac
            ;;
        py)
            case $p2 in
                i)
                    wpos_new_y=$((wpos_new_y+1))
                    ;;
                d)
                    wpos_new_y=$((wpos_new_y-1))
                    ;;
                *)
                    echo "incorrect parameters3"
                    ;;
            esac
            ;;
        sy)
            case $p2 in
                i)
                    wsz_new_y=$((wsz_new_y+1))
                    ;;
                d)
                    wsz_new_y=$((wsz_new_y-1))
                    ;;
                *)
                    echo "incorrect parameters2"
                    ;;
            esac
            ;;
        s)

            wpos_new_x=$p2
            wpos_new_y=$p3
            wsz_new_x=$p4
            wsz_new_y=$p5
            ;;
        *)
            echo "incorrect parameters1"
    esac

    echo "$wpos_new_x $wpos_new_y $wsz_new_x $wsz_new_y"
}

error_check()
{

    # Basic error check =======================================
    if [ $((wpos_new_x)) -gt 3 ];
    then
        wpos_new_x=3
    fi
    if [ $((wpos_new_y)) -gt 2 ];
    then
        wpos_new_y=2
    fi
    if [ $((wpos_new_x + wsz_new_x)) -gt 4 ]; then
        wsz_new_x=$((4 - wpos_new_x))
    fi
    if [ $((wpos_new_y + wsz_new_y)) -gt 3 ]; then
        wsz_new_y=$((3 - wpos_new_y))
    fi
    if [ $((wsz_new_x)) -lt 1 ];
    then
        wsz_new_x=1
    fi
    if [ $((wsz_new_y)) -lt 1 ];
    then
        wsz_new_y=1
    fi
    if [ $((wpos_new_x)) -lt 0 ];
    then
        wpos_new_x=0
    fi
    if [ $((wpos_new_y)) -lt 0 ];
    then
        wpos_new_y=0
    fi
    echo "$wpos_new_x $wpos_new_y $wsz_new_x $wsz_new_y"
}

win_prop_new_px()
{
    xpos_new=${xpos[wpos_new_x]}
    ypos_new=${ypos[wpos_new_y]}
    xsz_new=${xsz[wsz_new_x]}
    ysz_new=${ysz[wsz_new_y]}
}



tile()
{

    # Command starts =========================================

    cmdp="xdotool getactivewindow windowmove $xpos_new $ypos_new"
    cmds="xdotool getactivewindow windowsize $xsz_new $ysz_new"

    #echo ${xpos[*]}
    #echo ${ypos[*]}
    #echo ${xsz[*]}
    #echo ${ysz[*]}
    echo $cmdp
    echo $cmds
    eval $cmdp
    eval $cmds
    return 0
}

echo $2

basic_calculation
win_prop_cur_px
win_prop_cur_logical
win_prop_new_logical
error_check
win_prop_new_px
tile
