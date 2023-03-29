#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "../include/pyas/pyobj.h"
#include "../include/pyas/string.h"

void pyobj_new(pyobj_t* pyobj) {
    *pyobj = malloc(sizeof(**pyobj));
    assert(*pyobj);
    (*pyobj)->type = EMPTY;
    (*pyobj)->refcount = 0;
}

int pyobj_free(void* pyobj) {
    if (((pyobj_t)pyobj)->type == LIST) {
        for (int i = 0; i < ((pyobj_t)pyobj)->py.list.size; i=i+1)
            pyobj_free(((pyobj_t)pyobj)->py.list.value[i]);
        free(((pyobj_t)pyobj)->py.list.value);
    }
    if (((pyobj_t)pyobj)->type == CODE) {
        py_codeblock_free(*(((pyobj_t)pyobj)->py.codeblock));
        free(((pyobj_t)pyobj)->py.codeblock);
    }

    if (((pyobj_t)pyobj)->refcount == 0) free(pyobj);
    // Verifier si on met refcount à jours ici
    return 0;
}

void pyobj_set_int(pyobj_t pyobj, int32_t value) {
    pyobj->type = INT;
    pyobj->py.number.integer = value;
}

void pyobj_set_int64(pyobj_t pyobj, int64_t value) {
    pyobj->type = INT64;
    pyobj->py.number.interger64 = value;
}

void pyobj_set_float(pyobj_t pyobj, double value) {
    pyobj->type = FLOAT;
    pyobj->py.number.real = value;
}

void pyobj_set_complex(pyobj_t pyobj, double real, double imag) {
    pyobj->type = COMPLEX;
    pyobj->py.number.complex.real = real;
    pyobj->py.number.complex.imag = imag;
}

void pyobj_set_string(pyobj_t pyobj, string_t string) {
    pyobj->type = STRING;
    pyobj->py.string = string;
}

void pyobj_set_list(pyobj_t pyobj, pyobj_t *value, int32_t size) {
    pyobj->type = LIST;
    pyobj->py.list.value = value;
    pyobj->py.list.size = size;
}

void pyobj_set_codeblock(pyobj_t pyobj/*, py_codeblock *codeblock*/) {
    pyobj->type = CODE;
    // pyobj->py.codeblock = codeblock;
    pyobj->py.codeblock = malloc(sizeof(*(pyobj->py.codeblock)));
    assert(pyobj->py.codeblock);
    *(pyobj->py.codeblock) = py_codeblock_new();
}

void pyobj_set_constant(pyobj_t pyobj, pycst_value constant) {
    pyobj->type = CONSTANT;
    pyobj->py.constant = constant;
}

void* pyobj_get(pyobj_t pyobj) {
    switch (pyobj->type) {
        case INT:
            return &pyobj->py.number.integer;
        case INT64:
            return &pyobj->py.number.interger64;
        case FLOAT:
            return &pyobj->py.number.real;
        case COMPLEX:
            return &pyobj->py.number.complex;
        case STRING:
            return &pyobj->py.string;
        case LIST:
            return &pyobj->py.list;
        case CODE:
            return &pyobj->py.codeblock;
        case CONSTANT:
            return &pyobj->py.constant;
        default:
            return NULL;
    }
}

pyobj_type pyobj_get_type(pyobj_t pyobj) {
    return pyobj->type;
}

