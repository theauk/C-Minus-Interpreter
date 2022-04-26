#include <stdbool.h>  
#include <stdio.h>   
#include <string.h>

struct Entry {
    char type[50];
    float value;
    int line;
};

struct SymbolTable {
    char keys[50][50];
    struct Entry values[50];
    int nextEntryIndex;
};

struct SymbolTable symbolTableInsert( struct SymbolTable s, char k[], char t[], float v, int l) 
{
    strcpy(s.keys[s.nextEntryIndex], k);
    struct Entry newEntry;
    strcpy(newEntry.type, t);
    newEntry.value = v;
    newEntry.line = l;
    s.values[s.nextEntryIndex] = newEntry;
    printf("AFTER insert: %s, %s, %f, %d\n", s.keys[s.nextEntryIndex], s.values[s.nextEntryIndex].type, s.values[s.nextEntryIndex].value, s.values[s.nextEntryIndex].line);
    return s;
}

struct Entry symbolTableGet( struct SymbolTable s, int index ) 
{
    return s.values[index];
}

struct SymbolTable symbolTableUpdate( struct SymbolTable s, int index, char t[], float v, int l) 
{
    strcpy(s.values[index].type, t);
    s.values[index].value = v;
    s.values[index].line = l;
    printf("AFTER update: %s, %s, %f, %d\n", s.keys[index], s.values[index].type, s.values[index].value, s.values[index].line);
    return s;
}

int symbolTableContains( struct SymbolTable s, char k[] ) 
{
    printf("FOR k: %s\n", k);
    for(int i = 0; i < s.nextEntryIndex; i++) {
        printf("FOR contains: %i, %s\n", i, s.keys[i]);
        if (strcmp(s.keys[i], k) == 0) {
            return i;
        }
    }
    return -1;
}

// remember:
// check if already exists before insert
// increase next entry index (check if too large)
// delete test table