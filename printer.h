#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include "symbolTable.h"

void printArray(char key[], struct Entry e);

void printNonArray(char key[], struct Entry e);

/*
    Prints the entries in the symbol table line by line. 
*/
void printSymbolTable(struct SymbolTable s) {
    printf("\n--- SYMBOL TABLE ---\n");
    for (int i = 0; i < s.nextEntryIndex; i++) {
        if (s.values[i].isArray) {
            printArray(s.keys[i], s.values[i]);
        } else {
            printNonArray(s.keys[i], s.values[i]);
        }
    }
}

/*
    Prints an entry that is not of an array type. 
*/
void printNonArray(char key[], struct Entry e) {
    printf("var: %s; type: %s; declaration line: %d; ", key, e.type, e.line);

    if (strcmp(e.type, "program") != 0) {
        if (strcmp(e.type, "int") == 0) {
            int val = e.value;
            printf("value: %d; \n", val);
        } else {
            printf("value: %f; \n", e.value);
        }
    } else {
        printf("\n");
    }
}

/*
    Prints an entry that is of an array type. 
*/
void printArray(char key[], struct Entry e) {
    printf("var: %s; type: %s[%d]; declaration line: %d; values: ", key, e.type, e.arraySize, e.line);
    if (strcmp(e.type, "int") == 0) {
        printf("[ ");
        for (int i = 0; i < e.arraySize; i++) {
            int val = e.array[i];
            printf("%d ", val);
        }
        printf("]\n");
    } else {
        printf("[ ");
        for (int i = 0; i < e.arraySize; i++) printf("%f ", e.array[i]);
        printf("]\n");
    }
}