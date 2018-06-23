#!/bin/bash
#
# scan system files and generate a /tmp/gpiosetup readable folder for all PWM's files
#
GPIOSF=/tmp/gpiossetup  # demistified paths
PWMF=/tmp/pwmsetup      # demistified paths 

[[ -f $PWMF ]] && exit
touch $PWMF
sync
pushd /sys/class/pwm
idx=0
pwms=(20000     20000    20000    20000    20000    20000    20000) # pwm freq
dutys=( 0       0        0        0        0        0        0)     # initial duty
expo=(  0       1        0        1        0        1        0)     # pwm 0 or 1 from data sheet 
right=(48302200 48302200 48300100 48300200 48300200 48304200 48304200)

for p in P9.14  P9.16    P9.42    P9.21    P9.22    P8.13    P8.19;do
    config-pin $p pwm
    for link in $(ls -l | awk '{print $11}');do
        if [[ $link =~ ${right[$idx]} ]];then
            #echo $link
            #echo "sys folder for $p is $(echo $link | awk -F '/' '{print $NF}')"
            sysfld=$(echo $link | awk -F '/' '{print $NF}')
            pushd $sysfld
                echo ">"$(pwd)   exporting: ${expo[$idx]}"<"
                ex=${expo[$idx]}
                echo $ex > unexport
		sync
                echo $ex > export
                if [[ -d "pwm$ex" ]];then
                    echo $(pwd) $p  $ex >> $PWMF
                    echo ${pwms[$idx]} > "pwm$ex/period"
                    echo ${dutys[$idx]} > "pwm$ex/duty_cycle"
                    echo "1" > "pwm${ex}/enable"
                    #echo $(pwd)/pwm$ex/
                else
                    echo "? cannot export ($pwd)" >> $ERRORF
                fi
            popd
        fi
        sleep 0.2
    done
    idx=$((idx+1))
    sleep 0.2
done
popd