int pyobj_print(void* pyobj) {
    if (pyobj == NULL) return printf("Not allocated");
    switch (((pyobj_t)pyobj)->type) {
        case INT:
            printf("%d", ((pyobj_t)pyobj)->py.number.integer);
        break;
        case INT64:
            printf("%ld", ((pyobj_t)pyobj)->py.number.interger64);
        break;
        case FLOAT:
            printf("%f", ((pyobj_t)pyobj)->py.number.real);
        break;
        case COMPLEX:
            printf("%f + %fi", ((pyobj_t)pyobj)->py.number.complex.real, ((pyobj_t)pyobj)->py.number.complex.imag);
        break;
        case STRING:
            string_print(((pyobj_t)pyobj)->py.string);
            // for (int i = 0; i < ((pyobj_t)pyobj)->py.string.length; i=i+1) {
            //     printf("%c", ((pyobj_t)pyobj)->py.string.buffer[i]);
            // }
        break;
        case LIST:
            printf("[");
            for (int i = 0; i < ((pyobj_t)pyobj)->py.list.size; i=i+1) {
                pyobj_print(((pyobj_t)pyobj)->py.list.value[i]);
                if (i != ((pyobj_t)pyobj)->py.list.size - 1) printf(", ");
            }
            printf("]");
        break;
        case CODE:
            py_codeblock_print(*(((pyobj_t)pyobj)->py.codeblock));
        break;
        case CONSTANT:
            switch (((pyobj_t)pyobj)->py.constant) {
                case CST_NULL  : printf("Null");  break;
                case CST_TRUE  : printf("True");  break;
                case CST_FALSE : printf("False"); break;
                case CST_NONE  : printf("None");  break;
                default : printf("Unknown constant"); break;
            }
        break;
        default:
            printf("Empty");
        break;
    }
    return 0;
}

py_codeblock py_codeblock_new() {
    // codeblock = malloc(*codeblock);
    // assert(codeblock);
    py_codeblock codeblock;

    codeblock.version_pyvm = -1;
    codeblock.header.arg_count = -1;
    codeblock.header.local_count = -1;
    codeblock.header.stack_size = -1;
    codeblock.header.flags = -1;
    codeblock.parent = NULL;
    codeblock.binary.header.magic = -1;
    codeblock.binary.header.timestamp = -1;
    codeblock.binary.header.source_size = -1;
    codeblock.binary.content.interned = NULL;
    codeblock.binary.content.bytecode = NULL;
    codeblock.binary.content.consts = NULL;
    codeblock.binary.content.names = NULL;
    codeblock.binary.content.varnames = NULL;
    codeblock.binary.content.freevars = NULL;
    codeblock.binary.content.cellvars = NULL;
    codeblock.binary.trailer.filename = NULL;
    codeblock.binary.trailer.name = NULL;
    codeblock.binary.trailer.firstlineno = -1;
    codeblock.binary.trailer.lnotab = NULL;

    return codeblock;
}

void py_codeblock_print(py_codeblock codeblock) {
    printf("========== Affichage du codeblock ==========\n");
    printf("Version : %d\n", codeblock.version_pyvm);
    printf("Header : \n");
    printf("\targ_count : %d\n", codeblock.header.arg_count);
    printf("\tlocal_count : %d\n", codeblock.header.local_count);
    printf("\tstack_size : %d\n", codeblock.header.stack_size);
    printf("\tflags : 0x%08X\n", codeblock.header.flags);
    printf("parent : ");
    if (codeblock.parent == NULL)
        printf("NULL");
    else
        pyobj_print(codeblock.parent);
    printf("\n");
    printf("binary : \n");
    printf("\theader :\n");
    printf("\t\tmagic : %d\n", codeblock.binary.header.magic);
    printf("\t\ttimestamp : %ld\n", codeblock.binary.header.timestamp);
    printf("\t\tsource_size : %d\n", codeblock.binary.header.source_size);
    printf("\tcontent :\n");
    printf("\t\tinterned : ");
    if (codeblock.binary.content.interned != NULL)
        pyobj_print(codeblock.binary.content.interned);
    else
        printf("NULL");
    printf("\n");
    printf("\t\tbytecode : ");
    if (codeblock.binary.content.bytecode != NULL)
        pyobj_print(codeblock.binary.content.bytecode);
    else
        printf("NULL");
    printf("\n");
    printf("\t\tconsts : ");
    if (codeblock.binary.content.consts != NULL)
        pyobj_print(codeblock.binary.content.consts);
    else
        printf("NULL");
    printf("\n");
    printf("\t\tnames : ");
    if (codeblock.binary.content.names != NULL)
        pyobj_print(codeblock.binary.content.names);
    else
        printf("NULL");
    printf("\n");
    printf("\t\tvarnames : ");
    if (codeblock.binary.content.varnames != NULL)
        pyobj_print(codeblock.binary.content.varnames);
    else
        printf("NULL");
    printf("\n");
    printf("\t\tfreevars : ");
    if (codeblock.binary.content.freevars != NULL)
        pyobj_print(codeblock.binary.content.freevars);
    else
        printf("NULL");
    printf("\n");
    printf("\t\tcellvars : ");
    if (codeblock.binary.content.cellvars != NULL)
        pyobj_print(codeblock.binary.content.cellvars);
    else
        printf("NULL");
    printf("\n");
    printf("\ttrailer :\n");
    printf("\t\tfilename : ");
    if (codeblock.binary.trailer.filename != NULL)
        pyobj_print(codeblock.binary.trailer.filename);
    else
        printf("NULL");
    printf("\n");
    printf("\t\tname : ");
    if (codeblock.binary.trailer.name != NULL)
        pyobj_print(codeblock.binary.trailer.name);
    else
        printf("NULL");
    printf("\n");
    printf("\t\tfirstlineno : %d\n", codeblock.binary.trailer.firstlineno);
    printf("\t\tlnotab : ");
    if (codeblock.binary.trailer.lnotab != NULL)
        pyobj_print(codeblock.binary.trailer.lnotab);
    else
        printf("NULL");
    printf("\n");
    printf("============================================\n");
}

