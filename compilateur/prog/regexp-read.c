#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "../include/pyas/regexp.h"
#include "../include/unitest/unitest.h"
#include "../include/pyas/char_group.h"
#include "../include/pyas/string.h"
#include "../include/pyas/list.h"

void chrgrp2str(char** str, char_group grp, char display) {   // fonction comptant le nombre de 1 dans un char_group et mettant les caractères dans un char
  int length = 1;                        // Longueur de la chaîne de caractère (init à 1 pour le caractère de fin de chaîne)
  int ptr = 0;     // Pointeur sur la chaîne de caractère (init à grp[0] car on ne le rajoute pas à la chaîne car il s'agit d'un EOS)

  for (int i = 0; i < 256; i=i+1) length = length + (grp.group[i]==display);
  *str = calloc(length, sizeof(**str));
  assert(*str);

  for (int i = 1; i < 256; i=i+1) {
    if (grp.group[i] == display) {
      (*str)[ptr] = (char)i;
      ptr++;
    }
  }
  (*str)[length-1] = '\0';
}

int main(int argc, char* argv[]) {
    if (argc < 2) exit (EXIT_FAILURE);

    string_t expr = string_convert(argv[1]);
    regexp_t regexp = regexp_new(expr, expr);
    char* str = NULL;
    for (list_t l = regexp->groups; !list_empty(l); l = list_next(l)) {
      if (cast_char_group(list_first(l)).inverse) {
        chrgrp2str(&str, cast_char_group(list_first(l)), 0);
        switch (cast_char_group(list_first(l)).operator) {
          case NOP : printf("One not in \"%s\", one time.\n",           str); break;
          case ZOM : printf("One not in \"%s\", zero or more times.\n", str); break;
          case OOM : printf("One not in \"%s\", one or more times.\n",  str); break;
          case ZOO : printf("One not in \"%s\", zero or one time.\n",   str); break;
        }
      }
      else {
        chrgrp2str(&str, cast_char_group(list_first(l)), 1);
        switch (cast_char_group(list_first(l)).operator) {
          case NOP : printf("One in \"%s\", one time.\n",           str); break;
          case ZOM : printf("One in \"%s\", zero or more times.\n", str); break;
          case OOM : printf("One in \"%s\", one or more times.\n",  str); break;
          case ZOO : printf("One in \"%s\", zero or one time.\n",   str); break;
        }
      }
      free(str);
    }

    regexp_free(regexp);

    exit(EXIT_SUCCESS);
}
