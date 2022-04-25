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

struct SymbolTable symbolTableInsert( struct SymbolTable s, char k[], struct Entry e) 
{
    printf("IN insert %s\n", k);
    strcpy(s.keys[s.nextEntryIndex], k);
    printf("IN insert key %s\n", s.keys[s.nextEntryIndex]);
    s.values[s.nextEntryIndex] = e;
    printf("IN insert value %f\n", s.values[s.nextEntryIndex].value);
    return s;
}

struct Entry symbolTableGet( struct SymbolTable s, int index ) 
{
    return s.values[index];
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

int main() {
    struct SymbolTable s;

    struct Entry e;
    char key[] = "test1";
    strcpy(e.type, "float");
    e.line = 1;
    e.value = 1;

    s = symbolTableInsert(s, key, e);
    printf("MAIN insert key %s\n", s.keys[s.nextEntryIndex]);
    printf("MAIN insert value %f\n", s.values[s.nextEntryIndex].value);

    s.nextEntryIndex = s.nextEntryIndex + 1;

    int contains = symbolTableContains(s, key);

    printf("Contains %d\n", contains);
    if (contains != -1)
    {
        struct Entry output = symbolTableGet(s, contains);
        printf("Get %f\n", output.value);
        printf("Get %s\n", output.type);
        printf("Get %d\n", output.line);
    }
}

// remember:
// check if already exists before insert
// increase next entry index (check if too large)