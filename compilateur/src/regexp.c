/**
 * @file regexp.c
 * @author François Cayre <francois.cayre@grenoble-inp.fr>
 * @date Fri Jul  28 09:56:03 2022
 * @brief regexp
 *
 * regexp code, as in the project's pdf document
 *
 */

#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include "../include/rv32ias/regexp.h"
#include "../include/rv32ias/char_group.h"
#include "../include/rv32ias/string.h"
#include "../include/unitest/logging.h"

char process_backslash_out_groups(char* source) {
  // On ne considère pas le '\'
  switch (source[1]) {
    case '\\': return '\\';      break;
    case 'n' : return '\n';      break;
    case 't' : return '\t';      break;
    case '.' : return '.' ;      break;
    case '*' : return '*' ;      break;
    case '+' : return '+' ;      break;
    case '?' : return '?' ;      break;
    case '^' : return '^' ;      break;
    case '[' : return '[' ;      break;
    default  : return source[1]; break;
  }
}

void opti_regexp(list_t groups) {
  list_t p = groups;                     // Précédent maillon de la liste lorsque l'on la parcours
  char_group* prev; 
  char_group* curr;
  char same_group = 1;                   // Indique si deux char_group sont similaire sans prendre en compte l'opérateur

  if (!list_empty(p)) {
    list_t l = list_next(p);

    while (!list_empty(l)) {
      prev = list_first(p);
      curr = list_first(l);
      // Comparaison des char_group
      for (int i = 0; i < 256; i=i+1)
        if (prev->group[i] != curr->group[i]) same_group = 0;

      if (same_group) {
        // Traitement du cas a*ab ou a*a+b en a+b
        if (prev->operator == ZOM && (curr->operator == NOP || curr->operator == OOM)) {
          prev->operator = OOM;
          p->next = list_del_first(l, char_group_free);
          l = p->next;
        }
        // Traitement du cas a+ab en aa+b
        else if (prev->operator == OOM && curr->operator == NOP) {
          prev->operator = NOP;
          curr->operator = OOM;
          p = l;
          l = list_next(l);
        }
        else {
          p = l;
          l = list_next(l);
        }
      }
      else {
        p = l;
        l = list_next(l);
        same_group = 1;
      }
    }
  }
}

