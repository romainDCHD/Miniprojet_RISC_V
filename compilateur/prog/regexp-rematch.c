#include <stdlib.h>
#include <stdio.h>

#include "../include/pyas/regexp.h"
#include "../include/unitest/unitest.h"
#include "../include/pyas/char_group.h"
#include "../include/pyas/string.h"


int main(int argc, char* argv[]) {
    if ( argc < 3 ) {
        fprintf( stderr, "Usage :\n\t%s regexp text\n", argv[ 0 ] );
        exit( EXIT_FAILURE );
    }

    string_t end;
    string_new(&end, "", 0);
    regexp_t reg = regexp_new(string_convert(argv[1]),string_convert(argv[1]));
    int is_match = re_match( reg, string_convert(argv[ 2 ]), &end );
    if ( is_match ) {
        printf( "The start of '%s' is %s, %s: '", argv[2], argv[ 1 ], string_length(end) ? "next" : "END");
        string_print(end);
        printf("'.\n");
    }
    else {
     printf( "The start of '%s' is *NOT* %s.\n", argv[2], argv[ 1 ] );
    }
    
    regexp_free(reg);

    exit( EXIT_SUCCESS );
}