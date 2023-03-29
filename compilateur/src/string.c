#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "../include/pyas/string.h"

int string_new(string_t* str, char* content, int length) {
    // Si on souhaite un string vide
    if (length == 0) {
        str->content = NULL;
        str->length  = 0;
    }
    else {
        str->content = calloc(length, sizeof(*(str->content)));
        if (str->content == NULL) return -1;

        str->length = length;

        for (int i = 0; i < length; i=i+1)
            str->content[i] = content[i];
    }
    return 0;
}

char* string_get(string_t str) {return str.content;}

int string_length(string_t str) {return str.length;}

int string_set(string_t* str, char* content, int length) {
    // Si le nouveeau contenue est de taille inférieur au nouveau on réassigne simplement
    if (string_length(*str) >= length) {
        str->length = length;
        for (int i = 0; i < length; i=i+1) {
            str->content[i] = content[i];
        }
    }
    // Sinon on réalloue les données
    else {
        if (string_length(*str) != 0) free(string_get(*str));
        str->content = calloc(length, sizeof(*(str->content)));
        assert(str->content);                       // Là c'est chaud

        str->length = length;
        for (int i = 0; i < length; i=i+1)
            str->content[i] = content[i];
    }

    return 1;
}

string_t string_convert(char* str) {
    string_t out;
    out.length = 0;
    // Récupération de la longueur
    for (char* c = str; *c != '\0'; c=c+1)
        out.length++;
    out.content = str;
    return out;
}

int string_copy(string_t source, string_t* target) {
    return string_set(target, string_get(source), string_length(source));
}

void string_print(string_t str) {
    for (int i = 0; i < string_length(str); i=i+1) 
        printf("%c", *(string_get(str)+i));
}

void string_free(string_t* str) {
    free(string_get(*str));
    str->length = 0;
}

int string_compare(string_t str1, string_t str2) {
    if (str1.length != str2.length) return 0;
    for (int i = 0; i < str1.length; i=i+1)
        if (str1.content[i] != str2.content[i]) return 0;
    return 1;
}