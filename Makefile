#  ?= means that if CC not define then CC = gcc , otherwise CC = default
CC ?= gcc 
CFLAGS_common ?= -Wall -std=gnu99
# -O0(no optimzation), -O1(default), -O2, -O3(best optimization, but increase compile time)
CFLAGS_orig = -O0
CFLAGS_opt  = -O0

EXEC = phonebook_orig phonebook_opt
all: $(EXEC)

SRCS_common = main.c

# target: dependencies
# <Tab>Commands
# $@ means target name, $< means the first dependency in the rule
phonebook_orig: $(SRCS_common) phonebook_orig.c phonebook_orig.h
	$(CC) $(CFLAGS_common) $(CFLAGS_orig) \
		-DIMPL="\"$@.h\"" -o $@ \
		$(SRCS_common) $@.c

phonebook_opt: $(SRCS_common) phonebook_opt.c phonebook_opt.h
	$(CC) $(CFLAGS_common) $(CFLAGS_opt) \
		-DIMPL="\"$@.h\"" -o $@ \
		$(SRCS_common) $@.c

run: $(EXEC)
	echo 3 | sudo tee /proc/sys/vm/drop_caches
	# watch : executes function every two seconds
	watch -d -t "./phonebook_orig && echo 3 | sudo tee /proc/sys/vm/drop_caches"

cache-test: $(EXEC)
	perf stat --repeat 100 \
		-e cache-misses,cache-references,instructions,cycles \
		./phonebook_orig
	perf stat --repeat 100 \
		-e cache-misses,cache-references,instructions,cycles \
		./phonebook_opt

output.txt: cache-test calculate
	./calculate

plot: output.txt
	gnuplot scripts/runtime.gp

calculate: calculate.c
	# gcc -Wall -std=gnu99 calculate.c -o calculate
	$(CC) $(CFLAGS_common) $^ -o $@

# .PHONY specifies 'clean' as a fake item, so that the file name 'clean' will not be built
.PHONY: clean
clean:
	$(RM) $(EXEC) *.o perf.* \
	      	calculate orig.txt opt.txt output.txt runtime.png