void py_codeblock_free(py_codeblock codeblock) {
    if (codeblock.parent != NULL)
        pyobj_free(codeblock.parent);
    if (codeblock.binary.content.interned != NULL)
        pyobj_free(codeblock.binary.content.interned);
    if (codeblock.binary.content.bytecode != NULL)
        pyobj_free(codeblock.binary.content.bytecode);
    if (codeblock.binary.content.consts != NULL)
        pyobj_free(codeblock.binary.content.consts);
    if (codeblock.binary.content.names != NULL)
        pyobj_free(codeblock.binary.content.names);
    if (codeblock.binary.content.varnames != NULL)
        pyobj_free(codeblock.binary.content.varnames);
    if (codeblock.binary.content.freevars != NULL)
        pyobj_free(codeblock.binary.content.freevars);
    if (codeblock.binary.content.cellvars != NULL)
        pyobj_free(codeblock.binary.content.cellvars);
    if (codeblock.binary.trailer.filename != NULL)
        pyobj_free(codeblock.binary.trailer.filename);
    if (codeblock.binary.trailer.name != NULL)
        pyobj_free(codeblock.binary.trailer.name);
    if (codeblock.binary.trailer.lnotab != NULL)
        pyobj_free(codeblock.binary.trailer.lnotab);
}

int pyobj_type_compar(pyobj_t pyobj1, pyobj_t pyobj2){
    if (pyobj1->type != pyobj2->type){
        return 0;
    }
    else {
         switch (pyobj1->type) {
            case INT:
                if (*(int32_t*)pyobj_get(pyobj1) == *(int32_t*)pyobj_get(pyobj2)){
                    return 1;
                }
                else{
                    return 0;
                }
            break;
            case INT64:
                if (*(int64_t*)pyobj_get(pyobj1) == *(int64_t*)pyobj_get(pyobj2)){
                    return 1; 
                }
                else{
                    return 0;
                }
            break;
            case FLOAT:
                if (*(double*)pyobj_get(pyobj1) == *(double*)pyobj_get(pyobj2)){
                    return 1; 
                }
                else{
                    return 0; 
                }
            break;
            case COMPLEX:
                if((pyobj1->py.number.complex.real == pyobj2->py.number.complex.real) && (pyobj1->py.number.complex.imag == pyobj2->py.number.complex.imag)){
                    return 1; 
                }
                else{
                    return 0;
                }
                //return &pyobj->py.number.complex;
            break;
            case STRING:
                if (string_compare(pyobj1->py.string,pyobj2->py.string)==1){
                    return 1;
                }
                else{
                    return 0;
                }
            break;
            case LIST:
                printf("Pas supporté pour l'instant \n");
                return 0;
            break;
            case CODE:
                printf("Pas supporté pour l'instant \n");
                return 0; 
            break;
            case CONSTANT:
                printf("Pas supporté pour l'instant \n");
                return 0;
                //return &pyobj->py.constant;
            break;
            default:
                printf("Le type n'est pas reconnu \n");
                return 0;
            
        }
    }
}