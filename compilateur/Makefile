CFLAGS = -Wall -Wextra -std=c11 -ggdb3 -DNDEBUG -Iinclude
LFLAGS = -ldl -lm

FUNC_TESTS_SRC = $(wildcard prog/*.c)
FUNC_TESTS_BIN = $(subst prog, bin, $(FUNC_TESTS_SRC:%.c=%.exe))


SRC = $(wildcard src/*.c)
OBJ = $(SRC:%.c=%.o)
INCLUDES = $(wildcard include/*/*.h)

all : $(FUNC_TESTS_BIN) 

bin/%.exe : prog/%.o $(OBJ) $(INCLUDES)
	@mkdir -p bin
	$(CC) $(OBJ) $< $(LFLAGS) -o $@


clean :
	$(RM) $(OBJ)
	$(RM) $(FUNC_TESTS_BIN) 
	find . -name "*~" -delete
