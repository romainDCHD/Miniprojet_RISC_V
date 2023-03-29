#ifndef _PYOBJ_H
#define _PYOBJ_H

#include <stdint.h>
#include <time.h>
#include "string.h"

// typedef unsigned int pyobj_type;

typedef enum pyobj_type_enum {
    EMPTY,
    INT,
    INT64,
    FLOAT,
    COMPLEX,
    STRING,
    LIST,
    CODE,
    CONSTANT
} pyobj_type;

typedef enum pycst_value_enum {
    CST_NULL,
    CST_TRUE,
    CST_FALSE,
    CST_NONE
} pycst_value;

//----- Structure permettant de stocker une variable Python 
typedef struct pyobj {
    pyobj_type type;                     // Indique le type de l'objet
    unsigned int refcount;               // Indique le nombre de références de cet objet dans des listes (sujet p.70)

    // Union pour les différents  type de variable
    union {
        // S'il s'agit d'une liste
        struct {
            struct pyobj **value;        // Eléments contenus dans la liste
            int32_t size;                // Taille de la liste
        } list;
        // S'il s'agit d'un string
        string_t string;
        struct py_cdeblk *codeblock;     // Permet de manipuler du code sans utiliser trop de mémoire (sujet p.69/70)
        // S'il s'agit d'un nombre
        union {
            int32_t integer;             // Un entier sur 32 bits
            int64_t interger64;          // Un entier sur 64 bits
            double real;                 // Un flottant
            struct {
                double real;
                double imag;
            } complex;                   // Structure complexe
        } number;
        // S'il s'agit d'une constante
        pycst_value constant;
    } py;
} *pyobj_t;

typedef struct py_cdeblk {
    int version_pyvm;                    // Version du bytecode à produire (cf. Sec. 9.3)
    // Infos lu dans le header du code Python
    struct {
        uint32_t arg_count;
        uint32_t local_count;
        uint32_t stack_size;
        uint32_t flags;                  // Les options du bytecode (cf. Sec. C.4.2)
    } header;

    pyobj_t parent;                      // Pointeur vers le parent de l'objet
    // 
    struct {
        struct {
            uint32_t magic;              // Pas de ref dans le sujet
            time_t timestamp;            // Heure de production du fichier .pyc ?.
            uint32_t source_size;        // [Python 3.x] : la taille du code source (.py) en octets
        } header;
        struct {
            pyobj_t interned;            // Liste de chaîne de caractère indiquant les variables internées (section 8.3.2 (p.75) du sujet ou bas de page sujet p.69)
            pyobj_t bytecode;            // 
            pyobj_t consts;              // Liste des valeurs constantes dans le code (sec 8.3.3 p.77)
            pyobj_t names;               // Liste des noms de variables (sec 8.3.4 p.78)
            pyobj_t varnames;            // Liste des noms de variables locales
            pyobj_t freevars;            // 
            pyobj_t cellvars;            // 
        } content;
        struct {
            pyobj_t filename;            // Le nom du fichier source .py
            pyobj_t name;                // La chaîne constante "<module>"
            uint32_t firstlineno;        // Le numéro de la première ligne du code
            pyobj_t lnotab;              // Table de correspondance entre les lignes du code et les instructions ?
        } trailer;
    } binary;
} py_codeblock;

/**
 * @brief Créer un objet Python
 * 
 * @param pyobj Poiteur sur l'objet Python à créer
 */
void pyobj_new(pyobj_t* pyobj);

/**
 * @brief Libère la mémoire allouée à un objet Python
 * 
 * @param pyobj Pointeur sur l'objet Python à libérer
 * @return 0
 */
int pyobj_free(void* pyobj);

/**
 * @brief Créer un objet Python de type entier
 * 
 * @param pyobj Objet Python dont on veut définir la valeur
 * @param value Valeur de l'entier
 */
void pyobj_set_int(pyobj_t pyobj, int32_t value);

/**
 * @brief Créer un objet Python de type entier 64 bits
 * 
 * @param pyobj Objet Python dont on veut définir la valeur
 * @param value Valeur de l'entier
 */
void pyobj_set_int64(pyobj_t pyobj, int64_t value);

/**
 * @brief Créer un objet Python de type flottant
 * 
 * @param pyobj Objet Python dont on veut définir la valeur
 * @param value Valeur du flottant
 */
void pyobj_set_float(pyobj_t pyobj, double value);

/**
 * @brief Créer un objet Python de type complexe
 * 
 * @param pyobj Objet Python dont on veut définir la valeur
 * @param real  Partie réelle du nombre complexe
 * @param imag  Partie imaginaire du nombre complexe
 */
void pyobj_set_complex(pyobj_t pyobj, double real, double imag);

/**
 * @brief Créer un objet Python de type chaîne de caractère
 * 
 * @param pyobj Objet Python dont on veut définir la valeur
 * @param value Chaîne de caractère
 */
void pyobj_set_string(pyobj_t pyobj, string_t string);

/**
 * @brief Créer un objet Python de type liste
 * 
 * @param pyobj Objet Python dont on veut définir la valeur
 * @param value Tableau d'objets Python
 * @param size  Taille de la liste
 */
void pyobj_set_list(pyobj_t pyobj, pyobj_t *value, int32_t size);

/**
 * @brief Créer un objet Python de type code
 * 
 * @param pyobj Objet Python dont on veut définir la valeur
 */
//  * @param codeblock Code Python
//  */
void pyobj_set_codeblock(pyobj_t pyobj/*, py_codeblock *codeblock*/);

/**
 * @brief Créer un objet Python de type constant
 * 
 * @param pyobj Objet Python dont on veut définir la valeur 
 * @param constant Valeur de la constante parmi les valeurs suivantes :
 *                 CST_NULL
 *                 CST_TRUE
 *                 CST_FALSE
 *                 CST_NONE
 */
void pyobj_set_constant(pyobj_t pyobj, pycst_value constant);

/**
 * @brief Retourne la valeur d'un objet Python
 * 
 * @param pyobj Objet Python dont on veut récupérer la valeur
 * @return void* - Pointeur vers la valeur de l'objet Python
 */
void* pyobj_get(pyobj_t pyobj);

/**
 * @brief Retourne le type d'un objet Python
 * 
 * @param pyobj Objet Python dont on veut récupérer le type
 * @return pyobj_type - Type de l'objet Python
 */
pyobj_type pyobj_get_type(pyobj_t pyobj);

/**
 * @brief Affiche un objet Python
 * 
 * @param pyobj Objet Python à afficher
 * @return 0
 */
int pyobj_print(void* pyobj);

/**
 * @brief Initialise un codeblock vide
 * 
 * @return py_codeblock - Codeblock initialisé
 */
py_codeblock py_codeblock_new();

/**
 * @brief Affiche un codeblock
 * 
 * @param codeblock Codeblock à afficher
 */
void py_codeblock_print(py_codeblock codeblock);

/**
 * @brief Libère la mémoire alloué pour les pyobj_t d'un codeblock
 * 
 * @param codeblock - Codeblock dont on veut libérer la mémoire
 */
void py_codeblock_free(py_codeblock codeblock);

int pyobj_type_compar(pyobj_t pyobj1, pyobj_t pyobj2);

#endif