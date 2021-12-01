parallelQuicksort: parallelQuicksort.o



CFLAGS = -Wall -O3 -pthread -lrt -std=c99 

PROFFLAGS= -pg

%: %.o
	$(CC) $(INCLUDES) $(DEFS) $(CFLAGS) $^ $(LIBS) -o $@ 

%.o: %.c
	$(CC) $(INCLUDES) $(DEFS) $(CFLAGS) -c -o $@ $<

clean:
	rm -f gmon.out parallelQuicksort profiling *.o *~

profiling:
	$(CC) $(CFLAGS) $(PROFFLAGS) *.c -o $@
	./profiling > /dev/null
	gprof profiling gmon.out > gprof.txt
