
OUTPUT_DIRECTORY=data/`hostname`_`date +%F`
mkdir -p $OUTPUT_DIRECTORY
OUTPUT_FILE=$OUTPUT_DIRECTORY/measurements_`date +%R`.txt

touch $OUTPUT_FILE
for i in $(seq 1 5); do
    for j in $(seq 0 1000000 10000000) ; do
        echo "Size: $j" >> $OUTPUT_FILE;
        # scheduler settings
	sudo renice --priority -19 --pid $BASHPID > /dev/null
        # ./src/parallelQuicksort $j >> $OUTPUT_FILE;
        
        # Collection metadata
        # cpu usage https://unix.stackexchange.com/questions/69167/bash-script-that-print-cpu-usage-diskusage-ram-usage
        echo CPU: `top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'` 
        
        # ram usage 
	FREE_DATA=`free -m | grep Mem` 
	CURRENT=`echo $FREE_DATA | cut -f3 -d' '`
	TOTAL=`echo $FREE_DATA | cut -f2 -d' '`
	echo RAM: $(echo "scale = 2; $CURRENT/$TOTAL*100" | bc)
	# hdd usage
	echo HDD: `df -lh | awk '{if ($6 == "/") { print $5 }}' | head -1 | cut -d'%' -f1`
	# number of processes
	echo PROCESS: $(ps aux | wc -l)
	# on battery or not
	upower -i `upower -e | grep 'BAT'` |grep 'state' | sed "s/state/BATTERY_STATE/g"
	# Temperature https://askubuntu.com/questions/779819/cpu-temperature-embedded-in-bash-command-prompt
	echo TEMPERATURE: $(sensors | grep -oP 'CPU Die Core Temp.*?\+\K[0-9.]+')

	# cpu governor https://unix.stackexchange.com/questions/182696/how-to-get-current-cpupower-governor  (here we assume that the governor is the case accross all cores, which is probably the case)
	echo CPU_GOVERNOR: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
        
    done
done
