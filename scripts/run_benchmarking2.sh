
OUTPUT_DIRECTORY=data/`hostname`_`date +%F`
mkdir -p $OUTPUT_DIRECTORY
OUTPUT_FILE=$OUTPUT_DIRECTORY/measurements_`date +%R`.txt

touch $OUTPUT_FILE
for i in $(seq 1 5); do
    for j in $(seq 0 1000000 10000000) ; do
        echo "Size: $j" >> $OUTPUT_FILE;
        ./src/parallelQuicksort $j >> $OUTPUT_FILE;
        
    done
done