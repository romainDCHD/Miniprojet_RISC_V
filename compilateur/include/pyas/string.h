#ifndef _STRING_H_
#define _STRING_H_

/**
 * @brief Structure string
 * 
 */
typedef struct {
    char* content;
    int   length;
} string_t;

/**
 * @brief Créer un string à partir d'une chaîne de caractère
 * 
 * @param str string à initialiser
 * @param content Chaîne de caractère
 * @param length Longueur de la chaîne de caractère
 * @return int - 0 si l'allocation a fonctionné, -1 sinon
 */
int string_new(string_t* str, char* content, int length);

/**
 * @brief Retourne le pointeur sur le contenue d'un string
 * 
 * @param str String dont on veut le contenue
 * @return char* - Contenue du string
 */
char* string_get(string_t str);

/**
 * @brief Retourne la longueur d'un string
 * 
 * @param str String dont on veut la longueur
 * @return int - Longueur du string
 */
int string_length(string_t str);

/**
 * @brief Réassigne le contenue d'un string
 * 
 * @param str String a réassigner
 * @param content Contenue à assigner
 * @param length Longueur de content
 * @return int - 1 si l'assignation a fonctionné, 0 sinon
 */
int string_set(string_t* str, char* content, int length);

/**
 * @brief Convertie une chaîne de caractère STATIQUE en string_t
 * 
 * @param str Chaîne à convertir
 * @return string_t - String convertie
 */
string_t string_convert(char* str);

/**
 * @brief Copie un string de la source à la cible
 * 
 * @param source String à copier
 * @param target Pointeur sur la cible à copier
 * @return int - 1 si la copie à fonctionner, 0 sinon
 */
int string_copy(string_t source, string_t* target);

/**
 * @brief Affiche un string
 * 
 * @param str String à afficher
 */
void string_print(string_t str);

/**
 * @brief Libère la mémoire d'un string
 * 
 * @param str - String a supprimer
 */
void string_free(string_t* str);

/**
 * @brief Compare deux chaînes de caractères
 * 
 * @param str1 Première chaîne de caractères à comparer
 * @param str2 Deuxième chaîne de caractères à comparer
 * @return int - 1 si les deux chaîne de caractère sont similaire, 0 sinon
 */
int string_compare(string_t str1, string_t str2);
#endif