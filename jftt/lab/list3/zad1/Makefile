main: parser.y scanner.l
	bison -d -o parser.c parser.y
	flex -o scanner.c scanner.l
	gcc -o calc parser.c scanner.c -lfl

clean:
	rm scanner.c parser.c parser.h calc