regexp_t regexp_new(string_t name, string_t source) {
  regexp_t regexp;                       // Expression régulière à retourner
  char* c = string_get(source);          // Pointeur parcourant source
  char* end = c + string_length(source); // Poiteur fixe de la fin de la chaîne
  char reading_state = INIT;             // Indique l'état de la machine d'état de lecture
  char inverse_exp = 0;                  // 1 si l'on inverse le groupe qui arrive, ex : ^[0-9]+
  char* start_pointer;                   // Poiteur sur le début de l'expression du groupe
  char_group* group = NULL;              // Permet de manipuler les poiteur de char_group
  string_t str_buffer;                   // Contient l'éventuelle expression d'un char_group
  char saved = 0;                        // Indique si le dernier group a été sauvegarder

  regexp = malloc(sizeof(*regexp));
  assert(regexp);

  regexp->groups = list_new();

  string_new(&(regexp->name), NULL, 0);
  string_copy(name, &(regexp->name));
  
  regexp->groups = list_new();
  string_new(&str_buffer, NULL, 0);      // Initialisation de str_buffer

  // Boucle d'analyse
  while (c < end) {
    switch (reading_state) {
      // ----- Début de la lecture d'un ensemble de caractère
      case INIT:
        // Symbôle d'exclusion
        if      (*c == '^') inverse_exp = 1;
        // Début d'un groupe
        else if (*c == '[') {
          group = char_group_new();
          start_pointer = c;
          saved = 0;
          reading_state = GROUP;
        }
        // Backslah / caractères spéciaux
        else if (*c == '\\' && c < end-1) {
          group = char_group_new();
          char_group_single_char(group, 
                                 process_backslash_out_groups(c), 
                                 inverse_exp==1, 
                                 NOP);
          c = c + 1;                     // On lit les deux caractères en même temps
          saved = 0;
          reading_state = OPERATOR;
        }
        // Symbôle "tout caractère"
        else if (*c == '.') {
          group = char_group_new();
          // char_group_single_char(group, 0, inverse_exp==0, NOP);         // Créer un groupe qu'avec des 1 (ou des 0 selon s'il y a le symbôle d'exclusion)
          for (int i = 0; i < 256; i=i+1) group->group[i] = inverse_exp==0;
          saved = 0;
          reading_state = OPERATOR;
        }
        // Tous les autres caractères
        else {
          group = char_group_new();
          char_group_single_char(group, *c, inverse_exp==1, NOP);
          saved = 0;
          reading_state = OPERATOR;
        }
      break;
      
      //----- Lit le contenue d'un groupe
      case GROUP:
        // Si on atteint le bout du groupe
        if (*(c-1) != '\\' && *c == ']') {
          // On vérifie s'il ne reste pas d'opérateur
          if (c < end-1 && (*(c+1) == '*' || *(c+1) == '+' || *(c+1) == '?')) {
            string_set(&str_buffer, start_pointer, c-start_pointer+2);   // Récupération du texte contenant le groupe
            c = c + 1;                                                   // On saute l'opérateur
          }
          else
            string_set(&str_buffer, start_pointer, c-start_pointer+1);   // Récupération du texte contenant le groupe
          
          process_char_group(str_buffer, group);                         // Traitement du groupe
          if (inverse_exp) char_group_inverse(group);                    // Inversement du groupe si nécessaire
          regexp->groups = list_add_last(regexp->groups, group);         // Sauvegarde du groupe
          // Réinitialisation les variables pour le groupe suivant
          inverse_exp = 0;
          saved = 1;
          reading_state = INIT;
        }
      break;

      //----- Lit l'opérateur associé au caractère / groupe
      case OPERATOR:
        switch (*c) {
          case '*' : char_group_set_op(group, ZOM); break;
          case '+' : char_group_set_op(group, OOM); break;
          case '?' : char_group_set_op(group, ZOO); break;
          // S'il ne s'agit pas d'un opérateur
          default  : c = c - 1;          // On reprendra en compte le caractère au cycle suivant
        }
        // On sauvegarde le groupe et réinitialise les variables pour le groupe suivant
        regexp->groups = list_add_last(regexp->groups, group);
        inverse_exp = 0;
        saved = 1;
        reading_state = INIT;
      break;
    }
    c = c + 1;
  }
  
  // On sauvegarde un éventuelle groupe 
  if (!saved) regexp->groups = list_add_last(regexp->groups, group);

  string_free(&str_buffer);

  // Enfin on optimise les éventuelles problèmes dans les char_group
  opti_regexp(regexp->groups);

  return regexp;
}

list_t regexp_read(char* filename) {
	char* c;                           // Pointeur sur le caractère lu dans le fichier
	char* start_point = NULL;          // Indique le début du mot à utiliser
  int reading_state = READ_FIRST_BLANKS;
	regexp_t regexp;
	string_t name;
	string_t expr;
  list_t regexps;

  //----- Ouverture du fichier
  FILE *file = fopen(filename, "r");
  if (!file) {
    STYLE(stderr, COLOR_RED, STYLE_BLINK);
    fprintf(stderr, "Impossible d'ouvrir le fichier !\n");
    STYLE_RESET(stderr);
  }
  assert(file);

  //----- Récupération de la taille du fichier
  fseek(file, 0, SEEK_END);              // Seek jusquéà la fin du fichier
  int size = ftell(file);                // Récupère le pointeur du ficiher
  fseek(file, 0, SEEK_SET);              // Seek de nouveau au début du fichier

  //----- Allocatation de la chaîne de caractère sotackant le contenue du fichier
  c = calloc(size, sizeof(char*));
  assert(c);
  fread(c, sizeof(char), size, file);
  fclose(file);
	
	//----- Initialisation des variable pour la lecture du fichier
  regexps = list_new();
	string_new(&name, "", 0);
	string_new(&expr, "", 0);
	
  //----- Lecture du fichier
  for (int i = 0; i < size; i=i+1) {
		switch (reading_state) {
			case READ_FIRST_BLANKS:
				if (*c != ' ' && *c != '\t' && *c != '\n') {
					reading_state = READING_NAME;
					start_point = c;
				}
        if (*c == '#') reading_state = SKIP_COMMENT;
			break;
			
			case READING_NAME:
				if (*c == ' ' || *c == '\t') {
					string_set(&name, start_point, c-start_point);
					reading_state = READ_SECOND_BLANKS;
				}
        if (*c == '#') reading_state = SKIP_COMMENT;
			break;
			
			case READ_SECOND_BLANKS:
				if (*c != ' ' && *c != '\t') {
					reading_state = READ_REGEXP;
					start_point = c;
				}
			break;
			
			case READ_REGEXP:
				if (*c == '\n') {
          // Si la ligne n'est pas une ligne vide
          string_set(&expr, start_point, c-start_point);
          regexp = regexp_new(name, expr);
          if (regexp) {
            regexps = list_add_last(regexps, regexp);
          }
          else {
            printf("Erreur de création de l'expression régulière !\n");
          }
					reading_state = READ_FIRST_BLANKS;
				}
			break;

      case SKIP_COMMENT:
        if (*c == '\n') reading_state = READ_FIRST_BLANKS;
      break;
		}
		c = c + 1;
	}

  // Si le document ne se termine pas par un retour à la ligne
  if (reading_state == READ_REGEXP) {
    if (*string_get(name) != '#') {
      string_set(&expr, start_point, c-start_point);
      regexp = regexp_new(name, expr);
      if (regexp) {
        regexps = list_add_last(regexps, regexp);
      }
      else {
        printf("Erreur de création de l'expression régulière !\n");
      }
    }
  }

	string_free(&name);
	string_free(&expr);
  free(c-size);

  return regexps;
}

