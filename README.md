# Obsolete for kernel 4.14.108-ti-r108.
## Check new pin mapping at the forum @ https://www.redypis.org


## bbb-sysscan

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


The path for a PX.Y pin is /sys/class/pwm/pwmchipV/pwmW/<duty_cycle|export|polarity|period|enable>

where
    W is last column digit for ginve PX.Y

A crude C implementation would be

``` code javascript  

std::string get_pwm_path(const char* pin /*"P8.13"*/)
{
    std::string fname;
    std::string temp;
    char        pwmline[128];
    FILE*       pf = ::fopen("/tmp/pwmsetup", "rb");
    while(!::feof(pf))
    {
            ::fgets(pwmline, sizeof(pwmline)-1, pf);
            char* eol = ::strchr(pwmline,'\n');
            if(eol)  *eol=0;
            if(feof(pf))  break;
            if(::strstr(pwmline,   pin))
            {
                temp = ::strtok(pwmline," ");
                temp += "/";
                fname = temp;
                temp = ::strtok(0, " ");
                fname += "pwm";
                temp = ::strtok(0," ");
                fname += fname;
                fname += "/";
                break;
            }
        }
    }
    return fname;
}

```




