#include <stdio.h>

struct Stack {
    int stack[100];
    int top;
};

struct Stack initStack(struct Stack s) {
    s.stack[0] = 1;
    printf("\nINIT TOP INDEX %d\n", s.top);
    for (int i = 0; i < s.top + 1; i++) {
        printf("i: %d val: %d\n", i, s.stack[i]);
    }
    return s;
}

struct Stack pop(struct Stack s) {
    printf("\nPOP TOP INDEX %d\n", s.top);
    s.top = s.top - 1;
    for (int i = 0; i < s.top + 1; i++) {
        printf("i: %d val: %d\n", i, s.stack[i]);
    }
    return s;
}

int peek(struct Stack s) {
    printf("\nPEEK TOP INDEX %d\n", s.top);
    printf("PEEK VAL: %d\n", s.stack[s.top]);
    for (int i = 0; i < s.top + 1; i++) {
        printf("i: %d val: %d\n", i, s.stack[i]);
    }
    return s.stack[s.top];
}

struct Stack push(struct Stack s, int val) {
    s.top = s.top + 1;
    s.stack[s.top] = val;
    printf("\nPUSH TOP INDEX %d\n", s.top);
    for (int i = 0; i < s.top + 1; i++) {
        printf("i: %d val: %d\n", i, s.stack[i]);
    }
    return s;
}