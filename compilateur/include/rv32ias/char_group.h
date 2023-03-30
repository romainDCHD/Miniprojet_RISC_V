/**
 * @file char_group.h
 * @brief Fichier Header de la structure char_group
 * @date 2022-10-02
 * 
 */

#ifndef _CHAR_GROUP_H_
#define _CHAR_GROUP_H_

#include "string.h"

//========== Structure char_group
/**
 * @brief Enumération des différents opérateur associé à 
 * un caractère ou un groupe de caractère.
 * NOP --> No operator | 
 * ZOM --> Zero or more (*) | 
 * OOM --> One or more (+) | 
 * ZOO --> Zero or one (?)
 * 
 */
enum {NOP, ZOM, OOM, ZOO};
/**
 * @brief Structure de données spécifiant un ensemble de caractères
 * ainsi que l'opérateur associé (interprète par exemple [^a\\t]+)
 * 
 */
typedef struct {
    char group[256];           // Contient aux positions des caractères ASCII un 1 ou un 0 en fonction de sa présence dans le groupe
    int operator;              // Indique l'opérateur associé au groupe (NOP, ZOM, OOM, ZOO)
    char inverse;              // Indique si le char_group a été inversé
} char_group;

/**
 * @brief Retourne un pointeur sur un char_group vide
 * 
 * @return char_group* - NULL si l'opération a échoué, le poiteur sur le char_group vide sinon
 */
char_group* char_group_new();

//========== Rescources liées à la fonction process_char_group
/**
 * @brief Réinterprète des caractères précédés d'un \\
 * 
 * @param source Caractères à réinterpréter, par exemple '\\n'
 * @return char - Caractère réinterprété
 */
char process_backslash_in_group(char* source);
/**
 * @brief Permet de construire un groupe de caractère à partir d'une expression régulière
 * 
 * @param regexp Expression régulière au format 
 * ['^']<regexp-chunk>[<how-many>] (sujet p. 22)
 * @param group Poiteur sur le groupe de caractère 
 * @return int - 0 S'il n'y a pas d'erreur dans l'expression, 1 sinon
 */
int process_char_group(string_t regexp, char_group* group);

//========== Autres fonctions
/**
 * @brief Affiche un char_group
 * 
 * @param group char_group à afficher
 * @param display 1 si on veut afficher que les 1, 0 sinon
 */
void print_char_group(char_group group, char display);
/**
 * @brief Inverse toutes les valeurs du contenue d'un char_group
 * 
 * @param group char_group à inverser
 */
void char_group_inverse(char_group* group);
/**
 * @brief Créer un char_group contenant un seul caractère
 * 
 * @param group Poiteur sur le char_group où stocker les données
 * @param c Caractère contenue dans group
 * @param exclude 1 si le caractère en question est exclus, 0 sinon
 * @param operator Opérateur associé
 */
void char_group_single_char(char_group* group, char c, char exclude, int operator);
/**
 * @brief Applique un opérateur à un char_group
 * 
 * @param group Groupe auquel on veut appliquer l'opérateur
 * @param operator Opérateur à appliquer
 */
void char_group_set_op(char_group* group, int operator);
/**
 * @brief Libère la mémoire d'un char_group
 * 
 * @param char_group Poiteur sur le char_group à supprimer
 * @return int = 0
 */
int char_group_free(void* char_group);
/**
 * @brief Compare deux char_groups
 * 
 * @param group1 Premier char_group à comparer
 * @param group2 Second  char_group à comparer
 * @return int - 1 Si ils sont identique, 0 sinon
 */
int char_group_comp(char_group group1, char_group group2);
/**
 * @brief Indique si un caratère est contenue dans un char_group
 * 
 * @param group1 char_group dont on veut savoir s'il contient le caractère
 * @param caracter Caractère à tester
 * @return int - 1 si le char_group contient le caractère, 0 sinon
 */
int char_group_in(char_group group1, char caracter);
/**
 * @brief Convertie un void* en char_group
 * 
 * @param obj Variable à convertir
 * @return char_group - Variable convertie
 */
char_group cast_char_group(void* obj);

#endif