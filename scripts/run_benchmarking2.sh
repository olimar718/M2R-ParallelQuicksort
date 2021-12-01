
OUTPUT_DIRECTORY=data/`hostname`_`date +%F`
mkdir -p $OUTPUT_DIRECTORY
OUTPUT_FILE=$OUTPUT_DIRECTORY/measurements_`date +%R`.csv

touch $OUTPUT_FILE
        
# scheduler settings
sudo renice --priority -19 --pid $BASHPID > /dev/null
echo "Size, TimeSeq, TimePar,TimeBuiltIn, CPU_USAGE,RAM_USAGE,STORAGE_USAGE,N_PROCESS, ON_BATTERY,TEMPERATURE,CPU_GOVERNOR " >> $OUTPUT_FILE
for i in $(seq 1 5); do
    for j in $(seq 0 1000000 10000000) ; do
        echo -n "$j" >> $OUTPUT_FILE
        ./src/parallelQuicksort $j >> $OUTPUT_FILE
        
        
        # Collection metadata
        # cpu usage https://unix.stackexchange.com/questions/69167/bash-script-that-print-cpu-usage-diskusage-ram-usage
        echo -n  ,`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'` >> $OUTPUT_FILE
        
        # ram usage 
	FREE_DATA=`free -m | grep Mem` 
	CURRENT=`echo $FREE_DATA | cut -f3 -d' '`
	TOTAL=`echo $FREE_DATA | cut -f2 -d' '`
	echo -n ,$(echo "scale = 2; $CURRENT/$TOTAL*100" | bc)>> $OUTPUT_FILE
	# hdd usage
	echo -n ,`df -lh | awk '{if ($6 == "/") { print $5 }}' | head -1 | cut -d'%' -f1`>> $OUTPUT_FILE
	# number of processes
	echo -n ,$(ps aux | wc -l)>> $OUTPUT_FILE
	# on battery or not
	echo -n , >> $OUTPUT_FILE
	upower -i `upower -e | grep 'BAT'` |grep 'state' | sed "s/state://g" | tr -d '\n' | xargs | tr -d '\n'>> $OUTPUT_FILE
	# Temperature https://askubuntu.com/questions/779819/cpu-temperature-embedded-in-bash-command-prompt
	echo -n  ,$(sensors | grep -oP 'CPU Die Core Temp.*?\+\K[0-9.]+')>> $OUTPUT_FILE

	# cpu governor https://unix.stackexchange.com/questions/182696/how-to-get-current-cpupower-governor  (here we assume that the governor is the case accross all cores, which is probably the case)
	echo ,$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)>> $OUTPUT_FILE
    done
done
