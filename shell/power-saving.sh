# NMI watchdog should be turned off
# 
for foo in /proc/sys/kernel/nmi_watchdog;
  do echo 0 > $foo;
done

# Set SATA channel to power saving
for foo in /sys/class/scsi_host/host*/link_power_management_policy;
  do cat $foo;
  #do echo min_power > $foo;
done

# Select Ondemand CPU Governor
for foo in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor;
  do cat $foo;
  #do echo ondemand > $foo;
done

# Activate USB autosuspend
for i in /sys/bus/usb/devices/*/power/autosuspend; do echo 5 > $i; done 
#for foo in /sys/bus/usb/devices/*/power/level;
#  do echo auto > $foo;
#done

# Activate PCI autosuspend
#for foo in /sys/bus/pci/devices/*/power/control;
#  do echo auto > $foo;
#done
