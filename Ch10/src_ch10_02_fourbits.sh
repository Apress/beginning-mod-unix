readonly UNITY=1
readonly SYSTEM_CYGWIN=$(( UNITY<<0 ))  # 1     % Exclusive bits:   %
readonly SYSTEM_LINUX=$(( UNITY<<1 ))   # 2     % only one of these %
readonly SYSTEM_FREEBSD=$(( UNITY<<2 )) # 4     % three can be on   %
readonly VM=$(( UNITY<<3 ))             # 8

machtype=0                              # begin with all bits off
system=`uname -s`

if echo $system | grep -i Cygwin; then
    machtype=${SYSTEM_CYGWIN}

    model=`systeminfo | grep -i "System Model" | \
    awk -F : '{print $2}' | sed 's/^[[:space:]][[:space:]]*//'`

    [ "$model" = "VirtualBox" ] && machtype=$(( machtype | VM ))
else
    if [ $system = "Linux" ]; then
        machtype=${SYSTEM_LINUX}

        if cat /proc/cpuinfo | grep '^\<flags\>' | grep -qw hypervisor; then
            machtype=$(( machtype | VM ))
        fi
    else
        if [ $system = "FreeBSD" ]; then
            machtype=${SYSTEM_FREEBSD}
                    
            vmode=`sysctl -a | grep 'kern.vm_guest' | \
            awk -F : '{print $2}' | sed 's/^[[:space:]][[:space:]]*//'`

            [ "$vmode" != "none" ] && machtype=$(( machtype | VM ))
        fi
    fi
fi
