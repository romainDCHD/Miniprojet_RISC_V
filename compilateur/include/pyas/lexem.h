
/**
 * @file lexem.h
 * @author François Cayre <francois.cayre@grenoble-inp.fr>
 * @date Fri Jul  2 17:59:42 2021
 * @brief Lexems.
 *
 * Lexems.
 */

#ifndef _LEXEM_H_
#define _LEXEM_H_

#ifdef __cplusplus
extern "C" {
#endif
  #include "list.h"
  #include "string.h"

  typedef struct lexem {
    char *type;
    char *value;
    int line;
    int column;
  }
  *lexem_t;

  lexem_t lexem_new(string_t type, string_t value, int line, int column); 
  int     lexem_print( void *_lex );
  int     lexem_delete( void *_lex ); 
  int     lexem_type_strict ( lexem_t lex , char * type );
  int     lexem_type ( lexem_t lex , char * type );
/**
 * @brief Convertie un void* en lexem_t
 * 
 * @param obj Variable à convertir
 * @return lexem_t - Variable convertie
 */
  lexem_t lexem_cast(void* obj);
  /**
   * @brief Extrait d'un code source les lexems
   * 
   * @param filename Fichier source
   * @param lex Liste de lexems lus
   * @param reg Liste d'expression régulière
   * @return int - -1 si une erreur de syntaxe est détecté, 0 sinon
   */
  int lexem_read(char* filename, list_t* lex, list_t reg);
  /**
   * @brief Renvoie le prochain lexème sans l'enlever de la liste
   * 
   * @param lexems Liste de lexem dont on veut le prochain
   * @return lexem_t - Prochain lexème de la liste
   */
  lexem_t lexem_peek(list_t *lexems);
  /**
   * @brief Retourne le premier lexem de la liste et passe la suite de la liste
   * 
   * @param lexems Liste de lexem dont on veux la suite
   * @return lexem_t - Prochain lexem de la liste
   */
  lexem_t lexem_advance(list_t *lexems);
  /**
   * @brief Détermine si le prochain lexème utile est bien du type demandé
   * 
   * @param lexems Liste contenant le prochain lexem dont on veut vérfier le type
   * @param type Type à vérifier
   * @return int - 1 si les deux types concordent, 0 sinon
   */
  int next_lexem_is(list_t *lexems, char *type);
  /**
   * @brief Affiche le message d’erreur msg en le situant grâce aux coordonnées 
   * du lexème en tête de la liste *lexems
   * 
   * @param msg Message à afficher
   * @param lexems Liste de lexem contenant en tête l'erreur du lexem
   */
  int print_parse_error(char *msg, list_t *lexems);

  /**
   * @brief Compare deux lexems
   * 
   * @param lex1 Premier lexem à comparer
   * @param lex2 Deuxième lexem à comparer
   * @return int - 1 si les deux lexems sont identiques, 0 sinon
   */
  int lexem_comp(lexem_t lex1, lexem_t lex2);
#ifdef __cplusplus
}
#endif

#endif /* _LEXEM_H_ */
