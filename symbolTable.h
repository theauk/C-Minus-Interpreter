#include <stdbool.h>  
#include <stdio.h>   
#include <string.h>

struct Entry {
    char type[50];
    bool isArray;
    int arraySize;
    float value;
    int line;
    float array[100]; /* NOTE fix */
};

struct SymbolTable {
    char keys[50][50];
    struct Entry values[50];
    int nextEntryIndex;
};

struct SymbolTable symbolTableInsert(struct SymbolTable s, char k[], char t[], bool isArr, float v, int l, int arrSize) 
{
    strcpy(s.keys[s.nextEntryIndex], k);
    struct Entry newEntry;
    strcpy(newEntry.type, t);
    newEntry.value = v;
    newEntry.line = l;
    newEntry.isArray = isArr;

    if (isArr)
    {
        newEntry.arraySize = arrSize;
    }

    s.values[s.nextEntryIndex] = newEntry;
    return s;
}

struct Entry symbolTableGet( struct SymbolTable s, int index ) 
{
    return s.values[index];
}

struct SymbolTable symbolTableUpdate(struct SymbolTable s, int index, char t[], bool isArr, float v, int l, int arrSize) 
{
    strcpy(s.values[index].type, t);
    s.values[index].isArray = isArr;
    s.values[index].value = v;
    s.values[index].line = l;

    if (isArr)
    {
        s.values[index].arraySize = arrSize;
    }
    return s;
}

struct SymbolTable symbolTableUpdateArray(struct SymbolTable s, int index, int updateIndex, float newValue)
{
    s.values[index].array[updateIndex] = newValue;
    return s;
}

int symbolTableContains(struct SymbolTable s, char k[] ) 
{
    for(int i = 0; i < s.nextEntryIndex; i++) {
        if (strcmp(s.keys[i], k) == 0) {
            return i;
        }
    }
    return -1;
}