/**
 * @file char_group.c
 * @brief Code des fonction associé à char_group
 * @date 2022-10-02
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include "../include/rv32ias/char_group.h"
#include "../include/rv32ias/string.h"

char_group* char_group_new() {
  char_group* group = malloc(sizeof(char_group));
  assert(group);
  group->operator = NOP;
  group->inverse = 0;
  return group;
}

char process_backslash_in_group(char* source) {
  // On ne considère pas le '\'
  switch (source[1]) {
    case '\\': return '\\';      break;
    case 'n' : return '\n';      break;
    case 't' : return '\t';      break;
    case '^' : return '^' ;      break;
    case ']' : return ']' ;      break;
    case '-' : return '-' ;      break;
    default  : return source[1]; break;
  }
}

int process_char_group(string_t regexp, char_group* group) {
  char* c = string_get(regexp) + 1;      // Permet de parcourir source (on saute le premier caractère)
  char interval_start;                   // Sauvegarde le début d'un intervalle
  char exclude = 0;                      // Indique si les caractères dans le groupe sont exclus
  
  // On vérifie s'il y a un symbôle d'exclusion et on initialise
  if (*c != '^') {
    for (int i = 0; i < 256; i=i+1) 
      group->group[i] = 0;
  }
  else {
    exclude = 1;
    for (int i = 0; i < 256; i=i+1) 
      group->group[i] = 1;
    c = c + 1;                           // On passe directement au reste de l'expression
  }

  while (c < string_get(regexp) + string_length(regexp)) {
    switch (*c) {
      //----- Si on atteint la fin de l'intervalle
      case ']':
        c = c + 1;
        if (c < string_get(regexp) + string_length(regexp)) {
          if      (*c == '*') group->operator = ZOM;
          else if (*c == '+') group->operator = OOM;
          else if (*c == '?') group->operator = ZOO;
          else                group->operator = NOP;
        }
        else group->operator = NOP;
      break;

      //----- Si on commence à lire un intervalle
      case '-':
        c = c + 1;                     // On passe le '-'
        // Si le deuxième caractère n'est pas spécial
        if (*c != ']' && *c != '\\')
          for (char i = interval_start; i <= *c; i=i+1)
            group->group[(int)i] = !exclude;
        // Si on a un caractère spécial à la fin de l'intervalle
        else if (*c == '\\' && c + 1 < string_get(regexp) + string_length(regexp)) {
          // On vérifie que l'intervalle se trouve bien dans le bon sens
          // if (interval_start < process_backslash_in_group(c))
            for (char i = interval_start; i <= process_backslash_in_group(c); i=i+1) 
              group->group[(int)i] = !exclude;
          // else if (interval_start > process_backslash_in_group(c))
          //   for (char i = process_backslash_in_group(c); i <= interval_start; i=i+1) 
          //     group->group[(int)i] = !exclude;
          // else {
          //   printf("Erreur de syntaxe : l'intervalle doit avoir deux caractères différents\n");
          //   return 1;
          // }
          c = c + 2;
        }
        // Si le regexp se termine avant la fin de l'intervalle on retourne une erreur
        else {
          printf("Erreur de syntaxe : intervalle non fini\n");
          return 1;
        }
      break;

      //----- Si on lit un '\'
      case '\\':
        group->group[(int)process_backslash_in_group(c)] = !exclude;
        interval_start = process_backslash_in_group(c);
        c = c + 1;
      break;

      //----- Si on obtient un caractère incorrecte
      case '^':
        return 1;
      break;

      //----- On ajoute sinon un caractère normal
      default:
        group->group[(int)*c] = !exclude;
        interval_start = *c;
      break;
    }
    c = c + 1;
  }
  group->inverse = exclude;
  return 0;
}

void print_char_group(char_group group, char display) {
    printf("----- Affichage du char_group\n");
    switch (group.operator) {
        case NOP : printf("No operator\n");      break;
        case ZOM : printf("Zero or more (*)\n"); break;
        case OOM : printf("One or more (+)\n");  break;
        case ZOO : printf("Zero or one (?)\n");  break;
    }
    if (group.inverse) printf("A été inversé\n");
    else               printf("N'a pas été inversé\n");
    for (int i = 0; i < 256; i=i+1)
        if (group.group[i] == display) printf("%d\t%c\t%d\n", i, i, display);
}

void char_group_inverse(char_group* group) {
  for (int i = 0; i < 256; i=i+1) group->group[i] ^= 1;
  group->inverse = !(group->inverse);
}

void char_group_single_char(char_group* group, char c, char exclude, int operator) {
  // Initialisation du groupe
  for (int i = 0; i < 256; i=i+1) {
    if (i == c) group->group[i] = (exclude == 0);
    else        group->group[i] = (exclude == 1);
  }
  group->operator = operator;
  group->inverse  = exclude;
}

void char_group_set_op(char_group* group, int operator) {
  group->operator = operator;
}

int char_group_free(void* char_group) {
  free(char_group);
  return 0;
}

int char_group_comp(char_group group1, char_group group2) {
  if (group1.operator != group2.operator) return 0;
  for (int i = 0; i < 256; i=i+1)
    if (group1.group[i] != group2.group[i]) return 0;
  return 1;
}

int char_group_in(char_group grp, char chr) {
  for (int i = 0; i < 256; i=i+1) {
    if (grp.group[i])
      if (i == chr)
        return 1;
  }
  return 0;
}

char_group cast_char_group(void* obj){
  char_group* group = obj;
  return *group;
}