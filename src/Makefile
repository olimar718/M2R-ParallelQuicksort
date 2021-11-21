parallelQuicksort: parallelQuicksort.o



CFLAGS = -Wall -O3 -pthread -lrt -std=c99 

%: %.o
	$(CC) $(INCLUDES) $(DEFS) $(CFLAGS) $^ $(LIBS) -o $@ 

%.o: %.c
	$(CC) $(INCLUDES) $(DEFS) $(CFLAGS) -c -o $@ $<

clean:
	rm -f parallelQuicksort *.o *~
