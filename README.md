# bbb-sysscan
## Beagle Bone sys scanner to resolve PWM and GPIO pins paths and files

    - Scans sys folder and geerate /tmp/gpiosetup file with following content.
      - path for the pwm file, which pwm pin and which file

``` code console
/sys/class/pwm/pwmchip3 P9.14 0
/sys/class/pwm/pwmchip3 P9.16 1
/sys/class/pwm/pwmchip0 P9.42 0
/sys/class/pwm/pwmchip1 P9.21 1
/sys/class/pwm/pwmchip1 P9.22 0
/sys/class/pwm/pwmchip6 P8.13 1
/sys/class/pwm/pwmchip6 P8.19 0
```
