/**
 * @file lexem.c
 * @author François Cayre <francois.cayre@grenoble-inp.fr>
 * @date Fri Jul  2 17:59:27 2021
 * @brief Lexems.
 *
 * Lexems.
 */

#define _POSIX_C_SOURCE 200809L /* strdup(3) */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "../include/rv32ias/lexem.h"
#include "../include/rv32ias/list.h"
#include "../include/rv32ias/string.h"
#include "../include/rv32ias/regexp.h"
#include "../include/rv32ias/string.h"
#include "../include/rv32ias/char_group.h"
#include "../include/unitest/logging.h"

lexem_t lexem_new(string_t type, string_t value, int line, int column) { 
  lexem_t lex = malloc(sizeof(*lex));

  assert(lex);

  if (string_get(type)  && *string_get(type)) {
    lex->type  = calloc(string_length(type)+1, sizeof(*(lex->type)));
    for (int i = 0; i < string_length(type); i=i+1)
      lex->type[i] = string_get(type)[i];
    lex->type[string_length(type)] = '\0';
  }

  if (string_get(value)  && *string_get(value)) {
    lex->value  = calloc(string_length(value)+1, sizeof(*(lex->value)));
    for (int i = 0; i < string_length(value); i=i+1)
      lex->value[i] = string_get(value)[i];
    lex->value[string_length(value)] = '\0';
  }

  lex->line   = line;
  lex->column = column; 
  
  return lex; 
}

int     lexem_print( void *_lex ) { 
  lexem_t lex = _lex; 

  return printf( "[%d:%d:%s] %s",
		 lex->line,
		 lex->column,
		 lex->type,
		 lex->value );
}

int     lexem_delete( void *_lex ) { 
  lexem_t lex = _lex;
  
  if ( lex ) { 
    free( lex->type );
    free( lex->value );
  }
  
  free( lex );

  return 0; 
}

int lexem_type_strict ( lexem_t lex , char * type ) {
  return ! strcmp ( lex ->type , type );
}

int lexem_type ( lexem_t lex , char * type ) {
  return lex -> type == strstr ( lex->type , type ) ;
}

lexem_t lexem_cast(void* obj) {
  lexem_t lexem = obj;
  return lexem;
}

int lexem_read(char* filename, list_t* lex, list_t reg) {
  //----- Ouverture du fichier
  FILE *file = fopen(filename, "r");
  assert(file);

  //----- Récupération de la taille du fichier
  fseek(file, 0, SEEK_END);              // Seek jusquéà la fin du fichier
  int size = ftell(file);                // Récupère le pointeur du ficiher
  fseek(file, 0, SEEK_SET);              // Seek de nouveau au début du fichier

  //----- Allocatation de la chaîne de caractère sotackant le contenue du fichier
  char* content = calloc(size, sizeof(char*));
  assert(content);
  fread(content, sizeof(char), size, file);

  //----- Création string (on alloue les données à la main car le poiteur est déjà définie)
  string_t file_content;
  file_content.content = content;
  file_content.length = size;
  fclose(file);

  //----- Création des lexem
  string_t source;
  source.content = string_get(file_content);
  source.length  = string_length(file_content);
  list_t l = reg;                        // Permet de parcourir les regexp lors de l'identification d'un lexem
  string_t next;                         // Stock la suite de la source après avoir identifier un lexem
  
  // [A AMELIORER] Récupération des numéros de lignes et de colonnes
  int* line = calloc(size, sizeof(*line));
  int* col  = calloc(size, sizeof(*col ));
  int curr_line = 1;
  int curr_col  = 1;
  for (int i = 0; i < string_length(file_content); i=i+1) {
    line[i] = curr_line;
    col[i] = curr_col;
    if (string_get(file_content)[i] == '\n') {
      curr_col = 1;
      curr_line = curr_line + 1;
    }
    else
      curr_col = curr_col + 1;
  }

  // On parcours tout le fichier
  while (string_length(source) > 0) {
    // On test les différentes expressions régulières jusqu'à ce qu'elles correspondent
    while (!list_empty(l) && !re_match(cast_regexp(list_first(l)), source, &next))
      l = list_next(l);

    // Si aucune expression régulière ne correspond à la source 
    if (list_empty(l)) {
      printf("[ ERROR ] No matching regexp at line %d: '", line[string_get(source)-string_get(file_content)]);
      int i = 0;
       while (string_get(source)[i] != '\n' && i < string_length(source)) {
         printf("%c", source.content[i]);
         i = i + 1;
       }
      printf("'.\n");
      free(content);
      free(line);
      free(col);
      return -1;
    }
    // Sinon on créer un nouveau lexem
    else {
      // Source contient à ce moment là que la valeur du lexem
      source.length = source.length - next.length;
      *lex = list_add_last(
        *lex, 
        lexem_new(
          cast_regexp(list_first(l))->name,
          source, 
          line[string_get(source)-string_get(file_content)],
          col [string_get(source)-string_get(file_content)]
        )
      );
      source = next;
      l = reg;
    }
  }

  free(content);
  free(line);
  free(col);

  return 0;
}

