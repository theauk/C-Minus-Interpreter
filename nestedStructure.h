#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

struct Nested {
    bool vals[100];
    int nextIndex;
    int conditionalsNum;
};

struct Nested increaseConditionals(struct Nested n) {
    n.conditionalsNum++;
    printf("nested #: %d\n", n.conditionalsNum);
    return n;
}

struct Nested push(struct Nested n, int val) {
    n.vals[n.nextIndex] = val;
    n.nextIndex++;
    printf("nested next index: %d\n", n.nextIndex);
    return n;
}

bool isEmpty(struct Nested n) {
    return n.nextIndex == 1;
}

bool pop(struct Nested n) {
    n.nextIndex--;  // ALSO MINUS IN MAIN FILE!!!!
    n.conditionalsNum--;
    return n.vals[n.nextIndex]; 
}

bool getStart(struct Nested n) {
    return n.vals[0];
}

bool getEnd(struct Nested n) {
    return n.vals[n.nextIndex - 1];
}