int regexp_print(void* reg) {
  regexp_t regexp = reg;
  printf("========== Affichage de \"");
  string_print(regexp->name);
  printf("\" ==========\n");
  #ifdef __MINGW32__
    printf("Longueur de la liste : %lld\n", list_length(regexp->groups));
  #else
    printf("Longueur de la liste : %ld\n", list_length(regexp->groups));
  #endif
  char_group* group;
  for (list_t l = regexp->groups; !list_empty(l); l = list_next(l)) {
    group = list_first(l);
    print_char_group(*group, 1);
  }
  return 0;
}

int regexp_free(void* reg) {
  regexp_t regexp = reg;
  string_free(&(regexp->name));
  list_delete(regexp->groups, char_group_free);
  free(reg);
  return 0;
}

regexp_t cast_regexp(void* obj) {
  regexp_t reg = obj;
  return reg;
}

int re_match (regexp_t reg, string_t source, string_t* end) {
  // Déclaration des variables du programme
  char *c = string_get(source);          // Pointeur pour parcourir la chaine de caractère
  list_t l = reg->groups;
  char exp_ok = 1;                       // Vaut 1 si l'expression est bonne, 0 sinon
  char first_char = 0;                   // Vaut 1 si le premier caracter du OOM est en vu, 0 sinon
  
  while (exp_ok == 1 && c-string_get(source) < string_length(source)) {
    switch (cast_char_group(list_first(l)).operator) {
      case NOP:
        if (!char_group_in(cast_char_group(list_first(l)), *c))
          exp_ok = 0;
        else {
          c = c + 1;
          l = list_next(l);
        }
      break;

      case ZOM:
        if (char_group_in(cast_char_group(list_first(l)), *c) == 1)
          c = c + 1;
        else
          l = list_next(l);
      break;
      
      case OOM:
        // Si on croise le caractère pour la première fois
        if (char_group_in(cast_char_group(list_first(l)), *c)) {
          first_char = 1;
          c = c + 1;
        }
        // Cas où le caractere est déjà dedans et on cherche s'il est de nouveau présent
        else if (first_char == 1) {
          l = list_next(l);
          first_char = 0;
        }
        // Si le premier caractère n'est pas bon, l'expression est mauvaise
        else exp_ok = 0;
      break;

      case ZOO:
        if (char_group_in(cast_char_group(list_first(l)), *c) == 1)
          c = c + 1;
        l = list_next(l);
      break;
    }
    
    // Si on est arriver au bout de regexp mais pas de la chaîne
    if (list_empty(l)) {
      end->content = c;
      end->length  = string_length(source)-(c-string_get(source));
      return 1;
    }
  }
  
  if (! list_empty(l) &&                                     // Si l'expression régulière n'est pas complète
      !(list_empty(list_next(l)) &&                          // et si l'on est pas dans le cas où on est dans un opérator
       (cast_char_group(list_first(l)).operator == ZOM ||    // X or more en étant arrivé au bout de la chaîne
        cast_char_group(list_first(l)).operator == OOM))) {  // (Par exemple pour la regexp a* ou a+ avec "aaa" on devrait retourner 1)
    return 0;                                                // (tandis que pour la regexp coucou avec "cou"    on devrait retourner 0)
  }
  // Si on est au bout de la chaîne et de l'expression régulière
  else if (exp_ok) {
    end->content = c;
    end->length  = string_length(source)-(c-string_get(source));
    return 1;
  }
  // Si on est au bout de l'expression régulière mais que la chaîne est mauvaise
  else {
    return 0;
  }

}