lexem_t lexem_peek(list_t *lexems) {
  return list_first(*lexems);
}

lexem_t lexem_advance(list_t *lexems) {
  lexem_t out = list_first(*lexems);
  *lexems = list_next(*lexems);
  return out;
}

int next_lexem_is(list_t *lexems, char *type) {
  list_t l = *lexems;
  if (list_empty(l)) return 0;
  lexem_t lex = list_first(l);
  return lexem_type(lex, type);
}

// lexem_t lexem_peek(list_t *lexems) {  
//   // On passe tous les lexems inutiles
//   while (lexem_type_strict(lexem_cast(list_first(*lexems)), "blank")    || 
//          lexem_type_strict(lexem_cast(list_first(*lexems)), "newline")  || 
//          lexem_type_strict(lexem_cast(list_first(*lexems)), "comment")) {
//     // Si on arrive au bout de la liste on retourne quand même le lexem inutile
//     if (!list_empty(list_next(*lexems))) *lexems = list_next(*lexems);
//     else                                 return list_first(*lexems);
//   } 
//   return list_first(*lexems);
// }

// lexem_t lexem_advance(list_t *lexems) {
//   // On passe tous les lexems inutiles
//   while (lexem_type_strict(lexem_cast(list_first(*lexems)), "blank")    || 
//          lexem_type_strict(lexem_cast(list_first(*lexems)), "newline")  || 
//          lexem_type_strict(lexem_cast(list_first(*lexems)), "comment")) {
//     // Si on arrive au bout de la liste on retourne quand même le lexem inutile
//     if (!list_empty(list_next(*lexems))) *lexems = list_next(*lexems);
//     else                                 return list_first(*lexems);
//   }
//   lexem_t out = list_first(*lexems);
//   *lexems = list_next(*lexems);
//   return out;
// }

// int next_lexem_is(list_t *lexems, char *type) {
//   list_t l = *lexems;
//   if (list_empty(l)) return 0;
//   // On passe tous les lexems inutiles
//   while (lexem_type_strict(lexem_cast(list_first(l)), "blank")    || 
//          lexem_type_strict(lexem_cast(list_first(l)), "newline")  || 
//          lexem_type_strict(lexem_cast(list_first(l)), "comment")) {
//     if (!list_empty(list_next(l))) l = list_next(l);
//     else                           return 0;
//   }
//   lexem_t lex = list_first(l);
//   // lexem_print(lex);printf("\n");
//   return lexem_type(lex, type);
// }

int print_parse_error(char *msg, list_t *lexems) {
  if (!list_empty(*lexems)) {
    lexem_t lex = list_first(*lexems);
    STYLE(stderr, COLOR_RED, STYLE_REGULAR);
    fprintf(stderr, "Error:%d:%d : ", lex->line, lex->column);
    STYLE(stderr, COLOR_WHITE, STYLE_BOLD);
    printf("%s\n", msg);
    STYLE_RESET(stderr);
  }
  else {
    STYLE(stderr, COLOR_RED, STYLE_REGULAR);
    fprintf(stderr, "Error:EOF : ");
    STYLE(stderr, COLOR_WHITE, STYLE_BOLD);
    printf("%s\n", msg);
    STYLE_RESET(stderr);
  }
  return 0;
}

int lexem_comp(lexem_t lex1, lexem_t lex2) {
  if (lex1 == NULL || lex2 == NULL)               return 0;
  if (lex1->type  == NULL || lex2->type  == NULL) return 0;
  if (lex1->value == NULL || lex2->value == NULL) return 0;
  if (strcmp(lex1->type,  lex2->type)    != 0)    return 0;
  if (strcmp(lex1->value, lex2->value)   != 0)    return 0;
  return 1;
}