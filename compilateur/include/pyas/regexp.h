/**
 * @file regexp.h
 * @author François Cayre <francois.cayre@grenoble-inp.fr>
 * @date Fri Jul  28 09:56:03 2022
 * @brief General include for regexp
 *
 * General include for regexp, as in the project's pdf document
 */

#ifndef _REGEXP_H_
#define _REGEXP_H_

#include "string.h"
#include "list.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Structure stockant la syntaxe des expressions
 * régulière lus depuis un fichier lexem_file
 * 
 */
typedef struct {
    string_t name;                       // Nom de l'expression régulière
    list_t groups;                       // Liste de char_group composant cette regexp
} *regexp_t;

//========== Fonctions lié à l'analyse des expressions régulières
/**
 * @brief Etat de la lecture d'une expression régulière
 * 
 */
enum {INIT, GROUP, OPERATOR};
/**
 * @brief Réinterprète des caractères précédés d'un '\\\\'
 * 
 * @param source Caractères à réinterpréter, par exemple '\\n'
 * @return char - Caractère réinterprété
 */
char process_backslash_out_groups(char* source);
/**
 * @brief Optimise les char_group dans les cas a*ab, 
 * a*a+b, ou a+ab
 * 
 * @param groups Liste de char_group à optimiser
 */
void opti_regexp(list_t groups);
/**
 * @brief Construit l'expression régulière à partir d'une 
 * chaîne de caractère lu depuis le fichier lexem_file
 * 
 * @param name Nom de l'expression régulière
 * @param source String lu depuis le fichier lexem_file
 * @return L'expression régulière s'il n'y a pas d'erreur
 * de syntaxe ou d'allocation, NULL sinon
 */
regexp_t regexp_new(string_t name, string_t source);

/**
 * @brief Etats de la machine d'état de lecture des expression régulières
 * 
 */
enum {READ_FIRST_BLANKS, READING_NAME, READ_SECOND_BLANKS, READ_REGEXP, SKIP_COMMENT};
/**
 * @brief Retourne une liste d'expressions régulières contenues dans
 * un fichier
 * 
 * @param filename Fichier contenant les expressions régulières
 * @return list_t - Liste d'expressions régulières
 */
list_t regexp_read(char* filename);

/**
 * @brief Affiche les données d'une expression régulière
 * 
 * @param regexp Expression régulière à afficher
 */
int regexp_print(void* regexp);

/**
 * @brief Libère la mémoire d'une expression régulière
 * 
 * @param regexp Pointeur sur le regexp à libérer
 * @return 0
 */
int regexp_free(void* regexp);

/**
 * @brief Vérifie si la source respecte la syntaxe "Aucun ou une fois" '?'
 * 
 * @param c Caractère devant respecter la condition "Aucun ou une fois"
 * @param regexp Expression régulière
 * @param source Chaîne à parser
 * @param end Poiteur sur une chaîne de caractère retournant la suite de la source ne respectant pas regexp
 * @return int - 1 si source correspond à l'expression régulière, 0 sinon 
 */
int re_match_zero_one_or_one(char c, char* regexp, char* source, char** end);

/**
 * @brief Convertie un void* en regexp_t
 * 
 * @param obj Variable à convertir
 * @return regexp_t - Variable convertie
 */
regexp_t cast_regexp(void* obj);

/**
 * @brief Vérifie si l'expression source correspond à l'expression régulière regexp
 * 
 * @param regexp Expression régulière
 * @param source Chaîne à parser
 * @param end Chaîne de caractère contenant le reste de la source
 * @return int - 1 si source correspond à l'expression régulière, 0 sinon
 */
int re_match (regexp_t reg, string_t source, string_t* end);

#ifdef __cplusplus
}
#endif

#endif /* _ALL_H_ */